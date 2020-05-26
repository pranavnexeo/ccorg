global class Material_Sales_Data_SharingRecalc implements Database.Batchable<SObject> {

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([select id, Sales_Org_Code__c,
                                                Dist_Channel_Code__c 
                                           from Material_Sales_Data2__c]);
    }

    global void execute(Database.BatchableContext bc, SObject[] soa){
    	Material_Sales_Data2__c[] msd2a = (Material_Sales_Data2__c[]) soa;
    	Material_Sales_Data_Functions.createSharingRecords(msd2a);
    }
    
    global void finish(Database.BatchableContext bc) {
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, 
                                 TotalJobItems, CreatedBy.Email 
                            from AsyncApexJob where Id = :bc.getJobId()];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {a.CreatedBy.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Material Sales Data Sharing Recalculation ' + a.Status);
        mail.setPlainTextBody('Material Sales Data sharing recalculation processed ' + 
                               a.TotalJobItems + ' batches with '+ 
                               a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

}