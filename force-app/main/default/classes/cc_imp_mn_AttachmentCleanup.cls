public without sharing class cc_imp_mn_AttachmentCleanup {

    public final static String ATTACHMENT_DESCRIPTION = 'CC-TEMP-PDF';
    public final static Integer AGE = -2;

    /*
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id FROM Attachment WHERE Description = :ATTACHMENT_DESCRIPTION AND CreatedDate < :DateTime.now().addMinutes(AGE)]);
    }

    global void execute(Database.BatchableContext bc, List<sObject> scope){
        delete scope;
    }

    global void finish(Database.BatchableContext bc){
    }

    public static Id enqueueJob() {
        String jobId = null;
        try {
            jobId = System.scheduleBatch(new cc_imp_mn_AttachmentCleanup(), 'Attachment Cleanup ' + DateTime.now(), 5);
        }
        catch (Exception e) {
            System.debug(e.getMessage());
        }
        return jobId;
    }
    */

    public static void cleanup() {
        List<Attachment> attachments = [SELECT Id FROM Attachment WHERE Description = :ATTACHMENT_DESCRIPTION AND CreatedDate < :DateTime.now().addMinutes(AGE)];
        delete attachments;
    }
}