global class OpportunityOwnerBatch implements Database.Batchable<SObject> {

    global string q;
    global string callback;
    global OpportunityOwnerBatch(string callback){
    this.callback = callback;
        q = 'Select Id from Opportunity where Account.Account_Team_Updated__c  = true';
    
    }
    global Database.QueryLocator start(Database.BatchableContext bcMain) {
             return Database.getQueryLocator(q);                  
    }
    
    global void execute(Database.BatchableContext bcMain, List<Opportunity> Opps) {
         Opportunity_Territory_Functions.assignOwner(opps);
    }
    
    global void finish(Database.BatchableContext bcMain) {
    AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:bcMain.getJobId()];
    string str = callback;
    str += 'OpportunityOwnerBatch (' + a.Id + ' ' + a.status + ')  processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.';
     Territory2Model m = [select id from Territory2Model where state = 'Active' limit 1];
        Territory2Type ZDOG = [select id from Territory2Type where MasterLabel = 'ZDOG' limit 1];
        Territory2Type ZTER = [select id from Territory2Type where MasterLabel = 'ZTER' limit 1];
        database.executebatch(new ZDOG_Batch(str, m, ZDOG, ZTER));
    

    }
}