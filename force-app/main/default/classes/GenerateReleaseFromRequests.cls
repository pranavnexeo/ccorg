public with sharing class GenerateReleaseFromRequests{

  Public List<Request> Requests{get; set;}
  Public List<SelectOption> statuses{get; set;}
  Public String SelectedStatus{get; set;}
  Public Boolean MyApprovalsOnly{get; set;}

  Public String Comments{get; set;}
  public String sortField{get; set;}
  public string sortArrow{get; set;}
  Public ART_Release__c release{get; set;}
  private Boolean sortASC{get; set;}
  private String originalSortField{get; set;}
  private string UP_IMAGE = '/img/sort_asc_arrow.gif';
  private string DOWN_IMAGE = '/img/sort_desc_arrow.gif';
  private Sort_Helper SH;



public GenerateReleaseFromRequests(ApexPages.standardcontroller sc){

SH = new Sort_Helper();
sortASC = TRUE;
sortArrow = UP_IMAGE;
sortField = 'Target_Date_For_Nexeo_Release__c';
originalSortField = sortField;
release = new ART_Release__c();
release.Name = system.today() + ' Release';
    
Comments = '';
MyApprovalsOnly = false;
Schema.DescribeFieldResult F = Art_Request__c.Status__c.getDescribe();
List<String> values = new List<String>();
for(Schema.PicklistEntry p:F.getPickListValues()){
values.add(p.getlabel());
}
values.sort();
statuses = new list<SelectOption>();
for(String s:values){
statuses.add(new SelectOption(s, s));
}

SelectedStatus = 'Requesting Approval for Release';
Requests = new list<Request>();
For(ART_Request__c r:[select id, name, Project__r.Name, Release__c, solution__c, status__c, Project__c, Request_Number__c, Subject__c,  Target_Date_for_Nexeo_Release__c from ART_Request__c where Status__c = :SelectedStatus and createddate > 2011-08-22T00:00:00Z order by Target_Date_for_Nexeo_Release__c DESC limit 1000]){
  Requests.add(new Request(r));
}

}

// Sort Results
  public Pagereference sortResults(){
     system.debug('sortASC Start: ' + sortASC);
     sh = new sort_helper();
     Map<ID, Request> requestmap = new Map<ID, Request>();
     List<ART_Request__c> ART_Requests = new List<Art_Request__c>();
     
     for(Request r:requests){
       ART_Requests.add(r.request);
       requestmap.put(r.request.id, r);
     }
       
     sh.originalList = ART_Requests;
     if(sortField == originalSortField)
     { 
        sortASC = !sortASC;
        if(sortASC){
          sortArrow = UP_IMAGE;        
        }
        else{   
          sortArrow = DOWN_IMAGE;          
        }
     }
     else
     {
        sortArrow = UP_IMAGE;
        sortASC = TRUE;
     }
     system.debug('sortASC END: ' + sortASC);
     
     ART_Requests = sh.getsortedList(sortField, sortASC); 
     Requests.clear();
     originalSortField = sortField;
     for(ART_Request__c r:ART_Requests){
       Requests.add(requestmap.get(r.id));
     }
     return null;
  }

Public void StatusChanged(){

Requests.clear();
if(SelectedStatus == 'Completed'){
For(ART_Request__c r:[select id, name, Project__r.Name, Release__c, solution__c, status__c, Project__c, Request_Number__c, Subject__c,  Target_Date_for_Nexeo_Release__c from ART_Request__c where Status__c = :SelectedStatus and Target_Date_For_Nexeo_Release__c >= :System.Today() - 90 and createddate > 2011-08-22T00:00:00Z  order by Target_Date_for_Nexeo_Release__c DESC limit 1000 ]){
  Requests.add(new Request(r));
}
}
else{
For(ART_Request__c r:[select id, name, Project__r.Name, Release__c, solution__c, status__c, Project__c, Request_Number__c, Subject__c,  Target_Date_for_Nexeo_Release__c from ART_Request__c where Status__c = :SelectedStatus  and createddate > 2011-08-22T00:00:00Z  order by Target_Date_for_Nexeo_Release__c DESC limit 1000]){
  Requests.add(new Request(r));
}
}
}

public void ApproveRequests(){
if(SelectedStatus == 'Requesting Approval for Release'){
for(integer i=0; i<Requests.size(); i++){
  if(Requests.get(i).isselected == true){
    Approval_Functions.ApproveReject(Requests.get(i).Request.id, 'Approve', Comments);
    Requests.remove(i);
  }
}
}
else{
SelectedStatus = 'Requesting Approval for Release';
StatusChanged();
}
}


public void RejectRequests(){
if(SelectedStatus == 'Requesting Approval for Release'){
for(integer i=0; i<Requests.size(); i++){
  if(Requests.get(i).isselected == true){
    Approval_Functions.ApproveReject(Requests.get(i).Request.id, 'Reject', Comments);
    Requests.remove(i);
  }
}
}
else{
SelectedStatus = 'Requesting Approval for Release';
StatusChanged();
}
}

Public Pagereference CreateRelease(){

release.sfdc_release_date__C = system.today();
release.sfdc_release_status__c = 'Planned';
List<ART_Request__c> ART_Requests = new List<ART_Request__c>();

for(Request r:Requests){
  if(r.isselected == true){
    if(release.summary_of_release__c != null)
    {
    release.summary_of_release__c += 'Project: ' + r.request.Project__r.Name + '\n';
    }
    else
    {
    release.summary_of_release__c = 'Project: ' + r.request.Project__r.Name + '\n';
    }
    release.summary_of_release__c += 'Subject: ' + r.request.Subject__c + '\n';
    release.summary_of_release__c += 'Solution: ' + r.request.Solution__c + '\n';
    release.summary_of_release__c += 'Link to Request: http://NA49.Salesforce.com/' + r.request.id + '\n\n';
    ART_Requests.add(r.request);
  }
}

if(ART_Requests.size() > 0){
insert release;
for(ART_Request__c r:ART_Requests){
r.Release__c = release.id;
}
update ART_Requests;
String ReleaseId = Release.Id;
release = new ART_Release__c();
release.Name = system.today() + ' Release';
return new pagereference('/' + releaseid);
}
else{ return null; }
}

public void MyApprovalsChanged(){
  
  requests.clear();
  SelectedStatus = 'Requesting Approval for Release';
  if(MyApprovalsOnly == true){
  Set<ID>TargetObjectIDs = new Set<ID>();
  List<ProcessInstanceWorkItem> items = new list<ProcessInstanceWorkItem>();
  items = [select id, ProcessInstance.TargetObjectID, Actor.Name, Actorid from ProcessInstanceWorkItem p where ActorId = :userinfo.getuserid() and p.ProcessInstance.TargetObject.Type = 'ART_Request__c' limit 1000];
 
  for(ProcessInstanceWorkItem p:items){
     TargetObjectIDs.add(p.ProcessInstance.TargetObjectID);
  }
  
  For(ART_Request__c r:[select id, name, Project__r.Name, Release__c, solution__c, status__c, Project__c, Request_Number__c, Subject__c,  Target_Date_for_Nexeo_Release__c from ART_Request__c where ID IN :TargetObjectIds order by Target_Date_for_Nexeo_Release__c DESC limit 1000]){
     Requests.add(new Request(r));
  }
  }
  else{
  For(ART_Request__c r:[select id, name, Project__r.Name, Release__c, solution__c, status__c, Project__c, Request_Number__c, Subject__c,  Target_Date_for_Nexeo_Release__c from ART_Request__c where Status__c = :SelectedStatus order by Target_Date_for_Nexeo_Release__c DESC limit 1000]){
     Requests.add(new Request(r));
  }
  }
}

public static void updateactualreleasedateonrequest(List<ART_Release__c> releases){
  Set<ID> releaseIDs = new set<ID>();
  List<ART_Request__c> requests = new List<ART_Request__c>();
  Map<ID, ART_Release__c> RelMap = new map<ID, ART_Release__c>();  
    
  for(ART_Release__c rel:releases){
     releaseIDs.add(rel.id);
     RelMap.put(rel.id, rel);
  }
  
  requests = [select id, Actual_Effort__c, Actual_Completion_Date__c, release__c from ART_Request__c where release__c in :releaseIDs];
  
  for(ART_Request__c req:requests){
     if(RelMap.get(req.release__c).SFDC_Release_Status__c == 'Released'){
       req.Actual_Completion_Date__c = RelMap.get(req.release__c).SFDC_Release_Date__c;
       req.status__c = 'Completed';
       If(req.Actual_Effort__c == null){
         req.Actual_Effort__c = 0;
       }
       
     }   
  }  
  update requests;
  
}


Public class Request{
Public boolean isselected{get; set;}
Public ART_Request__c Request{get; set;}
public Request(ART_Request__C r){
  Request = r;
  isselected = false;
}
}

}