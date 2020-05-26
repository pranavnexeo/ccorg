@isTest
private class Integration_Error_Email_Handler_Test {
public static testMethod void TestinBoundEmail()
     {
     
      Test.StartTest();

  // create a new email and envelope object
      Messaging.InboundEmail email = new Messaging.InboundEmail() ;
      Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
    
      // setup the data for the email
      email.subject = 'Test';
      email.fromname = 'FirstName LastName';
      email.plainTextBody = 'email body\n2225256325\nTitle';
      email.htmlbody = 'test';
      env.fromAddress = 'aa.cc@dd.com';
      
      
      Messaging.InboundEmail email1 = new Messaging.InboundEmail() ;
      Messaging.InboundEnvelope env1 = new Messaging.InboundEnvelope();
      
      email1.subject = 'Test';
      email1.fromname = 'FirstName LastName';
      email1.htmlbody = 'test';
      env1.fromAddress = 'aa.cc@dd.com';
      
    
      // call the email service class and test it with the data in the testMethod
      Integration_Error_Email_Handler emailProcess = new Integration_Error_Email_Handler();
      emailProcess.handleInboundEmail(email, env);
      emailProcess.handleInboundEmail(email1, env1);
Test.StopTest();
}
}