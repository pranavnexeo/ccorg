public class SCPR_Open_Activity {

    /* Properties of the class */
    public id       TaskId                 { get; private set; }
    public date     ActivityDate           { get; private set; }
    public string   ActivityDate_Formatted { get; private set; }
    public id       AssignedToId           { get; private set; }
    public string   AssignedToName         { get; private set; }
    public string   subject                { get; private set; }
    public string   comments               { get; private set; }
    public id       WhoId                  { get; private set; }
    public string   Name                   { get; private set; }
    public id       WhatId                 { get; private set; }
    public string   RelatedTo              { get; private set; }
    public string   Status              { get; private set; }
    
    /* Class constructor */
    public SCPR_Open_Activity(id tId, date d, id owner, string ownerName, string s, String c, id wId, string wName, id whId, string whName,String St) {
        TaskId         = tId;
        ActivityDate   = d;
        AssignedToId   = owner;
        AssignedToName = ownerName;
        subject        = s;
        comments       = c;
        WhoId          = wId;
        Name           = wName;
        WhatId         = whId;
        RelatedTo      = whName;
        Status         = st;
        
        if (ActivityDate != null) {
            ActivityDate_Formatted = DateTime.newInstance(ActivityDate.year(),ActivityDate.month(),ActivityDate.day(), 0, 0, 0).format('MMMMM d yyyy');
            }
    }
    
    /* Formatting methods utilized primarily by the CaseHistoryPrint Visualforce page*/
    public integer dtmonth    { get { return ActivityDate.month();} }
    public integer dtyear     { get { return ActivityDate.year();} }
    public integer dtday      { get { return ActivityDate.day();} }
//    public string  localdt    { get { return DateTime.newInstance(ActivityDate.year(),ActivityDate.month(),ActivityDate.day(), 0, 0, 0).format('MMMMM d yyyy');} }
        
}