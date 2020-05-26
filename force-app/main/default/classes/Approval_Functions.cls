public class Approval_Functions {

    public static Map<ID, String> getComments(Set<ID> ids){
       List<ProcessInstance> PIs = new list<ProcessInstance>();
       Set<ID> PISet = new set<ID>();
       List<User> users = new list<user>();
       Set<ID> UserIDs = new set<ID>();
       List<ProcessInstanceStep> PISteps = new list<ProcessInstanceStep>();
       Map<ID, String> CommentsMap = new Map<ID, String>();
       Map<ID, ID> ObjecttoPI = new Map<ID, ID>();
       Map<ID, String> UserMap = new map<ID, String>();
       Map<ID, String> returnmap = new map<ID, String>();

       PIs = [select id, TargetObjectId from ProcessInstance where TargetObjectId in :IDs];

       for(ProcessInstance PI:PIs){
          PISet.add(PI.id);
          ObjectToPI.put(PI.TargetObjectID, PI.id);
       }

      PISteps = [select id, comments, OriginalActorID, ActorID, ProcessInstanceID, stepstatus, createddate from ProcessinstanceStep where ProcessInstanceID in :PISet order by createddate desc];

       for(ProcessInstanceStep PIstep:PISteps){
          userIDs.add(PIstep.ActorID);
          userIDs.add(PIstep.OriginalActorID);
       }

       users = [select id, name from user where id in :userids];
       List<group> groups = [select id, name from group where id in :userids];

       for(user u:users){
         userMap.put(u.id, u.name);
       }
       
       for(group g:groups){
         userMap.put(g.id, g.name);
       }

     for(ProcessInstanceStep PIstep:PISteps){

        if(CommentsMap.containskey(PIStep.ProcessInstanceID)){

               String s = CommentsMap.get(PIStep.ProcessInstanceID);
               if(PIStep.Comments != null){
                  s = s + '\n\n' + 'Assigned To: ' + usermap.get(PIStep.OriginalActorID) + '\n' + 'Actual Approver: ' + usermap.get(PIStep.ActorID) + '\n' + 'Status: ' + PIStep.stepstatus + '\n' + PIStep.createddate + '\n' + PIStep.Comments;
               }
               else {
                  s = s + '\n\n' + 'Assigned To: ' + usermap.get(PIStep.OriginalActorID) + '\n' + 'Actual Approver: ' + usermap.get(PIStep.ActorID) + '\n' + 'Status: ' + PIStep.stepstatus + '\n' + PIStep.createddate + '\n' + '\nNo Comments';
               }     
               CommentsMap.put(PIStep.ProcessInstanceID, s);    
            }
       else{
               if(PIStep.Comments != null){
               CommentsMap.put(PIStep.ProcessInstanceID, 'Assigned To: ' + usermap.get(PIStep.OriginalActorID) + '\n' + 'Actual Approver: ' + usermap.get(PIStep.ActorID) + '\n' + 'Status: ' + PIStep.stepstatus + '\n' + PIStep.createddate + '\n' + PIStep.Comments);
               }
               else{
               CommentsMap.put(PIStep.ProcessInstanceID, 'Assigned To: ' + usermap.get(PIStep.OriginalActorID) + '\n' + 'Actual Approver: ' + usermap.get(PIStep.ActorID) + '\n' + 'Status: ' + PIStep.stepstatus + '\n' + PIStep.createddate + '\n' + '\nNo Comments');
               }    
       }
    }

      for(ID i:IDs){
         for(ProcessInstance PI:PIs){
            if(i == PI.TargetObjectID){
               if(CommentsMap.containskey(PI.ID)){
                  if(returnmap.containskey(i)){
                     String s = returnmap.get(i);
                     s += '\n\n' + CommentsMap.get(PI.ID);
                     returnmap.put(i, s);
                  }
                  else{                
                    returnmap.put(i, CommentsMap.get(PI.ID));
                  }
            }
           }
          }
      }
   return returnmap;
   }
  public static Map<ID, String> getLastApproversComments(Set<ID> ids){
       List<ProcessInstance> PIs = new list<ProcessInstance>();
       Set<ID> PISet = new set<ID>();
       List<User> users = new list<user>();
       Set<ID> UserIDs = new set<ID>();
       List<ProcessInstanceStep> PISteps = new list<ProcessInstanceStep>();
       Map<ID, String> CommentsMap = new Map<ID, String>();
       Map<ID, ID> ObjecttoPI = new Map<ID, ID>();
       Map<ID, String> UserMap = new map<ID, String>();
       Map<ID, String> returnmap = new map<ID, String>();

       PIs = [select id, TargetObjectId from ProcessInstance where TargetObjectId in :IDs];

       for(ProcessInstance PI:PIs){
          PISet.add(PI.id);
          ObjectToPI.put(PI.TargetObjectID, PI.id);
       }

      PISteps = [select id, comments, OriginalActorID, ActorID, ProcessInstanceID, ProcessInstance.TargetObjectId, stepstatus, createddate from ProcessinstanceStep where ProcessInstanceID in :PISet and (stepstatus = 'Approved' OR stepstatus = 'Rejected') order by createddate DESC ];

       for(ProcessInstanceStep PIstep:PISteps){
          userIDs.add(PIstep.ActorID);
          userIDs.add(PIstep.OriginalActorID);
       }

       users = [select id, name from user where id in :userids];
       List<group> groups = [select id, name from group where id in :userids];

       for(user u:users){
         userMap.put(u.id, u.name);
       }
       
       for(group g:groups){
         userMap.put(g.id, g.name);
       }

     for(ProcessInstanceStep PIstep:PISteps){
          if(!CommentsMap.containskey(PIStep.ProcessInstance.TargetObjectId))
          {
               if(PIStep.Comments != null){
               CommentsMap.put(PIStep.ProcessInstance.TargetObjectId, PIStep.Comments);
               }
               else{
               CommentsMap.put(PIStep.ProcessInstance.TargetObjectId, 'No Comments');
               }   
         } 
       
    }
    return commentsmap;
   } 
    public static void submitrecord(id recordid, string comments){
   
       Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
       req1.setComments(comments);
       req1.setObjectId(recordid);                                     
       approval.ProcessResult result = Approval.process(req1); 
   }
   
     //*************
     //Purpose: To find out if the logged in User is either the Approver, the delegated Approver 
     //of the real approver, or a Queue member and thus providing approving capabilities to them. 
     //Added by:Sana Tarique
     //Added on:4th July 2014
     //*************
     Public static boolean isApprover(String userid, String Target_Id){
        //Init variables
        List<ProcessInstanceWorkitem> workItem = new List<ProcessInstanceWorkitem>();
        Set<id> Queue_users = new Set<id>(); //Users that are Group Members of the Approval Group
        Set<Id> delegList = new Set<Id>(); //Delegated Approvers
        
        //Get the work item
        if(Target_ID != null )
        {
            workItem = [ select 
                    Actor.Name,
                    ActorId,
                    ProcessInstance.TargetObjectId, 
                    ProcessInstance.Id, 
                    ProcessInstanceId              
                    from ProcessInstanceWorkitem  where ProcessInstance.TargetObjectId =: Target_ID 
                    ];  
 
       }
   
       //If ProcessInstanceWorkItem is found
       if(workitem.size()>0){
           
           
           //Get Group Members, assuming Actor Id (Approver) is a group
           for(GroupMember grp_mem:[select GroupID, UserOrGroupId from groupmember where GroupID= :workitem[0].ActorId])
               Queue_users.add(grp_mem.UserOrGroupId);
           
           //Get Delegated Approver of the Approver or of all Approvers who are members of the Approval Group (Queue_Users)
           for(User delegId: [select id, DelegatedApproverId from User where id = :workitem[0].ActorId or id IN :Queue_users])
               delegList.add(delegId.DelegatedApproverId );
           
           //Assume user is not approver until proven otherwise
           Boolean isApprover = false;
           
           // If user is a GroupMember of the Approval Group
           if(Queue_Users.contains(UserId)) 
             isApprover = true;
           // If Actor Id (Approver) is the delegated Approver of the user specified in the parameters
           if(delegList.contains(UserId))
           { 
             isApprover = true;
             system.debug('reached here');
           }
           // If Actor Id (approver) is the specified User
           if(workitem[0].ActorId == userId)
             isApprover = true;
           
           //Return isApprover
           return isApprover;
           
                      
      }
      else //If no Workitem is Found
          return false;
      }
      
    public static boolean issubmitted(String Target_Id){
    
    List<ProcessInstanceWorkItem> workItems = [ select 
                    p.Actor.Name,
                    p.ActorId,
                    p.ProcessInstance.TargetObjectId, 
                    p.ProcessInstance.Id, 
                    p.ProcessInstanceId              
                    from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: Target_Id ];  
    
    return (workitems.size() > 0);
    }
    
    public static string ApproveReject(String Target_Id, String ApproveReject, string comments)
    {
        List<ProcessInstanceWorkitem> workItem = new List<ProcessInstanceWorkitem>();
        ProcessInstance currentInstance = new ProcessInstance();
        List<ProcessInstanceStep> proccessHistory = new List<ProcessInstanceStep>();
        ProcessInstanceStep currentProccessStep = new ProcessInstanceStep();
        String userid = UserInfo.getuserid();
        String Response = '';
        
        if(Target_ID != null)
        {
        
            List<groupmember> membership = [select groupid, userorgroupid from groupmember where userorgroupid = :userid];
            set<ID> groupids = new set<id>();
           //User u = [select id, DelegatedApproverId from User where id = :userid limit 1];
            for(groupmember m:membership){
              groupids.add(m.groupid);
            }

            workItem = [ select 
                    p.Actor.Name,
                    p.ActorId,
                    p.ProcessInstance.TargetObjectId, 
                    p.ProcessInstance.Id, 
                    p.ProcessInstanceId              
                    from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId =: Target_ID and (p.ActorID = :userid or p.actorid IN :groupids)];  
            
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

        if(workitem.size() > 0 && approvereject == 'APPROVE'){
        Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
        req2.setComments(comments);
        req2.setAction('Approve');   
        req2.setWorkitemId(workitem.get(0).id);    
        Approval.ProcessResult result2 =  Approval.process(req2);
        response = 'APPROVED';
        }

        if(workitem.size() > 0 && approvereject == 'REJECT'){
        Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
        req2.setComments(comments);
        req2.setAction('Reject');   
        req2.setWorkitemId(workitem.get(0).id);    
        Approval.ProcessResult result2 =  Approval.process(req2);
        response = 'REJECTED';
        }
      }
      else{
        response = 'YOU ARE NOT THE APPROVER';
      }
    }
    else{
        response = 'TARGET ID IS NULL';
    }
          
    return response;        

   }
}