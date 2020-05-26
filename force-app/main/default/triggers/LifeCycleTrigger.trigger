/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        02/14/2018
*   Author:             Ignacio Gonzalez
*   Last Modified:       
*   Last Modified By:    
*
*   Short Description:  Trigger for LifeCycle_Report_Request__c object
*   
*   
*	
*   **********************************************************************************************************************/
trigger LifeCycleTrigger on LifeCycle_Report_Request__c (after insert) {

  if(Trigger.isInsert && Trigger.isAfter){
    LifeCycleTriggerHandler.OnAfterInsertAsync(Trigger.newMap.keySet());
  }

}