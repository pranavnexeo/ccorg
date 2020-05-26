global class nexPriceEmailService implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        String myPlainText = email.plainTextBody;
        
        String fromEmail = email.FromAddress;
        system.debug('From Email id is:'+fromEmail);
        List<User> toaddressespertransaction = new List<User>();
        Map<String, List<String>> IdToAddresses = new Map<String, List<String>>();
        Map<String, List<String>> IdToAddressesApprover = new Map<String, List<String>>();
        List<String> UserEmail = new List<String>();
        List<Id> PRTIds = new List<Id>();
        
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
        Integer index = email.subject.indexof('<');
        system.debug('index is : '+index);
        String PRTName = email.subject.substring(index+1,index+10);
        system.debug('PRTName is : '+PRTName);
        List<Price_Request_Transaction__c> prtRecord = [Select Id, PRT_Movement_Switch__c,Ship_To__r.SAP_Customer_Group_5__c,Ship_To__r.SAP_DivisionCode__c, Type__c, approval_status__c, Approval_Rejection_Comments__c, Email_Approval__c, CreatedById from  Price_Request_Transaction__c where Name = : PRTName];
        List<PRT_Movement_Settings__c> PRTMovmntSett = PRT_Movement_Settings__c.getall().values();
        Map<String,Boolean> CustGrpSettMap = new Map<String,Boolean>();
        Map<String,Boolean> customSettMap = new Map<String,Boolean>();
        String divCode;
        
        for(PRT_Movement_Settings__c PRTsett : PRTMovmntSett){
            customSettMap.put(PRTsett.Name,PRTsett.Switch__c);
            CustGrpSettMap.put(PRTsett.Name,PRTsett.CG5__c);
        }
        if(prtRecord.size()>0){
            String[] toaddress = new String[]{};
            toaddress.add(email.fromAddress);
            IdToAddressesApprover.put(prtRecord[0].Id,toaddress);
            toaddressespertransaction = [Select email from User where id =:prtRecord[0].CreatedById];
            UserEmail.add(toaddressespertransaction[0].email);
            IdToAddresses.put(prtRecord[0].Id,UserEmail);
            PRTIds.add(prtRecord[0].Id);
            system.debug('Status is: ' +prtRecord[0].approval_status__c );
            if(prtRecord[0].approval_status__c == 'Submitted' || prtRecord[0].approval_status__c == 'Pending Supplier'){    
                if(prtRecord[0].Ship_To__r.SAP_DivisionCode__c != null){
                    divCode = prtRecord[0].Ship_To__r.SAP_DivisionCode__c;
                    }
                else if (prtRecord[0].Sold_To__r.SAP_DivisionCode__c != null){
                    divCode = prtRecord[0].Sold_To__r.SAP_DivisionCode__c;
                }
                
                if(operation.contains('APPROVE') || operation.contains('YES')){
                 if(prtRecord[0].Type__c == 'CSP'){
                    if(customSettMap.get(divCode) == true){
                        if(CustGrpSettMap.get(divCode) == true){
                            prtRecord[0].approval_Status__c = 'SAP Transfer Open';
                        }
                        else{
                            if(prtRecord[0].Ship_To__r.SAP_Customer_Group_5__c == '11' || prtRecord[0].Ship_To__r.SAP_Customer_Group_5__c == '12' || prtRecord[0].Ship_To__r.SAP_Customer_Group_5__c == '13'){
                                prtRecord[0].approval_Status__c = 'Pending Entry';
                            }
                            else{
                                prtRecord[0].approval_Status__c = 'SAP Transfer Open';
                            }
                        }
                    }
                    else
                        prtRecord[0].approval_Status__c = 'Pending Entry';
                 }
                 else if(prtRecord[0].Type__c == 'Quote' || prtRecord[0].Type__c == 'RFQ')
                    prtRecord[0].approval_status__c = 'Approved';
                    prtRecord[0].Approval_Rejection_Comments__c = comments;
                    prtRecord[0].Email_Approval__c = true; 
                    update prtRecord;
                   result.success = true;
                   Email_Functions.sendEmailwithTemplate(IdToAddresses,PRTIds,'Price_Request_Trans_Approved',fromEmail);
                }else if(operation.contains('REJECT') || operation.contains('NO')){
                    prtRecord[0].approval_status__c = 'Rejected By Approver';
                    prtRecord[0].Approval_Rejection_Comments__c = comments;
                    prtRecord[0].Email_Approval__c = true; 
                    update prtRecord;
                    result.success = true;
                    Email_Functions.sendEmailwithTemplate(IdToAddresses,PRTIds,'Price_Request_Trans_Rejected',fromEmail); 
                }else{
                    String body = 'Your workflow approval message was not processed. The word used to approve or reject the item was not understood. Please contact your system administrator if you feel you received this message in error.';
                        
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setToAddresses(toaddress);
                    mail.setsubject(email.subject);
                    mail.setPlainTextBody(body);
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                    result.success = false;
                }
            }else{
                 
                 Email_Functions.sendEmailwithTemplate(IdToAddressesApprover,PRTIds,'Price_Request_Trans_Error_Mail','');
            }    
        }
        return result;
    }
}