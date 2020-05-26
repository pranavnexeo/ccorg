@isTest
private class AssignTaskToOwnerOfAccount_Test {

static testMethod void myUnitTest() {
        Test.startTest();
      
        Case c = new case();
        //Account acc = new Account(Name='TestAccount');
       // insert acc;
       Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
   Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution Customer').getRecordTypeId();
   Account acc = new Account(Name = 'Test',RecordtypeId=RecordTypeId,SAP_Sales_Org__c = 'Test', SAP_DivisionCode__c = 'Test', SAP_Industry_Key__c ='Test',HQ_Sales_Office__c = 'Test', SAP_SalesGroup__c = 'Test');
   insert acc; 
        Contact con = new Contact(FirstName='chandra',LastName='LastName', No_Email__c= true);
        con.AccountId = acc.Id;
        insert con;
        c.Accountid = acc.Id;
        c.contactid = con.id;
        insert c;
        ApexPages.StandardController sc = new ApexPages.StandardController(c);
        AssignTaskToOwnerOfAccount AT = new AssignTaskToOwnerOfAccount(sc);
        AT.AssignTask();
        AT.Cancel();

}



}