global class SchAccountSearchTerm implements schedulable
{

global void execute(SchedulableContext sc){
    //Batch class for updating accounts search term field
    Update_AccntSearchTerm b = new Update_AccntSearchTerm(); 
    database.executebatch(b);
} 

static testmethod void SchAccountSearchTerm() {
   Test.startTest();
   String sch = '0 10 * * * ?';
   // Schedule the test job  
      String jobId = System.schedule('testBasicScheduledApex',sch ,new SchAccountSearchTerm());
   // Get the information from the CronTrigger API object  
      CronTrigger ct = [SELECT id, CronExpression, TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :jobId];
    // Verify the expressions are the same  
      System.assertEquals(sch,ct.CronExpression);
    // Verify the job has not run  
      System.assertEquals(0, ct.TimesTriggered);
    // Verify the next time the job will run  
    Test.stopTest();
}
    
}