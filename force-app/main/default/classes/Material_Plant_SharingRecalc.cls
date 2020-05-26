global class Material_Plant_SharingRecalc implements Database.Batchable<SObject> {

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([select id, SalesOrg_Code__c
                                           from Material_Plant2__c
                                        ]);
    }

    global void execute(Database.BatchableContext bc, SObject[] soa){
        Material_Plant2__c[] mp2a = (Material_Plant2__c[]) soa;
        Material_Plant_Functions.createSharingRecords(mp2a);
    }
    
    global void finish(Database.BatchableContext bc) {
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, 
                                 TotalJobItems, CreatedBy.Email 
                            from AsyncApexJob where Id = :bc.getJobId()];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {a.CreatedBy.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Material Plant Sharing Recalculation ' + a.Status);
        mail.setPlainTextBody('Material Plant sharing recalculation processed ' + 
                               a.TotalJobItems + ' batches with '+ 
                               a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

}