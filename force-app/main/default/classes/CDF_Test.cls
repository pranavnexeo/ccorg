@isTest
public class CDF_Test{

  public static testMethod void testmyaccountdata() {
      id ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
     Account a = new Account(name = 'test account', type='Customer');
     insert a;
     Contract c = new Contract(Accountid = a.id);
     insert c;
     SAP_Purchasing_Group__c pg = new SAP_Purchasing_Group__c(name='test', Purchasing_Group_Code__c = 'ABC', email__c= userinfo.getusername());
     insert pg; 

           
   }
}