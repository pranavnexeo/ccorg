global class PriceSupportReqEmailService implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        String myPlainText = email.plainTextBody;
        String fromEmail = email.FromAddress;
        system.debug('From Email id is:'+fromEmail);
        List<User> toaddressespertransaction = new List<User>();
        Map<String, List<String>> IdToAddresses = new Map<String, List<String>>();
        Map<String, List<String>> IdToAddressesApprover = new Map<String, List<String>>();
        List<String> UserEmail = new List<String>();
        List<Id> PSRIds = new List<Id>();

        
        List<String> spliststrings = new List<String>();
        String comments = '';
        String operation = '';
        if(myPlainText != ''){
            spliststrings = myPlainText.split('\n');
            comments = spliststrings[1];
            operation = spliststrings[0];
            if(operation != '')
                operation = operation.toUpperCase();
        }
        system.debug('Operation is : '+ Operation);
        Integer index = email.subject.indexof('(');
        system.debug('index is : '+index);
        String PSRName = email.subject.substring(index+1,index+7);
        system.debug('PSRName is : '+PSRName);
        List<Price_Support_Request__c> psrRecord = [Select Id, Name, Status__c, Comments__c, CreatedById, Email_Approval__c from  Price_Support_Request__c where Name = : PSRName];
        
        if(psrRecord.size()>0){
            String[] toaddress = new String[]{};
            toaddress.add(email.fromAddress);
            IdToAddressesApprover.put(psrRecord[0].Id,toaddress);
            toaddressespertransaction = [Select email from User where id =:psrRecord[0].CreatedById];
            UserEmail.add(toaddressespertransaction[0].email);
            IdToAddresses.put(psrRecord[0].Id,UserEmail);
            PSRIds.add(psrRecord[0].Id);
            if(psrRecord[0].status__c == 'Open'){
                if(operation.contains('CLOSE')){
                    psrRecord[0].Status__c = 'Closed';
                    psrRecord[0].Comments__c = comments;
                    psrRecord[0].Email_Approval__c = true;
                    update psrRecord;
                    result.success = true;
                    //Send email for Closing the PSR
                    //Email_Functions.sendEmailwithTemplate(IdToAddresses,PSRIds,'Price_Request_Trans_Rejected',fromEmail);
                 } 
                 else{
                        String body = 'Your workflow approval message was not processed. The word used to close the item was not understood. Please contact your system administrator if you feel you received this message in error.';
                            
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setToAddresses(toaddress);
                        mail.setsubject(email.subject);
                        mail.setPlainTextBody(body);
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                        result.success = false;
                     } 
             }
             else{
                     //Error while closing the PSR record
                     //Email_Functions.sendEmailwithTemplate(IdToAddressesApprover,PSRIds,'Price_Request_Trans_Error_Mail','');
                }  
        }
        return result;
    }
}