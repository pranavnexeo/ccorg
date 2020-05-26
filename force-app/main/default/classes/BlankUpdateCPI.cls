global class BlankUpdateCPI implements Database.Batchable<sObject> {
  
   global Database.QueryLocator start(Database.BatchableContext BC){  
       Set<String> divisions=new Set<String>();
       divisions.add('31');
       divisions.add('32');
   	String query='select id from Customer_Product_info__c WHERE CPI_Account__c = \'\' AND CPI_Record_Type__c = \'1\' AND Deletion_Indicator__c != \'X\' and SAP_Material__r.Division_Code__c in:divisions';
	
	return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<sObject> CPItoUpdate){
      update CPIToUpdate;      
   }

   global void finish(Database.BatchableContext BC){
   }
}