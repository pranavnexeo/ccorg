//Author - Matt

global class ZDOG_Users_Batch implements Database.Batchable<SObject>{

global string callback;
global string q;
global final Territory2Model m{get; set;}

global ZDOG_Users_Batch(Territory2Model m, string callback){
  this.callback = callback;
  this.m = m;
  q =  'select id, Name, Record_Key__c,';
  q += 'YD_Partner__r.User__r.IsActive, YD_Partner__r.User__c,';
  q += 'YO_Partner__r.User__r.IsActive, YO_Partner__r.User__c,';
  q += 'YV_Partner__r.User__r.IsActive, YV_Partner__r.User__c ';
  q += ' from SAP_Sales_DOG__c';       
}
private class myclass{
  Set<Id> inactiveUsers{get; set;}
  Map<Id, UserTerritory2Association> UT2Amap{get; set;}
  
  public myclass(){
    inactiveusers = new set<Id>();
    UT2Amap = new Map<Id, UserTerritory2Association>();
  }
}

private static myclass getUserIds(SAP_Sales_DOG__c d){
  
  myclass toreturn = new myclass();  
  
  if(d.YD_Partner__r.User__c != null){
    if(d.YD_Partner__r.User__r.IsActive){
      toreturn.UT2Amap.put(d.YD_Partner__r.User__c,
       new UserTerritory2Association(
        UserId = d.YD_Partner__r.User__c,
        RoleInTerritory2 = 'District Manager'
       )
      );
    }
    else{
      toreturn.inactiveusers.add(d.YD_Partner__r.User__c);
    }
  }
  
  if(d.YO_Partner__r.User__c != null){
    if(d.YO_Partner__r.User__r.IsActive){
      toreturn.UT2Amap.put(d.YO_Partner__r.User__c, 
       new UserTerritory2Association(
        UserId = d.YO_Partner__r.User__c,
        RoleInTerritory2 = 'Sales Director'
      ));
    }
    else{
      toreturn.inactiveusers.add(d.YO_Partner__r.User__c);
    }
  }
  
  if(d.YV_Partner__r.User__c != null){
    if(d.YV_Partner__r.User__r.IsActive){
      toreturn.UT2Amap.put(d.YV_Partner__r.User__c,
      new UserTerritory2Association(
        UserId = d.YV_Partner__r.User__c,
        RoleInTerritory2 = 'Vice President'
     ));
    }
    else{
      toreturn.inactiveusers.add(d.YV_Partner__r.User__c);
    }
  }
  
  return toreturn;
}

//Start method
global Database.QueryLocator start(Database.BatchableContext bcMain){
         return Database.getQueryLocator(q);
} 
 
//Execute Method
global void execute(Database.BatchableContext bcMain, List<SAP_Sales_DOG__c> alist){
   
   Map<Id, SAP_Sales_DOG__c> dmap = new Map<Id, SAP_Sales_DOG__c>();
   Map<Id, Territory2> t2map = new Map<Id, Territory2>();
   Map<Id, Map<Id, UserTerritory2Association>> UT2Amap = new Map<Id, Map<Id, UserTerritory2Association>>();
   
   Set<Id> Ids = new Set<Id>();
   Set<Id> InactiveUsers = new Set<Id>();
   Map<Id, Map<Id, UserTerritory2Association>> umap = new map<Id, Map<Id, UserTerritory2Association>>();
   
   for(SAP_Sales_DOG__c d:alist){
     myclass myclass = getUserIds(d);
     umap.put(d.id, myclass.UT2Amap);
     InactiveUsers.addall(myclass.inactiveusers);
     dmap.put(d.id, d);
     ids.add(d.id);
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
   
   for(SAP_Sales_DOG__c d:alist){
     if(t2map.containskey(d.id)){
       territory2 t2 = t2map.get(d.id);
       Map<Id, UserTerritory2Association> ExistingUT2As = new Map<Id, UserTerritory2Association>();
       Map<Id, UserTerritory2Association> NewUT2As = new Map<Id, UserTerritory2Association>();
       
       if(UT2AMap.containskey(t2.id)){
         ExistingUT2As = UT2AMap.get(t2.id);
       }
       
       if(umap.containskey(d.id)){
         newUT2As = umap.get(d.id);
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
           if(existingUT2A.RoleInTerritory2 != 'Backup'){
             todelete.add(existingUT2A);
           }
         }
           
         }
         
         for(Id uid:newUT2As.keyset()){
           UserTerritory2Association newUT2A = newUT2As.get(uid);
           system.debug(newUT2A);
           system.debug(keepthese);
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
     str += '\nZDOG_Users_Batch(' + a.Id + ' ' + a.status + ')  processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.';
     ZTERR_Users_Batch r = new ZTERR_Users_Batch(m, str);
     system.schedulebatch(r, 'ZTERR_Users_Batch', 1); 
  }
}