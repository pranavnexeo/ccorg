//The Class is used to update CDF owner equal to its related Account owner.
//Author - Rajeev


global class CDF_Owner_Update_batch implements Database.Batchable<SObject>{

global string q;
private string callback;


global CDF_Owner_Update_batch (string callback){
        this.callback = callback;
        q = 'Select Id, OwnerId, AccountId, Account.OwnerId, CDF_Owner_Not_Equal_To_Account_Owner__c from Contract where CDF_Owner_Not_Equal_To_Account_Owner__c = \'TRUE\' and Account.Owner.Isactive = True and AccountId != null';
}



//Start method
global Database.QueryLocator start(Database.BatchableContext bcMain){
         return Database.getQueryLocator(q);
       } 
 
//Execute Method
global void execute(Database.BatchableContext bcMain, List<Contract>olist){
   if(olist.size()>0){
    Map<Id, boolean> permissionmap = new Map<Id, boolean>(); 
    Map<Id, Id> profilemap = new Map<Id, Id>();  
        
        for(ObjectPermissions op:[SELECT Id, parentid, SObjectType, PermissionsRead, PermissionsCreate, Parent.ProfileId 
                                 FROM ObjectPermissions WHERE parentid in (select Id from PermissionSet where IsOwnedByProfile = true) and sObjectType = 'Contract']){
            
            permissionmap.put(op.Parent.ProfileId,op.PermissionsRead);
            } 
        for(user u:[select id, profileid from user where profileid in :permissionmap.keyset() and IsActive = true]){
               profilemap.put(u.id, u.profileid);    
        }
     
            for(Contract o : olist){
            
              boolean Canread = false;
              if(permissionmap.containskey(profilemap.get(o.account.ownerid))){
                    Canread = permissionmap.get(profilemap.get(o.account.ownerid));
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
        mail.setPlainTextBody('CDF_Owner_Update_batch processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        */
        string str = '';
        if(callback != '' && callback != null)
          str += callback + '\n';
        str += 'CDF_Owner_Update_batch (' + a.Id + ' ' + a.status + ')  processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.';
        database.executebatch(new BC_Owner_Update_batch(str));
        

  }             
}