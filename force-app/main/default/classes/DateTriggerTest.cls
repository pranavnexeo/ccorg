public class DateTriggerTest{
    static testMethod void testDuplicateMonth() {
    Site_Information__c SiteInfoInsert=new Site_Information__c(Name='Corporate Incident-New Corporate Incident');
    insert SiteInfoInsert;
    Incident_Record__c IncidentInsert=new Incident_Record__c(Incident_Date__c=Datetime.now(),Nexeo_Location_Associated_with_incident__c=SiteInfoInsert.id);      
      try {
         insert IncidentInsert;         
      } catch (DmlException e) { }
    Incident_Record__c IncidentUpdate=new Incident_Record__c(Id=IncidentInsert.id,Incident_Date_Copy__c=IncidentInsert.Incident_Date__c.date(),Nexeo_Location_Associated_with_incident__c=SiteInfoInsert.id);      
      try {
         update IncidentUpdate;         
      } catch (DmlException e) { }  
   }
}