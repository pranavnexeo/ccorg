/*Batch class for Business Contracts
*to update Status based on expiration date
*Author - Rajeev
*/

global class Update_BusinessContract_Status_batch implements Database.Batchable<SObject>{
        /*Initializing variables*/
        String callback;
        String q;
        Date today = Date.today();
        List<Business_Contract__c> toUpdate = new List<Business_Contract__c>();
    
    /*Constructor -> Create query string*/
    global Update_BusinessContract_Status_batch(String callback){
        this.callback = callback;
        q = 'Select Id, Expiration_Date__c, Status__c, RecordType.Name from Business_Contract__c where Expiration_Date__c < today and Expiration_Date__c != null and (RecordType.Name = \'AD Business Contract\' OR RecordType.Name = \'AD Vendor Contract\') and Status__c != \'Inactive\'';
    }
    
    /*Start method -> Run query*/
    global Database.QueryLocator Start(Database.BatchableContext bcMain){
        return Database.getQueryLocator(q);
    }

    /*Execute method -> Update records*/
    global void execute(Database.BatchableContext bcMain, List<Business_Contract__c> blist){
       if(blist != null && blist.size()>0){ 
        for(Business_Contract__c bc : blist){
            bc.Status__c = 'Inactive';
                 toUpdate.add(bc);
        }
         if(toUpdate != null && toUpdate.size()>0){ 
            update toUpdate;
           } 
     }
    }
    /*Finish method -> Send emails*/
    global void finish(Database.BatchableContext bc){
    AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:bc.getJobId()];
        string str = '';
        if(callback != '' && callback != null)
        str += callback + '\n';
        str += 'Update_BusinessContract_Status_batch (' + a.Id + ' ' + a.status + ')  processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.';
        
        /*Added as an enhancement on 23rd June 14 - @Rajeev*/
        database.executebatch(new Account_SAP_Values_Sync_Batch(str));
    }
}