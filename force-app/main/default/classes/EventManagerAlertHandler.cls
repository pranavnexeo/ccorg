/* 
* Description: Handler class for Trigger EventManagerAlert on Event
* Date: 10 / 08 / 2018
* Developer: Ignacio Gonzalez
*/
public without sharing class EventManagerAlertHandler {
    
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;

    public EventManagerAlertHandler(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
    
    public void OnAfterInsert(Event[] newRecords){
        this.sendEmailNotification(newRecords);
    }
    
    public void OnBeforeInsert(Event[] newRecords){
       this.setRecordTypeToGeneric(newRecords);
       this.setCustomType(newRecords);
    }
    
    public void OnBeforeUpdate(Event[] oldRecords, Event[] updatedRecords, Map<ID, Event> recordMap){
         this.setRecordTypeToGeneric(updatedRecords);
         this.setCustomType(updatedRecords);
         this.sendEmailNotification(updatedRecords);
    }
    
    /*
     * This logic is going to allow us set the value of the custom field Type with the data
     * of the standard field Type
     * */
    private void setCustomType(Event[] newRecords){
        for (Event currentEvent:newRecords) {
             currentEvent.Type__c = currentEvent.Type;
        }
    }
    
    /*
     * In order to sent email notifications regarding the currrent event 
     * */
    private void sendEmailNotification(Event[] newRecords){
      
      Set<ID> Accountids = new Set<ID>();
      Set<ID> Ownerids = new set<ID>();
      map<ID, ID> AccountOwnerMap = new Map<ID, ID>();
      map<id, id> managermap = new map<id, string>();
      map<ID, String> emailmap = new Map<ID, String>();
      User u = [select id, name, email,ManagerId,Manager.email from user where id = :userinfo.getuserid() limit 1];
      system.debug('manager email: ' + u.Manager.email);
      for(event e:newRecords){
         if(e.accountid != null){
         AccountIDs.add(e.accountid);
         system.debug('Account IDs'+AccountIDs);
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
     
      for(event e:newRecords){
         List<String> emails = new list<string>(); 
         if(e.accountid != null && e.Notify_Account_Owner__c == 'Yes'){       
            emails.add(emailmap.get(AccountOwnerMap.get(e.accountid)));                 
         }
         if(e.Manager_Alert__c == 'Yes'){
            system.debug('Manger alert');
            if(e.accountid != null){
            emails.add(emailmap.get(managermap.get(AccountOwnerMap.get(e.accountid)))); 
           } else {
          if (u.Manager.email != null || u.Manager.email != ''){ 
          emails.add(u.Manager.email);}  
         }}
        
         if(e.manager_alert__c == 'Yes' && emails.size() == 0){
           system.debug('Manger alert1');
            emails.add(emailmap.get(AccountOwnerMap.get(e.accountid)));  
         }
         system.debug('Email Size: ' + emails.size());
         if(emails.size() != 0){

        String s = '';
        s += u.name + ' wants to notify you of the following task:<br>';
        s += '<br>Subject: '+e.Subject;
        if (e.ActivityDate != null) {
            s += '<br>Date: '+e.ActivityDate.format();
        }
        s += '<br>Type: '+ (String.isEmpty(e.Type) ? '': e.Type);
        s += '<br><br>Comments:<br> '+String_Functions.convertCRtoBR(e.Description);
        s += '<br><br>For more details on this Sales Call, click on the link below:<br><br>';
        s += Salesforce_System_Info_Functions.Retrieve_URL_Prefix();        
        s += '/'+e.Id;
        system.debug('Event id'+e.id);
         Email_Functions.SendEmail(emails, 
                                     null,
                                     null,
                                     u.email,
                                     u.name,
                                     false,
                                     null,
                                     e.subject,
                                     null,
                                     s
                                      );   
       }
     //  e.Manager_Alert__c = 'No';
     }
    }
    
    /*
     *  Set 
     * */
    private void setRecordTypeToGeneric(Event[] newRecords) {
        Generic_Nexeo_Settings__c customSetting = Generic_Nexeo_Settings__c.getOrgDefaults();
        for (Event currentEvent:newRecords) {
            if (String.isEmpty(currentEvent.WhatId ) && String.isEmpty(currentEvent.WhoId )) {
                currentEvent.recordTypeId = customSetting.Generic_Event__c;
                currentEvent.Type = '';
            }
        }        
        
    }
}