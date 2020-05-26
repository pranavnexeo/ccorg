public with sharing class MobileApproveRejectController {
    
    public String Target_ID = System.currentPageReference().getParameters().get('id');
    Public String UserID{get; set;}
    public string response{get; set;}
    public string comments{get; set;}
    
    private static final String CRNL = '\r\n';
    private static final String NL = '\n';

    public List<List<String>> lisfDetailFields { get; set; }
    
    public String formattedObjectDetail {get; set;}
  
    List<ProcessInstanceWorkitem> workItem = new List<ProcessInstanceWorkitem>();
    ProcessInstance currentInstance = new ProcessInstance();
    List<ProcessInstanceStep> proccessHistory = new List<ProcessInstanceStep>();
    ProcessInstanceStep currentProccessStep = new ProcessInstanceStep();
    
    public MobileApproveRejectController()
    {
        UserID = UserInfo.getUserId() ;
        genApproveReject();
    }
        
    private void genApproveReject()
    {
        if(Target_ID != null)
        {

            workItem = [ select 
                    p.Actor.Name,
                    p.ActorId,
                    p.ProcessInstance.TargetObjectId, 
                    p.ProcessInstance.Id, 
                    p.ProcessInstanceId              
                    from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: Target_ID and p.ActorID = :userid];  
            
            if(workitem.size() > 0){
            currentInstance = [select 
                                p.Id,
                                p.TargetObject.Name,
                                p.TargetObject.Type,
                                p.Status,       
                                p.TargetObjectId 
                                from ProcessInstance p where id =: workItem.get(0).ProcessInstanceId ];
            
            proccessHistory = [ Select 
                                p.CreatedDate,
                                p.StepStatus, 
                                p.ProcessInstance.TargetObjectId, 
                                p.ProcessInstanceId, 
                                p.Actor.Name,
                                p.OriginalActorId, 
                                p.Id, 
                                p.Comments,
                                p.SystemModstamp, 
                                p.ActorId 
                                from ProcessInstanceStep p 
                                where p.ProcessInstance.TargetObjectId =: currentInstance.TargetObjectId order by p.SystemModstamp desc];
            
            // CurrentStep
            currentProccessStep = proccessHistory[0];
            response = currentInstance.status;
            
          } 
        }
    }
    

public pagereference approveworkitem(){
if(workitem.size() > 0){
Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
req2.setComments(comments);
req2.setAction('Approve');   
req2.setWorkitemId(workitem.get(0).id);    
Approval.ProcessResult result2 =  Approval.process(req2);
response = 'APPROVED';
}
else{
response = 'YOU ARE NOT AN APPROVER FOR THIS ITEM';
}

return null;
// Verify the results  

}

public pagereference rejectworkitem(){
if(workitem.size() > 0){
Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
req2.setComments(comments);
req2.setAction('Reject');   
req2.setWorkitemId(workitem.get(0).id);    
Approval.ProcessResult result2 =  Approval.process(req2);
response = 'REJECTED';
}
else{
response = 'YOU ARE NOT AN APPROVER';
}

return null;
}

}