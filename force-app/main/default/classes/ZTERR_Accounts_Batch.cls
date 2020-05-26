//Author - Matt

global class ZTERR_Accounts_Batch implements Database.Batchable<SObject>{
global string q;
global final Territory2Model m;
global final string callback;

global ZTERR_Accounts_Batch(Territory2Model m, string callback){
  this.m = m;
  this.callback = callback;
  q = 'select id, YI_Partner__c, YY_Partner__c, YZ_Partner__c, ';
  q += ' YI_Partner__r.Record_Key__c, YY_Partner__r.record_key__c, YZ_Partner__r.Record_Key__c from Account where ( type = \'customer\' or type = \'Prospect\') and (YI_Partner__c != null or YY_Partner__c != null or YZ_Partner__c != null)';       
}

//Start method
global Database.QueryLocator start(Database.BatchableContext bcMain){
         return Database.getQueryLocator(q);
} 
 
//Execute Method
global void execute(Database.BatchableContext bcMain, List<Account> alist){
   
   Map<Id, Set<String>> amap = new Map<Id, Set<String>>(); //Territories assigned by Account
   Map<Id, Set<String>> existingAssociations = new Map<Id, Set<String>>(); //Existing Associations
   
   for(Account a:alist){
     Set<String> ids = new set<String>();
     if(a.YI_Partner__c != null)
       ids.add('T' + a.YI_Partner__r.Record_Key__c);
     if(a.YY_Partner__c != null)
       ids.add('T' + a.YY_Partner__r.Record_Key__c);
     if(a.YZ_Partner__c != null)
       ids.add('T' + a.YZ_Partner__r.Record_Key__c);
     amap.put(a.id, ids);
     existingAssociations.put(a.id, new Set<String>());    
   }
   
   //Tmap is Territory Record Key / T2 DeveloperName
   Map<String, Id> tmap = new Map<String, Id>();//Key > SAP_Territory Record Key, Value = Territory2 Id
   List<ObjectTerritory2Association> toinsert = new List<ObjectTerritory2Association>();
   List<ObjectTerritory2Association> todelete = new List<ObjectTerritory2Association>();
   
   for(Territory2 t2:[select id, DeveloperName from Territory2 where territory2modelId = :m.id])
     tmap.put(t2.DeveloperName, t2.id);
   
   
   for(ObjectTerritory2Association ot2a:[select id, Objectid, Territory2id, Territory2.DeveloperName from ObjectTerritory2Association where ObjectId In :amap.keyset() and AssociationCause = 'Territory2Manual']){
     
     //If for this account, developername is not in the list of territories then delete it
     if(!amap.get(ot2a.Objectid).contains(ot2a.Territory2.DeveloperName))
       todelete.add(ot2a);
     else //if it is in the list of territories
       existingAssociations.get(ot2a.ObjectId).add(ot2a.TErritory2.DeveloperName);
   }
   
   for(Account a:alist){
     if(a.YI_Partner__c != null && //YI Not Null
        tmap.containskey('T' + a.YI_Partner__r.Record_Key__c)//T2 Exists in Map 
        && !existingAssociations.get(a.id).contains('T' + a.YI_Partner__r.Record_Key__c)
       ){
           toinsert.add(new ObjectTerritory2Association(ObjectId = a.id, Territory2Id = tmap.get('T' + a.YI_Partner__r.Record_Key__c), AssociationCause = 'Territory2Manual')); 
          existingAssociations.get(a.id).add('T' + a.YI_Partner__r.Record_Key__c);
        }
     if(a.YY_Partner__c != null && //YY Not Null
        tmap.containskey('T' + a.YY_Partner__r.Record_Key__c)//T2 Exists in Map 
        && !existingAssociations.get(a.id).contains('T' + a.YY_Partner__r.Record_Key__c)
       ){
           toinsert.add(new ObjectTerritory2Association(ObjectId = a.id, Territory2Id = tmap.get('T' + a.YY_Partner__r.Record_Key__c), AssociationCause = 'Territory2Manual')); 
           existingAssociations.get(a.id).add('T' + a.YY_Partner__r.Record_Key__c);
        }
      if(a.YZ_Partner__c != null && //YZ Not Null
        tmap.containskey('T' + a.YZ_Partner__r.Record_Key__c) //T2 Exists in Map 
        && !existingAssociations.get(a.id).contains('T' + a.YZ_Partner__r.Record_Key__c)
       ){
           toinsert.add(new ObjectTerritory2Association(ObjectId = a.id, Territory2Id = tmap.get('T' + a.YZ_Partner__r.Record_Key__c), AssociationCause = 'Territory2Manual')); 
           existingAssociations.get(a.id).add('T' + a.YZ_Partner__r.Record_Key__c);
        }

   }
   
   if(todelete.size() > 0)
     delete todelete;
   
   if(toinsert.size() > 0){
     Database.SaveResult[] srlist = Database.insert(toinsert, false);

    String result = 'Records attempted to insert: ' + toinsert.size();
    // Iterate through each returned result
    for (Database.SaveResult sr : srList) {
    if (sr.isSuccess()) {
        // Operation was successful, so get the ID of the record that was processed
        //result += sr.getId() + ': Successfully inserted \n';
    }
    else {
        // Operation failed, so get all errors                
        for(Database.Error err : sr.getErrors()) {
            result += sr.getId() + ': Error. ' + err.getStatusCode() + ': ' + err.getMessage() + ' Fields: ' + err.getFields() + '\n';
        }
    }
    }

   }
}
  
//Finish Method
global void finish(Database.BatchableContext bcMain){
       
     AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:bcMain.getJobId()];
     String str = this.callback;
     str += '\nZTERR_Account_Batch(' + a.Id + ' ' + a.status + ')  processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.'; 
     ZDOG_Users_Batch zterr = new ZDOG_Users_Batch(m, str);
     database.executebatch(zterr);
  }
}