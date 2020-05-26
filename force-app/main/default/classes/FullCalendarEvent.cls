public class FullCalendarEvent{

public string start{get; set;}
public string end_x{Get; set;}
public string title{get; set;}
public boolean allDay{get; set;}
public boolean editable{get; set;}
public string id{Get; set;}
public string color{get ;set;}
public string textColor{get ;set;}

public FullCalendarEvent(string id, datetime startdate, datetime enddate, string title, boolean allday, string color, string textColor){
   
   string startmonth = '';
   string startday = '';
   string endmonth = '';
   string endday = '';
   
   if(startdate.month() < 10)
     startmonth = '0' + startdate.month();
   else
     startmonth = string.valueof(startdate.month());
   
   if(startdate.day() < 10)
     startday = '0' + startdate.day();
   else
     startday = string.valueof(startdate.day());
     
   if(enddate.month() < 10)
     endmonth = '0' + enddate.month();
   else
     endmonth = string.valueof(enddate.month());
   
   if(enddate.day() < 10)
     endday = '0' + enddate.day();
   else
     endday = string.valueof(enddate.day());
     
     
   
   start = startdate.year() + '-' + startmonth + '-' + startday;
   end_x = enddate.year() + '-' + endmonth + '-' + endday;
   this.title = title;
   this.allday = allday;
   this.editable = false;
   this.id = id;
   this.color = color;
   this.textcolor = textcolor;
}



}