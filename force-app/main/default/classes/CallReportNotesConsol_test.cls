@isTest
private class CallReportNotesConsol_test{
    static testMethod void CallReportNotesCons_TestMethod() 
    {
    test.starttest();
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
    User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
    //Map<String, SObject> testData = new Map<String, SObject>(NexeoTestUtils_Test.initData());
   // User u = (User) testData.get('nexeoIntegrationUser'); 
    insert u;
    account acc = new account(name = 'test1234');
    insert acc;
    contact cnt = new contact(LastName = 'test',Account = acc,phone= '1234567890',Role__c = 'Accounting',No_Email__c = true);
    insert cnt;
    
    Id RecordTypeId = Schema.SObjectType.Nexeo_Competitor__c.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
    Nexeo_Competitor__c nc = new Nexeo_Competitor__c(name = 'test',Status__c='Active',RecordTypeid=RecordTypeId);
    insert nc;
    
    opportunity op = new opportunity(name = 'Distribution Plastics',CurrencyIsoCode = 'AUD',Customer_Prospect__c = acc.id,Requested_Supplier__c = nc.id,Contact__c = cnt.id,CloseDate = system.today(),StageName = 'Concept');
    insert op;
    Supplier_Contact__c scon = new Supplier_Contact__c(First_Name__c = 'test',Last_Name__c ='test1',Competitor_Supplier_or_OEM__c = nc.id);
    insert scon;
    Opportunity_Call_Report__c ocr = new Opportunity_Call_Report__c(Opportunity__c = op.id,Supplier_Contact__c = scon.id,Employee__c = u.id, Status_Update__c = 'test');
    insert ocr;
    
    delete ocr;
   test.stoptest();
    
    
    }
    static testMethod void CallReportNotesCons_TestMethod2() 
    {
    test.starttest();
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
    User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
     // Map<String, SObject> testData = new Map<String, SObject>(NexeoTestUtils_Test.initData());
     // User u = (User) testData.get('nexeoIntegrationUser'); 
      insert u;
   
    account acc = new account(name = 'test1234');
    insert acc;
    contact cnt = new contact(LastName = 'test',Account = acc,phone= '1234567890',Role__c = 'Accounting',No_Email__c = true);
    insert cnt;
  Id RecordTypeId = Schema.SObjectType.Nexeo_Competitor__c.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
    
    Nexeo_Competitor__c nc = new Nexeo_Competitor__c(name = 'test',Status__c='Active',RecordTypeid=RecordTypeId);
    insert nc;
    opportunity op = new opportunity(name = 'Distribution Plastics',CurrencyIsoCode = 'AUD',Customer_Prospect__c = acc.id,Requested_Supplier__c = nc.id,Contact__c = cnt.id,CloseDate = system.today(),StageName = 'Concept');
    insert op;
    Supplier_Contact__c scon = new Supplier_Contact__c(First_Name__c = 'test',Last_Name__c ='test1',Competitor_Supplier_or_OEM__c = nc.id);
    insert scon;
    List<Opportunity_Call_Report__c> ocrList = new List<Opportunity_Call_Report__c>();
    Opportunity_Call_Report__c ocr = new Opportunity_Call_Report__c(Opportunity__c = op.id,Supplier_Contact__c = scon.id,Employee__c = u.id, Status_Update__c = 'test');
    ocrlist.add(ocr);
    Opportunity_Call_Report__c ocr1 = new Opportunity_Call_Report__c(Opportunity__c = op.id,Supplier_Contact__c = scon.id,Employee__c = u.id, Status_Update__c = 'test1');
    ocrList.add(ocr1);
    insert ocrlist;
    
    delete ocrlist[0];
   test.stoptest();
    
    
    }
    
}