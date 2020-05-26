@isTest
private class NCAR_AssignTaskToOwnerOfAccount_Test {

    static testMethod void myUnitTest() {
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
   Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution Customer').getRecordTypeId();
   Account acc = new Account(Name = 'Test',RecordtypeId=RecordTypeId,SAP_Sales_Org__c = 'Test', SAP_DivisionCode__c = 'Test', SAP_Industry_Key__c ='Test',HQ_Sales_Office__c = 'Test', SAP_SalesGroup__c = 'Test');
   insert acc;
      
        //Account acc = new Account(Name='TestAccount');
        //insert acc;
        
        Contact con = new Contact(FirstName='Chandra',LastName='LastName',  No_Email__c = true);
        con.AccountId = acc.Id;
        insert con;
        
        
        NCAR_Cases__c c = new NCAR_Cases__c();
        c.Account__c= acc.Id;
        c.Contact__c= con.id;
        insert c;
        
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(c);
        NCAR_AssignTaskToOwnerOfAccount AT = new NCAR_AssignTaskToOwnerOfAccount(sc);
        
        AT.AssignTask();
        AT.Cancel();
        
        Test.stopTest();
    
    }
    
}