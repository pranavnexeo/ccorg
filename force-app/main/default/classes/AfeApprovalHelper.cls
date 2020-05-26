/**  
* @Name AfeApprovalHelper 
* @Purpose This is a helper class used the AFE Approval Process to fetch the approval comments 
* @Author  Santhosh
* @Version 2.0 
*/
public class AfeApprovalHelper {

    

    public static void ProcessInst(Authorization_for_Expenditure__c[] afeList) {
    System.debug('---Inside approval class---'); 

        for(Authorization_for_Expenditure__c  afeObj:afeList) {
            ProcessInstance [] processInstanceList = [SELECT Id,Status,(SELECT Id,ActorId,Actor.Name,OriginalActorId,OriginalActor.Name, StepStatus,
             Comments FROM Steps)FROM ProcessInstance where TargetObjectId in : afeList];
              //System.debug('----inside for loop1----' + processInstanceList.size());  
            for (ProcessInstance processInstanceObj : processInstanceList ) {
                for (ProcessInstanceStep step : processInstanceObj.Steps) {
                 System.debug('---before if cond--------'); 
                 
                 //Process Instance step will have one record for each approval step..
                 
                    if(afeObj.Status__c == 'Rejected') {
                         System.debug('-----Status field----'+afeObj.Status__c); 
                        afeObj.Approver_Comments__c = step.Comments;
                        afeObj.Original_Actor__c = step.OriginalActor.Name;
                        afeObj.Behalf_approver__c = step.Actor.Name;
                        System.debug('-----appval comment------'+step.Comments);
                        
                    }else if(afeObj.Status__c == 'Approved'){
                          afeObj.Approver_Comments__c = step.Comments;
                          afeObj.Original_Actor__c = step.OriginalActor.Name;
                        afeObj.Behalf_approver__c = step.Actor.Name;
                        
                    }
                }
            }
        }  
    }
   
}