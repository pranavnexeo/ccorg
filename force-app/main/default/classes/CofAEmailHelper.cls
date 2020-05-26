global class CofAEmailHelper implements Messaging.InboundEmailHandler {
            global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
                Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
               
               Certificate_Of_Analysis__c cofa = new Certificate_Of_Analysis__c();
                 cofa.PlantName__c = email.subject;
                // cofa.Sender__c = email.fromAddress;

               
                               insert cofa;
                
               if (email.binaryAttachments != null && email.binaryAttachments.size() > 0) {
      for (integer i = 0 ; i < email.binaryAttachments.size() ; i++) {
        Attachment attachment = new Attachment();
        // attach to the newly created analysis certificate record
        attachment.ParentId = cofa.Id;
        attachment.Name = email.binaryAttachments[i].filename;
        attachment.Body = email.binaryAttachments[i].body;
        insert attachment;
      }
    }
               
               
                return result;
            }
        }