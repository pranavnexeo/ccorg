//Author - Matt

global class ZDOG_Batch implements Database.Batchable<SObject>{
global string q;
global final Territory2Model m{get; set;}
global final Territory2Type type{Get; set;}
global final Territory2Type zterr{get; set;}
global string callback{get; set;}

global ZDOG_Batch(string callback, Territory2Model m, territory2type type, territory2type zterr){
  this.callback = callback;
  this.m = m;
  this.type = type;
  this.zterr = zterr;
  q = 'select id, Name, Record_Key__c from SAP_Sales_DOG__c where record_Key__c != null';       
}

global ZDOG_Batch(Territory2Model m, territory2type type, territory2type zterr){
  this.callback = '';
  this.m = m;
  this.type = type;
  this.zterr = zterr;
  q = 'select id, Name, Record_Key__c from SAP_Sales_DOG__c where record_key__c != null';       
}

//Start method
global Database.QueryLocator start(Database.BatchableContext bcMain){
         return Database.getQueryLocator(q);
} 
 
//Execute Method
global void execute(Database.BatchableContext bcMain, List<SAP_Sales_DOG__c> alist){
   
   Map<String, SAP_Sales_DOG__c> dmap = new Map<String, SAP_Sales_DOG__C>();
   List<Territory2> newTerritories =  new List<Territory2>();
   
   
   for(SAP_Sales_DOG__c d:alist){
     dmap.put('D' + d.record_Key__c, d);
   }
  
   Map<string, Territory2> t2map = new Map<String, Territory2>();
   for(territory2 t2:[select id, Territory2ModelId, Territory2TypeId, DeveloperName from Territory2 where DeveloperName IN :dmap.keyset()]){
     t2.Territory2TypeId = type.id;
     SAP_Sales_DOG__c d = dmap.get(t2.DeveloperName);
     t2.name = d.name;
     t2.description = d.name;
     
     if(t2.Territory2ModelId == m.id)
       t2map.put(t2.DeveloperName, t2);
   }
   
   for(SAP_Sales_DOG__c d:alist){
     if(!t2map.containskey('D' + d.Record_Key__c)){
        newTerritories.add(new Territory2(
          Territory2ModelId = m.id,
          Territory2TypeId = type.id,
          AccountAccessLevel = 'Edit',
          OpportunityAccessLevel = 'Edit',
          Description = d.Name,
          DeveloperName = 'D' + d.record_key__c,
          Name = d.Name
        ));      
     }
   }
   
   if(t2map.values().size() > 0)
     update  t2map.values();
   
   if (newTerritories.size() > 0)
     insert newTerritories;
   
}
  
//Finish Method
global void finish(Database.BatchableContext bcMain){
       
     AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:bcMain.getJobId()];
     String str = callback;
     str += 'ZDOG_Batch(' + a.Id + ' ' + a.status + ')  processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.'; 
     ZTERR_Batch zterr = new ZTERR_Batch(m, zterr, str);
     System.schedulebatch(zterr, 'ZTERR_Batch', 1);
  }
}