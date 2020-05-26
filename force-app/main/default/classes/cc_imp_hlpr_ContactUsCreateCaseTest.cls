@isTest
public with sharing class cc_imp_hlpr_ContactUsCreateCaseTest {

   
    static testmethod void  insertCaseTest() {
         Map<String, SObject> m = cc_imp_testUtils.initData();
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc45@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A12345002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
          system.runAs(nexeoIntegrationUser)
        {
            insert cc_imp_testUtils.createNexeoCustomSettingList();
        User u = [SELECT Id, Name, ContactId, Contact.AccountId FROM User WHERE UserName = 'username@email.com'];

        Case c = new Case(AccountId = u.Contact.AccountId, Reason = 'because', ContactId = u.ContactId, Description = 'because because');

        Test.startTest();
        cc_imp_hlpr_ContactUsCreateCase.insertCase(c);
        Test.stopTest();

        System.assert(c.Id != null);
        }

    }

    static testmethod void  insertNexCareTest() {
         Map<String, SObject> m = cc_imp_testUtils.initData();
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdfsdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A12ds3002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
          system.runAs(nexeoIntegrationUser)
        {
            insert cc_imp_testUtils.createNexeoCustomSettingList();
        User u = [SELECT Id, Name, ContactId, Contact.AccountId FROM User WHERE UserName = 'username@email.com'];
        NexCare__c nexCare = new NexCare__c(Account_Name__c = u.Contact.AccountId, Tier_1__c = 'Request', Contact_Name__c = u.ContactId, Tier_2__c = 'Invoice Dispute', Short_Description__c = 'because', Description__c = 'because because');
        
        Test.startTest();
        cc_imp_hlpr_ContactUsCreateCase.insertNexCare(nexCare);
        Test.stopTest();

        System.assert(nexCare.Id != null);
        }
    }

    static testmethod void  insertCasesTest() {
         Map<String, SObject> m = cc_imp_testUtils.initData();
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhsdredc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A12ytty3002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
          system.runAs(nexeoIntegrationUser)
        {
            insert cc_imp_testUtils.createNexeoCustomSettingList();
        User u = [SELECT Id, Name, ContactId, Contact.AccountId FROM User WHERE UserName = 'username@email.com'];

        List<Case> cases = new List<Case>();
        cases.add(new Case(AccountId = u.Contact.AccountId, Reason = 'because', ContactId = u.ContactId, Description = 'because because'));

        Test.startTest();
        cc_imp_hlpr_ContactUsCreateCase.insertCases(cases);
        Test.stopTest();

        System.assert(cases[0].Id != null);
        }
    }
    
}