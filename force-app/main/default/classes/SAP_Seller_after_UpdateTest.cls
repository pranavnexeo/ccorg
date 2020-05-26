@isTest
public class SAP_Seller_after_UpdateTest {
    static testMethod void myUnitTest() {
                Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      
       User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true,Ashland_Employee_Number__c = 'A123000');
          insert u;
        List<ccrz__E_Product__c> ccpl;
        List<Database.Upsertresult> db;
        System.runAs(u) {
        SAP_Seller__c ss = new SAP_Seller__c(name = 'test',User__c = u.id);
            insert ss;
            update ss;
        }
    }
}