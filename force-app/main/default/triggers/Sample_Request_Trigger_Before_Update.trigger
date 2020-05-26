trigger Sample_Request_Trigger_Before_Update on Sample_Request__c (before update) {

    Sample_Request_Trigger_Functions.processBeforeUpdate(Trigger.new);
    
}