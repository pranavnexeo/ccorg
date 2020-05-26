public class CalendarComponent{


public Calendar Calendar{get; set;}
public String DisplayDate{get; set;}
public List<CalEventItem> LongList{get; set;}
List<CalEventItem> itemslist;
public boolean displayLongList{get; set;}
public integer multi{get; set;}
public boolean displaycreateevent{get; set;}
public event event{get; set;}
public String relatedTo{get; set;}
public boolean renderoptions{get; set;}


public CalendarComponent(){
itemslist = new list<CalEventItem>();
LongList = new List<CalEventItem>();
displaylonglist = false;
displaycreateevent = false;
event = new event();
}


public List<CalEventitem> getsobj(){ return itemslist; }
public void setsobj(List<CalEventItem> s) { 
  if(itemslist != null){
     itemslist = s;
  }  
  if(Calendar == null && itemslist != null){
    Calendar = new Calendar(itemslist);
    if(multi != null){
    Calendar.months = multi;
    }
  }
}

public void showmore(){ 

DisplayLongList = true;
For(CalMonth m:Calendar.getmultimonth()){
For(CalMonth.Week w:m.getweeks()){
  For(CalMonth.Day d: w.days){
    if(d.thedate.format() == displaydate){
      LongList = d.EventsTodayLong;
    }
  }
 }
}
}

public void showless(){
DisplayLongList = false;
LongList = new List<CalEventItem>();
}

public void hideevent(){
Displaycreateevent = false;
}

public void showevent(){
event = new event();
event.startdatetime = DateTime.parse(displaydate +' 7:00 AM');
event.enddatetime = DateTime.parse(displaydate + ' 8:00 AM');
event.ownerid = userinfo.getuserid();
if(relatedTo != null){ event.whatid = relatedTo; }
Displaycreateevent = true;

}

public pagereference saveevent(){

Displaycreateevent = false;

insert event;
CalEventItem c = new calEventItem(event, 'startdatetime', 'Subject', 'Event');
For(CalMonth m:Calendar.getmultimonth()){
For(CalMonth.Week w:m.getweeks()){
  For(CalMonth.Day d: w.days){
    if(d.thedate.format() == displaydate){
      d.eventstodayshort.add(C);
      d.eventstodaylong.add(c);
      Calendar.all_items.add(c);
    }
  }
 }
}
return null;
}

public void showoptions(){
  renderoptions = true;
}

public pagereference saveoptions(){
  Calendar.editoptions();
  renderoptions = false;
  return null;
}


}