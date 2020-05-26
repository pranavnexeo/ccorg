@isTest
    Public Class Account_Geo_Prospect1_test{
  
        Public static testmethod void TestAccount_Geo_Prospect(){
        //try{
           Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
            insert u;
           Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution Customer').getRecordTypeId();
           Account acct = new Account(Name = 'Test',RecordtypeId=RecordTypeId,SAP_Sales_Org__c = 'Test', SAP_DivisionCode__c = 'Test', SAP_Industry_Key__c ='Test',HQ_Sales_Office__c = 'Test', SAP_SalesGroup__c = 'Test');
           //insert acct; 
           
           // userRole ur = [SELECT id from userrole limit 1];
           // Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
           // Profile p1 = [SELECT Id FROM Profile WHERE Name='Standard User'];
           // User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
            //TimeZoneSidKey='America/Los_Angeles',UserName='ksbc@gorg.com',userrole = ur, IsActive = true);
           // insert u;
            List<Account> accl = new List<Account>();
            //Account acct = new Account(SAP_Bill_To_Account_Number__c= 'test1234',SAP_Bill_To_Account_Name__c = '12345',SAP_Sold_To_Record_Key__c='12345',SAP_Sold_To_Account_Number__c='test1',Account_number__c = '1234567',SAP_Payer_Account_Number__c = 'test12345',SAP_Payer_Account_Key__c = '12345',SAP_Bill_To_Record_Key__c = '1234',name='TestAccount',AccountNumber='123',type = 'Vendor',SAP_Accounting_Group__c = 'ZVEN',VendorUniqueId__c = 'test12345');
            accl.add(acct);
            insert accl;
            List<Account_Directory__c> adlst = new List<Account_Directory__c>();
            Account_Directory__c ad = new Account_Directory__c(Name = 'test',Record_Key__c = '123456789');
            insert ad;
            User_Defaults__c ud = new User_Defaults__c(name = 'test',Classification__c = 'test',SAP_Sales_Org__c = '123',SAP_Dist_Channel__c = '1',SAP_Sales_District__c = 'test12',SAP_Division__c = '1',SAP_Sales_Office__c = '12',SAP_Sales_Group__c= '1');
            insert ud;
            SAP_Sales_Org__C so = new SAP_Sales_Org__C (CurrencyIsoCode = 'AUD',Language_Code__c = '12',Sales_Org_Code__c ='123');
            insert so;
            SAP_Distribution_Channel__c sdc = new SAP_Distribution_Channel__c(Distribution_Channel_Code__c = '1',Language_Code__c = 'a',CurrencyIsoCode = 'AUD');
            insert sdc;
            SAP_Sales_Division__c ssd = new SAP_Sales_Division__c(Sales_Division_Code__c = '1',Language_Code__c = 'a',CurrencyIsoCode = 'AUD');
            insert ssd;
            SAP_Sales_District__c ssdi = new SAP_Sales_District__c(Language_Code__c = 'a',CurrencyIsoCode = 'AUD',Sales_District_Code__c ='test12');
            insert ssdi;
            SAP_Sales_Office__c  sso = new SAP_Sales_Office__c (Language_Code__c = 'a',CurrencyIsoCode = 'AUD',Sales_Office_Code__c  ='12');
            insert sso;
            SAP_Sales_Group__c ssg = new SAP_Sales_Group__c(Language_Code__c = 'a',CurrencyIsoCode = 'AUD',Sales_Group_Code__c  ='1');
            insert ssg;
            ud.Classification__c = 'test';
            ud.SAP_Sales_Org__c = '';
            ud.SAP_Dist_Channel__c = '';
            ud.SAP_Sales_District__c = '';
            ud.SAP_Division__c = '';
            ud.SAP_Sales_Office__c = '';
            ud.SAP_Sales_Group__c= '';
            update ud;
            
            Account_Geo_Prospect1 controller=new Account_Geo_Prospect1(new apexpages.standardcontroller(acct));
            
            controller.NearbyAcct=adlst;
            Account_Geo_Prospect1.stringtodouble('3.14159');
            controller.lat = 12.34;
            controller.lng = 12.34;
            controller.s = 'test';
            controller.main = 'test';
            controller.AccountName = 'test';
            controller.mainAcct = ad;
           // }catch(exception e){}
        
        }
        
                Public static testmethod void TestAccount_Geo_Prospect1(){
        //try{
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution Customer').getRecordTypeId();
        Account acct = new Account(Name = 'Test',RecordtypeId=RecordTypeId,SAP_Sales_Org__c = 'Test', SAP_DivisionCode__c = 'Test', SAP_Industry_Key__c ='Test',HQ_Sales_Office__c = 'Test', SAP_SalesGroup__c = 'Test');
        //insert a; 
            
            //userRole ur = [SELECT id from userrole limit 1];
            //Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
           // Profile p1 = [SELECT Id FROM Profile WHERE Name='Standard User'];
           // User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
           // TimeZoneSidKey='America/Los_Angeles',UserName='ksbc@gorg.com',userrole = ur, IsActive = true);
            //insert u;
            List<Account> accl = new List<Account>();
            //Account acct = new Account(SAP_Bill_To_Account_Number__c= 'test1234',SAP_Bill_To_Account_Name__c = '12345',SAP_Sold_To_Record_Key__c='12345',SAP_Sold_To_Account_Number__c='test1',Account_number__c = '1234567',SAP_Payer_Account_Number__c = 'test12345',SAP_Payer_Account_Key__c = '12345',SAP_Bill_To_Record_Key__c = '1234',name='TestAccount',AccountNumber='123',type = 'Vendor',SAP_Accounting_Group__c = 'ZVEN',VendorUniqueId__c = 'test12345');
            accl.add(acct);
            insert accl;
            List<Account_Directory__c> adlst = new List<Account_Directory__c>();
            Account_Directory__c ad = new Account_Directory__c(Name = 'test',Record_Key__c = '123456789');
            insert ad;
            adlst.add(ad);
            
            Account_Geo_Prospect1 controller=new Account_Geo_Prospect1(new apexpages.standardcontroller(acct));
            
            controller.NearbyAcct=adlst;
            Account_Geo_Prospect1.stringtodouble('12-03');
            controller.lat = 12.34;
            controller.lng = 12.34;
        
        }
        
        
 }