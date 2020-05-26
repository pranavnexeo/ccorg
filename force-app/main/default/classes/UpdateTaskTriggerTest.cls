@isTest
private class UpdateTaskTriggerTest
{
static TestMethod void TestAfterInsert()
{
Map<String, SObject> testData = NexeoTestUtils_Test.initData();
profile p= [select id from profile where name='AD-Sales Representative Plastics EMEA / China'];
Account acct = new Account(name='TestAccount',SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Vendor',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA');
insert acct; 
Opportunity opp= new Opportunity(Country__c='Canada',Name='12345',StageName='close-won',CloseDate=system.today());
insert opp;
Task t= new Task (CallObject='test',Status='test',whatID=opp.id);
insert t;
List<String> idList = new List<String>();
idlist.add(t.Whatid);
List<Opportunity> oppList = new List<Opportunity>() ;
opplist.add(opp);
opp.Country__c='US';
update opp;
}
}