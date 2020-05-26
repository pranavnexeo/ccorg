global class Churn_Owner_Update_batch implements Database.Batchable<SObject>{

global string q;
private string callback;
global Churn_Owner_Update_batch (String callback){
        this.callback = callback;
        q = 'Select Id ,Account_Number__r.OwnerId,Ownerid,AccountOwner_Equals_ChurnOwner__c from SalesChurn__c where AccountOwner_Equals_ChurnOwner__c = \'FALSE\' and Account_Number__r.Owner.Isactive = True and Account_Number__c!= null';
      }

//Start method
global Database.QueryLocator start(Database.BatchableContext bcMain){
         return Database.getQueryLocator(q);
       } 
 
//Execute Method
global void execute(Database.BatchableContext bcMain, List<SalesChurn__c> slist){
       if(slist.size()>0){ 
        Map<Id, boolean> permissionmap = new Map<Id, boolean>(); 
        Map<Id, Id> profilemap = new Map<Id, Id>();  
        Map<Id,Id> ChurnOwnerMap = new Map<Id,Id>();
        
        for(ObjectPermissions churn:[SELECT Id, parentid, SObjectType, PermissionsRead, PermissionsCreate,Parent.ProfileId 
                FROM ObjectPermissions WHERE parentid in (select id from permissionset where IsOwnedByProfile = true) and sObjectType = 'SalesChurn__c']){
            
            permissionmap.put(churn.Parent.ProfileId,churn.PermissionsRead);
            
            }
            system.debug('------permissionmap---'+permissionmap);
        for(user u:[select id, profileid from user where profileid in :permissionmap.keyset() and Isactive = True]){
               profilemap.put(u.id, u.profileid); 
              
        }
         system.debug('------profilemap---'+profilemap);   
        
           for(SalesChurn__c s : slist){
             boolean Canread = false;
              if(permissionmap.containskey(profilemap.get(s.Account_Number__r.OwnerId))){
               Canread = permissionmap.get(profilemap.get(s.Account_Number__r.OwnerId));
                  if(Canread = true && s.OwnerId != s.Account_Number__r.OwnerId){
                   s.OwnerId = s.Account_Number__r.OwnerId;
                    ChurnOwnerMap.put(s.Id,s.Account_Number__r.OwnerId);
              }
            } 
           } 
    Map<Id,Task> TasksToUpdateMap = new Map<Id,Task>([Select Id, OwnerId, WhatId from Task where WhatId In :ChurnOwnerMap.keyset()]);
     for(Task t : TasksToUpdateMap.values()){
      if((ChurnOwnerMap.get(TasksToUpdateMap.get(t.Id).WhatId)) != t.OwnerId){
       t.OwnerId = ChurnOwnerMap.get(TasksToUpdateMap.get(t.Id).WhatId);
        }
       }
    update slist;
    update TasksToUpdateMap.values();
    } 
   }
  
//Finish Method
global void finish(Database.BatchableContext bc){

        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:bc.getJobId()];
        string str = '';
        if(callback != '' && callback != null)
        str += callback + '\n';
        str += 'Churn_Owner_Update_batch (' + a.Id + ' ' + a.status + ')  processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.';
        
        /*
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {'NexeoSFDCSupport@nexeosolutions.com'});
        mail.setReplyTo('NexeoSFDCSupport@nexeosolutions.com');
        mail.setSenderDisplayName('Batch Processing');
        mail.setSubject('Owner Updates Batch Job Completed');
        mail.setPlainTextBody(str);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        */
        database.executebatch(new Account_Owner_Changes_batch(str));
  }             
  }