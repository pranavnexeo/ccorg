global class PriceRequestTransaction_Batch implements Database.Batchable<SObject> {


global String q;
public List<price_request_transaction__c> prt{get;set;}

// Class Constructor - set query string
global PriceRequestTransaction_Batch() {
    q = 'SELECT id, sold_to__c, ship_to__c, corporate_account__c, batch_updated__c, ship_to__r.SAP_Corporate_Account_Id__c, ship_to__r.SAP_Sold_To_Account_Id__c from Price_Request_transaction__c where batch_updated__c = false';
}

//"Start" runs when the class in instanciated
global Database.QueryLocator start(Database.BatchableContext bcMain) {

return Database.getQueryLocator(q);
}

// "Execute" is what is being run as a separate process per batch
global void execute(Database.BatchableContext bcMain, List<price_request_transaction__c> lstBatchRecords) {



List<Price_Request_Transaction__c> toupdate = new list<Price_Request_Transaction__c>();

for(Price_Request_Transaction__c t:lstBatchRecords)
{
   if(t.ship_to__r.SAP_Sold_To_Account_Id__c == '' || t.ship_to__r.SAP_Sold_To_Account_Id__c == null)
     t.sold_to__c = null;
   else
     t.sold_to__c = t.ship_to__r.SAP_Sold_To_Account_Id__c;
     
   if(t.ship_to__r.SAP_Corporate_Account_Id__c == '' || t.ship_to__r.SAP_Corporate_Account_Id__c == null)
     t.corporate_account__c = null;
   else
     t.corporate_account__c = t.ship_to__r.SAP_Corporate_Account_Id__c;
   t.batch_updated__c = true;
   toupdate.add(t);
}
if(toupdate.size() > 0)
  upsert toupdate;

}
// Finish the Batch Job
global void finish(Database.BatchableContext bcMain) {
// Optional - you can send an email to an admin with results
}
}