/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        02/15/2018
*   Author:             Ignacio Gonzalez
*   Last Modified:       
*   Last Modified By:    
*
*   Short Description:  test for handler for Wasted Summary Inbound email
*   
*   
*	
*   **********************************************************************************************************************/
@IsTest
public class cc_mn_LifeCycleEmailHandler_Test {

    @IsTest
    public static void processEmail() {
         /*
    	* Account Group
    	*/
        ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
        insert userAccountGroup;

        /*
    	* Account
    	*/
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
        userAccount.AccountNumber = '7770618';
        insert userAccount;
		
        String randomEmailToUse = 'test' + String.valueOf(DateTime.now().getTime()) + '@test.com.nx'; 
        /*
    	* Contact
    	*/
        Contact userContact = cc_imp_testUtils.createContact(userAccount, randomEmailToUse);
        insert userContact;
        
        Profile userProfile = cc_imp_testUtils.getCustomerCommunityProfile();
        
        /*
    	* Portal User
    	*/
        User portalUser = cc_imp_testUtils.createUser(userProfile, userContact, randomEmailToUse, randomEmailToUse, 'firstName', 'lastName', 'alias');
       // insert portalUser;
        
       // Create record to send to SAP and simulate an email
       LifeCycle_Report_Request__c lcr = new LifeCycle_Report_Request__c();
       lcr.From_Date__c = Date.Today();
       lcr.To_Date__c = Date.Today().addDays(7);
       lcr.Status__c = 'Requested';
       lcr.Account__c = userAccount.Id;
       lcr.Contact__c = userContact.Id;
       lcr.Account_Numbers__c = userAccount.AccountNumber; 
       insert lcr;   
       
       cc_imp_StorefrontSettings__c settings = cc_imp_testUtils.createMyNexeoCustomSetting();
       insert settings;
        
       StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
       mock.setStaticResource('mockResponseSummary');
       mock.setStatusCode(200);
       mock.setStatus('200');
       mock.setHeader('Content-Type', 'application/json');
       Test.setMock(HttpCalloutMock.class, mock);
       Set<Id> idToSendOnTest = new Set<Id>();
       idToSendOnTest.add(lcr.Id);
       LifeCycleTriggerHandler.OnAfterInsertAsync(idToSendOnTest);
        
       Test.startTest();
        //TODO
       
        cc_imp_StorefrontSettings__c settingq1 = new cc_imp_StorefrontSettings__c(name='mynexeo',Email_Handle_Exception__c='test@abc.com,xyz@test.com');
        insert settingq1;
       String wasteSummaryName = [SELECT Id, Name FROM LifeCycle_Report_Request__c WHERE Id =: lcr.Id].Name;
       // create a new email and envelope object
       Messaging.InboundEmail inboundEmail = new Messaging.InboundEmail() ;
       Messaging.InboundEnvelope inboundEnvelope = new Messaging.InboundEnvelope();
       
       // setup the data for the email
      inboundEmail.subject = 'id:' + wasteSummaryName;
      inboundEmail.fromAddress = 'someaddress@email.com';
      inboundEmail.plainTextBody = 'Some Awesome text';
      
      // add an Binary attachment
      Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
      attachment.body = blob.valueOf('my attachment text');
      attachment.fileName = 'textfileone.xls';
      attachment.mimeTypeSubType = 'application/vnd.ms-excel';
      inboundEmail.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
    
      
      // call the email service class and test it with the data in the testMethod
      cc_mn_LifeCycleEmailHandler emailHandler = new cc_mn_LifeCycleEmailHandler();
      emailHandler.handleInboundEmail(inboundEmail, inboundEnvelope);
      Test.stopTest();
    }
    
    @IsTest
    public static void processEmailFails() {
         /*
    	* Account Group
    	*/
        ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
        insert userAccountGroup;
		Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
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
  
       // Create record to send to SAP and simulate an email
       LifeCycle_Report_Request__c lcr = new LifeCycle_Report_Request__c();
       lcr.From_Date__c = Date.Today();
       lcr.To_Date__c = Date.Today().addDays(7);
       lcr.Status__c = 'Requested';
       lcr.Account__c = userAccount.Id;
       lcr.Contact__c = userContact.Id;
       lcr.Account_Numbers__c = userAccount.AccountNumber;
       insert lcr;   
       
       cc_imp_StorefrontSettings__c settings = cc_imp_testUtils.createMyNexeoCustomSetting();
       settings.Email_Handle_Exception__c = 'test@test.com';
       insert settings;
        
       StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
       mock.setStaticResource('mockResponseSummary');
       mock.setStatusCode(200);
       mock.setStatus('200');
       mock.setHeader('Content-Type', 'application/json');
       Test.setMock(HttpCalloutMock.class, mock);
       Set<Id> idToSendOnTest = new Set<Id>();
       idToSendOnTest.add(lcr.Id);
       LifeCycleTriggerHandler.OnAfterInsertAsync(idToSendOnTest);
        
       Test.startTest();
        //TODO
       
        cc_imp_StorefrontSettings__c settingq1 = new cc_imp_StorefrontSettings__c(name='mynexeo',Email_Handle_Exception__c='test@abc.com,xyz@test.com');
        insert settingq1;
 
       String wasteSummaryName = [SELECT Id, Name FROM LifeCycle_Report_Request__c WHERE Id =: lcr.Id].Name;
       // create a new email and envelope object
       Messaging.InboundEmail inboundEmail = new Messaging.InboundEmail() ;
       Messaging.InboundEnvelope inboundEnvelope = new Messaging.InboundEnvelope();
       
       // setup the data for the email
      inboundEmail.subject = 'id:' + wasteSummaryName;
      inboundEmail.fromAddress = 'someaddress@email.com';
      inboundEmail.plainTextBody = 'Some Awesome text';
      
      // call the email service class and test it with the data in the testMethod
      cc_mn_LifeCycleEmailHandler emailHandler = new cc_mn_LifeCycleEmailHandler();
      emailHandler.handleInboundEmail(inboundEmail, inboundEnvelope);
      Test.stopTest();
    }
}