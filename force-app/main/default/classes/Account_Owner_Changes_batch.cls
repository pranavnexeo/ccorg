//Batch Class to update SAP Corporate Account Manager and SAP Sold To Account Owner based on Owner Changes.
//Author - Matt

global class Account_Owner_Changes_batch implements Database.Batchable<SObject>{
private string callback;
global string q;
global Account_Owner_Changes_batch (string callback){
        this.callback = callback;
        q = 'select field, AccountId, NewValue, OldValue from AccountHistory where field = \'Owner\' and CreatedDate > YESTERDAY';
}

//Start method
global Database.QueryLocator start(Database.BatchableContext bcMain){
         return Database.getQueryLocator(q);
} 
 
//Execute Method
global void execute(Database.BatchableContext bcMain, List<AccountHistory> hlist){
       Set<Id> AccountIds = new Set<Id>();
       for(AccountHistory ah:hlist){
          AccountIds.add(ah.AccountId);
       }
       List<Account> accounts = [select id from Account where
                                  parentid IN :AccountIds OR
                                  SAP_Sold_To_Account_Id__c IN :AccountIds OR
                                  SAP_Corporate_Account_Id__c IN :AccountIds
                                ];
       update Accounts;                                
   }
//Finish Method
global void finish(Database.BatchableContext bc){
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:bc.getJobId()];
        string str = '';
        if(callback != '' && callback != null)
        str += callback + '\n';
        str += 'Account_Owner_Changes_batch (' + a.Id + ' ' + a.status + ')  processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.';
        //Added a new batch class in the chain - for Business contract
        //@Rajeev
        database.executebatch(new Update_BusinessContract_Status_batch (str));
    }
}