@isTest
  Private Class Account_SAP_Values_Sync_Batch_test{
  
  Public static testmethod void TestThisBatch(){
    
    Integration_table_change__c itc = new Integration_table_change__c(Completed__c = False, code_field__c = 'SAP_Central_Delivery_Block__c',description_field__c = 'SAP_Central_Delivery_Block_Desc__c',Config_Table__c = 'SAP_Delivery_Block_Code__c',
            Config_Code_Field__c = 'Delivery_Block_Code__c', Config_Desc_Field__c = 'Delivery_Block_Name__c', type__c = 'Account', new_description__c = 'test1',old_description__c = 'test2');
            insert itc;
    
    List<Integration_Table_Change__c> changes = new List<Integration_Table_Change__c>();
            changes.add(itc);
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
       Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution Customer').getRecordTypeId();
       Account a = new Account(Name = 'Test',RecordtypeId=RecordTypeId,SAP_Sales_Org__c = 'Test', SAP_DivisionCode__c = 'Test', SAP_Industry_Key__c ='Test',HQ_Sales_Office__c = 'Test', SAP_SalesGroup__c = 'Test');
      // insert a; 
    List<Account> acclist = new List<Account>();
           // Account a = new Account(Name = 'test',type = 'Customer');
            acclist.add(a);
            insert acclist;
   
    Account_SAP_Values_Sync_Batch asvsb = new Account_SAP_Values_Sync_Batch('test');
            ID idBatch = Database.executeBatch(asvsb);
            asvsb.execute(null,acclist); 
  }
  
    
}