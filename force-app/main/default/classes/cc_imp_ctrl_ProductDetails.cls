global with sharing class cc_imp_ctrl_ProductDetails {

	global String productType { get; set; }
    global String nexeoMaterialId { get; set; }
    global String productNumber { get; set; }
    global String customerMaterialNumber { get; set; }
    global String currencyPrice { get; set; }
    global String currencyCode { get; set; }
    global String cartCurrency { get; set; }
    global Decimal minimumQuantity {get; set;}
    global String tiers {get; set;}

	global cc_imp_ctrl_ProductDetails() {
        String sku = ApexPages.currentPage().getParameters().get('sku');
        String cartID= ccrz.cc_CallContext.currCartId;
			
        List<ccrz__E_Cart__c> cartSFDCid = [
            select 
            	id
            from
            	ccrz__E_Cart__c
            where 
            	ccrz__EncryptedId__c = : cartID Limit 1
        ];
        if(!cartSFDCid.isEmpty()){
               List<ccrz__E_CartItem__c> cartItemCurrency = [
            select 
            	id,
                CurrencyIsoCode                
            from
            	ccrz__E_CartItem__c
            where 
            	ccrz__Cart__c in: cartSFDCid  ORDER BY Name ASC Limit 1
        ];
            for(ccrz__E_CartItem__c cartItem : cartItemCurrency){
                this.cartCurrency=cartItem.CurrencyIsoCode;
            } 
            
            
        }
        else{
                this.cartCurrency='';
            
        }
        List<ccrz__E_Product__c> products = [
            SELECT
                Id,
                ccrz__ProductType__c,
                Product_Number__c,
                NexeoMaterialId__c
            FROM
                ccrz__E_Product__c
            WHERE
                ccrz__SKU__c = :sku LIMIT 1
        ];

        if (!products.isEmpty()) {
            Set<Id> productIdSet = new Set<Id>();
            for (ccrz__E_Product__c item : products) {
                productIdSet.add(item.Id);
            }
            Map<Id, ccrz__E_PriceListItem__c> pliMap = cc_imp_hlpr_PriceListHelper.getPriceListItemsBySequence(new List<Id>(productIdSet));

            productType = products.get(0).ccrz__ProductType__c;
            nexeoMaterialId = products.get(0).NexeoMaterialId__c;
            productNumber = String.valueOf(Integer.valueOf(products.get(0).Product_Number__c));

            ccrz__E_PriceListItem__c pli = pliMap.get(products.get(0).Id);
            if (pli != null) {
                if (pli.CPI__c != null) {
                    this.customerMaterialNumber = pli.CPI__r.Customer_Material_Number__c;
                }
                this.currencyCode=pli.Currency_ISO_Code__c;
                this.currencyPrice = pli.Price_with_Currency__c;
                this.minimumQuantity = pli.ccrz__MinQty__c;
                this.tiers = JSON.serialize(cc_imp_hlpr_PriceListHelper.getPriceListItemTier(pli.Id));
                System.debug(tiers);
            }

        }
	}

    @RemoteAction
    global static ccrz.cc_RemoteActionResult fetchMSDS(ccrz.cc_RemoteActionContext ctx, String materialId, String sfid) {
        return cc_imp_util_Storefront.fetchSDSAttachment(ctx,materialId,sfid);
    }

}