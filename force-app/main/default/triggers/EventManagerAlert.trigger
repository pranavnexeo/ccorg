trigger EventManagerAlert on Event (after insert, before update, before insert) {
    
	EventManagerAlertHandler handler = new EventManagerAlertHandler(Trigger.isExecuting, Trigger.size);	
    
     if(Trigger.isInsert && Trigger.isBefore) {
        handler.OnBeforeInsert(Trigger.new);
     } else if(Trigger.isInsert && Trigger.isAfter) {
        handler.OnAfterInsert(Trigger.new);
     } else if(Trigger.isUpdate && Trigger.isBefore) {
        handler.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.newMap);
     }
   
}