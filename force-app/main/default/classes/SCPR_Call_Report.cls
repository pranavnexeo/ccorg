public class SCPR_Call_Report {

    /* Properties of the class */
    public id       callReportId             { get; private set; }
    public id       callReportCreatedById    { get; private set; }
    public string   callReportCreatedByName  { get; private set; }
    public datetime callReportDate           { get; private set; }
    public string   callReportDate_Formatted { get; private set; }
    public string   subject                  { get; private set; }
    public string   comments                 { get; private set; }
    public string   discussion                 { get; private set; }
    
    /* Class constructor */
    public SCPR_Call_Report(Id cId, Id oId, string oName, datetime d, string s, String c,String dis) {
        callReportId            = cId;
        callReportCreatedById   = oId;
        callReportCreatedByName = oName;
        callReportDate          = d;
        subject                 = s;
        comments                = c;
        discussion              = dis;

        if (callReportDate != null) 
            {callReportDate_Formatted = callReportDate.format('MMMMM d yyyy');}
    }


    public SCPR_Call_Report(Id cId, Id oId, string oName, datetime d, string s, String c) {
        callReportId            = cId;
        callReportCreatedById   = oId;
        callReportCreatedByName = oName;
        callReportDate          = d;
        subject                 = s;
        comments                = c;

        if (callReportDate != null) 
            {callReportDate_Formatted = callReportDate.format('MMMMM d yyyy');}
    }    
    /* Formatting methods utilized primarily by the CaseHistoryPrint Visualforce page*/
    public string dtmonthyr   { get { return callReportDate.format('MMMMM yyyy'); } }
    public string dttime      { get { return callReportDate.format('h:mm a');} }
    public string dtdayfmt    { get { return callReportDate.format('d - EEEE'); } }
//    public string  localdt    { get { return callReportDate.format('MMMMM d yyyy'); } }
    public integer dtmonth    { get { return callReportDate.month();} }
    public integer dtyear     { get { return callReportDate.year();} }
    public integer dtday      { get { return callReportDate.day();} }

}