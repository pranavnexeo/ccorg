//Batch Class to update Opportunities owner equal to their related account owner.
//Author - Manish
//Test method in nexpriceCPI_security class.

global class NexpriceCPI_Owner_Update_batch implements Database.Batchable<SObject>{
String callback;
string q;
global NexpriceCPI_Owner_Update_batch (String callback){
        this.callback = callback;
        q = 'Select Id, OwnerId, Account__c, Account__r.OwnerId, Account_Owner_Equals_AM_Owner__c from Account_Material__c where Account_Owner_Equals_AM_Owner__c = \'FALSE\' and Account__r.Owner.Isactive = True and Account__c != null';
      }

//Start method
global Database.QueryLocator start(Database.BatchableContext bcMain){
         return Database.getQueryLocator(q);
       } 
 
//Execute Method
global void execute(Database.BatchableContext bcMain, List<Account_Material__c>olist){
       if(olist.size()>0){ 
       
        
    
        Map<Id, boolean> permissionmap = new Map<Id, boolean>(); 
        Map<Id, Id> profilemap = new Map<Id, Id>();  
        
        for(ObjectPermissions op:[SELECT Id, parentid, SObjectType, PermissionsRead, PermissionsCreate,Parent.ProfileId 
                FROM ObjectPermissions WHERE parentid in (select id from permissionset where IsOwnedByProfile = true) and sObjectType = 'Account_Material__c']){
            
            permissionmap.put(op.Parent.ProfileId,op.PermissionsRead);
            }
        for(user u:[select id, profileid from user where profileid in :permissionmap.keyset() and IsActive = true]){
               profilemap.put(u.id, u.profileid);    
        }
        
        Set<Id> accIds = new Set<Id>();
        
            for(Account_Material__c o : olist){
             boolean Canread = false;
              if(permissionmap.containskey(profilemap.get(o.account__r.ownerid))){
               Canread = permissionmap.get(profilemap.get(o.account__r.ownerid));
                  if(Canread == true){ 
                   o.OwnerId = o.Account__r.OwnerId;
                   accIds.add(o.Id);
              }
            } 
           } 
    
        update olist;
    } 
   }
//Finish Method
global void finish(Database.BatchableContext bc){
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:bc.getJobId()];
        string str = '';
        if(callback != '' && callback != null)
        str += callback + '\n';
        str += 'NexpriceCPI_Owner_Update_batch (' + a.Id + ' ' + a.status + ')  processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.';
        database.executebatch(new Nexprice_Account_Team_batch(str));
    }
  }