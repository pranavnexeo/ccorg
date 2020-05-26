/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        02/14/2018
*    Author:             Ignacio Gonzalez
*   Last Modified:       
*   Last Modified By:    
*
*   Short Description:  Unit test for Controller cc_mn_ctrl_LifeCycleReport
*   
*   
*	
*   **********************************************************************************************************************/
@IsTest
public class cc_mn_ctrl_LifeCycleReport_Test {

		
    private static void setupInitialData() {
         Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
		 cc_imp_StorefrontSettings__c testSettings = cc_imp_testUtils.createMyNexeoCustomSetting();
         insert testSettings;
        
         Profile userProfile = cc_imp_testUtils.getCustomerCommunityProfile();

        /*
    	* Account Group
    	*/
        ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
        insert userAccountGroup;

        /*
    	* Account
    	*/
        Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
        insert userAccount;
		
        String randomEmailToUse = 'test' + String.valueOf(DateTime.now().getTime()) + '@test.com.nx'; 
        /*
    	* Contact
    	*/
        Contact userContact = cc_imp_testUtils.createContact(userAccount, randomEmailToUse);
        insert userContact;

        /*
    	* Portal User
    	*/
        User portalUser = cc_imp_testUtils.createUser(userProfile, userContact, randomEmailToUse, randomEmailToUse, 'firstName', 'lastName', 'alias');
        //insert portalUser;
        
        ccrz.cc_CallContext.currContact = userContact;
        ccrz.cc_CallContext.currContact.Id = userContact.Id;
        ccrz.cc_CallContext.currContact.email = userContact.email;
        ccrz.cc_CallContext.effAccount = userAccount;
    }
    
    @IsTest
    public static void initializeLifeCyclePage() {
        Test.startTest();
       
        setupInitialData();
        PageReference pageRef = Page.cc_mn_LifeCycle;
        Test.setCurrentPage(pageRef);      
        cc_mn_ctrl_LifeCycleReport controller = new cc_mn_ctrl_LifeCycleReport();
        Test.stopTest();
    }
    
    @IsTest
    public static void saveNewReportRequestLifeCyclePage() {
        Test.startTest();
        setupInitialData();
        PageReference pageRef = Page.cc_mn_LifeCycle;
        Test.setCurrentPage(pageRef);
        String startStringDate = '02-12-2018';
        String endStringDate = '02-17-2018';
        cc_mn_ctrl_LifeCycleReport controller = new cc_mn_ctrl_LifeCycleReport();
        Account userAccount=[select name from Account where id=:ccrz.cc_CallContext.effAccount.id];
        cc_mn_ctrl_LifeCycleReport.saveRecord(startStringDate, endStringDate,ccrz.cc_CallContext.effAccount.id,userAccount.Name,userAccount.Name);
        Test.stopTest();
    }
}