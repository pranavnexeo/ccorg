public with sharing class TestSubmit {

public static Approval.ProcessResult submitForApproval(String comments,Id targetObjectID){ 
                 
         Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();  
         req1.setComments(comments);
         req1.setObjectId(targetObjectID);    
        
         system.debug('targetObjectID'+req1);
         Approval.ProcessResult result = Approval.process(req1);
                 
         return result;
    }
    
    public static void doApproval(String comments,Id targetObjectID){ 
    
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();  
        
        req.setComments(comments);  
        req.setAction('Approve');  
        Id workItemId = getWorkItemId(targetObjectID);  
        
        if(workItemId!=null)   {  
            req.setWorkitemId(workItemId);  
            Approval.ProcessResult result =  Approval.process(req);  
        }  
       
         
       
    }
    
    public static void doRejection(String comments,Id targetObjectID){ 
    
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();  
        req.setComments(comments);  
        req.setAction('Reject');  
        
        Id workItemId = getWorkItemId(targetObjectID);  
        system.debug('=-==========TEst caseWorkID========='+workItemId);
         
        if(workItemId!=null){  
            req.setWorkitemId(workItemId);  
            Approval.ProcessResult result =  Approval.process(req);  
            List <Authorization_for_Expenditure__c> af = [select id, Status__c from Authorization_for_Expenditure__c where id =: targetObjectID];
            system.debug('=-==========TEst case========='+af);
        } 
        
          
    }
    
    private static Id getWorkItemId(Id targetObjectId)  
    {  
         Id retVal = null;  
         for(ProcessInstanceWorkitem workItem  : [Select p.Id from ProcessInstanceWorkitem p  
             where p.ProcessInstance.TargetObjectId =: targetObjectId])  
        {  
           retVal  =  workItem.Id;  
        }  
        return retVal;  
     }  
}