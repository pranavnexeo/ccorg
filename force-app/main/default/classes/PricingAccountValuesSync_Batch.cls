global class PricingAccountValuesSync_Batch implements Database.Batchable<SObject> {

List<Account_Industries__C> industries;
Set<String> indstrings;
List<SAP_Sales_Group_CS__c> sales_groups;
Set<String> sgstrings;
global String q;

// Class Constructor - set query string
global PricingAccountValuesSync_Batch() {
q = 'SELECT SAP_Sales_Org__c, SAP_DivisionCode__c, Ownerid, SAP_Industry_key_Desc__c, SAP_SalesGroup__c, SAP_Sales_group_desc__c FROM Account WHERE type=\'Customer\' and SAP_DistChannel__c = \'30\' and recordtype.name = \'Distribution Customer\'';
}
// "Start" runs when the class in instanciated
global Database.QueryLocator start(Database.BatchableContext bcMain) {

industries = Account_Industries__c.getall().values();
delete industries;
sales_groups = SAP_Sales_Group_CS__c.getall().values();
delete sales_groups;
return Database.getQueryLocator(q);
}

// "Execute" is what is being run as a separate process per batch
global void execute(Database.BatchableContext bcMain, List<Account> lstBatchRecords) {

industries = Account_Industries__c.getall().values();
sales_groups = SAP_Sales_Group_CS__c.getall().values();
indstrings = new Set<String>();
sgstrings = new set<string>();

for(Account_Industries__c ind:industries)
  indstrings.add(ind.name);
for(SAP_Sales_Group_CS__c sg:sales_groups)
  sgstrings.add(sg.name);

List<Account> inboundRecords = lstBatchRecords;
List<Account_Industries__c> RecordsToInsert = new List<Account_Industries__c>();
List<SAP_Sales_Group_CS__c> SGRecordsToInsert = new List<SAP_Sales_Group_CS__c>();

for(Account a : inboundrecords) {        
  if(!indstrings.contains(a.SAP_Industry_key_Desc__c) && a.SAP_Industry_Key_Desc__c != null && a.SAP_Industry_Key_Desc__c != '')
  {
       RecordsToInsert.add(new Account_Industries__c(name = a.SAP_Industry_Key_Desc__c));
       indstrings.add(a.SAP_Industry_key_Desc__c);
  }
  if(!sgstrings.contains(a.SAP_Sales_Group_Desc__c) && a.SAP_Sales_Group_Desc__c != null && a.SAP_Sales_Group_Desc__c != '')
  {
       SGRecordsToInsert.add(new SAP_Sales_Group_CS__c(name = a.SAP_Sales_Group_Desc__c, Sales_Group_Code__c = a.SAP_SalesGroup__c));
       sgstrings.add(a.SAP_Sales_Group_Desc__c);
  }
}
if(RecordsToInsert.size() > 0) { insert RecordsToInsert; }
if(SGRecordsToInsert.size() > 0) { insert SGRecordsToInsert; }
}
// Finish the Batch Job
global void finish(Database.BatchableContext bcMain) {
// Optional - you can send an email to an admin with results
}
}