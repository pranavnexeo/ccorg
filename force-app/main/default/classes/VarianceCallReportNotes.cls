public with sharing class VarianceCallReportNotes{

    public Id varId;
   
    public VarianceCallReportNotes(ApexPages.StandardController stdController){        
     varId = (Id)stdController.getRecord().get('Sales_Variance__c');
    
    }
   
      public List<SelectOption> getSupplierContact(){
         List<SelectOption> options = new List<SelectOption>();
       
         List<SalesChurn__c> opp = [Select Requested_Supplier__c from SalesChurn__c where Id = :varId limit 1];
         for(Supplier_Contact__c sc: [Select Id, First_Name__c, Last_Name__c from Supplier_Contact__c where Competitor_Supplier_or_OEM__c = :opp[0].Requested_Supplier__c order by Last_Name__c limit 1000])
            options.add(new selectoption(sc.Id,(sc.First_Name__c+' '+sc.Last_Name__c))); 
       
       return options;  
        
        
     }
}