//Batch Class to update Business contracts owner equal to their related account owner.
//Author - Rajeev


global class BC_Owner_Update_batch implements Database.Batchable<SObject>{

private string callback;
global string q;
global BC_Owner_Update_batch (string callback){
        this.callback = callback;
        q = 'Select Id, OwnerId, Customer_Name__c, Customer_Name__r.OwnerId, Owner_Does_Not_Equal_Account_Owner__c from Business_Contract__c where Owner_Does_Not_Equal_Account_Owner__c= \'TRUE\' and Customer_Name__r.Owner.Isactive = True and Customer_Name__c != null';
      }

//Start method
global Database.QueryLocator start(Database.BatchableContext bcMain){
         return Database.getQueryLocator(q);
       } 
 
//Execute Method
global void execute(Database.BatchableContext bcMain, List<Business_Contract__c>olist){
   if(olist.size()>0){
    Map<Id, boolean> permissionmap = new Map<Id, boolean>(); 
    Map<Id, Id> profilemap = new Map<Id, Id>();  
        
    for(ObjectPermissions op:[SELECT Id, parentid, SObjectType, PermissionsRead, PermissionsCreate, Parent.ProfileId 
                             FROM ObjectPermissions WHERE parentid in (select Id from PermissionSet where IsOwnedByProfile = true) and sObjectType = 'Business_Contract__c']){
            
            permissionmap.put(op.Parent.ProfileId,op.PermissionsRead);
            } 
        for(user u:[select id, profileid from user where profileid in :permissionmap.keyset() and IsActive = true]){
               profilemap.put(u.id, u.profileid);    
        }

        
            for(Business_Contract__c o : olist){
              boolean Canread = false;
              if(permissionmap.containskey(profilemap.get(o.Customer_Name__r.ownerid))){
                    Canread = permissionmap.get(profilemap.get(o.Customer_Name__r.ownerid));
                        if(Canread == True){
                o.OwnerId = o.Customer_Name__r.OwnerId;
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
        str += 'BC_Owner_Update_batch (' + a.Id + ' ' + a.status + ')  processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.';
        database.executebatch(new Contact_Owner_Update_batch(str));

  }             
}