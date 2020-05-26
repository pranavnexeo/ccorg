public with sharing class CallReportNotes{

    public Id oppId;

    // *Constructor*
    //Instead of fetching Id from URL, use StandardController. No Hardcoding.
    public CallReportNotes(ApexPages.StandardController stdController){        
     oppId = (Id)stdController.getRecord().get('Opportunity__c');
    }

   
   //Method to display Supplier Contact picklist values. 
   public List<SelectOption> getSupplierContact(){
         List<SelectOption> options = new List<SelectOption>();
         //Use List instead of sObject to assign values.
         List<Opportunity> opp = [Select Requested_Supplier__c from Opportunity where Id = :oppId limit 1];
         //Use soql for loop for optimization.
         for(Supplier_Contact__c sc: [Select Id, First_Name__c, Last_Name__c from Supplier_Contact__c where Competitor_Supplier_or_OEM__c = :opp[0].Requested_Supplier__c order by Last_Name__c limit 1000])
            options.add(new selectoption(sc.Id,(sc.First_Name__c+' '+sc.Last_Name__c))); 
       
       return options;
      
     }
}