/***********************************************************************************************************************   
Univar Solutions
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        03/29/2017
*   Author:              Naren Karthik
*   Last Modified:       Naren Karthik
*   Last Modified By:    04/27/2017
*
*   Short Description:  Send email to CSR on new Transaction payment of mynexeo orders which is created after the new order creation
*                       Added send email to nexeo3d email on new Transaction payment of nexeo3d orders which is created after the new order creation
*   **********************************************************************************************************************/

public class cc_nex_order_email 
{
    public static void emailtocsr(Set<String> cctranspayIds)
    {
        try
        {
            OrgWideEmailAddress[] owea = new OrgWideEmailAddress[]{};
            
            if(!Test.isRunningTest())
            {
                owea = [select Id from OrgWideEmailAddress where Address = 'mynexeoplasticsdonotreply@nexeosolutions.com'];
            }
            
            Map<Id,ccrz__E_TransactionPayment__c> cctranspay_map = new Map<Id,ccrz__E_TransactionPayment__c>([Select Id, ccrz__AccountNumber__c, ccrz__CCOrder__c from ccrz__E_TransactionPayment__c where Id in: cctranspayIds]);
            System.debug('FGG'+cctranspay_map);
            Map<String,String> order_trans_pay_map = new Map<String,String>();
            Map<String,String> acc_order_map = new Map<String,String>();
            Map<String,String> csr_acc_map = new Map<String,String>();
            Map<String,String> order_con_map = new Map<String,String>();
            Set<String> csrwithemail = new Set<String>();
           
            List<Messaging.SingleEmailMessage> csr_emails = new List<Messaging.SingleEmailMessage>();
            
            for(ccrz__E_TransactionPayment__c  trp : cctranspay_map.values())
            {
                order_trans_pay_map.put(trp.ccrz__CCOrder__c, trp.Id);
            } 
			System.debug('FGG'+41);
            Map<Id,ccrz__E_Order__c> ccorders_map = new Map<Id,ccrz__E_Order__c>([Select Id, ccrz__Contact__c, ccrz__Account__c, Name, ccrz__OrderNumber__c, ccrz__PONumber__c, ccrz__RequestDate__c, ccrz__ShipTo__c  from ccrz__E_Order__c where Id in: order_trans_pay_map.keyset()]);
            List<Id> ccShipToContactAdd = new List<Id>();
            
			System.debug('FGG'+ccorders_map);
            for(ccrz__E_Order__c cco : ccorders_map.values())
            {
                acc_order_map.put(cco.ccrz__Account__c, cco.Id);
                System.debug(' cco.ccrz__Account__c ' + cco.ccrz__Account__c);
                order_con_map.put(cco.Id,cco.ccrz__Contact__c);
                ccShipToContactAdd.add(cco.ccrz__ShipTo__c);
            }  
            System.debug('FGG '+53);
            Map<Id,Contact> contact_map = new Map<Id,Contact>([Select Id, FirstName, LastName from Contact where Id in: order_con_map.values()]);
            
            System.debug('FGG '+contact_map);
            Map<Id,Account> accs_map = new Map<Id,Account>([Select Id, AccountNumber, Name, ZC_Partner__c from Account where Id in: acc_order_map.keySet()]);
            System.debug(' acc_order_map ' + acc_order_map);
            System.debug(' accs_map ' + accs_map);
            //Get shipping comments
            Map<Id, ccrz__E_ContactAddr__c > shippingCommentsMap = new Map<Id, ccrz__E_ContactAddr__c >();
            for (ccrz__E_ContactAddr__c contactAddress : [SELECT Id, ccrz__ShippingComments__c  FROM ccrz__E_ContactAddr__c WHERE Id IN :ccShipToContactAdd]) {
                	shippingCommentsMap.put(contactAddress.Id, contactAddress);
            }
            
            for(Account acc : accs_map.values())
            {
                csr_acc_map.put(acc.ZC_Partner__c, acc.Id);
            }  
            
            Map<Id,SAP_Seller__c> csrwithemail_map = new Map<Id,SAP_Seller__c>([Select Id, Email__c from SAP_Seller__c where Id in: csr_acc_map.keyset() and Email__c != NULL and Email__c != '']);
            
            if(csrwithemail_map.size() > 0)
            {            
                for(String csrid : csrwithemail_map.keySet())
                {            
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    List<String> sendTo = new List<String>();
                    sendTo.add(csrwithemail_map.get(csrid).Email__c);
                    mail.setToAddresses(sendTo);
                    
                   if (owea.size() > 0) 
                  {
                       mail.setOrgWideEmailAddressId(owea.get(0).Id);
                  }
                  else
                  {
                        mail.setReplyTo('mynexeoplasticsdonotreply@nexeosolutions.com');
                        mail.setSenderDisplayName('MyNexeo');                    
                  }
    
                    String subject = 'A new MyNexeo Order was created';
                    String comments = shippingCommentsMap.get(ccorders_map.get(acc_order_map.get(csr_acc_map.get(csrid))).ccrz__ShipTo__c).ccrz__ShippingComments__c;
                    if(String.isEmpty(comments)){
                        comments = '';
                    }
                    String body = 'Hi,';
                    body += '<br/>';
                    body += '<br/>';
                    body += 'A new MyNexeo Order was created and the details are below.';
                    body += '<br/>';
                    body += '<br/>';
                    body += 'Account Name: ' + accs_map.get(csr_acc_map.get(csrid)).Name;
                    body += '<br/>';
                    body += 'Account Number: ' + accs_map.get(csr_acc_map.get(csrid)).AccountNumber;
                    body += '<br/>';
                    body += 'Name of user: ' + contact_map.get(order_con_map.get(acc_order_map.get(csr_acc_map.get(csrid)))).FirstName + ' ' + contact_map.get(order_con_map.get(acc_order_map.get(csr_acc_map.get(csrid)))).LastName;
                    body += '<br/>';
                    body += 'Requested Date: ' + ((ccorders_map.get(acc_order_map.get(csr_acc_map.get(csrid))).ccrz__RequestDate__c != Null) ? formatDate(ccorders_map.get(acc_order_map.get(csr_acc_map.get(csrid))).ccrz__RequestDate__c) : 'No Date specified');
                    body += '<br/>';
                    body += 'PO Number: ' + ((cctranspay_map.get(order_trans_pay_map.get(acc_order_map.get(csr_acc_map.get(csrid)))).ccrz__AccountNumber__c != Null) ?  cctranspay_map.get(order_trans_pay_map.get(acc_order_map.get(csr_acc_map.get(csrid)))).ccrz__AccountNumber__c : ((ccorders_map.get(acc_order_map.get(csr_acc_map.get(csrid))).ccrz__PONumber__c != NULL) ? ccorders_map.get(acc_order_map.get(csr_acc_map.get(csrid))).ccrz__PONumber__c : 'No PO number specified'));
                    body += '<br/>';
                    body += 'SalesForce Order number: ' + ccorders_map.get(acc_order_map.get(csr_acc_map.get(csrid))).Name;
                    body += '<br/>';
                    body += 'Shipping Comments: ' + comments ;
                    body += '<br/>';
                    body += '<br/>';
                    body += 'Please Note: It could take up to 15 minutes before this order is available in SAP.';
                    body += '<br/>';
                    body += '<br/>';
                    body += 'Thanks';
                    body += '<br/>';
                    body += 'Salesforce';
                    
                    mail.setSubject(subject);
                    mail.setHtmlBody(body);
                    System.debug('Code execution reached here!!!');
                    csr_emails.add(mail);
                }
            }
            
            Messaging.SendEmailResult[] resultMail =  Messaging.sendEmail(csr_emails);
            
            System.debug('Email result:' + resultMail[0]);
        }
        catch(System.Exception e)
        {
            System.debug('FGG ERROR: Building & Sending email to CSR on new mynexeo orders encountered the following error. ' + e.getMessage());
        }      
    }

    public static void emailtonexeo3demail(Set<String> ccorderIds)
    {
        try
        {
            String nexeo3demail = 'nexeo3Dsolutions@nexeosolutions.com';
            
            OrgWideEmailAddress[] owea = new OrgWideEmailAddress[]{};
            
            if(!Test.isRunningTest())
            {
                owea = [select Id from OrgWideEmailAddress where Address = 'plasticsdonotreply@nexeosolutions.com'];
            }

            Map<String,String> acc_order_map = new Map<String,String>();
            Map<String,String> order_con_map = new Map<String,String>();
           
            List<Messaging.SingleEmailMessage> nexeo3d_emails = new List<Messaging.SingleEmailMessage>();
            
            Map<Id,ccrz__E_Order__c> ccorders_map = new Map<Id,ccrz__E_Order__c>([Select Id, ccrz__Contact__c, ccrz__Account__c, Name, ccrz__OrderNumber__c, ccrz__PONumber__c, ccrz__RequestDate__c from ccrz__E_Order__c where Id in: ccorderIds]);
            
            for(ccrz__E_Order__c cco : ccorders_map.values())
            {
                acc_order_map.put(cco.ccrz__Account__c, cco.Id);
                order_con_map.put(cco.Id,cco.ccrz__Contact__c);
            }  
            
            Map<Id,Contact> contact_map = new Map<Id,Contact>([Select Id, FirstName, LastName from Contact where Id in: order_con_map.values()]);
            
            Map<Id,Account> accs_map = new Map<Id,Account>([Select Id, AccountNumber, Name from Account where Id in: acc_order_map.keySet()]);
            
            for(String accid : accs_map.keySet())
            {            
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                List<String> sendTo = new List<String>();
                sendTo.add(nexeo3demail);
                mail.setToAddresses(sendTo);
                
                if (owea.size() > 0) 
                {
                    mail.setOrgWideEmailAddressId(owea.get(0).Id);
                }
                else
                {
                    mail.setReplyTo('mynexeoplasticsdonotreply@nexeosolutions.com');
                    mail.setSenderDisplayName('MyNexeo');                    
                }
                
                String subject = 'A new nexeo3D Order was created';
                String body = 'Hi,';
                body += '<br/>';
                body += '<br/>';
                body += 'A new nexeo3D Order was created and the details are below.';
                body += '<br/>';
                body += '<br/>';
                body += 'Account Name: ' + accs_map.get(accid).Name;
                body += '<br/>';
                body += 'Account Number: ' + accs_map.get(accid).AccountNumber;
                body += '<br/>';
                body += 'Name of user: ' + contact_map.get(order_con_map.get(acc_order_map.get(accid))).FirstName + ' ' + contact_map.get(order_con_map.get(acc_order_map.get(accid))).LastName;
                body += '<br/>';
                body += 'SalesForce Order number: ' + ccorders_map.get(acc_order_map.get(accid)).Name;
                body += '<br/>';
                body += '<br/>';
                body += 'Please Note: It could take up to 15 minutes before this order is available in SAP.';
                body += '<br/>';
                body += '<br/>';
                body += 'Thanks';
                body += '<br/>';
                body += 'Salesforce';
                
                mail.setSubject(subject);
                mail.setPlainTextBody(body);
                nexeo3d_emails.add(mail);
            }
            
            Messaging.SendEmailResult[] resultMail =  Messaging.sendEmail(nexeo3d_emails);
            
            System.debug('Email result:' + resultMail[0]);
        }
        catch(System.Exception e)
        {
            System.debug('ERROR: Building & Sending email to nexeo3d email address on new nexeo3d orders encountered the following error. ' + e.getMessage());
        }      
    }
    
    public static String formatDate(Date d) 
    {
        return d.month() + '/' + d.day() + '/' + d.year() ;
    }
    
}