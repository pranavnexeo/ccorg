/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        05/01/2018
*   Author:              Ignacio Gonzalez
*   Last Modified:       
*   Last Modified By:    
*
*   Short Description:  Trigger to manage events triggered by CC Order DML Events
*   
*   
*	
*   **********************************************************************************************************************/
trigger CCOrderTrigger on ccrz__E_Order__c (after insert, after update) {
    
    CCOrderTriggerHandler handler = new CCOrderTriggerHandler(Trigger.isExecuting, Trigger.size);
	
    if(Trigger.isInsert && Trigger.isAfter){
    	handler.OnAfterInsert(Trigger.new);
  	}
        
    if(Trigger.isUpdate && Trigger.isAfter){
    	handler.OnAfterUpdate(Trigger.new);
  	}
}