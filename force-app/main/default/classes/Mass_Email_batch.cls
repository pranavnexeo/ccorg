//Batch Class to mirror Account table in Account Directory.
//Author - Matt

global class Mass_Email_batch implements Database.Batchable<SObject>, Database.Stateful{

global set<string> emailssent{Get; set;}
global final string q{get; set;}
global final String displayname{get; set;}
global final String fromEmail{Get; set;}
global final string templateid{get; set;}
global final integer count{get; set;}
global final string testemail{get; set;}
global final boolean issandbox{get; set;}
global integer countsent{get; set;}
global integer counterrors{get; set;}
global string errorString{get; set;}
global set<Id> ErrorContactIds{Get; set;}
global set<Id> reattemptContactIds{Get; set;}

global Mass_Email_batch (boolean issandbox, string fromemail, string displayname, string templateid, string testemail){
   this.issandbox = issandbox;
   this.fromemail = fromemail;
   this.displayname = displayname;
   this.templateid = templateid;
   this.testemail = testemail;
   emailssent = new set<String>();
   ErrorContactIds = new set<id>();
   q = 'select id, email, accountid from Contact where NPS_Contact__c = true and HasOptedOutOfEmail = false and email != null';
   count = Database.query(q).size();  
   countsent = 0;
   counterrors = 0;
   errorstring = '';
}

global Mass_Email_batch (boolean issandbox, string fromemail, string displayname, string templateid, string testemail, set<id> ids){
   this.issandbox = issandbox;
   this.fromemail = fromemail;
   this.displayname = displayname;
   this.templateid = templateid;
   this.testemail = testemail;
   this.ErrorContactIds = new set<id>();
   this.reattemptContactIds = ids;
   emailssent = new set<String>();
   q = 'select id, email, accountid from Contact where NPS_Contact__c = true and HasOptedOutOfEmail = false and email != null and id IN :reattemptContactids';
   count = Database.query(q).size();  
   countsent = 0;
   counterrors = 0;
   errorstring = '';
}



//Start method
global Database.QueryLocator start(Database.BatchableContext bcMain){    
         return Database.getQueryLocator(q);
} 
 
//Execute Method
/*Modified by Rajeev*/
global void execute(Database.BatchableContext bcMain, List<Contact> alist){

     //List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
     List<Id> sendcontactIds = new List<Id>();
     for(contact c:alist){
      if(
      (!emailssent.contains(c.email) || c.email == testemail) && //Unique Email OR email is test email
       //AND ONE OF THE FOLLOWING 
      (
          (!isSandbox) || //EITHER In Production (Not Sandbox)
          (isSandbox && c.email.endswith('.full')) || // OR In Sandbox and Email ends with .full
          (isSandbox && c.email ==  testemail)// OR In Sandbox and Email equals test email
      )//END AND ONE OF THE FOLLOWING
      )//END IF
      {
        emailssent.add(c.email); // Add to set to ensure unique
        sendcontactIds.add(c.id);
      }
     }
     EmailTemplate t = [select id, subject from EmailTemplate where id = :templateid limit 1];
     Messaging.MassEmailMessage m = new Messaging.MassEmailMessage();
     m.setSenderDisplayName(displayname);
     m.setReplyTo(fromemail);
     m.setSaveAsActivity(true);
     m.settargetobjectids(sendcontactids);
     m.settemplateid(templateid);
     m.setDescription(t.subject);

     if(sendcontactIds.size() > 0){
       List<Messaging.SendEmailResult> results = new List<Messaging.SendEmailResult>();
       
       if(Test.isRunningtest() == false){
         results = Messaging.sendEmail(new List<Messaging.MassEmailMessage>{m}, false);  
       }
       
       for(Messaging.SendEmailResult r:results){
         if(!r.isSuccess()){       
           counterrors += sendcontactids.size();
           for(Messaging.SendEmailError e:r.geterrors()){
             ErrorContactIds.addall(sendcontactids); // Add contact Ids to error set.
             errorstring += 'Error: ' + e.getmessage() + '\n';
           }
         }else{ countsent += sendcontactids.size(); }
       }
     }
     
     
     
   }
   
//   
//Finish Method
global void finish(Database.BatchableContext bcMain){
        
       system.debug('Is Sandbox?: ' + issandbox);
       AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:bcMain.getJobId()];
        String str = '';
        str += 'Mass_Email_batch(' + a.Id + ' ' + a.status + ')  processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures. ';
        str += count + ' Contacts found. \n' + countsent + ' emails sent. \n' + counterrors + ' email errors, which will be reattempted in 24 hours. \nError List: \n' + errorstring;
        
        if(ErrorContactIds.size() > 0){
          Mass_Email_batch meb = new Mass_Email_batch(issandbox, fromemail, displayname, templateid, testemail, ErrorContactids);
          System.scheduleBatch(meb, 'Reattempt Mass Email Batch ' + a.id, 1441);
        }
        
        try{
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {'mjrumschlag@nexeosolutions.com', a.createdby.email});
        mail.setReplyTo(a.createdby.email);
        mail.setSenderDisplayName('Mass_Email_batch');
        mail.setSubject('Mass_Email_batch');
        mail.setPlainTextBody(str);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
        }catch(exception e){ system.debug('Error Sending Email: ' + e.getMessage()); }
        
        
    }
}