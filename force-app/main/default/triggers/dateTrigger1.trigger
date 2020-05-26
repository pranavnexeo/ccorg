trigger dateTrigger1 on Incident_Record__c(before insert, before update)
{
If (trigger.isinsert)
{
    for (Incident_Record__c t : Trigger.New){
if(t.Incident_Date__c != null){
t.Incident_Date_Copy__c   = t.Incident_Date__c.date();
}
}
}
If (trigger.isupdate)
{
    for (Incident_Record__c t : Trigger.New){
if(t.Incident_Date__c != null  &&  t.Incident_Date_Copy__c!= t.Incident_Date__c.date())
{
t.Incident_Date_Copy__c   = t.Incident_Date__c.date();
}
}
}
}