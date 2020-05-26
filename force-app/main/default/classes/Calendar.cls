public class Calendar {
 
  public integer months{ get; set; }
  Public List<CalEventItem> all_items{get; set;}
  Private List<CalEventItem> this_months_items{get; set;}
  Private String DateField{get; set;}
  Private String Subject{get; set;}
  public CalMonth month;
  Public List<CalendarOption> CalendarOptions{get; set;}

  public Calendar(List<CalEventItem> items) {
 
   Date d = system.today();  // default to today 
   Integer mo = d.month(); 
   String m_param = System.currentPageReference().getParameters().get('mo');
   String y_param = System.currentPageReference().getParameters().get('yr');
   String multi_m = System.currentPageReference().getParameters().get('multi');
      
   // allow a month to be passed in on the url as mo=10
   if (m_param != null) { 
        Integer mi = Integer.valueOf(m_param); 
        if (mi > 0 && mi <= 12) {
          d = Date.newInstance(d.year(),mi,d.day());
        }
   }
   // and year as yr=2008
   if (y_param != null) { 
        Integer yr = Integer.valueOf(y_param); 
        d = Date.newInstance(yr, d.month(), d.day());
   }
   
   if (multi_m != null) { 
       months = Integer.valueOf(multi_m);     
        if (months < 0 || months > 12) {
          months = 1;
        }
   } else {months = 1; }
   
   this_months_items = new list<CalEventItem>();
   this.all_items = items;
    
   datetime startdatetime = system.now() - 180;
   datetime enddatetime = system.now() + 180;
   for(event e:[select id, subject, startdatetime, enddatetime from event where ownerid = :userinfo.getuserid() and startdatetime > :startdatetime and startdatetime < :enddatetime LIMIT 1000]){
     
     date s = e.startdatetime.date();
     date ed = e.enddatetime.date();
     integer diff = s.daysbetween(ed);
     system.debug(e.id);
     system.debug(s);
     system.debug(ed);
     system.debug('Days Between: ' + diff);
     if(diff > 0){
       for(integer i = 0; i<=diff; i++){
         date datein = s.adddays(i);
         system.debug('Datein: ' + datein);
         this.all_items.add(new CalEventItem(e, datein , 'startdatetime', 'subject', 'Sales Call (Event)'));
       }
     } else{   
         this.all_items.add(new CalEventItem(e, 'startdatetime', 'subject', 'Sales Call (Event)'));
     }
   }
   
   CalendarOptions = new List<CalendarOption>();
   Set<String> OptionSet = new Set<String>();
   for(CalEventItem i:all_items){
      if(!OptionSet.contains(i.objname)){
        CalendarOptions.add(new CalendarOption(i.objname));
        OptionSet.add(i.objName);
      }
   }
   
   setMonth(d);
  }
 
  public List<CalMonth.Week> getWeeks() { 
    system.assert(month!=null,'month is null');
    return month.getWeeks();
  }
  
  public CalMonth getMonth() { return month; } 

  public List<CalMonth> getmultimonth() { 
  
   List<CalMonth> retlist = new list<Calmonth>();
   CalMonth m = month;
   retlist.add(month);
   for(integer i = 2; i <= months; i++){
     addmonth(1);
     retlist.add(month);
   }
   month = m;
   system.debug('retlist: ' + retlist.size());
   return retlist; 
  }
  
  public void next() { 
    addMonth(months);
  }

  public void prev() { 
    addMonth(-months); 
  }

  private void setMonth(Date d) { 
    month = new CalMonth(d);  
    system.assert(month != null); 
    Date[] da = month.getValidDateRange();  // gather events that fall in this month
    this_months_items.clear();
    
    for(CalEventItem ei:all_items){      
       if(ei.dt.date() >= da[0] && ei.dt.date() <= da[1]){
        this_months_items.add(ei);
       }
    }
    month.setEvents(this_months_items);  // merge those events into the month class

  }
  
  public date getstartdate(){ 
    Date[] da = month.getValidDateRange();
    return da[0];
  }

  public date getenddate(){
    Date[] da = month.getValidDateRange();
    return da[1];
  }
   
  public void addMonth(Integer val) { 
    Date d = month.getFirstDate();
    d = d.addMonths(val);
    setMonth(d);
  }
  
  public pagereference editoptions(){
   for(CalendarOption option:CalendarOptions){
    For(CalMonth m:getmultimonth()){
     For(CalMonth.Week w:m.getweeks()){
       For(CalMonth.Day d: w.days){
         d.eventstodayshort.clear();
         for(CalEventItem i:d.eventstodaylong){
           if(i.objname == option.option){
             i.rendered = option.render;
           }
           if(i.rendered == true && d.eventstodayshort.size() < 2){
             d.eventstodayshort.add(i);
           }                 
         }
        }
       }
      }
     }
     return null;
   }
  
  public class calendaroption{
    public boolean render{get; set;}
    public String Option{get; set;}
    public calendaroption(String name){
       render = true;
       Option = name;
    }
  }
      

}