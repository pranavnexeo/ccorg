//Batch Class to update Contacts owner equal to their related account owner.
//Author - Rajeev

global class Contact_Owner_Update_batch implements Database.Batchable<SObject>{

private string callback;
global string q;
global Contact_Owner_Update_batch (string callback){
        this.callback = callback;
        q = 'Select Id, OwnerId, AccountId, Account.OwnerId, Account.Owner_name__c, Contact_owner_same_as_account_owner__c from Contact where Contact_owner_same_as_account_owner__c = \'FALSE\' and Account.Owner.Isactive = True and AccountId != null';
      }

//Start method
global Database.QueryLocator start(Database.BatchableContext bcMain){
         return Database.getQueryLocator(q);
       } 
 
//Execute Method
global void execute(Database.BatchableContext bcMain, List<Contact>olist){
   if(olist.size()>0){
    Map<Id, boolean> permissionmap = new Map<Id, boolean>(); 
    Map<Id, Id> profilemap = new Map<Id, Id>();  
        
    for(ObjectPermissions op:[SELECT Id, parentid, SObjectType, PermissionsRead, PermissionsCreate, Parent.ProfileId 
                             FROM ObjectPermissions WHERE parentid in (select Id from PermissionSet where IsOwnedByProfile = true) and sObjectType = 'Contact']){
            
            permissionmap.put(op.Parent.ProfileId,op.PermissionsRead);
            } 
        for(user u:[select id, profileid from user where profileid in :permissionmap.keyset() and IsActive = true]){
               profilemap.put(u.id, u.profileid);    
        }
          
            for(Contact o : olist){
              boolean Canread = false;
               if(permissionmap.containskey(profilemap.get(o.Account.ownerid))){
                    Canread = permissionmap.get(profilemap.get(o.Account.ownerid));
                        if(Canread == True){
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
        if(callback != '' && callback != null)
          str += callback + '\n';
        str += 'Contact_Owner_Update_batch (' + a.Id + ' ' + a.status + ')  processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.';
        database.executebatch(new SampleRequest_Owner_Update_batch(str));
    }
  }