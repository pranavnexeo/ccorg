public with sharing class Approval_Process_Email_Functions {

private static final String NL = '\n';
 private static final String CRNL = '\r\n';


public static void sendhtmlnotification(String body, string subject, string fromAddress, string fromName)
{    
    system.debug('Approval_Process_Email_Functions + sendhtmlnotification');
    String key = '';
    system.debug('subject: ' + subject);
     if(subject.contains('[Key:'))
     {  key = subject.substring(subject.indexof('[Key: ') + 6, subject.indexof(']'));
         subject =  subject.substring(0, subject.indexof('[Key: '));     
     }
     system.debug('Key: ' + key);
     
     system.debug('Key size before trim ####:' + key.length());
     key = key.trim(); // Added to avoid white spaces - Abhishek 30Aug2013
     system.debug('Key size after trim ####:' + key.length());
     
        List<Approval_Process_Email_Notification__c> APENs = [select id, key__c, email__c, email_List__c, user__c, User__r.email from Approval_Process_Email_Notification__c where key__c = :key];
        List<String> toAddresses = new list<String>();
        List<Messaging.SingleEmailMessage> mlist = new list<Messaging.SingleEmailMessage>();
        List<string> emaillist = new list<string>();
     
     for(Approval_Process_Email_Notification__c APEN:APENs){
           
           if(APEN.User__c != null){
           toAddresses.add(APEN.user__r.email);}
           if(APEN.Email__c != null && APEN.email__c != ''){
           toAddresses.add(APEN.Email__c);}
           emaillist.clear();
           if(APEN.Email_List__c != null){
           emaillist = APEN.email_list__c.split(CRNL);
           for(string s:emaillist){
           toaddresses.add(s);
           }
           }
        }
        Messaging.SingleEmailMessage m = new Messaging.SingleEmailMessage();
                m.setReplyTo(fromAddress);
                m.setSaveAsActivity(false);
                m.setSenderDisplayName(fromAddress);
                m.setToAddresses(toAddresses);
                system.debug('ToAddresses: ' + toAddresses);
                system.debug('fromAddress: ' + fromAddress);
                m.setHTMLBody(body);
                m.setsubject(subject);
                mlist.add(m);
                
       try {
                List<Messaging.SendEmailResult> results = Messaging.sendEmail(mlist);
                System.debug('RESULTS: ' + results);
                
            } catch(Exception e) {
                            System.debug('ERROR: ' + e.getMessage());
            }


}
Public static void sendnotification(String body, string subject, string fromAddress, string fromName){
        system.debug('Approval_Process_Email_Functions + sendnotification');
        String Key = '';
        List<String> sa = body.split(NL);
      
          If(sa.get(0) == 'Force.com Sandbox'){
           Key = sa.get(2).trim();
          }
          else{ 
           key = sa.get(0);
          }

        system.debug('Key: ' + key);
        system.debug('Key size before trim ####:' + key.length());
        key = key.trim(); // Added to avoid white spaces - Abhishek 30Aug2013
        system.debug('Key size after trim ####:' + key.length());
        
        List<Approval_Process_Email_Notification__c> APENs = [select id, key__c, email__c, email_List__c, user__c, User__r.email from Approval_Process_Email_Notification__c where key__c = :key];
        List<String> toAddresses = new list<String>();
        List<Messaging.SingleEmailMessage> mlist = new list<Messaging.SingleEmailMessage>();
        List<string> emaillist = new list<string>();
        
      
        system.debug('APEN Size: ' + APENs.size());
        system.debug('Key: ' + key);
        
        for(Approval_Process_Email_Notification__c APEN:APENs){
           
           if(APEN.User__c != null){
           toAddresses.add(APEN.user__r.email);}
           if(APEN.Email__c != null && APEN.email__c != ''){
           toAddresses.add(APEN.Email__c);}
           emaillist.clear();
           if(APEN.Email_List__c != null){
           emaillist = APEN.email_list__c.split(CRNL);
           for(string s:emaillist){
           toaddresses.add(s);
           }
           }
        }
       
       
        String newbody = '';
             
        If(sa.get(0) == 'Force.com Sandbox'){
        for (integer i=3; i<sa.size(); i++){
        newbody = newbody + sa.get(i) + NL;
        }
        }
        else{ 
        for (integer i=1; i<sa.size(); i++){
        newbody = newbody + sa.get(i) + NL;
        }
        }
        
       Messaging.SingleEmailMessage m = new Messaging.SingleEmailMessage();
                m.setReplyTo(fromAddress);
                m.setSaveAsActivity(false);
                m.setSenderDisplayName(fromAddress);
                m.setToAddresses(toAddresses);
                system.debug('ToAddresses: ' + toAddresses);
                system.debug('fromAddress: ' + fromAddress);
                m.setPlainTextBody(newbody);
                system.debug('body: ' + newbody);
                m.setsubject(subject);
                mlist.add(m);
                
       try {
                List<Messaging.SendEmailResult> results = Messaging.sendEmail(mlist);
                System.debug('RESULTS: ' + results);
                
            } catch(Exception e) {
                            System.debug('ERROR: ' + e.getMessage());
            }

}

}