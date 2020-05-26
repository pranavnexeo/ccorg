/* 
* Description: Test class for the class cc_imp_ctrl_mn_header
* Date: 07 / 11 / 2017
* Developer: Ignacio Gonzalez
*/
@IsTest
public class cc_imp_ctrl_mn_header_test {
    
        static User nexeoIntegrationUser;
    
        static void setupUpTestData() {
            
               List <cc_imp_StorefrontSettings__c > storeFrontSettingsList = cc_imp_testUtils.createNexeoCustomSettingList();

               insert storeFrontSettingsList ;
        
               Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.MYNEXEO_USER_COMMUNITY_PROFILE];
        
                ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
                insert userAccountGroup;
        		Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
         nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
                Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
                insert userAccount;
        
                Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
                insert userContact;
        
                //portalUser = cc_imp_testUtils.createUser(userProfile, userContact, 'cc_imp_username@email.com', 'contact@email.com', 'firstName', 'lastName', 'alias');
            	//insert portalUser;
        
               //cc_imp_testUtils.clearContext();
               ccrz.cc_CallContext.currAccountId = userAccount.Id;
               ccrz.cc_CallContext.currContact = userContact;
               ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_MYNEXEO_STOREFRONT;
             
               ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
    	}
    
        // We are going to simulate that user has change his language
    	@isTest static void changeLanguage() {
             setupUpTestData();
             // In order to simulate that we are the user that is logged in to the Portal
			 System.runAs(nexeoIntegrationUser) {
                //cc_imp_ctrl_mn_header objcc_imp_ctrl_mn_header = new cc_imp_ctrl_mn_header();
             	//cc_imp_ctrl_mn_header.updateLocale('en_US');
             }            
                       
        }
    
        // We are going to simulate that user has change his language
    	@isTest static void externalLogin() {
             System.currentPageReference().getParameters().put('logintype', 'external');
             System.currentPageReference().getParameters().put('username', 'awesomusername@awesome.com');
             System.currentPageReference().getParameters().put('password', 'securePassword');
             setupUpTestData();
             // In order to simulate that we are the user that is logged in to the Portal
			 System.runAs(nexeoIntegrationUser) {
                //cc_imp_ctrl_mn_header objcc_imp_ctrl_mn_header = new cc_imp_ctrl_mn_header();
             	//cc_imp_ctrl_mn_header.updateLocale('en_US');
             }            
                       
        }    
    

}