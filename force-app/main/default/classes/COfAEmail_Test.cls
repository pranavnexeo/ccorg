@isTest
public class COfAEmail_Test{

static testMethod void testCofAEmail() {
 
  // create a new email and envelope object
  Messaging.InboundEmail email = new Messaging.InboundEmail() ;
  Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
 
  // setup the data for the email
  email.subject = 'Test C Of A Email';
   env.fromAddress = 'someaddress@email.com';
 
  // add an attachment
  Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
  attachment.body = blob.valueOf('my attachment text');
  attachment.fileName = 'textfile.txt';
  attachment.mimeTypeSubType = 'text/plain';
 
  email.binaryAttachments =
    new Messaging.inboundEmail.BinaryAttachment[] { attachment };
 
  // call the email service class and test it with the data in the testMethod
  CofAEmailHelper emailProcess = new CofAEmailHelper();
  emailProcess.handleInboundEmail(email, env);
 
  // query for the C of A for which the email service was created
  
   Certificate_Of_Analysis__c cofa  = [select id,(select Attachment.Name from  Certificate_Of_Analysis__c.Attachments where Attachment.Name ='textfile.txt') from Certificate_Of_Analysis__c ];
 
     
  // find the attachment
  Attachment a = [select name from attachment where parentId = :cofa.id];
 
  System.assertEquals(a.name,'textfile.txt');
 
}


}