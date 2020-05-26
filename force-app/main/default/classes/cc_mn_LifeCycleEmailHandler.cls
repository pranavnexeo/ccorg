/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        02/13/2018
*   Author:             Ignacio Gonzalez
*   Last Modified:       
*   Last Modified By:    
*
*   Short Description:  Inbound email handler for life cycle reports
*   
*   
*	
*   **********************************************************************************************************************/
global with sharing class cc_mn_LifeCycleEmailHandler implements Messaging.InboundEmailHandler {
    
	  global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
		  Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
          String myPlainText = email.plainTextBody;
       	  String fromEmail = email.FromAddress;
          String emailSubject = email.subject;
          
          if (String.isNotBlank(emailSubject)) {
              
              Savepoint sp = Database.setSavepoint();
              try {
                  
                  //Get Id from subject
                  Integer startId = emailSubject.lastIndexOf('R-');
                  String idOnSubject = emailSubject.substring(startId , startId + 10);
                                
                  //If Id on subject is valid
                  LifeCycle_Report_Request__c lcr = [SELECT Id, Status__c, Document_ID__c, Contact__c FROM 
                                                     LifeCycle_Report_Request__c WHERE Name =: idOnSubject];
                  
                  User userToBeOwner = [SELECT Id FROM User WHERE ContactId =:  lcr.Contact__c];
                  
                  //Verify if we have on attachment on email
                 if (email.binaryAttachments != null && email.binaryAttachments.size() > 0) {
                      //We will only get the xls attachment
                     Messaging.Inboundemail.BinaryAttachment reportFromSAP;
                     for (Messaging.Inboundemail.BinaryAttachment attachment:email.binaryAttachments) {
                         if (attachment.filename.contains('xls') || attachment.filename.contains('XLS') || attachment.filename.contains('xlsx') || attachment.filename.contains('XLSX')) {
                             reportFromSAP = attachment;
                         }
                     }
                     
                     Attachment attach = new Attachment(Name = reportFromSAP.filename, Description = 'Life Cycle Report', ParentId = lcr.Id);
                     attach.body = reportFromSAP.body;
                     attach.CreatedById  = userToBeOwner.Id;
                     attach.OwnerId = userToBeOwner.Id;
                     insert attach;
					
                     //Updating status and document id on LifeCycleReport 
                     lcr.Status__c = 'Delivered';
                     lcr.Document_ID__c = attach.Id;
                     update lcr;
                     
 
                 }
                
              } catch (Exception ex) {
                  Database.rollback(sp);
                  cc_imp_StorefrontSettings__c settings = cc_imp_StorefrontSettings__c.getInstance('mynexeo');
                  Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                  message.toAddresses = settings.Email_Handle_Exception__c.split(',');
                  message.subject = 'CP-Exception on Waste Summary Report';
                  String plainText = 'Email Subject : "' + emailSubject + '" \n ' + ' Plain Text : "' + myPlainText + '"';
                  message.plainTextBody = plainText + ' \n CP-Exception: '+ex.getLineNumber()+' '+ex.getMessage();
                  Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
                  Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                  System.debug('CP-Exception: '+ex.getLineNumber()+' '+ex.getMessage());
              }


          }
          
          return result;
      }
    
}