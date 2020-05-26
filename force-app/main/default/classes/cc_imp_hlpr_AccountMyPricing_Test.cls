@isTest
public class cc_imp_hlpr_AccountMyPricing_Test {
    
   @isTest static void getAccountWithRepresentative(){
       Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg2' + DateTime.now().getTime() + '.com', IsActive = true,Ashland_Employee_Number__c = 'A123002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
       Account userAccount = new Account(Name = 'Test Account');
       insert userAccount;
       
       Profile sysAdminProfile = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator' LIMIT	1];        
       User sysAdminUser = new User(FirstName = 'firstName', LastName = 'lastName', Email = 'sysadmin@email.com', Alias = 'alias', Username = 'sysadmin@email' + DateTime.now().getTime() + '.com', LocaleSidKey = 'en_US', TimeZoneSidKey = 'GMT', ProfileId = sysAdminProfile.Id, LanguageLocaleKey = 'en_US',	EmailEncodingKey = 'UTF-8');

       System.runAs(sysAdminUser) {
           	Profile userProfile = [SELECT Id, Name FROM Profile WHERE Name = 'AD-Sales Representative Plastics' LIMIT	1];        
       		User primarySeller = new User(FirstName = 'firstName', LastName = 'lastName', Email = 'primarySeller@email.com', Alias = 'alias', Username = 'primarySeller@email' + DateTime.now().getTime() + '.com', LocaleSidKey = 'en_US', TimeZoneSidKey = 'GMT', ProfileId = userProfile.Id, LanguageLocaleKey = 'en_US',	EmailEncodingKey = 'UTF-8');
       		insert primarySeller;
           	userAccount.Primary_Seller__c = primarySeller.Id;
          	update userAccount;
       }
       
       Account accountWihtRepresentative = cc_imp_hlpr_AccountMyPricing.getAccountWithRepresentative(userAccount.Id);
       System.assert(accountWihtRepresentative.Primary_Seller__r.User_Email__c != null);

    }

}