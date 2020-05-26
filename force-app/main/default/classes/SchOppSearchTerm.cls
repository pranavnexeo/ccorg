global class SchOppSearchTerm implements schedulable
{
    global void execute(SchedulableContext sc)
    {
    Update_OppSearchTerm b = new Update_OppSearchTerm(); //ur batch class
      database.executebatch(b);
      //ID batchprocessid = Database.executeBatch(b);
    }

static testmethod void SchOppSearchTerm() {
   Test.startTest();
   String sch = '0 10 * * * ?';
   // Schedule the test job  
      String jobId = System.schedule('testBasicScheduledApex',sch ,new SchOppSearchTerm());
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