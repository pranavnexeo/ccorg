global abstract class AbstractNextApproverBatch implements Database.Batchable<SObject> {

    protected Database.QueryLocator qryLocator;
    
    protected Datetime lastTimestamp;
    
    protected String objectType;
    
    protected final String processStatus = 'Pending';

    protected String soql = 'select Id, TargetObjectId from ProcessInstance where ' +
                            'SystemModStamp >= :lastTimestamp ' +
                            'and TargetObject.type = :objectType ' + 
                            'and Status = :processStatus';
    
    global void finish(Database.BatchableContext bc) {
/*
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
                                 TotalJobItems, CreatedBy.Email
                            from AsyncApexJob 
                           where Id =:bc.getJobId()];
        String sender = 'NextApprover Batch Processing';
        String subject = 'NextApprover Batch Process Id: ' + a.Id + ' ' + a.Status;
        String body = 'NextApprover batch Apex job processed ' + a.TotalJobItems +
                      ' batches with '+ a.NumberOfErrors + ' failures.';
        log(subject + '\n' + body);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {a.CreatedBy.Email});
        mail.setReplyTo(a.CreatedBy.Email);
        mail.setSenderDisplayName(sender);
        mail.setSubject(subject);
        mail.setPlainTextBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
//*/
    }
    
    global void log(String msg) {
    	System.debug('>>>>>> [' + msg + ']');
    }
}