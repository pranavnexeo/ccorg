public class Approval_Section_Controller{

public List<Process_Instance> ApprovalHistory{Get; set;}

public Approval_Section_Controller(apexpages.standardcontroller sc){

       Id recordid = sc.getrecord().id;
       List<ProcessInstance> PIs = new list<ProcessInstance>();
       ApprovalHistory = new list<Process_Instance>();
       Set<ID> PISet = new set<ID>();
       Set<ID> ApproverIDs = new set<ID>();
       List<ProcessInstanceStep> PISteps = new list<ProcessInstanceStep>();
       List<ProcessInstanceWorkitem> PIItems = new list<ProcessInstanceWorkItem>();

       PIs = [select id, TargetObjectId, status from ProcessInstance where TargetObjectId = :recordid order by createdDate desc];

       for(ProcessInstance PI:PIs){
          PISet.add(PI.id);
       }

      PISteps = [select id, comments, OriginalActorID, originalactor.name, originalactor.type, ActorID, Actor.name, Actor.type, ProcessInstanceID, stepstatus, createddate from ProcessinstanceStep where ProcessInstanceID in :PISet order by createddate desc];
      PIItems = [select id, OriginalActorID, originalactor.name, originalactor.type, ActorID, actor.name, Actor.type, ProcessInstanceID, createddate from ProcessinstanceWorkItem where ProcessInstanceID in :PISet order by createddate desc];
      
      for(ProcessInstance PI:PIs){
      List<Process_Step> steps= new list<Process_Step>(); 
         for(ProcessInstanceWorkItem i:PIItems){
           if(i.ProcessInstanceID == PI.id){
             steps.add(new Process_Step(PI, i));          
           }
         }    
         for(ProcessInstanceStep PIstep:PISteps){
           if(PIStep.ProcessInstanceID == PI.id){
             steps.add(new Process_Step(PIStep));          
           }
         }
      ApprovalHistory.add(new process_instance(PI, steps));
      }
}

public class Process_Instance{
   public ProcessInstance PI{get; set;}
   public List<Process_Step> steps{get; set;}
   
   Public Process_Instance(ProcessInstance p, List<Process_Step> PIS){
     PI = p;
     steps = PIS;
   }

}

public class Process_Step{
public string createddate{get; set;}
public id stepid{get; set;}
public string actorname{get; set;}
public id actorid{get; set;}
public string originalactorname{get; set;}
public id originalactorid{get; set;}
public pagereference approverejectlink{get; set;}
public pagereference reassignLink{get; set;}
public pagereference relatedToLink{get; set;}
public pagereference actorlink{get; set;}
public pagereference originalactorlink{get; set;}
public string comments{get; set;}
public string status{get; set;}
public string actortype{get; set;}
public string originalactortype{get; set;}

public Process_Step(ProcessInstanceStep s){

  createddate = s.createddate.format();
  stepid = s.id;
  actorid = s.actorid;
  actorname = s.actor.name;
  originalactorid = s.originalactorid;
  originalactorname = s.originalactor.name;
  comments = s.comments;
  status = s.stepstatus;
  approverejectlink = null;
  reassignLink  = null;
  actortype = s.actor.type;
  originalactortype = s.originalactor.type;
  if(s.actor.type == 'Queue'){ actorlink = new pagereference('/p/own/Queue/d?id=' + actorid);}
  else{ actorlink = new pagereference('/' + actorid);}
  if(s.originalactor.type == 'Queue'){ originalactorlink = new pagereference('/p/own/Queue/d?id=' + originalactorid);}
  else{ originalactorlink = new pagereference('/' + originalactorid); }
  
}

public Process_Step(ProcessInstance p, ProcessInstanceWorkItem i){

  comments = '';
  createddate = i.createddate.format();
  actorid = i.actorid;
  actorname = i.actor.name;
  originalactorid = i.originalactorid;
  originalactorname = i.originalactor.name;
  approverejectlink = new pagereference('/p/process/ProcessInstanceWorkitemWizardStageManager?id=' + stepid);
  reassignLink  = new pagereference('/' + stepid + '/e?et=REASSIGN&retURL=%2Fhome%2Fhome.jsp');
  status = P.status;
  actortype = i.actor.type;
  originalactortype = i.originalactor.type;
  if(i.actor.type == 'Queue'){ actorlink = new pagereference('p/own/Queue/d?id=' + actorid);}
  else{ actorlink = new pagereference(actorid);}
  if(i.originalactor.type == 'Queue'){ originalactorlink = new pagereference('p/own/Queue/d?id=' + originalactorid);}
  else{ originalactorlink = new pagereference(originalactorid); }
 
}

}

}