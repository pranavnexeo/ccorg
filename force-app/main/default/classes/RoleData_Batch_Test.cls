@isTest
private class RoleData_Batch_Test {
  
  public static testMethod void testmybatch() {
    
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
   Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution Customer').getRecordTypeId();
   Account a = new Account(Name = 'Test',RecordtypeId=RecordTypeId,SAP_Sales_Org__c = 'Test', SAP_DivisionCode__c = 'Test', SAP_Industry_Key__c ='Test',HQ_Sales_Office__c = 'Test', SAP_SalesGroup__c = 'Test');
   insert a;
   List<Account>lstBatchRecords = new List<Account>();
   lstBatchRecords.add(a);
   Role_Data__c rd = new Role_Data__c(type__c = 'Account');
   insert rd;
RoleData_Batch clsBatchSync = new RoleData_Batch();
ID idBatch = Database.executeBatch(clsBatchSync);
   clsBatchSync.execute(null,lstBatchRecords ); 
   
  }
}