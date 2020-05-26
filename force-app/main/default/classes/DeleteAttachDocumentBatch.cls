global class DeleteAttachDocumentBatch implements Database.Batchable<sObject>{
    
    
   global Database.QueryLocator Start(Database.BatchableContext bcMain){
       List<ES_Order_Document__c> ordersParentFromDocuments = new List<ES_Order_Document__c>();
       ordersParentFromDocuments = [SELECT id FROM ES_Order_Document__c];
       String query = '';
       if(!ordersParentFromDocuments.isEmpty()) {
           	query = 'SELECT Id FROM Attachment where parentid in :ordersParentFromDocuments';
       } else {
			query = 'SELECT Id FROM Attachment limit 0'; 
       }              
      
       return Database.getQueryLocator(query);
    }
    
    global void Execute(Database.BatchableContext bcMain, List<Attachment> attachmentList){
        try {
            if (!attachmentList.isEmpty()) {
                delete attachmentList;
            } 
        } catch (Exception ex) {
            
        }
    }
    
    
    global void finish(Database.BatchableContext bcMain){
    }
}