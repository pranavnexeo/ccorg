//Author - Matt

global class ZTERR_Batch implements Database.Batchable<SObject>{

global string callback;
global string q;
global final Territory2Model m{get; set;}
global final Territory2Type type{Get; set;}

global ZTERR_Batch(Territory2Model m, territory2type type, string callback){
  this.callback = callback;
  this.m = m;
  this.type = type;
  q = 'select id, Name, Record_Key__c, SAP_Sales_DOG__r.Record_Key__c from SAP_Territory__c where record_key__c != null';       
}

//Start method
global Database.QueryLocator start(Database.BatchableContext bcMain){
         return Database.getQueryLocator(q);
} 
 
//Execute Method
global void execute(Database.BatchableContext bcMain, List<SAP_Territory__c> alist){
   
   Set<String> parentids = new Set<String>();
   
   List<Territory2> newTerritories =  new List<Territory2>();
   Map<String, SAP_Territory__c> tmap = new Map<String, SAP_Territory__c>();
   Map<String, Territory2> t2parentmap = new map<String, Territory2>(); //Key > Id of Territory2, Value > Territory2
   
   //Loop through SAP Territory records
   for(SAP_Territory__c t:alist){
     tmap.put('T' + t.record_Key__c, t); //Put SAP Territory Ids in a map
     if(t.SAP_Sales_DOG__c != null){ 
       parentids.add('D' + t.SAP_Sales_DOG__r.Record_Key__c); //Put SAP Sales DOG Ids in a set.
     }
   }

   //Query Standard Territory2 records. These corrlate to the SAP Sales DOG 1-1
   for(territory2 t2:[select id, DeveloperName from Territory2 where DeveloperName IN :parentids]){
     t2parentmap.put(t2.DeveloperName, t2);
   }
   
   //Init map of Territory2 where the SAP Territory Id that corresponds to this Territory2 record is in tmap. 
   Map<string, Territory2> t2map = new Map<String, Territory2>();
   
   //Loop through Territory2 records 
   for(territory2 t2:[select id, Territory2ModelId, Territory2TypeId, DeveloperName, ParentTerritory2Id from Territory2 where DeveloperName IN :tmap.keyset()]){
     t2.Territory2TypeId = type.id; //Set Territory2Type to ZTERR
     SAP_Territory__c t = tmap.get(t2.DeveloperName);  //Get the SAP Territory record
     system.debug('Parent Dev Name: ' + 'D' + t.SAP_Sales_DOG__r.Record_Key__c);
     if(t2parentmap.containskey('D' + t.SAP_Sales_DOG__r.Record_Key__c)){ //If the SAP Sales DOG is in the map
       t2.ParentTerritory2Id = t2parentmap.get('D' + t.SAP_Sales_DOG__r.Record_Key__c).id; //Parent it to the T2 corresponding to the SAP Sales DOG
     }
     t2.Name = t.name; //Set Name
     t2.Description = t.name;  //Set Description
     if(t2.Territory2ModelId == m.id)
       t2map.put(t2.DeveloperName, t2);
   }
   
   for(SAP_Territory__c t:alist){ //For each SAP Territory
     Territory2 t2 = new Territory2( //Create new Territory2 record
         
          Territory2ModelId = m.id,
          Territory2TypeId = type.id,
          AccountAccessLevel = 'Edit',
          OpportunityAccessLevel = 'Edit',
          Description = t.Name,
          DeveloperName = 'T' + t.record_key__c,
          Name = t.Name
        );
     if(t2parentmap.containskey('D' + t.SAP_Sales_DOG__r.Record_Key__c)){
       t2.Parentterritory2id = t2parentmap.get('D' + t.SAP_Sales_DOG__r.Record_Key__c).id; //Parent Id
     }   
     if(!t2map.containskey('T' + t.Record_Key__c)){
        newTerritories.add(t2);      
     }
   }
   
   if(t2map.values().size() > 0)
     update  t2map.values();
   
   if (newTerritories.size() > 0)
     insert newTerritories;
   
   system.debug('Updates: ' + t2map.values().size());
   system.debug('Inserts: ' + newTerritories.size()); 
}
  
//Finish Method
global void finish(Database.BatchableContext bcMain){
       
     AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:bcMain.getJobId()];
     String str = callback;
     str += '\nZTERR_Batch(' + a.Id + ' ' + a.status + ')  processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.';
     ZTERR_Accounts_Batch r = new ZTERR_Accounts_Batch(m, str);
     system.schedulebatch(r, 'ZTERR_Account_Batch', 1); 
  }
}