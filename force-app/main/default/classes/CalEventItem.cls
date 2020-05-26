public class CalEventItem {
    public sobject ev;
    public datetime dt;
    public String datefield;
    public string subject;
    public string FormatedDate;
    public String objname;
    public boolean rendered{get; set;}
    
    public CalEventItem(sobject e, String d, String s, string o) { 
        ev= e;
        datefield = d;
        dt = DateTime.valueOf(e.get(d)+' 00:01:01');
        if(o == 'Sales Call (Event)'){
        formatedDate =
        datetime.valueOf(e.get('startdatetime')).format('EEE, MMM d') + ' @ ' +
        datetime.valueOf(e.get('startdatetime')).format('h:mm a') + ' To ' +
        datetime.valueOf(e.get('enddatetime')).format('EEE, MMM d') + ' ' +
        datetime.valueof(e.get('enddatetime')).format('h:mm a');
        }else{ 
        formatedDate = dt.format('h:mm a');
        }
        subject = (string)e.get(s);
        objname = o;
        rendered = true;
    }
    
    public CalEventItem(sobject e, date d, string df, string s, string o){
        ev= e;
        datefield = df;
        dt = DateTime.valueOf(d +' 00:01:01'); 
        if(o == 'Sales Call (Event)'){
        formatedDate =
        datetime.valueOf(e.get('startdatetime')).format('EEE, MMM d') + ' ' +
        datetime.valueOf(e.get('startdatetime')).format('h:mm a') + ' To ' +
        datetime.valueOf(e.get('enddatetime')).format('EEE, MMM d') + ' ' +
        datetime.valueof(e.get('enddatetime')).format('h:mm a');
        }else{
        formatedDate = dt.format('h:mm a');}
        subject = (string)e.get(s);
        objname = o;
        rendered = true;
    }
    public sobject getEv() { return ev; }
    public String getFormatedDate() { return formatedDate; }
    public String getsubject(){ return subject; }
    public datetime getdt(){ return dt; }
    public String getobjname(){ return objname; }
    
}