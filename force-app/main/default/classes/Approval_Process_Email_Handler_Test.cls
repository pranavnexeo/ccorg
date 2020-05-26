@isTest
private class Approval_Process_Email_Handler_Test {

public static testMethod void TestinBoundEmail()
     {
     
     try{
      Test.StartTest();

      Messaging.InboundEmail email = new Messaging.InboundEmail() ;
      Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
    
     email.subject = 'Test';
      email.fromname = 'FirstName LastName';
      email.plainTextBody = 'email body\n2225256325\nTitle';
      email.htmlbody = 'test';
      env.fromAddress = 'aa.cc@dd.com';
      
    Approval_Process_Email_Handler emailProcess = new Approval_Process_Email_Handler();
      emailProcess.handleInboundEmail(email, env);
      
Test.StopTest();
}catch(exception e){}
}
}