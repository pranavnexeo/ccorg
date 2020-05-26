global with sharing class Rolling_Product_Sales_Info_Upsert implements Database.Batchable<sObject> {

    private static final Date START_DATE = Rolling_Product_Sales_Info_Functions2.START_DATE;
    
    private static final Date END_DATE = Rolling_Product_Sales_Info_Functions2.END_DATE;
    
    private static Integer MAX_PSF_RECS = 20000000;
    
    global Database.Querylocator start(Database.BatchableContext bc) {
        Database.Querylocator ql;
        String q = Rolling_Product_Sales_Info_Functions2.getPsfQuery(false, false, false);
        ql = Database.getQueryLocator(q);
        return ql;
    }


    global void execute(Database.BatchableContext bc, List<SObject> alist){
        List<Product_Sales_Figure__c> psfa = (List<Product_Sales_Figure__c>)alist;
        Rolling_Product_Sales_Info_Functions2.upsertRollingProductSalesInfo(psfa);
    }
    
    global void finish(Database.BatchableContext bc){
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
                                 TotalJobItems, CreatedBy.Email
                            from AsyncApexJob 
                           where Id =:bc.getJobId()];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {a.CreatedBy.Email});
        mail.setReplyTo(a.CreatedBy.Email);
        mail.setSenderDisplayName('Rolling_Product_Sales_Info_Upsert Batch Processing');
        mail.setSubject('Apex Batch Job - Rolling_Product_Sales_Info_Upsert Batch Processing - ' + 
                         a.Status+' - '+a.TotalJobItems+' batches');
        mail.setPlainTextBody('Job Id : '+a.Id+' processed ' + a.TotalJobItems +
                              ' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    Webservice static String submitBatchJob() {
        Rolling_Product_Sales_Info_Upsert b = new Rolling_Product_Sales_Info_Upsert();
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
        MAX_PSF_RECS = 10;
        Rolling_Product_Sales_Info_Functions2.insertTestPSF();
        submitBatchJob();
        Test.stopTest();
    }

}