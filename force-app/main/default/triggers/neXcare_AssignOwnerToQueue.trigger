/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:         09/07/2016
*    Author:              Sneha Likhar
*   Last Modified:        09/07/2016
*   Last Modified By:     Sneha Likhar
*
*   Short Description:  To assign account's CSR as assigned to user and CSR's queue as owner
*   **********************************************************************************************************************/

trigger neXcare_AssignOwnerToQueue on NexCare__c (Before Insert) {
if(Trigger.isInsert){
  Nexcare_HelperClass.NexcareMethod(Trigger.new); }
}