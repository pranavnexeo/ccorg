trigger UserTrigger on User (after insert, after update) {

    UserTriggerHandler handler = new UserTriggerHandler();
    
    if(Trigger.isInsert && Trigger.isAfter){
        handler.OnAfterInsert(Trigger.new);
  	} else if(Trigger.isUpdate && Trigger.isAfter){
    handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.newMap);
  }
    
}