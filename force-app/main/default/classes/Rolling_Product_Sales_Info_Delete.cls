global with sharing class Rolling_Product_Sales_Info_Delete implements Database.Batchable<sObject> {

    private static final String MONTH_01 = Rolling_Product_Sales_Info_Functions2.MONTH_01;
    
    private static Integer MAX_RECS = 20000000;
    
    global Database.Querylocator start(Database.BatchableContext bc) {
        Database.Querylocator ql;
        ql = Database.getQueryLocator([
                select id
                  from Rolling_Product_Sales_Info__c
                 where Month_01__c <> :MONTH_01
                 limit :MAX_RECS
             ]);
        return ql;
    }


    global void execute(Database.BatchableContext bc, List<SObject> alist){
        List<Rolling_Product_Sales_Info__c> rpsi = (List<Rolling_Product_Sales_Info__c>)alist;
        try {delete rpsi;} catch(Exception e){}
    }
    
    global void finish(Database.BatchableContext bc){
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
                                 TotalJobItems, CreatedBy.Email
                            from AsyncApexJob 
                           where Id =:bc.getJobId()];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {a.CreatedBy.Email});
        mail.setReplyTo(a.CreatedBy.Email);
        mail.setSenderDisplayName('Rolling_Product_Sales_Info_Delete Batch Processing');
        mail.setSubject('Apex Batch Job - Rolling_Product_Sales_Info_Delete Batch Processing - ' + 
                         a.Status+' - '+a.TotalJobItems+' batches');
        mail.setPlainTextBody('Job Id : '+a.Id+' processed ' + a.TotalJobItems +
                              ' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    Webservice static String submitBatchJob() {
        Rolling_Product_Sales_Info_Delete b = new Rolling_Product_Sales_Info_Delete();
        String msg;
        try {
            msg = Database.executeBatch(b);
        } catch(Exception e) {
            msg = e.getMessage();
            System.debug(e);
        }
        return msg;
    }

    static testMethod void test01() {
        Test.startTest();
        MAX_RECS = 200;
        submitBatchJob();
        Test.stopTest();
    }

}