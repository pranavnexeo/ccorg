@isTest
private class VarianceCallReportNotes_test{
    static testMethod void VarianceCallReportNotes_TestMethod() 
    {
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
    User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
    insert u;
    account acc = new account(name = 'test1234');
    insert acc;
    contact cnt = new contact(LastName = 'test',Account = acc,phone= '1234567890',Role__c = 'Accounting',No_Email__c = true);
    insert cnt;
    //Nexeo_Competitor__c nc = new Nexeo_Competitor__c(name = 'test',Status__c='Active',RecordTypeid='012E0000000LH70');
    Id RecordTypeId = Schema.SObjectType.Nexeo_Competitor__c.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
    Nexeo_Competitor__c nc = new Nexeo_Competitor__c(name = 'test',Status__c='Active',RecordTypeid=RecordTypeId);
    insert nc;
    opportunity op = new opportunity(name = 'Distribution Plastics',CurrencyIsoCode = 'AUD',Customer_Prospect__c = acc.id,Contact__c = cnt.id,CloseDate = system.today(),StageName = 'Concept');
    insert op;
    SalesChurn__c sc = new SalesChurn__c(Account_Number__c = acc.id,ChurnOpportunity__c = op.id);
    insert sc;
    Supplier_Contact__c scon = new Supplier_Contact__c(First_Name__c = 'test',Last_Name__c ='test1',Competitor_Supplier_or_OEM__c = nc.id);
    insert scon;
    Variance_Call_Report__c vcr = new Variance_Call_Report__c(Sales_Variance__c = sc.id,Supplier_Contact__c = scon.id,Employee__c = u.id);
    insert vcr;
    
    List<SalesChurn__c> sclist = new List<SalesChurn__c>();
    //sclist.add
    
    
    ApexPages.standardcontroller stdController = new ApexPages.standardcontroller(vcr);
    VarianceCallReportNotes vcrn = new VarianceCallReportNotes(stdController);
    vcrn.getSupplierContact();
    
    }
    
}