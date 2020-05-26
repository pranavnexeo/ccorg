@isTest
private class Account_Directory_Test {

static testMethod void myUnitTest() {
       
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution Customer').getRecordTypeId();
        Account acct = new Account(Name = 'Test',RecordtypeId=RecordTypeId,SAP_Sales_Org__c = 'Test', SAP_DivisionCode__c = 'Test', SAP_Industry_Key__c ='Test',HQ_Sales_Office__c = 'Test', SAP_SalesGroup__c = 'Test');
        insert acct; 
       
       // account acct = new Account(name='TestAccount',SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Customer',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA',SAP_DivisionCode__c='31');
       // insert acct; 
       // account acct1 = new Account(name='TestAccount',Prospect_Sales_Group__c= 'DM CHEM CASE SE (298)',Full_Address__c= 'test test',Prospect_Division__c= 'Nexeo Chem (31)',sales_area__c= 'test',SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Prospect',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA',SAP_DivisionCode__c='31');
       // insert acct1; 
        List<account> a = new list<account>();
       // a.add(acct1);
        a.add(acct);
        Test.startTest();
        Account_Directory_Batch r =new Account_Directory_Batch(10);
        id idbatch = database.executebatch(r);
        r.execute(null,a);
        Test.stoptest();     
}
}