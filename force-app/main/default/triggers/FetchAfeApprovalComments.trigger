/**  
* @Name FetchAfeApprovalComments 
* @Purpose This trigger is used to fetch the approval comments from an approved AFE record
* @Author  Santhosh
* @Version 2.0 
*/
trigger FetchAfeApprovalComments on Authorization_for_Expenditure__c (before update, after insert) {
    
    System.debug('----------FetchAfeApprovalComments ----------');
    Authorization_for_Expenditure__c [] afeList = Trigger.new;
    AfeApprovalHelper.ProcessInst(afeList);
   
    
}