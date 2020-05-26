@isTest
public class cc_imp_RequestForQuoteTriggerHandlerTest {
    static testmethod void triggerTest() {
        

        Map<String, SObject> m = cc_imp_testUtils.initData();
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc65765@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A1235675002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
          system.runAs(nexeoIntegrationUser)
        {
            insert cc_imp_testUtils.createNexeoCustomSettingList();
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        ctx.storefront = 'mynexeo';

        ccrz__E_RequestForQuote__c rfq = null;
        Test.startTest();

        rfq = new ccrz__E_RequestForQuote__c();
        rfq.ccrz__Account__c = m.get('userAccount').Id;
        rfq.ccrz__Contact__c = m.get('userContact').Id;
        rfq.ccrz__Cart__c = m.get('cart').Id;
        rfq.ccrz__Amount__c = 100.00;
        rfq.ccrz__CloseDate__c = Date.today();
        rfq.ccrz__Company__c = 'TestCo';
        rfq.ccrz__Description__c = 'RFQ Test';
        rfq.ccrz__Email__c = 'test@nexeo.com';
        rfq.ccrz__HasOptedOutOfEmail__c = false;
        rfq.ccrz__FirstName__c = 'Test';
        rfq.ccrz__LastName__c = 'User' ;
        rfq.ccrz__Phone__c = '123-456-1234';
        rfq.ccrz__Storefront__c = 'mynexeo';
        insert rfq;
        Test.stopTest();

        NexCare__c nexCare = [SELECT Id FROM NexCare__c WHERE Account_Name__c = :m.get('userAccount').Id];

        System.assert(nexCare != null);
        }
    }
}