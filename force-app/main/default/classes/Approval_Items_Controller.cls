public class Approval_Items_Controller{

public List<Approval_Wrapper> Approvals{Get; set;}

public Approval_Items_Controller(){

       Id userid = userinfo.getuserid();
       List<ProcessInstance> PIs = new list<ProcessInstance>();
       List<ProcessInstanceWorkItem> workitems = new list<ProcessInstanceWorkItem>();
       Approvals = new list<Approval_Wrapper>();
       Set<ID> PISet = new set<ID>();
       Set<ID> ApproverIDs = new set<ID>();
       Set<ID> objectIDs = new set<ID>();
       Map<ID, String> ApproverMap = new map<ID, String>();
       User u = [select id, name from user where id = :userid];
       
       List<groupmember> members = [select id, groupid from groupmember where userorgroupid = :userid];
       for(groupmember gm:members){
         approverids.add(gm.groupid);
       }
       
       workItems = [ select 
                    p.Actor.Name,
                    p.ActorId,
                    p.ProcessInstance.TargetObjectId, 
                    p.ProcessInstance.TargetObject.Name,
                    p.ProcessInstance.TargetObject.Type,
                    p.ProcessInstance.Id, 
                    p.ProcessInstanceId,
                    createddate              
                    from ProcessInstanceWorkitem p where p.ActorID = :userid OR p.actorid in :approverids order by createddate desc];  
      
              
         for(ProcessInstanceWorkItem i:WorkItems){
           Approvals.add(new approval_Wrapper(i.id, i.ProcessInstance.TargetObjectId, i.ProcessInstance.TargetObject.Name, i.ProcessInstance.TargetObject.Type, u, i));
         }
}

public class Approval_Wrapper{
public id stepid{get; set;}
public ProcessInstanceWorkItem step{get; set;}
public id TargetObjectId{Get; set;}
public string TargetObjectName{get; set;}
public string TargetObjectType{get; set;}
public user user{get;set;}
public pagereference approverejectlink{get; set;}
public pagereference reassignLink{get; set;}
public pagereference relatedToLink{get; set;}
public pagereference userlink{get; set;}


public Approval_Wrapper(Id sid, Id TargetId, String TargetName, String t, user u, ProcessInstanceWorkItem i){
  step = i;
  TargetObjectId = TargetId;
  TargetObjectName = TargetName;
  TargetObjectType = t;
  User = u;
  stepid = sid;
  approverejectlink = new pagereference('/p/process/ProcessInstanceWorkitemWizardStageManager?id=' + stepid);
  reassignLink  = new pagereference('/' + stepid + '/e?et=REASSIGN&retURL=%2Fhome%2Fhome.jsp');
  relatedToLink = new pagereference('/' + targetobjectId);
  userlink = new pagereference('/' + user.id);
}

}


}