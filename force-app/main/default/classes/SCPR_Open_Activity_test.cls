@isTest
    Private Class SCPR_Open_Activity_test{
    
        public static testmethod void SCPROA(){
        
        userRole ur = [SELECT id from userrole limit 1];
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
        
        Account a = new Account(name = 'test',ownerid=u.id);
        insert a;
        
   Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution Customer').getRecordTypeId();      
        Account acc = new Account(Name = 'TestAccount',type= 'Customer',SAP_city__c='pune',SAP_Sold_To_Account__c = '1234',SAP_Sold_To_Account_Id__c = a.id,SAP_State__c='MH',recordtypeid= RecordTypeId , AccountNumber = '1233456',ownerid=u.id, SAP_Partner_Functions__c = 'Sold To',SAP_Corporate_Account__c = '1234',SAP_Corporate_Account_Id__c = a.id);
        insert acc;            
              
        Contact con = new Contact(firstName='john',lastName='smith',Email='user@acme.com',HasOptedOutOfEmail=true,Accountid = acc.id);
        insert con;
              
        Task T = new Task(CallObject = 'Test');
        insert T;
            
        SCPR_Open_Activity scproa = new SCPR_Open_Activity(T.id,System.today(),u.id,'Lisa','test','test11',con.id,'Test1',acc.id,'abc','sttest');
        
        }
 }