global without sharing class cc_mn_ctrl_ProductList {
    global String cartCurrency { get; set; }
    global String tiers {get;  set;}
    
    global cc_mn_ctrl_ProductList(){
        jsonProductEntryData = populateProductEntryData(); 
    	
    } 

    public String jsonProductEntryData {get; private set;}
	
    public static final List<String> STATUSES = new List<String>{'Released', 'Not Orderable'};

    public String populateProductEntryData(){
        
        String cartID= ccrz.cc_CallContext.currCartId;
		System.debug('FGG cartID'+cartID);
        List<ccrz__E_Cart__c> cartSFDCid = [
            select 
            	id,
            	ccrz__CurrencyISOCode__c,
            	ccrz__TotalQuantity__c
            from
            	ccrz__E_Cart__c
            where 
            	ccrz__EncryptedId__c = : cartID Limit 1
        ];
            
        
        System.debug('FGG cartSFDCid'+cartSFDCid);
        if(!cartSFDCid.isEmpty()){
        for(ccrz__E_Cart__c cart : cartSFDCid){
            if(cart.ccrz__TotalQuantity__c==0){
                this.cartCurrency='';
            }else{
                this.cartCurrency=cart.ccrz__CurrencyISOCode__c;
            }
            } 
            
        }
        else{
                this.cartCurrency='';
            
        }
        
        System.debug('FGG cartCurrency'+this.cartCurrency);
        
        
        
        // List of products to return
        List<cc_mn_bean_ResultsBaseData> productList = null;

        // Check for the category ID
        Map<String,String> pageParms = ccrz.cc_CallContext.currPageParameters;
        System.debug('*** pageParms: ' + JSON.serializePretty(pageParms));

        String curCategoryId = pageParms.get('categoryId');
        System.debug('*** curCategoryId: ' + curCategoryId);

        String operation = pageParms.get('operation');
        System.debug('*** operation: ' + operation);

        String searchText = pageParms.get('searchText');
        System.debug('*** searchText: ' + searchText);

        if (curCategoryId != null) {
            productList = populateProductCategoryData(curCategoryId);
        }
        else if (operation == 'quickSearch' && String.isNotEmpty(searchText)) {
            productList = populateProductSearchData(searchText);
        }
        else {
            productList = new List<cc_mn_bean_ResultsBaseData>();
            
        }
		System.debug('FGG 1 '+productList);
        List<Id> idsToRetrievePriceList = new List<Id>();
        for (cc_mn_bean_ResultsBaseData product:productList) {
        		idsToRetrievePriceList.add(product.sfid);
        }        
		tiers = getTiersByProduct(idsToRetrievePriceList);
        return JSON.serialize(productList);

    }

    public List<cc_mn_bean_ResultsBaseData> populateProductCategoryData(String curCategoryId) {
        List<cc_mn_bean_ResultsBaseData> productList = new List<cc_mn_bean_ResultsBaseData>();
        cc_imp_StorefrontSettings__c settings = cc_imp_StorefrontSettings__c.getInstance(ccrz.cc_CallContext.storefront);

        // if the current product category matches the category ID from the 
        // custom setting, get the products from the customer's price list

        String priceListId = getPriceListId();
        System.debug('*** priceListId: ' + priceListId);

        String discoveredCategory = null;
        try {
            discoveredCategory = [
                SELECT 
                    ccrz__CategoryId__c
                FROM 
                    ccrz__E_Category__c
                WHERE
                    Id = :curCategoryId
                LIMIT
                    1
            ].ccrz__CategoryId__c;
            
             
            //discoveredCategory = thecategory.ccrz__CategoryId__c;
        }catch(Exception e){
            System.debug('Could not match category: ' + e.getMessage());
            // non-critical
        }

		System.debug('FGG 3 '+discoveredCategory);
        if(discoveredCategory != null 
            && settings.CustomPriceListId__c != null 
            && priceListId != null
            && discoveredCategory == settings.CustomPriceListId__c
        ){
            // Query the products from the price list items in the selected price list
            Date theDay = Date.today();
            List<ccrz__E_PriceListItem__c> pliList = [
                SELECT 
  Id
                    , ccrz__Product__c
                    , ccrz__Product__r.ccrz__Sku__c
                    , ccrz__Product__r.Name
                    , ccrz__Product__r.CreatedDate
                    , ccrz__Product__r.ccrz__StartDate__c
                    , ccrz__Price__c
                    , CPI__c
                    , CPI__r.Customer_Material_Number__c
                	, Currency_ISO_Code__c
                	, Price_with_Currency__c
                	
                FROM 
                    ccrz__E_PriceListItem__c
                WHERE
                    ccrz__PriceList__c = :priceListId
                AND
                    ccrz__Product__r.ccrz__ProductStatus__c in :STATUSES
                AND
                    ccrz__StartDate__c <= :theDay
                AND
                    ccrz__EndDate__c >= :theDay
                AND
                    ccrz__Product__r.ccrz__StartDate__c <= :theDay
                AND
                    ccrz__Product__r.ccrz__EndDate__c >= :theDay
                ORDER BY
                    ccrz__Product__r.Name
            ];        
 		System.debug('FGG 4'+pliList);
            Integer sequence = 0;
            for(ccrz__E_PriceListItem__c pli :pliList){
                productList.add(new cc_mn_bean_ResultsBaseData(
                    String.valueOf(pli.ccrz__Product__c),
                    pli.ccrz__Product__r.ccrz__Sku__c,
                    pli.ccrz__Product__r.Name,
                    String.valueOf(pli.ccrz__Product__r.CreatedDate),
                    sequence++,
                    pli.ccrz__Price__c,
                    pli.Currency_ISO_Code__c,
                    pli.Price_with_Currency__c
                ));
            }
        }
		System.debug('FGG 5'+productList);	
        return productList;
    }

    public List<cc_mn_bean_ResultsBaseData> populateProductSearchData(String searchText) {
        List<cc_mn_bean_ResultsBaseData> productList = new List<cc_mn_bean_ResultsBaseData>();

        // if the current product category matches the category ID from the 
        // custom setting, get the products from the customer's price list

        String priceListId = getPriceListId();
        System.debug('*** priceListId: ' + priceListId);

        if (priceListId != null) {
            String searchString = '%' + searchText + '%';

            // Query the products from the price list items in the selected price list
            List<ccrz__E_PriceListItem__c> pliList = [
                SELECT 
                    Id
                    , ccrz__Product__c
                    , ccrz__Product__r.ccrz__Sku__c
                    , ccrz__Product__r.Name
                    , ccrz__Product__r.CreatedDate
                    , ccrz__Product__r.ccrz__StartDate__c
                    , ccrz__Price__c
                    , CPI__c
                    , CPI__r.Customer_Material_Number__c
                	, Currency_ISO_Code__c
                	, Price_with_Currency__c
                FROM 
                    ccrz__E_PriceListItem__c
                WHERE
                    ccrz__PriceList__c = :priceListId AND
                    CPI__r.Customer_Material_Number__c LIKE :searchString
                AND
                    ccrz__Product__r.ccrz__ProductStatus__c in :STATUSES
            ];        
			System.debug('FGG 5'+pliList);	
            Integer sequence = 0;
            for(ccrz__E_PriceListItem__c pli :pliList){
                productList.add(new cc_mn_bean_ResultsBaseData(
                    String.valueOf(pli.ccrz__Product__c),
                    pli.ccrz__Product__r.ccrz__Sku__c,
                    pli.ccrz__Product__r.Name,
                    String.valueOf(pli.ccrz__Product__r.CreatedDate),
                    sequence++,
                    pli.ccrz__Price__c,
                    pli.Currency_ISO_Code__c,
                    pli.Price_with_Currency__c
                ));
                	
            }
            System.debug('FGG 6'+pliList);
        }
		System.debug('FGG 7'+productList); 
        return productList;
    }

    private String getPriceListId() {
        // Query the user's account
        String accountId = ccrz.cc_CallContext.effAccountId;
        if(accountId == null){
            accountId = ccrz.cc_CallContext.currAccountId;
        }
        System.debug('*** accountId: ' + accountId);

        // Query the account
        String priceListId = null;
        try {
            priceListId = [
                SELECT 
                    Id
                    , cc_imp_MyProductList__c
                FROM 
                    Account 
                WHERE
                    Id = :accountId
                LIMIT
                    1
            ].cc_imp_MyProductList__c;
        }
        
        catch(Exception e){
           // no-op 
           System.debug('Could not find a My Products price list entry');
        }
        
        System.debug('FGG 8'+priceListId);	
        return priceListId;        
    } 

    @RemoteAction   
    global static ccrz.cc_RemoteActionResult fetchExtendedData(ccrz.cc_RemoteActionContext ctx, String data) {
        ccrz.cc_RemoteActionResult response = cc_imp_hlpr_RemoteActionHelper.remoteInit(ctx);
        Map<String, ExtendedProduct> extendedProductMap = new Map<String, ExtendedProduct>();

        List<Object> input = (List<Object>) JSON.deserializeUntyped(data);
    
        Set<Id> productIdSet = new Set<Id>();
        for (Object item : input) {
            Map<String, Object> theMap = (Map<String, Object>) item;
            Map<String, Object> theProduct = (Map<String, Object>) theMap.get('prodBean');
            productIdSet.add((String)theProduct.get('id'));
        }
        Map<Id, ccrz__E_PriceListItem__c> pliMap = cc_imp_hlpr_PriceListHelper.getPriceListItemsBySequence(new List<Id>(productIdSet));

        for (Id item : productIdSet) {
            ExtendedProduct newExtendedProduct = new ExtendedProduct();
            ccrz__E_PriceListItem__c pli = pliMap.get(item);
            if (pli != null) {
                if (pli.CPI__c != null) {
                    newExtendedProduct.customerMaterialNumber = pli.CPI__r.Customer_Material_Number__c;
                    newExtendedProduct.productNumber=String.valueOf(Integer.valueOf(pli.ccrz__Product__r.Product_Number__c));
                    newExtendedProduct.pliID=pli.Id;
                    newExtendedProduct.uom=pli.Material_Container_Abbreviation__c;
                    newExtendedProduct.containerWeight=pli.Container_Weight__c;
                }
                newExtendedProduct.currencyCode = pli.Currency_ISO_Code__c;
                newExtendedProduct.priceCurrency =pli.Price_with_Currency__c;
                newExtendedProduct.minimumQuantity = pli.ccrz__MinQty__c;
            }

            extendedProductMap.put(item, newExtendedProduct);
        }
    

        response.data = extendedProductMap;
        response.success = true;
         
        return response;
    }

    
    @RemoteAction
    global static string checkInventory(ccrz.cc_RemoteActionContext ctx, String pliID, String qty, string uom, string shipDate) {
        
         		string response;
        		List<ccrz__E_PriceListItem__c> pli=[select id,Account_Material__c from ccrz__E_PriceListItem__c where id=:pliID];
        List<Account_Material__c> acctMat = [select SAP_Material__r.Material_Number__c,SAP_Plant_Code__c,Quantity__c,ATP_UOM__c,Ship_Date__c from Account_Material__c where id=:pli[0].Account_Material__c];
				Account acct = [select SAP_DivisionCode__c,AccountNumber,SAP_Sales_Org__c,SAP_DistChannel__c,Sold_To_Customer_Number__c,SAP_Sold_To_Account_Number__c from Account where id=:ctx.effAccountId];
        		acctMat[0].Quantity__c=Decimal.valueOf(qty);
        		acctMat[0].ATP_UOM__c=uom;
        		acctMat[0].Ship_Date__c=Date.newInstance(Integer.valueOf(shipDate.substring(6,10)),Integer.valueOf(shipDate.substring(0,2)),Integer.valueOf(shipDate.substring(3,5)));
        		Map<String, String> respMap= new Map<String, String>();
				respMap=atpInventoryCallOut.doPost(acctMat,acct,'mynexeo');
            
            if(respMap.ContainsKey(acctMat[0].SAP_Material__r.Material_Number__c)){
                response = respMap.get(acctMat[0].SAP_Material__r.Material_Number__c);
                return response;
            }
            else{
                response = 'Something went wrong, Please retry '+Integer.valueOf(shipDate.substring(6,10))+' '+Integer.valueOf(shipDate.substring(0,2))+' '+Integer.valueOf(shipDate.substring(3,5));
                return response;
            }                               
     return 'Something went wrong, Please try again';        
    }
   
    private  String getTiersByProduct(List<Id> idsToRetrievePriceList) {
        String result = '';
            try  {              	
                
         		List<Id> idsToRetrieve = new List<Id>();
                Map<Id, ccrz__E_PriceListItem__c> pliMap = cc_imp_hlpr_PriceListHelper.getPriceListItemsBySequence(new List<Id>(idsToRetrievePriceList));
				
                for (ccrz__E_PriceListItem__c priceListItem: pliMap.values()) {
                    
					idsToRetrieve.add(priceListItem.Id);
            	}
                       
                result = JSON.serialize(cc_imp_hlpr_PriceListHelper.getPriceListItemTierBulk(idsToRetrieve));

            } catch(Exception ex) {
            }        
        return result;
    }
	
    
    global class ExtendedProduct {
        public String customerMaterialNumber {get; set;}
        public String productNumber {get; set;}        
        public Decimal minimumQuantity {get; set;}
        public String currencyCode {get; set;}
        public String priceCurrency {get; set;}
        public String pliID {get; set;}
        public String uom {get; set;}
        public String containerWeight {get; set;}
        
    }
}