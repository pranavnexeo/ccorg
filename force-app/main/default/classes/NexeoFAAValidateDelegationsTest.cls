@isTest
private class NexeoFAAValidateDelegationsTest {

    static testMethod void myUnitTest() {   
         
         FAA_Request__c FAARequest = new FAA_Request__c();
         FAARequest.Request_Status__c='Approved';
         //FAARequest.Agent_Name__c='005E0000000YxhD';
         FAARequest.Agent_Redelegate__c='Yes';
         //FAARequest.Delegator_Name__c='005E0000000ZG55';
         FAARequest.Delegator_Status_Date__c=Date.today();
         FAARequest.Treasury_Applied_Date__c=Date.today();          
         try {
           insert FAARequest;
         }catch (DmlException e){
            return;
         }
         
         
         Category_Limit__c  CategoryLimit=new Category_Limit__c (Category__c = 'Payroll',Desired_US_Dollar_Limit__c=120.000,Current_US_Dollar_Limit__c=120.000,FAA_Request__c=FAARequest.id);                
         try {
           insert CategoryLimit;
         }catch (DmlException e){
            return;
         }
                  
          Category_Master__c CategoryMaster=new Category_Master__c(CategoryDesc__c='Payroll',EmpId__c='c893984',Limit__c=120.00);

         try {        
           insert CategoryMaster; 
         }catch (DmlException e){
            return;
         }
         
     	 Category_Limit__c  CategoryLimit1=new Category_Limit__c (Category__c = 'Payroll',Desired_US_Dollar_Limit__c=120.000,Current_US_Dollar_Limit__c=1200.000,FAA_Request__c=FAARequest.id);                
         try {
           insert CategoryLimit1;
         }catch (DmlException e){
            return;
         }
         
    }
}