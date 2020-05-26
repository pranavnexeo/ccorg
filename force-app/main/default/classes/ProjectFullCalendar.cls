public class ProjectFullCalendar{

public string JSONString{get; set;}
public List<sObject> objs{Get; set;}
public boolean includeothers{Get; set;}

public ProjectFullCalendar(apexpages.standardcontroller sc){
   
 
   objs = new List<sobject>{sc.getrecord()};
   JSONString = init(objs, new List<String>{'Other', 'Testing', 'Training', 'Go-Live'});
}
public ProjectFullCalendar(apexpages.standardsetcontroller ssc){

   objs = new List<sobject>();
   integer pagenumber = 1;
   
   do{
      objs.addall(ssc.getrecords());
      if(ssc.gethasnext() == true)
        ssc.next();
   }while(ssc.gethasnext() == true);
   system.debug('size: ' + ssc.getresultsize());
   JSONString = init(objs, new List<String>{'Testing', 'Training', 'Go-Live'});
}

@RemoteAction
public static string init(List<sObject> objs, List<String> types){
   List<eventColor> colorList = new List<eventColor>{
      new eventColor('#378006', 'white'),
      new eventColor('#38595E', 'white'),
      new eventcolor('#000080', 'white'),
      new eventcolor('#C0C0C0', 'black'),
      new eventColor('#F4733D', '#38595E') 
   };
   
   List<string> recordids = new List<String>();
   for(sObject s:objs)
     recordids.add(s.id);
   
   List<FullCalendarEvent> events = new List<FullCalendarEvent>();
   if(objs.size() > 0){
       string objname = objs.get(0).getSObjectType().getDescribe().getName();
       system.debug(objName);
       if(objName == 'ART_Project__c')
         events = getEventsByProject(recordids, types);
       else
         events = getEventsByMilestone(recordids, types);
   
   }
   
   string JSONString = JSON.serialize(events);
   JSONString = JSONString.replaceall('_x', '');
   system.debug('jsonstring: ' + jsonstring);
   return JSONString;
}

@RemoteAction
public static List<FullCalendarEvent> getEventsByMilestone(List<String> objs, List<String> types){
      List<eventColor> colorList = new List<eventColor>{
      new eventColor('#378006', 'white'),
      new eventColor('#38595E', 'white'),
      new eventcolor('#000080', 'white'),
      new eventcolor('#C0C0C0', 'black'),
      new eventColor('#F4733D', '#38595E') 
   };
   
   List<FullCalendarEvent> events = new List<FullCalendarEvent>();
   Map<id, integer> colormap = new map<id, integer>();

   List<Milestone__c> milestones = new List<Milestone__c>();
   milestones = [Select Id, Start__c, End__c,Actual_Start__c,Project__c,Project__r.Name,Actual_End__c,Name from Milestone__c where
    Id IN :objs and start__c != null and end__c != null and type__c IN :types];
   
   system.debug('milestones: ' + milestones.size());
   for(milestone__c m:milestones){
                
                if(!colormap.containskey(m.Project__c))
                   colormap.put(m.Project__c, Math.mod(Math.round(Math.random()*1000), colorlist.size()-1));
                
                integer rand = colormap.get(m.project__c);
                events.add(new FullCalendarEvent(m.id, m.start__c, m.end__c, m.Project__r.Name + ': ' + m.name, true, colorlist.get(rand).color, colorlist.get(rand).textcolor ));     
   }
   return events;
}

@RemoteAction
public static List<FullCalendarEvent> getEventsByProject(List<String> objs, List<String> types){
   
      List<eventColor> colorList = new List<eventColor>{
      new eventColor('#378006', 'white'),
      new eventColor('#00FCF0', 'black'),
      new eventcolor('#000080', 'white'),
      new eventcolor('#C0C0C0', 'black'),
      new eventColor('#F4733D', '#38595E') 
   };
   
   Map<string, integer> typemap = new map<String, Integer>{
     'Testing' => 2,
     'Training' => 1, 
     'Go-Live' => 0,
     'Other' =>3,
     null => 4,
     '' => 4
   };
   List<FullCalendarEvent> events = new List<FullCalendarEvent>();
   Map<id, integer> colormap = new map<id, integer>();

   for(string s:objs){
       colormap.put(s, Math.mod(Math.round(Math.random()*1000), colorlist.size()-1));
   }
   List<Milestone__c> milestones = new List<Milestone__c>();
   system.debug('projects size: ' + objs.size());
   milestones = [Select Id, Start__c, End__c,Actual_Start__c,Project__c,Project__r.Name,Actual_End__c,Name, type__c from Milestone__c where
    Project__c IN :objs and start__c != null and end__c != null and type__c IN :types];

   system.debug('milestones: ' + milestones.size());
   for(milestone__c m:milestones){
                integer rand = colormap.get(m.project__c);
                events.add(new FullCalendarEvent(m.id, m.start__c, m.end__c, m.Project__r.Name + ': ' + m.name, true, colorlist.get(typemap.get(m.type__c)).color, colorlist.get(typemap.get(m.type__c)).textcolor ));     
   }
   return events;
}

public class eventColor{
  public string color{get; set;}
  public string textcolor{get; set;}
  public eventColor(string color, string textcolor){
    this.color = color;
    this.textcolor = textcolor;
  }
}

}