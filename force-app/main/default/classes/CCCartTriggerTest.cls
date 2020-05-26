@isTest 
public class CCCartTriggerTest { 

    @isTest 
    public static void createCart() { 
       //Insert custom setting for this test
       Map<String, SObject> m = cc_imp_testUtils.initData();
        userRole ur = [SELECT id from userrole  where developername= 'NEXEOSOLUTIONSORG' limit 1];
        id ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhddsfgdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A12ert3002', FirstName = 'Nexeo_Integration',UserRoleId = ur.Id);
        insert nexeoIntegrationUser;
         system.runAs(nexeoIntegrationUser)
        {
        cc_imp_StorefrontSettings__c myNexeoCustomSetting = cc_imp_testUtils.createMyNexeoCustomSetting();
       insert myNexeoCustomSetting ;
        
        //Map<String, SObject> m = cc_imp_testUtils.initData();
        ccrz__E_Product__c product = (ccrz__E_Product__c) m.get('product');
        product.NexeoMaterialId__c = 'materialId000';
        product.Product_Number__c = '00000011';
        update product;

        
        Account shipToAccount = (Account) m.get('userAccount');
        shipToAccount.SAP_Accounting_Group__c = 'Ship To';
        
        Account parentAccount = new Account(name = 'ParentAccountoAccountForShipTo' + shipToAccount.Id);
             
        
        Account billToAccount = new Account(name = 'SoldToAccountForShipTo' + shipToAccount.Id);
        
        insert billToAccount;
        System.debug('billToAccount ' + billToAccount);
        parentAccount.SAP_Bill_To_Account_ID__c = billToAccount.Id;
        insert parentAccount;   
        
        shipToAccount.Parent_Account__c = parentAccount.Id;
        update shipToAccount;
        System.debug('shipToAccount ' + shipToAccount);
        }
    }
    
    @isTest 
    public static void createCartWithBillToShipEmpty() {
       //Insert custom setting for this test
       Map<String, SObject> m = cc_imp_testUtils.initData();
        userRole ur = [SELECT id from userrole  where developername= 'NEXEOSOLUTIONSORG' limit 1];
        id ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhddsfgdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A12ert3002', FirstName = 'Nexeo_Integration',UserRoleId = ur.Id);
        insert nexeoIntegrationUser;
         system.runAs(nexeoIntegrationUser)
        {
        cc_imp_StorefrontSettings__c myNexeoCustomSetting = cc_imp_testUtils.createMyNexeoCustomSetting();
       insert myNexeoCustomSetting ;
        
        //Map<String, SObject> m = cc_imp_testUtils.initData();
        ccrz__E_Product__c product = (ccrz__E_Product__c) m.get('product');
        product.NexeoMaterialId__c = 'materialId000';
        product.Product_Number__c = '00000011';
        update product;

        
        Account shipToAccount = (Account) m.get('userAccount');
        shipToAccount.SAP_Accounting_Group__c = 'Ship To';
        
        Account parentAccount = new Account(name = 'ParentAccountoAccountForShipTo' + shipToAccount.Id);
             
        
        Account billToAccount = new Account(name = 'SoldToAccountForShipTo' + shipToAccount.Id);
        
        insert billToAccount;
        System.debug('billToAccount ' + billToAccount);
        parentAccount.SAP_Bill_To_Account_ID__c = billToAccount.Id;
        insert parentAccount;   
        
        shipToAccount.Parent_Account__c = parentAccount.Id;
        update shipToAccount;
        System.debug('shipToAccount ' + shipToAccount);
        
        ccrz__E_Cart__c newCart = new ccrz__E_Cart__c(
            ccrz__Account__c = shipToAccount.Id,
            ccrz__ActiveCart__c = true,
            ccrz__EffectiveAccountID__c = shipToAccount.id,
            ccrz__CartStatus__c = 'Open',
            ccrz__Storefront__c = 'mynexeo',
            ccrz__CurrencyISOCode__c = 'USD',
            CurrencyIsoCode = 'USD'
        );
        
        insert newCart;
        }
 
    }
}