global class priceLetterEmailService implements Messaging.InboundEmailHandler {
      global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
            try{
            String ContactId = email.subject.trim().substring(email.subject.length()-7);
            List<Contact> Contacts = [select id, AccountId from Contact where SFDC_Contact_Number__c = :ContactId and AccountId != null limit 1];
            if(contacts.size() > 0){
            Map<Integer, String> months = new Map<Integer, String>{ 1=>'Jan',2=>'Feb', 3=>'Mar', 4=>'Apr', 5=>'May', 6=>'Jun', 7=>'Jul', 8=>'Aug', 9=>'Sept', 10=>'Oct', 11=>'Nov', 12=>'Dec'};
            
            Automated_Price_Letter__c apl = new Automated_Price_Letter__c(
              Name = system.today().day() + ' ' + months.get(system.today().month()) + ' ' + system.today().year(),
              Contact__c = Contacts.get(0).Id,
              Account__c = Contacts.get(0).AccountId
            );
            insert apl;
            system.debug('@@@'+email.binaryAttachments.size());
            List<Attachment> att = new List<Attachment>();
            if (email.binaryAttachments !=null && email.binaryAttachments.size() > 0)
             {

               for (integer i = 0 ; i < email.binaryAttachments.size() ; i++)
                {
                    Attachment a = new Attachment();
                    a.ParentId = apl.id;
                    a.Name = email.binaryAttachments[i].filename;
                    a.Body = email.binaryAttachments[i].body;
                    att.add(a);
                    
                 }
               insert att;
               if(att.size() == 1){
                 apl.attachment_id__c = att.get(0).id;
                 update apl;
               }
               
                 
              }
              
             }
            }catch(exception e){ system.debug('***ERROR***' + e.getmessage()); }

        return result;
      }
  }