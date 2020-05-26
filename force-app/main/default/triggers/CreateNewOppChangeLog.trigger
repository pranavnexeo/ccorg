trigger CreateNewOppChangeLog on Opportunity (after update) {

   List<Opportunity_Change_Log__c> ocl = new List<Opportunity_Change_Log__c>();
   List<Opportunity> oppStageChanged = new List<Opportunity>();  
   Map<Id, Date> stageChange = new Map<Id, Date>();

   for (Opportunity newOpp : Trigger.new)  {

      Opportunity oldOpp = Trigger.oldMap.get(newOpp.Id);

      // If no change was made to the Stage and Amount field, do not create a Opportunity Change Log
      if ((newOpp.StageName == oldOpp.StageName) && (newOpp.Amount == oldOpp.Amount))
         continue;

      Opportunity_Change_Log__c newOCL = new Opportunity_Change_Log__c();

      // Update the fields of the OCL record with the values from the Opportunity
      newOCL.Opportunity__c = newOpp.Id;
      newOCL.Account__c = newOpp.AccountId;
      newOCL.Opportunity_Modified_Date__c = System.Now();
      newOCL.Opportunity_Modified_By__c = newOpp.LastModifiedById;
      newOCL.Close_Date__c = newOpp.CloseDate;
      if (newOpp.StageName != oldOpp.StageName)  {
         newOCL.Stage_Change__c = true;
         newOCL.Previous_Stage__c = oldOpp.StageName;
         newOCL.New_Stage__c = newOpp.StageName;
         DateTime t = newOpp.CreatedDate;
         Date d = Date.newInstance(t.year(), t.month(), t.day());
         stageChange.put(newOpp.Id, d);
         oppStageChanged.add(newOpp);
      }
      if (newOpp.Amount != oldOpp.Amount)  {
         newOCL.Previous_Amount__c = oldOpp.Amount;
         newOCL.New_Amount__c = newOpp.Amount;
         newOCL.Amount_Change__c = true;
      }
        
      ocl.add(newOCL);
   }

   // If there are Opportunities where the Stage has changed, work out how many days have passed since the last Stage change
   if(!oppStageChanged.isEmpty())  {
      for(Opportunity_Change_Log__c ocls : [SELECT Id, Opportunity__c, CreatedDate FROM Opportunity_Change_Log__c WHERE Opportunity__c IN :oppStageChanged AND Stage_Change__c = true])  {
         Date stageChangeDate = stageChange.get(ocls.Opportunity__c);
         DateTime t = ocls.CreatedDate;
         Date oclCreatedDate = Date.newInstance(t.year(), t.month(), t.day());
         if(oclCreatedDate > stageChangeDate) {
            stageChange.remove(ocls.Opportunity__c);
            stageChange.put(ocls.Opportunity__c, oclCreatedDate);               
         }
      }
      
      for (Opportunity_Change_Log__c o : ocl)  {
         if (o.Stage_Change__c)  {
            Date today = System.Today();
            Date stageChangeDate = stageChange.get(o.Opportunity__c);
            Double days_in_between = stageChangeDate.daysBetween(today);
            o.Stage_Duration__c = days_in_between;
         }
      }
   }

   if(!ocl.isEmpty())
      insert(ocl);   
}