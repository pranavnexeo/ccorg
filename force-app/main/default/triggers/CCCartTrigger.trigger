trigger CCCartTrigger on ccrz__E_Cart__c (before insert) {
    
    CCCartTriggerHelper handler = new CCCartTriggerHelper(Trigger.isExecuting, Trigger.size);
	
    if(Trigger.isBefore && Trigger.isInsert){
    	handler.OnBeforeInsert(Trigger.new);
  	}            
}