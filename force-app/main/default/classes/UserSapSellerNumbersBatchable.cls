global with sharing class UserSapSellerNumbersBatchable implements Database.Batchable<SObject> {

    global database.querylocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('select Id from User where IsActive = true');
    }

    global void execute(Database.BatchableContext bc, List<SObject> alist){
    	List<User> usrs = (List<User>) alist;
        Set<Id> userIds = new Set<Id>();
        for (User u : usrs) {
            userIds.add(u.Id);
        }
        SAP_Seller_Functions.updateUserSapSellerNumbers(userIds);
        System.debug('DMLStatements : '+Limits.getDMLStatements()+'/'+Limits.getLimitDMLStatements());
        System.debug('ScriptStatements : '+Limits.getScriptStatements()+'/'+Limits.getLimitScriptStatements());
    }
    
    global void finish(Database.BatchableContext bc){
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
                                 TotalJobItems, CreatedBy.Email
                            from AsyncApexJob 
                           where Id =:bc.getJobId()];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {a.CreatedBy.Email});
        mail.setReplyTo(a.CreatedBy.Email);
        mail.setSenderDisplayName('UserSapSellerNumbers Batch Processing');
        mail.setSubject('Batch Process Id: '+a.Id+' '+a.Status);
        mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems +
                              ' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

}