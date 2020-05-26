global with sharing class cc_mn_ctrl_Cart {

    public String extendedCartJSON {get; set;}
    public String cartCurrency {get; set;}

    public cc_mn_ctrl_Cart() {
       String encryptedCartId = ApexPages.currentPage().getParameters().get('cartId');
 		 String cartID= ccrz.cc_CallContext.currCartId;
		System.debug('FGG cartID'+cartID);
        List<ccrz__E_Cart__c> cartSFDCid = [
            select 
            	id,
            	ccrz__CurrencyISOCode__c
            from
            	ccrz__E_Cart__c
            where 
            	ccrz__EncryptedId__c = : cartID Limit 1
        ];
            
        
        System.debug('FGG cartSFDCid'+cartSFDCid);
        if(!cartSFDCid.isEmpty()){
        for(ccrz__E_Cart__c cart : cartSFDCid){
                this.cartCurrency=cart.ccrz__CurrencyISOCode__c;
            } 
            
        }
        else{
                this.cartCurrency='';
            
        }
       this.extendedCartJSON = JSON.serialize(buildExtendedCartItemMap(encryptedCartId));
    }

    private Map<String,ExtendedCartItem> buildExtendedCartItemMap(String encryptedCartId) {
        Map<String, ExtendedCartItem> extendedCartItemMap = new Map<String, ExtendedCartItem>();

        List<ccrz__E_CartItem__c> cartItemList = new List<ccrz__E_CartItem__c>(
            [
                SELECT
                    Id
                    , ccrz__Product__c, ccrz__Price__c,Price_Per_Unit__c,ccrz__Quantity__c
                FROM
                    ccrz__E_CartItem__c
                WHERE
                    ccrz__Cart__r.ccrz__EncryptedId__c = :encryptedCartId
            ]
        );

        Set<Id> productIdSet = new Set<Id>();
        for (ccrz__E_CartItem__c item : cartItemList) {
            productIdSet.add(item.ccrz__Product__c);
        }
        Map<Id, ccrz__E_PriceListItem__c> pliMap = cc_imp_hlpr_PriceListHelper.getPriceListItemsBySequence(new List<Id>(productIdSet));
        cc_imp_hlpr_PriceListHelper priceListHelper=new cc_imp_hlpr_PriceListHelper();
        System.debug('FGGT size pli'+pliMap.size());
        //priceItemsTiers=cc_imp_hlpr_PriceListHelper.getPriceListItemTierBulk(pliMap.values());
        
        
        for (ccrz__E_CartItem__c item : cartItemList) {
            ExtendedCartItem newExtendedCartItem = new ExtendedCartItem();
            ccrz__E_PriceListItem__c pli = pliMap.get(item.ccrz__Product__c);
            if (pli != null && pli.CPI__c != null) {
                List<cc_imp_hlpr_PriceListHelper.PriceListItemTier> priceItemsTiers=new List<cc_imp_hlpr_PriceListHelper.PriceListItemTier>();
                priceItemsTiers=cc_imp_hlpr_PriceListHelper.getPriceListItemTierFGG(pli.Id);
                newExtendedCartItem.customerMaterialNumber = pli.CPI__r.Customer_Material_Number__c;                
                newExtendedCartItem.productNumber=String.valueOf(Integer.valueOf(pli.ccrz__Product__r.Product_Number__c));
                String priceUOM='';   
                String amount='';
                //List<cc_imp_hlpr_PriceListHelper.PriceListItemTier> tiers=priceItemsTiers.get(pli.Id);
                   //cc_imp_hlpr_PriceListHelper.PriceListItemTier tierPrice=tiers[0];
                System.debug('FGGT Tiers size'+priceItemsTiers.size());
                if(priceItemsTiers.size()>1 && item.ccrz__Quantity__c>1){
                    for(Integer i=0; i<priceItemsTiers.size(); i++)
                    {          
                        if(item.ccrz__Quantity__c>=Decimal.valueOf(priceItemsTiers[i].lowerBound)){
                            
                            priceUOM=priceItemsTiers[i].baseAmount;
                            amount=priceItemsTiers[i].amount;
                        }
                            
                    }                                        
                    newExtendedCartItem.priceuom=priceUOM;
                    newExtendedCartItem.priceperunit=amount;
                }else{
                    if(priceItemsTiers.size() > 0){
                        newExtendedCartItem.priceuom=priceItemsTiers[0].baseAmount;    
                        newExtendedCartItem.priceperunit=priceItemsTiers[0].amount;    
                        System.debug('FGGT Else baseAmount '+priceItemsTiers[0].baseAmount);
                    }                    

                }
                
            }
            if(pli != null && pli.ccrz__MinQty__c != null && pli.ccrz__MinQty__c > 1){
                newExtendedCartItem.minimumQuantity = pli.ccrz__MinQty__c;
            }
            else {
                newExtendedCartItem.minimumQuantity = 1;
            }

            extendedCartItemMap.put(item.Id, newExtendedCartItem);
        }

        return extendedCartItemMap;
    }
  

   
    global class ExtendedCartItem {
        public String customerMaterialNumber {get; set;}
        public Decimal minimumQuantity {get; set;}
        public String priceperunit {get; set;}
        public String priceuom {get; set;}
        public String productNumber {get; set;}        
    }
}