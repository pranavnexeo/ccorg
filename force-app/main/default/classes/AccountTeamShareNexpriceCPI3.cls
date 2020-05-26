global class AccountTeamShareNexpriceCPI3 implements Database.Batchable<SObject> {

    Set<Id> accountIds = new set<Id>();
    private string callback;
    
    global AccountTeamShareNexpriceCPI3 (string callback){
        this.callback = callback;
        }
    
    global Database.QueryLocator start(Database.BatchableContext bcMain) {
             
             return Database.getQueryLocator('Select Id from Account where Type = \'Customer\' and lastmodifieddate = TODAY');
             
    }
      
    
    global void execute(Database.BatchableContext bcMain, List<Account> accounts) {

             sharing_functions.share_with_Account_Team([select id, Account__c from Account_Material__c where Account__c IN :accounts]);
         
    }

    global void finish(Database.BatchableContext bcMain) {
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id = : bcMain.getJobId()];
        String str = callback;
        str += 'AccountTeamShareNexpriceCPI3(' + a.Id + ' ' + a.status + ')  processed ' + a.TotalJobItems + ' batches with ' + a.NumberOfErrors + ' failures.';
        ContactOwnerBatch c = new ContactOwnerBatch(str);
        database.executebatch(c);
    }
}