public class ProjectCalendar{

public Calendar Calendar{get; set;}
public List<CalEventItem> items{get; set;}

public ProjectCalendar(ApexPages.standardcontroller sc){
items = new list<CalEventItem>();
Art_Project__c p = (ART_Project__c)sc.getrecord();
for(milestone__c m:[ select id, name, due_date__c, subject__c, createddate from milestone__c where (project__c = :p.id or project__r.parent_project__c = :p.id or project__r.parent_project__r.parent_project__c = :p.id)]){
  items.add(new CalEventItem(m, 'Due_Date__c', 'Subject__c', 'MileStone'));
}


for(Art_Project__c proj:[select id, name, target_date_for_completion__c from ART_Project__c where (id = :p.id or parent_Project__c = :p.id or parent_project__r.parent_project__c = :p.id) and target_date_for_completion__c != null]){
  items.add(new calEventItem(proj, 'target_date_for_completion__c', 'name', 'Project'));
}

Set<id> releaseids = new set<id>();
for(Art_Request__c req:[select id, name, target_date_for_release__c, release__c from ART_Request__c where (project__c = :p.id or project__r.parent_Project__c = :p.id or project__r.parent_project__r.parent_project__c = :p.id) and target_date_for_release__c != null]){
  items.add(new calEventItem(req, 'target_date_for_release__c', 'name', 'Request'));
  if(req.id != null){ releaseids.add(req.release__c); }
}

for(Art_Request__c emergencyreq:[select id, name, emergency_release_date__c, release__c from ART_Request__c where (project__c = :p.id or project__r.parent_Project__c = :p.id or project__r.parent_project__r.parent_project__c = :p.id) and emergency_release_date__c != null]){
  items.add(new calEventItem(emergencyreq, 'emergency_release_Date__c', 'name', 'Request'));
  if(emergencyreq.id != null) { releaseids.add(emergencyreq.release__c); }
}

for(Art_Release__c rel:[select id, name, sfdc_release_date__c from ART_Release__c where id IN :releaseids and sfdc_release_date__c != null]){
  items.add(new calEventItem(rel, 'sfdc_release_date__c', 'name', 'Release'));
}

}
}