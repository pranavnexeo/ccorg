@isTest
private class Chatter_Add_Follower_Email_Handler_Test {
public static testMethod void TestinBoundEmail()
     {
      
      Test.StartTest();

  // create a new email and envelope object
      Messaging.InboundEmail email = new Messaging.InboundEmail() ;
      Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
      Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
      Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution Customer').getRecordTypeId();
   Account acc = new Account(Name = 'Test',RecordtypeId=RecordTypeId,SAP_Sales_Org__c = 'Test', SAP_DivisionCode__c = 'Test', SAP_Industry_Key__c ='Test',HQ_Sales_Office__c = 'Test', SAP_SalesGroup__c = 'Test');
   insert acc;
 
      //Account acc = new Account(Name='TestAcc');
       // insert acc;
    
      // setup the data for the email
      email.subject = acc.id;
      email.fromname = 'FirstName LastName';
      email.plainTextBody = 'email body\n2225256325\nTitle';
      email.htmlbody = 'test';
      env.fromAddress = 'aa.cc@dd.com';
      
      
       // call the email service class and test it with the data in the testMethod
      Chatter_Add_Follower_Email_Handler emailProcess = new Chatter_Add_Follower_Email_Handler();
      emailProcess.handleInboundEmail(email, env);
      
Test.StopTest();
}
}