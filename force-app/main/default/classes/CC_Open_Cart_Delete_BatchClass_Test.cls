// Class Name: CC_Open_Cart_Delete_BatchClass_Test 
// Developer Name: Naren Karthik
// Functionality Description:  test class for Batch Class CC_Open_Cart_Delete_BatchClass.
//Last Modified By: Naren Karthik  Date: 04/07/2017.
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


@isTest
private class CC_Open_Cart_Delete_BatchClass_Test { 
    
    static testMethod void nexeo3d_opencart_test() 
    {    
               //Insert custom setting for this test
               cc_imp_StorefrontSettings__c myNexeoCustomSetting = cc_imp_testUtils.createMyNexeoCustomSetting();
               insert myNexeoCustomSetting ;
        id ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123002', FirstName = 'Nexeo_Integration');
        //insert nexeoIntegrationUser;
           // account acct = new Account(name='TestAccount',Type='Customer');
            //insert acct; 
           Map<String, SObject> testData = new Map<String, SObject>(NexeoTestUtils_Test.initData());
           Account acct= (Account) testData.get('testGeneralAccount');
        
            ccrz__E_Cart__c eecart = NULL;
            eecart = new ccrz__E_Cart__c(ccrz__Storefront__c='mynexeo',ccrz__Account__c= acct.id, ccrz__CartStatus__c = 'Open');
            insert eecart;
    
            List<ccrz__E_Cart__c> ccart = new list<ccrz__E_Cart__c>();
            ccart.add(eecart);
            Test.startTest();
            CC_Open_Cart_Delete_BatchClass occ =new CC_Open_Cart_Delete_BatchClass();
            id idbatch = database.executebatch(occ);
            Test.stoptest();  
        
            User nexeo3Dguestuser = [Select Id from User where name = 'nexeo3d Site Guest User' LIMIT 1];
            List<ccrz__E_Cart__c> cccarts = [Select id,ccrz__Storefront__c,ccrz__Account__c from ccrz__E_Cart__c where ccrz__Storefront__c = 'nexeo3d' AND ccrz__CartStatus__c = 'Open' AND CreatedById =: nexeo3Dguestuser.Id];
            
            System.assertEquals(0, cccarts.size(), 'Nexeo3d open carts still exists after batch delete');
    }
    static testMethod void mynexeo_opencart_test() 
    {
               //Insert custom setting for this test
       cc_imp_StorefrontSettings__c myNexeoCustomSetting = cc_imp_testUtils.createMyNexeoCustomSetting();
       insert myNexeoCustomSetting ;
        
            //account acct = new Account(name='TestAccount',Type='Prospect');
            //insert acct; 
            Map<String, SObject> testData = new Map<String, SObject>(NexeoTestUtils_Test.initData());
            Account acct= (Account) testData.get('testGeneralAccount');
            ccrz__E_Cart__c eecart = new ccrz__E_Cart__c(ccrz__Storefront__c='mynexeo', ccrz__Account__c= acct.id, ccrz__CartStatus__c = 'Open');
            insert eecart;
            
            List<ccrz__E_Cart__c> ccart = new list<ccrz__E_Cart__c>();
            ccart.add(eecart);
            Test.startTest();
            CC_Open_Cart_Delete_BatchClass occ =new CC_Open_Cart_Delete_BatchClass();
            id idbatch = database.executebatch(occ);
            Test.stoptest();

            List<ccrz__E_Cart__c> cccarts = [Select id,ccrz__Storefront__c,ccrz__Account__c from ccrz__E_Cart__c where ccrz__Storefront__c = 'mynexeo' AND ccrz__CartStatus__c = 'Open'];
            
            System.assertEquals(0, cccarts.size(), 'myNexeo open carts still exists after batch delete');        
    }
}