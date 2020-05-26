public with sharing class Task_Functions {

    private static final String TASK = 'Task';
    
    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>>>>> ' + s);
    }
    
    public static void sendEmailsToAccountOwner(List<Task> tlist){
      Set<ID> Accountids = new Set<ID>();
      Set<ID> Ownerids = new set<ID>();
      map<ID, ID> AccountOwnerMap = new Map<ID, ID>();
      map<id, id> managermap = new map<id, string>();
      map<ID, String> emailmap = new Map<ID, String>();
      

      for(Task t:tlist){
         if(t.accountid != null){
         AccountIDs.add(t.accountid);
         }
      }
      
      list<Account> alist = [select id, ownerid, owner.email, owner.backup__c, owner.backup__r.email, owner.managerid, owner.manager.email from Account where id in :AccountIDs];
         for(account a:alist){
            AccountOwnerMap.put(a.id, a.ownerid);
            emailmap.put(a.ownerid, a.owner.email);
            
            if(a.owner.backup__c != null && a.owner.managerid == null){
               managermap.put(a.ownerid, a.owner.backup__r.id);
               emailmap.put(a.owner.backup__c, a.owner.backup__r.email);
            }
            if(a.owner.managerid != null){
              managermap.put(a.ownerid, a.owner.managerid);
              emailmap.put(a.owner.managerid, a.owner.manager.email);
            }
         }
     
      for(Task t:tlist){
         List<String> emails = new list<string>(); 
         if(t.accountid != null && t.Notify_Account_Owner__c == 'Yes'){       
            emails.add(emailmap.get(AccountOwnerMap.get(t.accountid)));        
            
         }
         if(t.manager_alert__c == 'Yes'){
            emails.add(emailmap.get(managermap.get(AccountOwnerMap.get(t.accountid)))); 
         }
        
         if(t.manager_alert__c == 'Yes' && emails.size() == 0){
            emails.add(emailmap.get(AccountOwnerMap.get(t.accountid)));  
         }
         if(emails.size() != 0){
         sendnotificationemail(t, emails);}
      }
    }
    
    private static void updateTaskParentChatterFeed(List<Task> tasks){
       
       For(Task t:tasks){
         if(t.post_to_chatter__c == true){
            Chatter_Functions.createLinkPost(t.whatid, t.subject, t.description, new pagereference('/' + t.id).geturl());
         }
       }
    
    }
    
    public static void sendEmailsToDevelopmentGroup(Map<Id, Task> oldMap, 
                                                    Map<Id, Task> newMap) {
        sendEmailsToAccountOwner(newMap.values()); 
        updateTaskParentChatterFeed(newMap.values());
                                             
        List<Task> tlist = new List<Task>();
        if (oldMap == null || oldMap.isEmpty()) {
            tlist = newMap.values();
        } else {
            List<Task> olist = oldMap.values();
            Task nt;
            for (Task ot : olist) {
                nt = newMap.get(ot.Id);
                if (nt.Development_Group__c != null &&
                    nt.Development_Group__c != ot.Development_Group__c) {
                    tlist.add(nt);
                }
            } 
        }
        if (!tlist.isEmpty()) {
            sendEmails(tlist);
        }
    }

    public static void createtaskandsendemails(ID ownerid, ID whatid, string subject, string description, Account account ){
    
      Task t = new Task();
      t.OwnerId = ownerid;
      t.WhatId = whatid;
      t.Subject = subject;
      t.ActivityDate = System.today();
      t.Status = 'Not Started';
      try {
      t.RecordTypeId = RecordType_Relationship_Functions.GetCSRTaskType_Based_on_AccountRecordTypeId(account.RecordTypeId);
      } catch(Exception e) {}

      t.Priority = 'Normal';
      t.Description = description;

      Database.DMLOptions dmlo = new Database.DMLOptions();
      dmlo.EmailHeader.triggerUserEmail = true;
      database.insert(t, dmlo);
      
      
      }
    

    private static void sendEmails(Task[] ta) {
        List<Task> tlist = getTasks(ta);
        for(Task t : tlist) {
            String dgroup = t.Development_Group__c;
            List<String> emailIds = ActivityUserGroup_Functions.getEmailIds(TASK, dgroup);
            if (emailIds != null && !emailIds.isEmpty()) {
              sendEmail(t, emailIds);
            }
        }
    }
    
    private static List<Task> getTasks(Task[] ta) {
        List<Id> taskIds = new List<Id>();
        for (Task t : ta) {
            taskIds.add(t.Id);
        }
        List<Task> tasks = [select id, Development_Group__c, Subject,
                                   // Account.Name, 
                                   ActivityDate, Priority, 
                                   Owner.FirstName, Owner.LastName,
                                   LastModifiedBy.FirstName, LastModifiedBy.LastName,
                                   LastModifiedBy.Email
                              from Task 
                             where id in :taskIds];
        return tasks;
    }

    public static void sendEmail(Task t, List<String> emailIds) {
        User lmb = t.LastModifiedBy;
        List<String> cc = null;
        List<String> bcc = null;
        String replyTo = '';
        replyTo = lmb.Email;

        String sender = lmb.FirstName + ' ' + lmb.LastName;
        Boolean bccSender = false;
        Boolean signature = false;
        String subject = t.Subject;
        String body = null;
        String htmlBody = getEmailBody(t);
        Boolean result = Email_Functions.sendEmail(emailIds, cc, bcc,
                                                   replyTo, sender, 
                                                   bccSender, signature,
                                                   subject, body, htmlBody);
    }

        private static void sendNotificationEmail(Task t, List<String> emailIds) {
        User lmb = t.LastModifiedBy;
        if(lmb == null){
           String userid = UserInfo.getuserid();
           lmb = [select id, email, firstname, lastname from user where id = :userid];
        }
        List<String> cc = null;
        List<String> bcc = null;
        String replyTo = '';
        replyTo = lmb.Email;

        String sender = lmb.FirstName + ' ' + lmb.LastName;
        Boolean bccSender = false;
        Boolean signature = false;
        String subject = t.Subject;
        String body = null;
        String htmlBody = getEmailBodyForOwnerNotification(t, lmb);
        Boolean result = Email_Functions.sendEmail(emailIds, cc, bcc,
                                                   replyTo, sender, 
                                                   bccSender, signature,
                                                   subject, body, htmlBody);
    }

    private static String getEmailBody(Task t) {
        User lmb = t.LastModifiedBy;
        String sender = lmb.FirstName + ' ' + lmb.LastName;
        String owner = t.Owner.FirstName + ' ' + t.Owner.LastName;
        String s = '';
        s += 'New Task<br><br>';
        // s += 'To: ' + owner + '<br><br>';
        s += sender + ' has assigned you the following new task:<br>';
        s += '<br>Subject: '+t.Subject;
        // s += '<br>Account: '+t.Account.Name;
        s += '<br>Due Date: '+t.ActivityDate.format();
        s += '<br>Priority: '+t.Priority;
        s += '<br><br>For more details on this task, click on the link below:<br><br>';
        s += Salesforce_System_Info_Functions.Retrieve_URL_Prefix();        
        s += '/'+t.Id;
        return s;
    }
    
    private static String getEmailBodyForOwnerNotification(Task t, user lmb){

        String sender = lmb.FirstName + ' ' + lmb.LastName;
        String owner = t.Owner.FirstName + ' ' + t.Owner.LastName;
        String s = '';
        s += sender + ' wants to notify you of the following task:<br>';
        s += '<br>Subject: '+t.Subject;
        // s += '<br>Account: '+t.Account.Name;
        if (t.ActivityDate != null) {
            s += '<br>Due Date: '+t.ActivityDate.format();
        }
        s += '<br>Priority: '+t.Priority;
        s += '<br><br>Comments:<br> '+String_Functions.convertCRtoBR(t.Description);
        s += '<br><br>For more details on this task, click on the link below:<br><br>';
        s += Salesforce_System_Info_Functions.Retrieve_URL_Prefix();        
        s += '/'+t.Id;
        return s;
    }  
}