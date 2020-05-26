global class scheduledDeleteAttachDocumentBatch  implements Schedulable{
    global void execute(SchedulableContext SC) {
        
        DeleteAttachDocumentBatch batchToDeleteAttachments = new DeleteAttachDocumentBatch();
        database.executebatch(batchToDeleteAttachments);

    }
}