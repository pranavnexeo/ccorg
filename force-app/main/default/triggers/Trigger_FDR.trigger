/* 
* Description: Trigger on Functional_Design_Registration__c
* Date: 10 / 10 / 2017
* Developer: Ignacio Gonzalez
*/
trigger Trigger_FDR on Functional_Design_Registration__c (after update, after insert, after delete) {
    
    //We are creating the object that references to the handler of this trigger
    FDRTriggerHandler handler = new FDRTriggerHandler(Trigger.isExecuting, Trigger.size);
    
    if (Trigger.isAfter && Trigger.isUpdate) {
        //After update event
        handler.handleAfterUpdate(Trigger.old, Trigger.new, Trigger.newMap);
    }
    
    else if (Trigger.isAfter && Trigger.isInsert) {
        //After insert event
         handler.OnAfterInsert(Trigger.new);
    }
    
    else if (Trigger.isAfter && Trigger.isDelete) {
        //After update event
        handler.OnAfterDelete(Trigger.old, Trigger.oldMap);
    }
    
}