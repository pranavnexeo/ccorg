/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        02/14/2018
*   Author:             Ignacio Gonzalez
*   Last Modified:       
*   Last Modified By:    
*
*   Short Description: LifeCycleTrigger and LifeCycleTriggerHandler
*   
*   
*   
*   **********************************************************************************************************************/
@IsTest
public class LifeCycleTrigger_Test {
    
    public static Map<String, Object> setupInitialData(){
        
        Map<String, Object> dataCreated = new Map<String, Object>();
                Profile userProfile = cc_imp_testUtils.getCustomerCommunityProfile();
id ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        /*
        * Account Group
        */
        system.runAs(nexeoIntegrationUser)
        {
        ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
        insert userAccountGroup;

        /*
        * Account
        */
        
 
       Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
        userAccount.AccountNumber = '7770618';
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
        userRole ur = [SELECT id from userrole  where developername= 'NEXEOSOLUTIONSORG' limit 1];    
        User portalUser = cc_imp_testUtils.createUser(userProfile, userContact, randomEmailToUse, randomEmailToUse, 'firstName', 'lastName', 'alias');
        portalUser.userRoleId =ur.id;
            //insert portalUser;
        
        cc_imp_StorefrontSettings__c settings = cc_imp_testUtils.createMyNexeoCustomSetting();
        insert settings;
        
        
        dataCreated.put('userAccount', userAccount);
        dataCreated.put('userContact', userContact);
        }
	        return dataCreated;
    }
    
    @IsTest
    public static void newWasteSummaryRequestSucccessOnBulk(){
		
        Map<String, Object> testData = setupInitialData();
        userRole ur = [SELECT id from userrole  where developername= 'NEXEOSOLUTIONSORG' limit 1];
        id ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdcc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A12c3002', FirstName = 'Nexeo_Integration1',UserRoleId = ur.Id);
        insert nexeoIntegrationUser;
         system.runAs(nexeoIntegrationUser)
        {

        Account userAccount = (Account)testData.get('userAccount');
        Contact userContact = (Contact)testData.get('userContact');
        List<LifeCycle_Report_Request__c> lcrs = new  List<LifeCycle_Report_Request__c>();
        for (Integer i = 0; i < 60; i ++) {
        LifeCycle_Report_Request__c lcr = new LifeCycle_Report_Request__c();
            Date startDate =  Date.Today();
            Date endDate = startDate.addDays(7);
     
            lcr.From_Date__c = startDate;
            lcr.To_Date__c = endDate;
            lcr.Status__c = 'Requested';
            lcr.Account__c = userAccount.Id;
            lcr.Contact__c = userContact.Id;
            lcr.Account_Numbers__c = userAccount.AccountNumber;
            lcrs.add(lcr);
        }
            
        insert lcrs;  
        
        Test.startTest();
        //TODO
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('mockResponseSummary');
        mock.setStatusCode(200);
        mock.setStatus('200');
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
        Set<Id> idToSendOnTest = new Set<Id>();
        for(LifeCycle_Report_Request__c lcr:lcrs) {
            idToSendOnTest.add(lcr.Id);
        }
       
        LifeCycleTriggerHandler.OnAfterInsertAsync(idToSendOnTest);
        Test.stopTest();
        }    
    }
    
    @IsTest
    public static void newWasteSummaryRequestSucccess(){
 
        Map<String, Object> testData = setupInitialData();
        userRole ur = [SELECT id from userrole  where developername= 'NEXEOSOLUTIONSORG' limit 1];
        id ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbherdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123re002', FirstName = 'Nexeo_Integration1',UserRoleId = ur.Id);
        insert nexeoIntegrationUser;
         system.runAs(nexeoIntegrationUser)
        {

        Account userAccount = (Account)testData.get('userAccount');
        Contact userContact = (Contact)testData.get('userContact');
        LifeCycle_Report_Request__c lcr = new LifeCycle_Report_Request__c();
            Date startDate =  Date.Today();
            Date endDate = startDate.addDays(7);
     
            lcr.From_Date__c = startDate;
            lcr.To_Date__c = endDate;
            lcr.Status__c = 'Requested';
            lcr.Account__c = userAccount.Id;
            lcr.Contact__c = userContact.Id;
            lcr.Account_Numbers__c = userAccount.AccountNumber;

        insert lcr;  
        
        Test.startTest();
        //TODO
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('mockResponseSummary');
        mock.setStatusCode(200);
        mock.setStatus('200');
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
        Set<Id> idToSendOnTest = new Set<Id>();
        idToSendOnTest.add(lcr.Id);
        LifeCycleTriggerHandler.OnAfterInsertAsync(idToSendOnTest);
        Test.stopTest();
        }
    }

}