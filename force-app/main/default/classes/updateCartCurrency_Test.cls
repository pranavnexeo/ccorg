@IsTest
public class updateCartCurrency_Test {
    
    @isTest static void cartItemInsert() {
        
        Map<String, SObject> m = cc_imp_testUtils.initData();
        
       // List<cc_imp_StorefrontSettings__c> setList = cc_imp_testUtils.createNexeoCustomSettingList();
       // insert setList;
        
        User portalUser = (User) m.get('portalUser'); 
        
        System.runAs(portalUser) {
            ccrz__E_Product__c p = (ccrz__E_Product__c) m.get('product');
            ccrz.cc_CallContext.storefront = cc_imp_testUtils.DEFAULT_STOREFRONT;
            ccrz.cc_CallContext.effAccountGroup = ccrz.cc_CallContext.currAccountGroup;
            
            ccrz__E_Cart__c a = new ccrz__E_Cart__c();
                a.ccrz__CurrencyISOCode__c = 'USD';
                a.CurrencyIsoCode = 'USD';
                a.ccrz__Storefront__c = 'mynexeo';
            insert a;
            ccrz__E_Product__c product = new ccrz__E_Product__c();
                product.ccrz__SKU__c = '12345678';
            insert product;
            ccrz__E_CartItem__c cartItem = new ccrz__E_CartItem__c();
                cartItem.ccrz__Cart__c = a.Id;
                cartItem.ccrz__StoreID__c = 'mynexeo';
                cartItem.ccrz__Price__c = 39000;
                cartItem.ccrz__Product__c = p.Id;
            insert cartItem;
        }        	
        
    }

}