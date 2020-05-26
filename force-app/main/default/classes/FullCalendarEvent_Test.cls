//@istest(SeeAllData=true)
@istest
public class FullCalendarEvent_Test{ 
    
    public static testmethod void test1(){
    Map<String, SObject> initialData = ProjectTrackerTestUtils.initData();
    FullCalendarEvent e = new fullCalendarEvent('TestId', system.now(), system.now(), 'Title', false, 'blue', 'red');
    ART_Project__c project = new ART_Project__c(name='Test');
    insert project;
    Milestone__c m = new Milestone__c(
       Start__c = system.now(),
       End__c = system.now(),
       Actual_Start__c = system.now(),
       Project__c = project.id,
       Actual_End__c = system.now(),
       Name = 'Milestone',
       type__c = 'Other');
     insert m;
     ProjectFullCalendar PFC = new ProjectFullCalendar(new apexpages.standardcontroller(project)); 
     ProjectFullCalendar.getEventsByMilestone(new list<String>{m.id}, new List<String>{'Other'});
   } 
  
  
}