@isTest
Private class eventdeletelogTest {

    public static testMethod void testbeforedlete() {
    Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
    Account testAcct = new Account(Name='TestAccount');
        insert testAcct;
        
    Event testEvent = new Event();
        testEvent.Whatid = testAcct.Id;
        testEvent.Type = 'Email';
        //testEvent.recordType='Nexeo Sales Call';
        testEvent.Total_Hours__c = 1;
        testEvent.DurationInMinutes = 59;
        testEvent.ActivityDateTime = DateTime.newInstance(System.today().year(),System.today().month(),System.today().day(), 0, 0, 0);
        testEvent.StartDateTime = DateTime.newInstance(System.today().year(),System.today().month(),System.today().day(), 0, 0, 0);
        testEvent.EndDateTime = DateTime.newInstance(System.today().year(),System.today().month(),System.today().day(), 0, 59, 0);
        testEvent.Description = 'Test';
        insert testEvent;
        
        Delete testEvent;
        
        
        //private static void testInsertAuditLogs() {
       List<Audit_Log__C> logs = new LIst<Audit_Log__c>(); 
       
       String objectName = 'Event';
       String recordType = 'Nexeo Sales Call';
       String objectId   = 'testEvent.id';
       String auditNote2 = 'Deleted';
      //Audit_Log__c a1 = createLogForDeleted(objectName, recordType, objectId, auditNote2);
     Audit_Log__c log = new Audit_Log__c(object_id__c = testEvent.id,
           object_name__C = 'Event',
           record_type__c = testEvent.recordtypeid,
           audit_note1__c = 'Deleted' );
     logs.add(log);
     
     insert logs;
    //} 
        
    }
    

}