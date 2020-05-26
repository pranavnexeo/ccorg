@istest
public  Class runzheimerbatch_Test {
    
    static testMethod void runzheimerbatch(){
        //Map<String, SObject> testData = NexeoTestUtils_Test.initData();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
       Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution Customer').getRecordTypeId();
        Account acc= new Account(Name = 'Test',RecordtypeId=RecordTypeId,SAP_Sales_Org__c = 'Test', SAP_DivisionCode__c = 'Test', SAP_Industry_Key__c ='Test',HQ_Sales_Office__c = 'Test', SAP_SalesGroup__c = 'Test');
        //insert a; 
       // Account acc = new Account();
      //  acc.Name='Test1';
       // acc.Type='Prospect';
      //  acc.billingstreet='1 Waterway Ave';
       // acc.SAP_Street__c='1 Waterway Ave';
        acc.runzheimer_batch_Updated__c=false; 
        insert acc;
        
       // Account acc1 = new Account();
      //  acc1.Name='Test2';
      //  acc1.Type='Customer';
      //  acc1.billingstreet='1 Waterway Ave';
      //  acc1.SAP_Street__c='1 Waterway Ave';
      //  acc1.runzheimer_batch_Updated__c=false; 
      //  insert acc1;
       
        Test.startTest();
        runzheimerbatch  obj = new runzheimerbatch();
        DataBase.executeBatch(obj);
        Test.stopTest();
    }
}