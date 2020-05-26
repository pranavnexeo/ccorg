@isTest(seealldata=false)
public class AccountDirectoryCleanUpBatchTest {
    public static testMethod void accDirectCleanupTest() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
       
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
                 TimeZoneSidKey='America/Los_Angeles', UserName='hjvvbvh@gorg.com', IsActive = true);
        insert u;
        
       Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution Customer').getRecordTypeId();
   Account a = new Account(Name = 'Test',RecordtypeId=RecordTypeId,SAP_Sales_Org__c = 'Test', SAP_DivisionCode__c = 'Test', SAP_Industry_Key__c ='Test',HQ_Sales_Office__c = 'Test', SAP_SalesGroup__c = 'Test');
   insert a; 
       
              
       // Account a = new Account(Name = 'test11',type = 'Customer', OwnerId = u.id);
       // insert a;
        
        Account_Directory__c ad = new Account_Directory__c();
        ad.Account_Id__c = a.id;
        ad.Record_Key__c = a.id;
        insert ad;
       
        
        test.starttest();
        AccountDirectoryCleanUpBatch b = new AccountDirectoryCleanUpBatch();
        database.executebatch(b,200);
        test.stopTest();
        
    }   
    

}