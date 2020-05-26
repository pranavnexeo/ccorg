//Batch Class to update Opportunities owner equal to their related account owner.
//Author - Rajeev

global class Opportunity_Owner_Update_batch implements Database.Batchable<SObject>{

global string q;
global Opportunity_Owner_Update_batch (){
        q = 'Select Id, OwnerId, AccountId, Account.OwnerId, Account_Owner_Equals_Opportunity_Owner__c from Opportunity where Account_Owner_Equals_Opportunity_Owner__c = \'FALSE\' and Account.Owner.Isactive = True and AccountId != null';
      }

//Start method
global Database.QueryLocator start(Database.BatchableContext bcMain){
         return Database.getQueryLocator(q);
       } 
 
//Execute Method
global void execute(Database.BatchableContext bcMain, List<Opportunity>olist){
       if(olist.size()>0){ 
        Map<Id, boolean> permissionmap = new Map<Id, boolean>(); 
        Map<Id, Id> profilemap = new Map<Id, Id>();  
        
        for(ObjectPermissions op:[SELECT Id, parentid, SObjectType, PermissionsRead, PermissionsCreate,Parent.ProfileId 
                FROM ObjectPermissions WHERE parentid in (select id from permissionset where IsOwnedByProfile = true) and sObjectType = 'Opportunity']){
            
            permissionmap.put(op.Parent.ProfileId,op.PermissionsRead);
            }
        for(user u:[select id, profileid from user where profileid in :permissionmap.keyset() and IsActive = true]){
               profilemap.put(u.id, u.profileid);    
        }
        
        
            for(Opportunity o : olist){
             boolean Canread = false;
              if(permissionmap.containskey(profilemap.get(o.account.ownerid))){
               Canread = permissionmap.get(profilemap.get(o.account.ownerid));
                  if(Canread == true){
                   o.OwnerId = o.Account.OwnerId;
              }
            } 
           } 
    update olist;
    } 
   }
//Finish Method
global void finish(Database.BatchableContext bc){
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:bc.getJobId()];
        /*
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {a.CreatedBy.Email});
        mail.setReplyTo(a.CreatedBy.Email);
        mail.setSenderDisplayName('Batch Processing');
        mail.setSubject('Batch Process Id: '+a.Id+' '+a.Status);
        mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        */
        string str = '';
        str += 'Opportunity_Owner_Update_batch (' + a.Id + ' ' + a.status + ')  processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.';
        //system.debug('str is :' +str);
        database.executebatch(new CDF_Owner_Update_batch(str));
    }
  }