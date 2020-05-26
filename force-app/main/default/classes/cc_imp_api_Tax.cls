public with sharing class cc_imp_api_Tax {

    public static final String SHIP_TO_VALUE = '888888';
    public static final String SOLD_TO_VALUE = '888888';
    public static final String FREIGHT_TERMS_VALUE = 'ZD1';
    public static final String PARTNER_ROLE_SOLD_TO_VALUE = 'AG';
    public static final String PARTNER_ROLE_SHIP_TO_VALUE = 'WE';
    public static final String DIVISION = '32';

    public static final String MYNEXEP_REQUEST_METHOD = 'mynexeo';

    public static cc_imp_StorefrontSettings__c settings {get; set;}


    public static ccrz__E_Cart__c queryCart(Id cartId) {
        ccrz__E_Cart__c cart = null;
        List<ccrz__E_Cart__c> carts = new List<ccrz__E_Cart__c>(
            [
                SELECT
                    Id
                    , ccrz__CurrencyISOCode__c
                    , ccrz__ShipAmount__c
                    , ccrz__Account__c
                    , ccrz__BillTo__r.ccrz__AddressFirstline__c
                    , ccrz__BillTo__r.ccrz__City__c
                    , ccrz__BillTo__r.ccrz__CountryISOCode__c
                    , ccrz__BillTo__r.ccrz__FirstName__c
                    , ccrz__BillTo__r.ccrz__LastName__c 
                    , ccrz__BillTo__r.ccrz__PostalCode__c
                    , ccrz__BillTo__r.ccrz__StateISOCode__c
                    , ccrz__ShipTo__r.ccrz__AddressFirstline__c
                    , ccrz__ShipTo__r.ccrz__City__c
                    , ccrz__ShipTo__r.ccrz__CountryISOCode__c
                    , ccrz__ShipTo__r.ccrz__FirstName__c
                    , ccrz__ShipTo__r.ccrz__LastName__c
                    , ccrz__ShipTo__r.ccrz__PostalCode__c
                    , ccrz__ShipTo__r.ccrz__StateISOCode__c
                    , ccrz__ShipTo__r.County__c
                FROM
                    ccrz__E_Cart__c
                WHERE
                    Id = :cartId
            ]
        );
        if (carts != null && !carts.isEmpty()) {
            cart = carts[0];
        }
        return cart;
    }

    public static Account queryAccount(Id accountId) {
        return [SELECT Id, ccrz__E_AccountGroup__c, Ship_To_Number__c, SAP_Sold_To_Account_Number__c, SAP_DivisionCode__c FROM Account WHERE Id = :accountId];
    }

    public static Map<Id, ccrz__E_CartItem__c> queryCartItemsByCartId(Id cartId){
        Map<Id, ccrz__E_CartItem__c> cartItemMap = new Map<Id, ccrz__E_CartItem__c>(
            [
                SELECT
                    Id
                    , ccrz__ItemTotal__c
                    , ccrz__Quantity__c
                    , ccrz__Product__c
                    , ccrz__Price__c
                    , ccrz__UnitOfMeasure__c
                    , ccrz__Product__r.CurrencyIsoCode
                    , ccrz__Product__r.SAP_Material__c
                    , ccrz__Product__r.NexeoMaterialId__c
                    , ccrz__Product__r.Product_Number__c
                    , ccrz__Product__r.Sales_UoM__c
                    , ccrz__Product__r.SalesOrgCode__c
                    , ccrz__Product__r.DistChannel_Code__c
                    , ccrz__Product__r.DivisionCode__c
                    , Discount_Amount_from_Coupon__c    
                    , DiscountType__c
                    , Coupon_Spec_Quantity__c
                    , ccrz__Coupon__c
                    ,ccrz__AbsoluteDiscount__c
                FROM
                    ccrz__E_CartItem__c
                WHERE
                    ccrz__Cart__c = :cartId
                AND 
                    ccrz__CartItemType__c!='Coupon'
            ]
        );
        System.debug('queryCartItemsByCart: ' + JSON.serializePretty(cartItemMap));
        return cartItemMap;
    }

    // Queries the AccountGroupPriceLists and orders them in ascending order.
    public static List<ccrz__E_AccountGroupPriceList__c> queryAccountGroupPriceListsByAccount(Id accountGroupId, String currencyCode){
        List<ccrz__E_AccountGroupPriceList__c> agpList = [
            SELECT
                Id
                , ccrz__Sequence__c
                , ccrz__PriceList__c
            FROM
                ccrz__E_AccountGroupPriceList__c
            WHERE
                ccrz__AccountGroup__c = :accountGroupId AND
                ccrz__PriceList__r.ccrz__CurrencyISOCode__c = :currencyCode
            ORDER BY
                ccrz__Sequence__c
        ];

        System.debug('queryAccountGroupPriceListsByAccount: ' + JSON.serializePretty(agpList));
        return agpList;
    }

    public static List<ccrz__E_PriceListItem__c> queryPriceListItemsByProductAndPriceList(List<Id> productIds, List<Id> priceListIds){

        System.debug('queryPriceListItemsByProductAndPriceList productIds: ' + JSON.serializePretty(productIds));
        System.debug('queryPriceListItemsByProductAndPriceList priceListIds: ' + JSON.serializePretty(priceListIds));
        List<ccrz__E_PriceListItem__c> items = [
            SELECT
                Id
                , ccrz__PriceList__c
                , ccrz__Product__c
                , PriceUoM__c
                , volumeUom__c
                , ccrz__UnitOfMeasure__c
                , ccrz__Price__c
                , CPI_Plant__c
                , CPI_Freight_Terms__c
            FROM
                ccrz__E_PriceListItem__c
            WHERE
                ccrz__Product__c in :productIds
            AND
                ccrz__PriceList__c in :priceListIds
        ];
        System.debug('queryPriceListItemsByProductAndPriceList: ' + JSON.serializePretty(items));
        return items;
    }

    
     public static List<ccrz__E_CartItem__c> SplitCartItemsWithCoupons(List<ccrz__E_CartItem__c> cartItemsWithCoupons){
        System.debug('FGG GOT TO SplitCartItemsWithCoupons '+cartItemsWithCoupons);
        List<ccrz__E_CartItem__c> cartItemstoSplit=new List<ccrz__E_CartItem__c>();
        List<ccrz__E_CartItem__c> cartFixedItems=new List<ccrz__E_CartItem__c>();
        List<ccrz__E_CartItem__c> cartItemsnoCoupons=new List<ccrz__E_CartItem__c>();
         
        for(ccrz__E_CartItem__c cartItem: cartItemsWithCoupons){
            
            if(cartItem.ccrz__Coupon__c!=null && cartItem.ccrz__Quantity__c>cartItem.Coupon_Spec_Quantity__c){
            cartItemstoSplit.add(cartItem);    
            System.debug('FGG quantity is more than coupon quantity for '+cartItem);    
            }
            else{
                
                cartItemsnoCoupons.add(cartItem);
            }
            
        }
        List<ccrz__E_CartItem__c> cartItemstoInsert=new List<ccrz__E_CartItem__c>();
        List<ccrz__E_CartItem__c> cartItemstoUpdate=new List<ccrz__E_CartItem__c>();   
         System.debug('FGG cartitemstosplit '+cartItemstoSplit);
        for(ccrz__E_CartItem__c cartItem: cartItemstoSplit){
            ccrz__E_CartItem__c itemtoInsert=cartItem.clone(true,true,false,false);
            
            System.debug('FGG for itemtoInsert '+itemtoInsert);
            System.debug('FGG for CartItemstoSplit'+cartItem);    
            try{            
            cartItem.ccrz__Quantity__c=cartItem.Coupon_Spec_Quantity__c;
            cartItem.ccrz__SubAmount__c=(cartItem.ccrz__Quantity__c*cartItem.ccrz__Price__c)-cartItem.ccrz__AbsoluteDiscount__c;
            itemtoInsert.ccrz__Quantity__c=itemtoInsert.ccrz__Quantity__c-cartItem.Coupon_Spec_Quantity__c;
            itemtoInsert.ccrz__AbsoluteDiscount__c=0;
            itemtoInsert.ccrz__PercentDiscount__c=0;
            
            itemtoInsert.ccrz__SubAmount__c=(itemtoInsert.ccrz__Quantity__c*itemtoInsert.ccrz__Price__c);
            itemtoInsert.ccrz__Coupon__c=null;
            System.debug('FGG itemtoInsert Second'+itemtoInsert);
            System.debug('FGG cartItemstoInsert First'+cartItemstoInsert);
           
            cartItemstoInsert.add(itemtoInsert);    
            cartItemstoUpdate.add(cartItem);
            }catch(exception e){
                
                System.debug('FGG Error in code '+e.getLineNumber()+ e.getMessage());
            }
        }
         System.debug('FGG cartItemstoInsert '+cartItemstoInsert);
         System.debug('FGG cartItemstoUpdate '+cartItemstoUpdate);

         System.debug('FGG cartitemsnoCoupons '+cartitemsnoCoupons);

         cartFixedItems.addAll(cartItemstoInsert);
         cartFixedItems.addAll(cartItemstoUpdate);
        cartFixedItems.addAll(cartitemsnoCoupons);
        //update orderItemstoUpdate;
        System.debug('FGG cartFixedItems '+cartFixedItems);
        return cartFixedItems;
    }
   
    public static List<cc_imp_json_TaxRequest> buildTaxRequests(ccrz__E_Cart__c cart, Account theAccount, List<ccrz__E_CartItem__c> cartItems, Map<Id, ccrz__E_PriceListItem__c> pliMap, String method, String vatNumber, String taxClassification) {
        List<cc_imp_json_TaxRequest> taxRequests = new List<cc_imp_json_TaxRequest>();
        
      
        List<ccrz__E_CartItem__c> cartItemsSplited=SplitCartItemsWithCoupons(cartItems);
                System.debug('FGG cartItemsSplited '+cartItemsSplited);

        System.debug('buildTaxRequests cartItems: ' + JSON.serializePretty(cartItemsSplited));
        System.debug('buildTaxRequests pliMap: ' + JSON.serializePretty(pliMap));
        List<cc_imp_json_TaxRequest.Partner> partners = buildPartners(cart, vatNumber);
        for(ccrz__E_CartItem__c ci :cartItemsSplited){
            cc_imp_json_TaxRequest req = new cc_imp_json_TaxRequest();
            taxRequests.add(req);

            ccrz__E_PriceListItem__c pli = pliMap.get(ci.ccrz__Product__c);
            
            //This If condition is for MyNexeo and Else is for Nexeo3D
            if (MYNEXEP_REQUEST_METHOD == method) {
                req.ship_to = theAccount.Ship_To_Number__c; 
                req.sold_to = theAccount.SAP_Sold_To_Account_Number__c;
                req.division = theAccount.SAP_DivisionCode__c;
            }
            else {
                req.ship_to = SHIP_TO_VALUE; //ci.ccrz__Cart__r.ccrz__Account__r.SAP_Sold_To_Account_Number__c;
                req.sold_to = SOLD_TO_VALUE; //ci.ccrz__Cart__r.ccrz__Account__r.Ship_To_Number__c;
                req.division = DIVISION;
            }
            req.material = ci.ccrz__Product__r.Product_Number__c; // ci.ccrz__Product__r.NexeoMaterialId__c;
            req.quantity = String.valueOf(ci.ccrz__Quantity__c);
            req.sales_unit = pli.volumeUom__c; //ci.ccrz__Product__r.Sales_UoM__c;
            //req.price = String.valueOf(ci.ccrz__Price__c); // TODO Any formatting needed here?
            req.price = String.valueOf(ci.ccrz__ItemTotal__c); // TODO Any formatting needed here?
          
            req.price_unit = pli.PriceUoM__c; //ci.ccrz__Product__r.Sales_UoM__c; //ci.ccrz__UnitOfMeasure__c; //String.valueOf(ci.ccrz__Price__c);
            req.curr = cart.ccrz__CurrencyISOCode__c; //ci.ccrz__Product__r.CurrencyIsoCode;
            req.plant = pli.CPI_Plant__c;
            req.sfdc_account_id = theAccount.Id;
            //req.sfdc_material_id = ci.ccrz__Product__r.SAP_Material__c;
            req.sales_org = ci.ccrz__Product__r.SalesOrgCode__c; // TODO Is this needed?
            req.distr_chan = ci.ccrz__Product__r.DistChannel_Code__c; // TODO Is this populated?
            //req.division = ci.ccrz__Product__r.DivisionCode__c; // TODO Is this populated?
            
            if(ci.ccrz__Coupon__c==null){
            req.DISCOUNT_TYPE = '';
            req.DISCOUNT_AMOUNT= 0;            
            }else{
           req.DISCOUNT_TYPE = ci.DiscountType__c;
            req.DISCOUNT_AMOUNT= ci.Discount_Amount_from_Coupon__c;            
                
            }
            if (MYNEXEP_REQUEST_METHOD == method) {
                req.freight_terms = pli.CPI_Freight_Terms__c;
            }
            else {
                req.freight_terms = FREIGHT_TERMS_VALUE; 
            }
            req.shipping_amt = String.valueOf(cart.ccrz__ShipAmount__c);
            req.partners = partners;
            if(taxClassification == null){
                taxClassification = '';
            }
            req.alttax_cls = taxClassification;
        }

        return taxRequests;
    }
 
    private static List<cc_imp_json_TaxRequest.Partner> buildPartners(ccrz__E_Cart__c cart, String vatNumber) {
        List<cc_imp_json_TaxRequest.Partner> partners = new List<cc_imp_json_TaxRequest.Partner>();
        cc_imp_json_TaxRequest.Partner partnerSoldTo = new cc_imp_json_TaxRequest.Partner();
        partnerSoldTo.partn_role = PARTNER_ROLE_SOLD_TO_VALUE;
        partnerSoldTo.itm_number = '000000'; // TODO Does this need to increment?
        partnerSoldTo.name = cart.ccrz__BillTo__r.ccrz__FirstName__c + ' ' + cart.ccrz__BillTo__r.ccrz__LastName__c;
        partnerSoldTo.street = cart.ccrz__BillTo__r.ccrz__AddressFirstline__c;
        partnerSoldTo.postl_code = cart.ccrz__BillTo__r.ccrz__PostalCode__c;
        partnerSoldTo.city = cart.ccrz__BillTo__r.ccrz__City__c;
        partnerSoldTo.region = cart.ccrz__BillTo__r.ccrz__StateISOCode__c;
        partnerSoldTo.country = cart.ccrz__BillTo__r.ccrz__CountryISOCode__c;
        partnerSoldTo.vat_reg_no = vatNumber;
        partners.add(partnerSoldTo);
        cc_imp_json_TaxRequest.Partner partnerShipTo = new cc_imp_json_TaxRequest.Partner();
        partnerShipTo.partn_role = PARTNER_ROLE_SHIP_TO_VALUE;
        partnerShipTo.itm_number = '000000'; // TODO Does this need to increment?
        partnerShipTo.name = cart.ccrz__ShipTo__r.ccrz__FirstName__c + ' ' + cart.ccrz__ShipTo__r.ccrz__LastName__c;
        partnerShipTo.street = cart.ccrz__ShipTo__r.ccrz__AddressFirstline__c;
        partnerShipTo.postl_code = cart.ccrz__ShipTo__r.ccrz__PostalCode__c;
        partnerShipTo.city = cart.ccrz__ShipTo__r.ccrz__City__c;
        partnerShipTo.region = cart.ccrz__ShipTo__r.ccrz__StateISOCode__c;
        partnerShipTo.country = cart.ccrz__ShipTo__r.ccrz__CountryISOCode__c;
        partnerShipTo.district = cart.ccrz__ShipTo__r.County__c;
        partnerShipTo.vat_reg_no = vatNumber;
        partners.add(partnerShipTo);
        return partners;
    }

    // list of Map<product id, price list item>
    // each list item is a map<prod id, pli> that represents
    // the products in a pricelist 
    public static ccrz__E_PriceListItem__c findPriceListItemByPrice(Id productId, List<Map<Id,ccrz__E_PriceListItem__c>> priceLists){
        ccrz__E_PriceListItem__c priceListItem = null;
        for(Map<Id, ccrz__E_PriceListItem__c> pliMap :priceLists){
            ccrz__E_PriceListItem__c pli = pliMap.get(productId);
            if(pli != null){
                if(pli.ccrz__Price__c != null && (priceListItem == null || pli.ccrz__Price__c < priceListItem.ccrz__Price__c)){
                    priceListItem = pli;
                }
            }
        }
        System.debug('findPriceListItemByPrice: ' + productId);
        System.debug('findPriceListItemByPrice: ' + JSON.serializePretty(priceLists));
        System.debug('findPriceListItemByPrice: ' + JSON.serializePretty(priceListItem));
        return priceListItem;
    }

// map of price list => map<product id, price list item> -- priceListMap
// Map<Id, Map<Id, ccrz__E_PriceList__c>> priceListMap = new Map<Id, Map<Id, ccrz__E_PriceList__c>>();
// for each price list item
// get the productid => pli map
    // Map<Id, ccrz__E_PriceListMap> themap  = priceListMap.get(price list id)
    // if(themap == null){
        // themap = new Map<Id, ccrz__E_PriceListMap>();
        // priceListMap.put(price list id, themap);
    // }
    // themap.put(product id, price list item)



    // 
    public static List<Map<Id,ccrz__E_PriceListItem__c>> buildPriceListMaps(List<ccrz__E_AccountGroupPriceList__c> accountGroupPriceLists){
        List<Map<Id,ccrz__E_PriceListItem__c>> agplList = new List<Map<Id,ccrz__E_PriceListItem__c>> ();

        // for each AGPL, get the pricelist, make a map of productId=>pricelistitem, insert the map into the list
        for(ccrz__E_AccountGroupPriceList__c agpl :accountGroupPriceLists){
            // create the map
            Map<Id, ccrz__E_PriceListItem__c> agplMap = new Map<Id, ccrz__E_PriceListItem__c>();

            // insert the map into the list
            agplList.add(agplMap);

            // Add the products from the pricelist to the new map

        }
        return agplList;
    }

    // list of Map<product id, price list item>
    // each list item is a map<prod id, pli> that represents
    // the products in a pricelist 
    // this method expects that the list is sorted by the account group price list in ascending order
    public static ccrz__E_PriceListItem__c findPriceListItemByPriceListSequence(Id productId, List<Map<Id,ccrz__E_PriceListItem__c>> priceLists){
        ccrz__E_PriceListItem__c price = null;
        for(Map<Id, ccrz__E_PriceListItem__c> pliMap :priceLists){
            ccrz__E_PriceListItem__c pli = pliMap.get(productId);
            if(pli != null && pli.ccrz__Price__c != null){
                price = pli;
                break;
            }
        }

        System.debug('findPriceListItemBySequence: ' + productId);
        System.debug('findPriceListItemBySequence: ' + JSON.serializePretty(priceLists));
        System.debug('findPriceListItemBySequence: ' + JSON.serializePretty(price));
        return price;
    }

    public static Decimal calculateTax(String cartId, String vatNumber, String taxClassification){
        Decimal taxAmount = null;
        
        //if (settings == null) {
            String storeFrontName = ccrz.cc_CallContext.storefront;
            settings =  cc_imp_StorefrontSettings__c.getInstance(storeFrontName);
        //}
        
        Boolean calcTaxes = Boolean.valueOf(settings.PerformTaxCalculation__c);  
		
		if (storeFrontName=='mynexeo' && calcTaxes==false) {
			return 0.00;
		}
		
		//ccrz.ccLog.log('*** FAHD -Storefront name is ' + storeFrontName); 
		
		// Structure::
        // Account - CC Account Group - CC Account Group Price List - CC Price List -
        // - Price List Item - Product

        ccrz__E_Cart__c cart = queryCart(cartId);

        // Query the Cart Items with prices, including the AccountId, and the product data
        Map<Id, ccrz__E_CartItem__c> cartItemMap = queryCartItemsByCartId(cartId);

        Account theAccount = queryAccount(ccrz.cc_CallContext.currAccountId);

        Id accountGroupId = ccrz.cc_CallContext.effAccountGroup.Id;
        if (accountGroupId == null) {
            accountGroupId = ccrz.cc_CallContext.currAccountGroup.Id;
        }


        // Get Account Group Prices lists ordered by sequence
        List<ccrz__E_AccountGroupPriceList__c> accountGroupPriceLists = queryAccountGroupPriceListsByAccount(accountGroupId, cart.ccrz__CurrencyISOCode__c);

        // Get Price list items for the found products(from cart items) and pricelists(from accountGroupPriceLists)
        // - do this in the next loop       List<Map<Id,ccrz__E_PriceListItem__c>> priceListItemMaps = buildPriceListMaps(accountGroupPriceLists);

        // List of Product id => price list item
        List<Map<Id, ccrz__E_PriceListItem__c>> priceListProductsBySequence = new List<Map<Id, ccrz__E_PriceListItem__c>>();
        // Map of price list id => (<product id => price list item>)
        Map<Id, Map<Id, ccrz__E_PriceListItem__c>> priceListToProductMap = new Map<Id, Map<Id, ccrz__E_PriceListItem__c>>();
        for(ccrz__E_AccountGroupPriceList__c agpl :accountGroupPriceLists){
            Map<Id, ccrz__E_PriceListItem__c> productToPliMap = new Map<Id, ccrz__E_PriceListItem__c>();
            priceListProductsBySequence.add(productToPliMap);
            priceListToProductMap.put(agpl.ccrz__PriceList__c, productToPliMap);
        }



        // Query price list items
        List<Id> productIds = new List<Id>();
        for(ccrz__E_CartItem__c ci :cartItemMap.values()){
            productIds.add(ci.ccrz__Product__c);    
        }
        List<ccrz__E_PriceListItem__c> priceListItems = queryPriceListItemsByProductAndPriceList(productIds, new List<Id>(priceListToProductMap.keySet()));


        // Put the price list items in the priceListToProductMap
        for(ccrz__E_PriceListItem__c pli :priceListItems){
            // Get the priceListToProductMap for the price list item
            Map<Id, ccrz__E_PriceListItem__c> theMap = priceListToProductMap.get(pli.ccrz__PriceList__c);

            // Put the pli into the priceListToProductMap
            theMap.put(pli.ccrz__Product__c, pli);
        }


        // product id => selected price list item
        Map<Id, ccrz__E_PriceListItem__c> selectedPricingMap = new Map<Id, ccrz__E_PriceListItem__c>();

        // for each price list item, get the price by either price list sequence, or lowest price
        Boolean bySequence = Boolean.valueOf(settings.TaxServiceFindBySequence__c);  // true means by account group price list sequence, false means lowest price
        ccrz__E_PriceListItem__c foundPli;
        if (bySequence) {
            for(ccrz__E_PriceListItem__c pli :priceListItems){

                selectedPricingMap.put(pli.ccrz__Product__c, findPriceListItemByPriceListSequence(pli.ccrz__Product__c, priceListProductsBySequence));
            }
        }
        else {
            for(ccrz__E_PriceListItem__c pli :priceListItems){

                selectedPricingMap.put(pli.ccrz__Product__c, findPriceListItemByPrice(pli.ccrz__Product__c, priceListProductsBySequence));
            }
        }

        // For each cart item, get the PriceListItem for the product in the CartItem
        for(ccrz__E_CartItem__c cartItem :cartItemMap.values()){
            ccrz__E_PriceListItem__c pli = selectedPricingMap.get(cartItem.ccrz__Product__c);

        // HERE - now we know the selected PriceListItem for each cartitem
            // Build the data into the request
        }
        List<cc_imp_json_TaxRequest> taxRequests = buildTaxRequests(cart, theAccount, cartItemMap.values(), selectedPricingMap, settings.TaxServiceRequestMethod__c, vatNumber, taxClassification);
        ccrz.ccLog.log('*** Tax Requests: ' + JSON.serialize(taxRequests));

        // Callout to the tax service
        cc_imp_util_Http httpUtil = executeTaxRequest(taxRequests);
        ccrz.ccLog.log('*** Tax Response: ' + JSON.serialize(httpUtil.response.getBody()));

        // Parse the response to calculate the tax
        try {
        taxAmount = parseTaxResponse(httpUtil.response.getBody());
        ccrz.ccLog.log('*** Tax amount: ' + taxAmount);
        }
        catch(Exception e){
            ccrz.ccLog.log('*** Tax exception: ' + e.getMessage());
        }


        ccrz.ccLog.log('*** Returning Tax Amount: ' + taxAmount);
        return taxAmount;
	}

    public static cc_imp_util_Http executeTaxRequest(List<cc_imp_json_TaxRequest> taxRequests) {
        if (settings == null) {
            String storeFrontName = ccrz.cc_CallContext.storefront;
            settings =  cc_imp_StorefrontSettings__c.getInstance(storeFrontName);
        }

        String requestBody = JSON.serialize(taxRequests, true);
        System.debug('Request: ' + requestBody);
        // TODO - test only
        // requestBody = '[{"ship_to":"31162","sold_to":"31162","material":"69436","quantity":"1","sales_unit":"DR",      "price":"12.34", "price_unit":"LB",      "curr":"USD", "plant":"0056",      "sfdc_account_id":"11-22-33","sfdc_material_id":"44-55-1","sales_org":"1000","distr_chan":"30","division":"31","freight_terms":"ZD1"}]';

        cc_imp_util_Http httpUtil = new cc_imp_util_Http();
        httpUtil.method = cc_imp_util_Http.REQUEST_TYPE.POST;
        httpUtil.endpoint = ('callout:Nexeo_SAP_Endpoint/'+ settings.TaxServiceURLPath__c);
        httpUtil.timeout = Integer.valueOf(settings.TaxServiceTimeout__c);

        httpUtil.addHeader('Content-Type', 'application/json');
        httpUtil.addHeader('Accept', 'application/json');
        httpUtil.setBody(requestBody);
        HttpResponse response = httpUtil.submitRequest();
        System.debug('Response: ' + JSON.serialize(response.getBody()));
        return httpUtil;

    }

    public static Decimal parseTaxResponse(String response){
        Decimal taxAmount = null;
        Boolean success = true;
//        try {
            List<cc_imp_json_TaxResponse> responses = cc_imp_json_TaxResponse.parse(response);
            for(cc_imp_json_TaxResponse res :responses) {
                if (res.status == cc_imp_json_TaxResponse.SUCCESS_STATUS) {
                    for(cc_imp_json_TaxResponse.Subtotals subs :res.subtotals){
                        System.debug('cm_group: ' + subs.cm_group + ' -- cm_subtotal: ' + subs.cm_subtotal);
                        if('03'.equals(subs.cm_group) && '09'.equals(subs.cm_subtotal)){
                            if(subs.kwert != null){
                                subs.kwert = subs.kwert.replaceAll(' ', '');
                                System.debug('kwert: .' + subs.kwert + '.');
                                Decimal amount = Decimal.valueOf(subs.kwert);   
                                if (taxAmount == null) {
                                    taxAmount = amount;
                                }
                                else {
                                    taxAmount += amount;
                                }
                            }
                        }
                    }
                }
                else {
                    success = false;
                    break;
                }
            }
//        }
//        catch(Exception e) {
//            System.debug('Error parsing tax response: ' + e.getMessage());
//            throw new TaxCalculationException(e);
//        }
        if (!success) {
            throw new TaxCalculationException('Tax service returned unsuccessful status.');
        }
        return taxAmount;
    }

    public class TaxCalculationException extends Exception {}

}