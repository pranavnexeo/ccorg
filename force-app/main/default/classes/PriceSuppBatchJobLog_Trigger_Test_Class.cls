@isTest
private class  PriceSuppBatchJobLog_Trigger_Test_Class  {

//******************
//Test Method 
//******************
static testMethod void UnitTestForupdate()
{

SAP_Price_Support__c sp = new SAP_Price_Support__c(Agreement_Number__c = '0039943564',Effective_Date__c=system.today());
insert sp ;
   
Price_Support_Batch_Job_Log__c ta = new Price_Support_Batch_Job_Log__c(Launch_batch_job__c = true);
insert ta ;

Test.StartTest();
  PriceSupport_Indicator obj = new PriceSupport_Indicator(0,true,'');
  ID batchprocessid = Database.executeBatch(obj,1 );
  Test.StopTest();
}

//The End
}