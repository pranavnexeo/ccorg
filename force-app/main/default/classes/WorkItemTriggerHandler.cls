public without sharing class WorkItemTriggerHandler {
    
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;

    public WorkItemTriggerHandler(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;

    }
    /**
     * Method that is going to handle the after Update event
     * 
     * */
    public void handleAfterUpdate(Work_Item__c[] oldRecords, 
                                    Work_Item__c[] updatedRecords, 
                                  Map<Id, Work_Item__c> recordMap) { 
/*
        Map<Id, Decimal> extendedMapWorkItem = new Map<Id, Decimal>(); // FDR Id, value to add 
        
        for (Integer i = 0; i < updatedRecords.length; i ++) {
                
                if(oldRecords[i].Resource_Hours__c != updatedRecords[i].Resource_Hours__c ) {
                    Decimal valueToadd = extendedMapWorkItem.get(updatedRecords[i].Functional_Design_Registration__c);
                    if (valueToadd == null) {
                        valueToadd = 0;
                    }
        
                    valueToadd += updatedRecords[i].Resource_Hours__c - oldRecords[i].Resource_Hours__c;
                    extendedMapWorkItem.put(updatedRecords[i].Functional_Design_Registration__c , valueToadd);
                    
                }
        
        }
        
        List<Functional_Design_Registration__c> listFDRToUpdate = new List<Functional_Design_Registration__c>();
        
        for (Id fdrId: extendedMapWorkItem.keySet()) {
            Functional_Design_Registration__c recordToUpdate = new Functional_Design_Registration__c();
            recordToUpdate.Id = fdrId;
            recordToUpdate.Resource_Hours__c = extendedMapWorkItem.get(fdrId);
            listFDRToUpdate.add(recordToUpdate);
        }
        
        
        if (!listFDRToUpdate.isEmpty()) {
            update listFDRToUpdate;
        } */                                 
                                  
    }
    
    public void OnAfterInsert(Work_Item__c[] newRecords){ } 
    
    public void OnAfterDelete(Work_Item__c[] deletedRecords, Map<ID, Work_Item__c> recordMap){}


}