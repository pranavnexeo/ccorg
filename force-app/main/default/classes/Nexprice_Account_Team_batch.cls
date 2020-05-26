/*Nexprice CPI Security enhancement
 *Author @Rajeev
 *The batch job deletes Nexprice Team Member records due past expiration date.
 *The sharing records are then deleted by trigger.
 *Test method in "nexpriceCPI_security" class.
 */
global class Nexprice_Account_Team_batch implements Database.Batchable<SObject> {
    String callback;
    String query;
    Date today = system.today();
    
    global Nexprice_Account_Team_batch(String callback){
        this.callback = callback;
        query = 'Select Id,Expiration_Date__c from Nexeo_Account_Team__c where Expiration_Date__c < :today';
    }
    
    
    global Database.QueryLocator start(Database.BatchableContext bcMain) {
        return Database.getQueryLocator(query);
    }


    global void execute(Database.BatchableContext bcMain, List<Nexeo_Account_Team__c> team) {
        
        if(team != null && team.size()>0)
            delete team;
            
    }


    global void finish(Database.BatchableContext bcMain) {
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:bcMain.getJobId()];
        string str = '';
        if(callback != '' && callback != null)
        str += callback + '\n';
        str += 'Nexprice_Account_Team_batch (' + a.Id + ' ' + a.status + ')  processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.';
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {'NexeoSFDCSupport@nexeosolutions.com'});
        mail.setReplyTo('NexeoSFDCSupport@nexeosolutions.com');
        mail.setSenderDisplayName('Batch Processing');
        mail.setSubject('Batch Processing');
        mail.setPlainTextBody(str);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }


}