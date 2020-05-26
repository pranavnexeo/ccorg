@isTest
private class UpdateOppTriggerTest
{

static TestMethod void TestAfterInsert()
{
Map<String, SObject> testData = NexeoTestUtils_Test.initData();    
//profile p= [select id from profile where name='AD-Purchasing'];
Test.StartTest();
Account acct = new Account(name='TestAccount',SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Vendor',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA');
insert acct; 
try{
Opportunity opp= new Opportunity(Country__c='Canada',Name='12345',StageName='close-won',CloseDate=system.today());
insert opp;
Consumption__c consm= new Consumption__c(Agent_Area__c='ohio',Industry__c='test',Lead_Source__c='test',Price__c=1098.234,Account_Name__c=acct.id,RelatedOpportunity__c=opp.id);
insert consm;
List<String> idList = new List<String>();
idlist.add(consm.RelatedOpportunity__c);
List<Opportunity> oppList = new List<Opportunity>() ;
opplist.add(opp);
opp.Country__c='US';

update opp;
}
catch(exception e){}
Test.StopTest();
}
}