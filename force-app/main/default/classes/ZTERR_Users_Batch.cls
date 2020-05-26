//Author - Matt

global class ZTERR_Users_Batch implements Database.Batchable<SObject>{

global string callback;
global string q;
global final Territory2Model m{get; set;}

global ZTERR_Users_Batch(Territory2Model m, string callback){
  this.callback = callback;
  this.m = m;
  q =  'select id, Name, Record_Key__c,';
  q += 'YS_Partner__r.User__r.IsActive, YS_Partner__r.User__c,';
  q += 'ZS_Partner__r.User__r.IsActive, ZS_Partner__r.User__c ';
  q += ' from SAP_Territory__c';       
}
private class myclass{
  Set<Id> inactiveUsers{get; set;}
  Map<Id, UserTerritory2Association> UT2Amap{get; set;}
  
  public myclass(){
    inactiveusers = new set<Id>();
    UT2Amap = new Map<Id, UserTerritory2Association>();
  }
}


private static myclass getUserIds(SAP_Territory__c t){
  
  myclass toreturn = new myclass();  
  
  if(t.YS_Partner__r.User__c != null){
    if(t.YS_Partner__r.User__r.IsActive){
      toreturn.UT2Amap.put(t.YS_Partner__r.User__c,
       new UserTerritory2Association(
        UserId = t.YS_Partner__r.User__c,
        RoleInTerritory2 = 'Sales Support'
       )
      );
    }
    else{
      toreturn.inactiveusers.add(t.YS_Partner__r.User__c);
    }
  }
  
  if(t.ZS_Partner__r.User__c != null){
    if(t.ZS_Partner__r.User__r.IsActive){
      toreturn.UT2Amap.put(t.ZS_Partner__r.User__c,
       new UserTerritory2Association(
        UserId = t.ZS_Partner__r.User__c,
        RoleInTerritory2 = 'Sales Executive'
       )
      );
    }
    else{
      toreturn.inactiveusers.add(t.ZS_Partner__r.User__c);
    }
  }
  
  return toreturn;
}

//Start method
global Database.QueryLocator start(Database.BatchableContext bcMain){
         return Database.getQueryLocator(q);
} 
 
//Execute Method
global void execute(Database.BatchableContext bcMain, List<SAP_Territory__c> alist){
   
   Map<Id, SAP_Territory__c> tmap = new Map<Id, SAP_Territory__c>();
   Map<Id, Territory2> t2map = new Map<Id, Territory2>();
   Map<Id, Map<Id, UserTerritory2Association>> UT2Amap = new Map<Id, Map<Id, UserTerritory2Association>>();
   
   Set<Id> Ids = new Set<Id>();
   Set<Id> InactiveUsers = new Set<Id>();
   Map<Id, Map<Id, UserTerritory2Association>> umap = new map<Id, Map<Id, UserTerritory2Association>>();
   
   for(SAP_Territory__c t:alist){
     myclass myclass = getUserIds(t);
     umap.put(t.id, myclass.UT2Amap);
     InactiveUsers.addall(myclass.inactiveusers);
     tmap.put(t.id, t);
     ids.add(t.id);
   }

   for(territory2 t2:[select id, parent_id__c from Territory2 where parent_Id__c IN :ids]){
     t2map.put(t2.parent_id__c, t2);
     UT2Amap.put(t2.id, new Map<Id, UserTerritory2Association>());
   }
   
   for(UserTerritory2Association ut2a:[select id, userid, territory2id, RoleInTerritory2 from UserTerritory2Association where territory2id IN :UT2Amap.keyset()]){
     UT2Amap.get(ut2a.territory2id).put(ut2a.userid, ut2a);
   } 
   
   List<UserTerritory2Association> todelete = new List<UserTerritory2Association>();
   List<UserTerritory2Association> toInsert = new List<UserTerritory2Association>();
   List<UserTerritory2Association> toUpdate = new List<UserTerritory2Association>();
   
    for(SAP_Territory__c t:alist){
     if(t2map.containskey(t.id)){
       territory2 t2 = t2map.get(t.id);
       Map<Id, UserTerritory2Association> ExistingUT2As = new Map<Id, UserTerritory2Association>();
       Map<Id, UserTerritory2Association> NewUT2As = new Map<Id, UserTerritory2Association>();
       
       if(UT2AMap.containskey(t2.id)){
         ExistingUT2As = UT2AMap.get(t2.id);
       }
       
       if(umap.containskey(t.id)){
         newUT2As = umap.get(t.id);
       }
       
       Set<Id> keepthese = new set<Id>();
       for(Id uid:ExistingUT2As.keyset()){
         UserTerritory2Association existingUT2A = ExistingUT2As.get(uid);
         if(NewUT2As.containskey(uid)){
           UserTerritory2Association newUT2A = newUT2As.get(uid);
           keepthese.add(uid);
           if(existingUT2A.RoleInTerritory2 != newUT2A.RoleInTerritory2){
             existingUT2A.RoleInTerritory2 = newUT2A.RoleInTerritory2;
             toupdate.add(existingUT2A);
           }
         }else{
           todelete.add(existingUT2A);
         }
           
         }
         
         for(Id uid:newUT2As.keyset()){
           UserTerritory2Association newUT2A = newUT2As.get(uid);
           if(!keepthese.contains(newUT2A.userId)){
             newUT2A.territory2Id = t2.id;
             toInsert.add(newUT2A);
           }
         }
       }
     }     
     
     if(todelete.size() > 0)
       delete todelete;
     
     if(toinsert.size() > 0)
       insert toinsert;
       
     if(toupdate.size() > 0)
       update toUpdate;    
}
  
//Finish Method
global void finish(Database.BatchableContext bcMain){
       
     AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:bcMain.getJobId()];
     String str = callback;
     str += '\nZTERR_Users_Batch(' + a.Id + ' ' + a.status + ')  processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.';
     AccountTeamUpdatedClear atu = new AccountTeamUpdatedClear();
     database.executebatch(atu);
     Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {'NexeoSFDCSupport@nexeosolutions.com'});
        mail.setReplyTo('NexeoSFDCSupport@nexeosolutions.com');
        mail.setSenderDisplayName('Territory Batch');
        mail.setSubject('Territory Batch');
        mail.setPlainTextBody(str);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
     
  }
}