//Batch Class to update Sample requests owner equal to their related account owner.
//Author - Rajeev


global class SampleRequest_Owner_Update_batch implements Database.Batchable<SObject>{

private string callback;
global string q;
global SampleRequest_Owner_Update_batch (string callback){
        this.callback = callback;
        q = 'Select Id, OwnerId, Account__c, Account__r.OwnerId, Sample_Owner_Same_as_Account_Owner__c from Sample_Request__c where Sample_Owner_Same_as_Account_Owner__c = \'FALSE\' and Account__r.Owner.Isactive = True and Account__c != null';
      }

//Start method
global Database.QueryLocator start(Database.BatchableContext bcMain){
         return Database.getQueryLocator(q);
       } 
 
//Execute Method
global void execute(Database.BatchableContext bcMain, List<Sample_Request__c>olist){
      if(olist.size()>0){
        Map<Id, boolean> permissionmap = new Map<Id, boolean>(); 
        Map<Id, Id> profilemap = new Map<Id, Id>();  
        
        for(ObjectPermissions op:[SELECT Id, parentid, SObjectType, PermissionsRead, PermissionsCreate, Parent.ProfileId 
                             FROM ObjectPermissions WHERE parentid in (select Id from PermissionSet where IsOwnedByProfile = true) and sObjectType = 'Sample_Request__c']){
            
            permissionmap.put(op.Parent.ProfileId,op.PermissionsRead);
           } 
        for(user u:[select id, profileid from user where profileid in :permissionmap.keyset() and IsActive = true]){
               profilemap.put(u.id, u.profileid);    
        }

            for(Sample_Request__c o : Olist){
                boolean Canread = false;
                 if(permissionmap.containskey(profilemap.get(o.account__r.ownerid))){
                    Canread = permissionmap.get(profilemap.get(o.account__r.ownerid));
                        if(Canread == True){
                         o.OwnerId = o.Account__r.OwnerId;
       }
      }
     }   
    update Olist;
     }
    }
//Finish Method
global void finish(Database.BatchableContext bc){

        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:bc.getJobId()];
        string str = '';
        if(callback != '' && callback != null)
        str += callback + '\n';
        str += 'SampleRequest_Owner_Update_batch (' + a.Id + ' ' + a.status + ')  processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.';
        database.executebatch(new Churn_Owner_Update_batch(str));
  }             
}