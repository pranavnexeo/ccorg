trigger callPriceSupport_Indicator on Price_Support_Batch_Job_Log__c (before insert) {
  
    Set<String> closedStatuses = new set<String>{'Aborted', 'Completed', 'Failed'};
    
    List<AsyncApexJob> jobs = [select id, ApexClass.Name from AsyncApexJob where ApexClass.Name = 'PriceSupport_Indicator' and (NOT Status IN :closedStatuses)];
    
    if(trigger.isInsert){
        boolean runjob = false;
        for(Price_Support_Batch_Job_Log__c psbatch : trigger.new)
        {
            if(psbatch.Launch_batch_job__c == true && jobs.isempty())
            {
                runjob = true;           
            }
        }
        
        string id = '';
        if(runjob == true)
        {
          PriceSupport_Indicator a = new PriceSupport_Indicator(0,true,'');
          id = database.executebatch(a,1);
          for(Price_Support_Batch_Job_Log__c psbatch : trigger.new)
        {
            if(runjob == true)
            {
                psbatch.SFDC_Batch_Job_Id__c = id;       
            }
        }
        } 
    }    
}