trigger updateCartCurrency on ccrz__E_CartItem__c (before Insert, before Update) {
    System.debug('FGG Trigger size '+Trigger.size);
    Set<Id> productIdSet = new Set<Id>();
    Set<Id> cartIdSet = new Set<Id>();
    for(ccrz__E_CartItem__c item : Trigger.new){  
        if(item.ccrz__StoreID__c!='nexeo3d'){
            productIdSet.add(item.ccrz__Product__c);
            cartIdSet.add(item.ccrz__Cart__c);
            System.debug('FGG Product Id '+item.ccrz__Product__c);
        }
    }   
        Map<Id, ccrz__E_PriceListItem__c> pliMap = cc_imp_hlpr_PriceListHelper.getPriceListItemsBySequence(new List<Id>(productIdSet));
        cc_imp_hlpr_PriceListHelper priceListHelper=new cc_imp_hlpr_PriceListHelper();
        Map<Id, String> cartCurrency= new Map<Id, String>();
    if(pliMap.size()>=1){
        for(ccrz__E_CartItem__c item : Trigger.new){  
                 if(item.ccrz__StoreID__c!='nexeo3d'){
                    ccrz__E_PriceListItem__c pli = pliMap.get(item.ccrz__Product__c);   
                    item.CurrencyIsoCode=pli.Currency_ISO_Code__c;
                    cartCurrency.put(item.ccrz__Cart__c, pli.Currency_ISO_Code__c);
                    System.debug('FGG Product currency '+pli.Currency_ISO_Code__c);   
                    System.debug('FGG Trigger size pli'+pliMap.size());        
                 }
        }   
        Set<id> cartHeaderIds=new Set<Id>();
        cartHeaderIds=cartCurrency.keySet();
        List<ccrz__E_Cart__c> cartHeaders = [SELECT Id, CurrencyIsoCode, ccrz__CurrencyISOCode__c,ccrz__Storefront__c FROM ccrz__E_Cart__c WHERE id in :cartHeaderIds];
        List<ccrz__E_Cart__c> cartstoUpdate=new List<ccrz__E_Cart__c>();
        for(ccrz__E_Cart__c cartHeader : cartHeaders){
             if(cartHeader.ccrz__Storefront__c!='nexeo3d'){
                cartHeader.ccrz__CurrencyISOCode__c=cartCurrency.get(cartHeader.Id);
                cartHeader.CurrencyIsoCode=cartCurrency.get(cartHeader.Id);        
                cartstoUpdate.add(cartHeader);
             }
    }
    update cartstoUpdate;
    }
}