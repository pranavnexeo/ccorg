@IsTest
public class DeleteAttachDocumentBatch_Test {
    
    public static void setupData(Integer dataToCreate) {
        List<Attachment> attachments = new List<Attachment>();
        ES_Order_Document__c ESDocument = new ES_Order_Document__c();
		insert ESDocument;
        for(Integer i = 0; i < dataToCreate; i ++) {
            Attachment attach = new Attachment();   	
            attach.Name = 'attachmentToES';
            Blob bodyBlob = Blob.valueOf('Attachment');
            attach.body = bodyBlob;
            attach.parentId = ESDocument.id;
            attachments.add(attach);
        }
		
        insert attachments;
    }

    @IsTest
    public static void deleteAttachment() {
        setupData(1);
        Test.startTest();

            scheduledDeleteAttachDocumentBatch scheduledJob = new scheduledDeleteAttachDocumentBatch(); 
            scheduledJob.execute(null);
        
        Test.stopTest();
        Integer currentAttachments = [SELECT Id FROM Attachment].size();
        System.assertEquals(0, currentAttachments);
    }
    
    @IsTest
    public static void deleteAttachments() {
        setupData(200);
        Test.startTest();

            scheduledDeleteAttachDocumentBatch scheduledJob = new scheduledDeleteAttachDocumentBatch(); 
            scheduledJob.execute(null);
        
        Test.stopTest();
        Integer currentAttachments = [SELECT Id FROM Attachment].size();
        System.assertEquals(0, currentAttachments);
    }
    
     @IsTest
    public static void noDataToDelete() {
        Test.startTest();

            scheduledDeleteAttachDocumentBatch scheduledJob = new scheduledDeleteAttachDocumentBatch(); 
            scheduledJob.execute(null);
        
        Test.stopTest();
        Integer currentAttachments = [SELECT Id FROM Attachment].size();
        System.assertEquals(0, currentAttachments);
    }
}