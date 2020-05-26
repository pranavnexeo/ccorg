//Test class for Batch classes(5 batch classes for owner update)
//Author-Rajeev
@isTest
private class Owner_Update_batch_test{
    
    //test method for SampleRequest_Owner_Update_batch
    
    Public static testmethod void TestThisBatch1(){
    List<Sample_request__c> samlist = new List<Sample_request__c>();
    
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
    Profile p1 = [SELECT Id FROM Profile WHERE Name='Standard User'];
    User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true);
    insert u;
    
    User u1 = new User(Alias = 'standt', Email='xxx@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p1.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='bhsdsc@testorg.com', IsActive = true);
    insert u1;
    
    Account a = new Account(Name = 'test11',type = 'Customer', OwnerId = u.id);
    insert a;

    Sample_request__c sam = new Sample_request__c(Account__c = a.id, OwnerId = u1.id);
    samlist.add(sam);
    insert samlist;
    String test = 'test';
    SampleRequest_Owner_Update_batch s = new SampleRequest_Owner_Update_batch(test);
        ID idBatch = Database.executeBatch(s);
        s.execute(null,samlist);
    }
   
   //test method for Opportunity_Owner_Update_batch
   Public static testmethod void TestThisBatch2(){
    List<Opportunity> opplist = new List<Opportunity>();
    
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
    Profile p1 = [SELECT Id FROM Profile WHERE Name='Standard User'];
    User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
    insert u;
    
    User u1 = new User(Alias = 'standt', Email='xxx@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p1.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='jsnbcnbs@testorg.com', IsActive = true);
    insert u1;
    
    Account a = new Account(Name = 'test11',type = 'Customer', OwnerId = u.id);
    insert a;

    Opportunity opp = new Opportunity(Name = 'Opp test',AccountId = a.id, OwnerId = u1.id, StageName = 'Prospect', CloseDate = System.today(),CurrencyIsoCode = 'USD');
    opplist.add(opp);
    insert opplist;
    
    Opportunity_Owner_Update_batch s1 = new Opportunity_Owner_Update_batch();
        ID idBatch = Database.executeBatch(s1);
        s1.execute(null,opplist);
    }
    
    //test method for Contact_Owner_Update_batch
    Public static testmethod void TestThisBatch3(){
    List<Contact> conlist = new List<Contact>();
    
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
    Profile p1 = [SELECT Id FROM Profile WHERE Name='Standard User'];
    User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='habvsc@gorg.com', IsActive = true);
    insert u;
    
    User u1 = new User(Alias = 'standt', Email='xxx@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p1.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='ljnsvcsn@testorg.com', IsActive = true);
    insert u1;
    
    Account a = new Account(Name = 'test11',type = 'Customer', OwnerId = u.id);
    insert a;

    Contact con = new Contact(AccountId = a.id, OwnerId = u1.id, Email = 'abc@gmail.com', LastName = 'test2',Role__c = 'Accounting', FirstName = 'test3');
    conlist.add(con);
    insert conlist;
    String test = 'test';
    Contact_Owner_Update_batch s2 = new Contact_Owner_Update_batch(test);
        ID idBatch = Database.executeBatch(s2);
        s2.execute(null,conlist);
    }
    
    //test method for CDF_Owner_Update_batch
    Public static testmethod void TestThisBatch4(){
    List<Contract> cotlist = new List<Contract>();
    
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
    Profile p1 = [SELECT Id FROM Profile WHERE Name='Standard User'];
    User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='hjvvbvh@gorg.com', IsActive = true);
    insert u;
    
    User u1 = new User(Alias = 'standt', Email='xxx@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p1.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='zxxccgc@testorg.com', IsActive = true);
    insert u1;
    
    Account a = new Account(Name = 'test11',type = 'Customer', OwnerId = u.id);
    insert a;
    Material_Sales_Data2__c mm = new Material_Sales_Data2__c(Name = 'test material', Material_Number__c = '000000000000000123',Dist_Channel_Code__c = '30',Sales_Org_Code__c = '1000',Record_Key__c = '123456789012345');
    insert mm;
    
    Contract cot = new Contract(StartDate = system.today(),OwnerExpirationNotice = '120',AccountId = a.id, OwnerId = u1.id,Forecasted_Quantity__c = 1234.123,Per__c = 'Month', Stocking_Unit__c = 'BAGS',Ashland_Supplier__c = 'Acidchem', Stocking_Warehouse__c = '0004 - Edmonton', SAP_Material__c = mm.id  );
    cotlist.add(cot);
    insert cotlist;
    string test = 'test';
    CDF_Owner_Update_batch s3 = new CDF_Owner_Update_batch(test);
        ID idBatch = Database.executeBatch(s3);
        s3.execute(null,cotlist);
    }
    
    //test method for BC_Owner_Update_batch
    Public static testmethod void TestThisBatch5(){
    List<Business_Contract__c> bclist = new List<Business_Contract__c>();
    
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
    Profile p1 = [SELECT Id FROM Profile WHERE Name='Standard User'];
    User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='uicmjkkj@gorg.com', IsActive = true);
    insert u;
    
    User u1 = new User(Alias = 'standt', Email='xxx@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p1.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='okmhjhg@testorg.com', IsActive = true);
    insert u1;
    
    Account a = new Account(Name = 'test11',type = 'Customer', OwnerId = u.id);
    insert a;
    
    Business_Contract__c bot = new Business_Contract__c(CurrencyIsoCode = 'USD',Customer_Name__c = a.id, OwnerId = u1.id,Contract_Type__c = 'Consignment',Form_Type__c= 'Customer Form', Contract_Clauses__c = 'None',Effective_Date__c = System.today(), Expiration_Date__c = system.today()+10, Expected_Annual_Volume__c = 1000,Expected_Annual_Revenue__c = 1000,Expected_Annual_Margin__c = 1200,Synopsis__c = 'test',Comments__c = 'testsss');
    bclist.add(bot);
    insert bclist;
    string test = 'test';
    BC_Owner_Update_batch s4 = new BC_Owner_Update_batch(test);
        ID idBatch = Database.executeBatch(s4);
        s4.execute(null,bclist);
    } 
    
    Public static testmethod void TestThisBatch6(){
    string test = 'test';
    List<AccountHistory> hlist = [Select field, AccountId, NewValue, OldValue from AccountHistory where field = 'Owner' and CreatedDate > YESTERDAY limit 5];
    Account_Owner_Changes_batch s5 = new Account_Owner_Changes_batch(test);
        ID idBatch = Database.executeBatch(s5);
        s5.execute(null,hlist);
    }
    
    Public static testmethod void TestThisBatch7(){
    
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
    
    List<Business_Contract__c> bclist = new List<Business_Contract__c>();
    
    Account a = new Account(Name = 'test14',type = 'Customer');
    insert a;
    
    Map<String, Schema.RecordTypeInfo> rtMap = Business_Contract__c.sObjectType.getDescribe().getRecordTypeInfosByName();
    
    Business_Contract__c bc = new Business_Contract__c(RecordtypeId = rtMap.get('AD Business Contract').getRecordTypeId(),CurrencyIsoCode = 'USD',Customer_Name__c = a.id, Contract_Type__c = 'Consignment',Form_Type__c= 'Customer Form',
                                  Contract_Clauses__c = 'None',Effective_Date__c = System.today(), Expiration_Date__c = system.today()-10, Expected_Annual_Volume__c = 1000,Expected_Annual_Revenue__c = 1000,Expected_Annual_Margin__c = 1200,Synopsis__c = 'test',Comments__c = 'testsss');
    bclist.add(bc);
    insert bclist;
    
    string test = 'test';
    
    Update_BusinessContract_Status_batch s6 = new Update_BusinessContract_Status_batch(test);
        ID idBatch = Database.executeBatch(s6);
        s6.execute(null,bclist);
    }                
}