// Class Name: CC_Prospect_Cart_Delete_BatchClass_Test 
// Developer Name: Sneha Likhar
// Functionality Description:  test class for Batch Class CC_Prospect_Cart_Delete_BatchClass.
//Last Modified By: Naren Karthik  Date: 03/28/2017.
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


@isTest
private class CC_Prospect_Cart_Delete_BatchClass_Test { 

static testMethod void myUnitTest() {
                   //Insert custom setting for this test
               cc_imp_StorefrontSettings__c myNexeoCustomSetting = cc_imp_testUtils.createMyNexeoCustomSetting();
insert myNexeoCustomSetting;
    id ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Portal Prospect').getRecordTypeId();
        account acct = new Account(name='TestAccount',Type='Prospect',recordtypeid=accRecordTypeId );
        insert acct; 
        ccrz__E_Cart__c eecart = new ccrz__E_Cart__c(ccrz__Storefront__c='mynexeo',ccrz__Account__c= acct.id);
        insert eecart;
       
        List<ccrz__E_Cart__c> ccart = new list<ccrz__E_Cart__c>();
        ccart.add(eecart);
        Test.startTest();
        CC_Prospect_Cart_Delete_BatchClass r =new CC_Prospect_Cart_Delete_BatchClass();
        id idbatch = database.executebatch(r);
        //r.execute(null,ccart);
        Test.stoptest(); 

        List<ccrz__E_Cart__c> cccarts = [Select id,ccrz__Storefront__c,ccrz__Account__c from ccrz__E_Cart__c where ccrz__Storefront__c = 'mynexeo' AND ccrz__Account__c =: acct.id];
    
        System.assertEquals(0, cccarts.size(), 'myNexeo prospect carts still exists after batch delete');     
}
}