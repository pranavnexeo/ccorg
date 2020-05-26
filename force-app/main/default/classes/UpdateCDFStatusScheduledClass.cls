global class UpdateCDFStatusScheduledClass Implements Schedulable

{
global void execute(SchedulableContext sc)
{
  UpdateCDFStatus();
}

public void UpdateCDFStatus()

{
    //List to store all CDF records 
    List<contract> AllCDF = new List<contract>();
    // Set to hold the ID of the CDFs
    Set<ID> CDFId = new Set<ID>();
    //public RankingUpdateForAccount(){
    System.debug('calling my method');
       //Query contract object for records about to expire 
        for (contract R : [select id,status,EndDate,ContractTerm from contract where EndDate <=: System.TODAY() and status =: 'Activated' LIMIT 1000]) {
            if(!CDFId.contains(R.id)){
                contract cdf = new contract(ID = R.id);
                cdf.Status = 'Expired';
                AllCDF.add(cdf);
                System.debug('accounts updated '+AllCDF.size());
                CDFId.add(R.id); 
                System.debug('accounts ID '+CDFId);
}
}
        System.debug('All accounts updated '+AllCDF.size());
   update AllCDF;
  //}               
}
//Test method for schedule class  
static testmethod void test() {
   Test.startTest();
   String sch = '0 10 * * * ?';
   // Schedule the test job  
      String jobId = System.schedule('testBasicScheduledApex',sch ,new UpdateCDFStatusScheduledClass());
   // Get the information from the CronTrigger API object  
      CronTrigger ct = [SELECT id, CronExpression, TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :jobId];
    // Verify the expressions are the same  
      System.assertEquals(sch,ct.CronExpression);
    // Verify the job has not run  
      System.assertEquals(0, ct.TimesTriggered);
    // Verify the next time the job will run  
    Test.stopTest();
} 
/*//test method
   static testMethod void UpdateCDFStatus(){
        //List to store all CDF records 
    List<contract> AllCDF = new List<contract>();
    // Set to hold the ID of the CDFs
    Set<ID> CDFId = new Set<ID>();
    Account acc = new Account (Name = 'Account for Ranking');
       insert acc;
       //Query contract object for records about to expire 
        for (contract R : [select id,status,EndDate,ContractTerm from contract where EndDate <=: System.TODAY() and status =: 'Activated' LIMIT 1000]) {
            if(!CDFId.contains(R.id)){
                contract cdf = new contract(ID = R.id);
                cdf.Status = 'Expired';
                AllCDF.add(cdf);
                CDFId.add(R.id); 
}
}
   update AllCDF;
   }*/
}