global class DedupAccountMaterial_Batch{// implements Database.Batchable<SObject> {

/*
global String q;
global List<Account> accts{get;set;}
global integer total{get; set;}
global integer numtodelete{get; set;}

// Class Constructor - set query string
global DedupAccountMaterial_Batch() {
q = 'SELECT id, SAP_Sales_Org__c, Ownerid, SAP_Industry_key_Desc__c, SAP_SalesGroup__c, SAP_Sales_group_desc__c FROM Account WHERE type=\'Customer\' and SAP_DistChannel__c = \'30\' and recordtype.name = \'Distribution Customer\'';
}

//"Start" runs when the class in instanciated
global Database.QueryLocator start(Database.BatchableContext bcMain) {
total = 0;
numtodelete = 0;
return Database.getQueryLocator(q);
}

// "Execute" is what is being run as a separate process per batch
global void execute(Database.BatchableContext bcMain, List<Account> lstBatchRecords) {
  
  set<id> accids = new set<id>();
  for(account a:lstBatchRecords)
    accids.add(a.id);
  
  List<Account_material__c> ams = [select id, SAP_Material__c, account__c from Account_material__c where account__c IN :accids order by created_from_cpi__r.Customer_Material_Number__c DESC];
   
  Set<String> accmatids = new set<String>();
  List<Account_Material__c> toDelete = new List<Account_material__c>();
  for(Account_material__c am: ams)
  {
     if(accmatids.contains(am.account__c + '-' + am.SAP_Material__c))
       toDelete.add(am);
     else
       accmatids.add(am.account__c + '-' + am.SAP_Material__c);
  }
  delete toDelete;
  
system.debug('delete ' + todelete.size() + ' of ' + ams.size());
if(total != null)
total = total + ams.size();
else
total = ams.size();

if(numtodelete != null)
numtodelete += todelete.size();
else
numtodelete = todelete.size();
}

// Finish the Batch Job
global void finish(Database.BatchableContext bcMain) {
// Optional - you can send an email to an admin with results
  system.debug('Delete ' + numtodelete + ' records out of ' + total + ' total records.');
}
*/
}