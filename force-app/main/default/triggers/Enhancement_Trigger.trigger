/* 
* Description: Trigger on Enhancement__c
* Date: 1 / 17 / 2018
* Developer: Ignacio Gonzalez
*/
trigger Enhancement_Trigger on Enhancement__c (before insert, before update) {

    //We are creating the object that references to the handler of this trigger
	EnhancementTriggerHandler handler = new EnhancementTriggerHandler(Trigger.isExecuting, Trigger.size);
	
    if (Trigger.isBefore && Trigger.isUpdate) {
        //Before update event
        handler.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.newMap);
    } else if (Trigger.isBefore && Trigger.isInsert) {
        //Before insert event
        handler.OnBeforeInsert(Trigger.new);
    }
}