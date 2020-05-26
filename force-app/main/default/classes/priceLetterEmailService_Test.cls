@isTest
public class priceLetterEmailService_Test{
    static Contact con;
    static Account acc;

 static testMethod void testpriceLetterEmailService() {
 Map<String, SObject> testData = NexeoTestUtils_Test.initData();
  // create a new email and envelope object
  Messaging.InboundEmail email = new Messaging.InboundEmail() ;
  Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
  
  acc = new Account(
      Name = 'test'
      );
     insert acc;
  
   con = new Contact(
         Receive_Price_Letter__c = true,
         AccountId = acc.Id,
         Email = 'test@gmail.com',
         FirstName = 'Monalisa',
         LastName = 'Halder',
         Price_Letter_Delivery_Method__c = 'Email',
         Price_Letter_Level__c = 'Ship To',
         Price_Letter_Language__c = 'English'   
      );
     insert con;
 
  // setup the data for the email
    contact c = [select id, SFDC_Contact_Number__c from contact where id = :con.id limit 1];
    email.subject = c.SFDC_Contact_Number__c;
  
  // add an attachment
  Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
  attachment.body = blob.valueOf('my attachment text');
  attachment.fileName = 'textfile.txt';
  attachment.mimeTypeSubType = 'text/plain';
 
  email.binaryAttachments =
    new Messaging.inboundEmail.BinaryAttachment[] { attachment };
 
  // call the email service class and test it with the data in the testMethod
  priceLetterEmailService pLES = new priceLetterEmailService();
  pLES.handleInboundEmail(email, env);
    
  // find the attachment
  Automated_Price_Letter__c pl = [select id from Automated_Price_Letter__c where contact__c = :con.id limit 1];
  Attachment a = [select name from attachment where parentId = :pl.id];
  System.assertEquals(a.name,'textfile.txt');
 
}


}