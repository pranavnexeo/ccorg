@isTest
    Private Class Account_Trigger_Functions_test1{
  
        Public static testmethod void TestUpdate_Account_Trigger_Functions1(){
            Test.startTest();
            Profile profile = [select id from profile where name='System Administrator'];
            User u = new User(lastname='Nexeo_Integration User',Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8',  LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = profile.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true,Ashland_Employee_Number__c = 'A123000');
          insert u;
            
            
            List<Account> accl = new List<Account>();
           Map<ID, Account> oldmap = new  Map<ID, Account>();
            Account acct = new Account(SAP_Bill_To_Account_Number__c= 'test1234',SAP_Bill_To_Account_Name__c = '12345',SAP_Sold_To_Record_Key__c='12345',SAP_Sold_To_Account_Number__c='test1',Account_number__c = '1234567',SAP_Payer_Account_Number__c = 'test12345',SAP_Payer_Account_Key__c = '12345',SAP_Bill_To_Record_Key__c = '1234',name='TestAccount',AccountNumber='123',type = 'Vendor',SAP_Accounting_Group__c = 'ZVEN',VendorUniqueId__c = 'test12345');
            accl.add(acct);
            insert accl;
            account_trigger_functions atf = new account_trigger_functions();
            account_trigger_functions.PopulateAccountDetails(accl);
            account_trigger_functions.processBeforeUpsert(accl,true,oldmap);
            Test.stopTest();
        }
        
        Public static testmethod void TestUpdate_Account_Trigger_Functions2(){
            Test.startTest();
            Profile profile = [select id from profile where name='System Administrator'];
            User u = new User(lastname='Nexeo_Integration User',Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8',  LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = profile.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true,Ashland_Employee_Number__c = 'A123000');
          insert u;
                    SAP_Plant__c sp = new SAP_Plant__c(Ashland_Legacy_Id__c = '234654',Plant_Code__c = '00065');
          insert sp;  
            
            List<Account> accl = new List<Account>();
           Map<ID, Account> oldmap = new  Map<ID, Account>();
            Account acct = new Account(SAP_Bill_To_Account_Number__c= 'test1234',SAP_Bill_To_Account_Name__c = '12345',SAP_Sold_To_Record_Key__c='12345',SAP_Sold_To_Account_Number__c='test1',Account_number__c = '1234567',SAP_Payer_Account_Number__c = 'test12345',SAP_Payer_Account_Key__c = '12345',SAP_Bill_To_Record_Key__c = '1234',name='TestAccount',AccountNumber='123',type = 'Vendor',SAP_Accounting_Group__c = 'ZVEN',VendorUniqueId__c = 'test12345');
            acct.Customer_Hierarchy_Number__c = '123';
            acct.SAP_ShippingPlant__c = '00065';
            acct.country_picklist__c = 'United States (US)';
            acct.Prospect_Division__c = 'Nexeo Plastics (32)';
            acct.Prospect_Sales_District__c = 'ADDITIVES (11100)';
            acct.Prospect_Sales_Office__c = 'CM PLASTICS ASIA (3280)';
            acct.Prospect_Sales_Group__c = 'ADVANCED (350)	';
            acct.Prospect_Customer_Group__c = 'ADDITIVES (11)';
            acct.Prospect_Customer_Group1__c = 'CHEMICAL & REFINERY (17)';
   
            accl.add(acct);
            insert accl;

            account_trigger_functions.setCustomerHierarchyAccount(accl);
            Test.stopTest();

        }  
        
        Public static testmethod void TestUpdate_Account_Trigger_Functions3(){
            Test.startTest();
            Profile profile = [select id from profile where name='System Administrator'];
            User u = new User(lastname='Nexeo_Integration User',Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8',  LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = profile.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true,Ashland_Employee_Number__c = 'A123000');
          insert u;
                    SAP_Plant__c sp = new SAP_Plant__c(Ashland_Legacy_Id__c = '234654',Plant_Code__c = '00065');
          insert sp;  
            
            SAP_Industry_Name__c sin = new SAP_Industry_Name__c(Industry_Code__c = '89', Industry_Name__c = 'sdfd');
            insert sin;
            
            SAP_Payment_Term_Explanation__c spte = new SAP_Payment_Term_Explanation__c(Payment_Term_Code__c = '7654');
            insert spte;
            
            SAP_Customer_Group5__c scg5 = new SAP_Customer_Group5__c(Customer_Group5_Code__c = '123', Customer_Group5_Name__c = 'Cool Name');
            insert scg5;
            
                      SAP_Seller__c ss = new SAP_Seller__c(name = 'test',User__c = u.id);
          insert ss;
          
          SAP_Sales_DOG__c ssd = new SAP_Sales_DOG__c (YD_Partner__c = ss.id,YV_Partner__c = ss.id,YO_Partner__c = ss.id);
          insert ssd;
          
          SAP_Territory__c ST = new SAP_Territory__c(Name = 'test', ZS_Partner__c = ss.id, YS_Partner__c = ss.id,SAP_Sales_DOG__c = ssd.id);
          insert ST;
            
            List<Account> accl = new List<Account>();
           Map<ID, Account> oldmap = new  Map<ID, Account>();
           Id cutomerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution RTK Prospect').getRecordTypeId();
            Account acct1 = new Account(Account_number__c = '89775511', RecordTypeId = cutomerRecordTypeId, SAP_Bill_To_Account_Name__c = '12345',SAP_Sold_To_Record_Key__c='12345',SAP_Sold_To_Account_Number__c='test1',SAP_Payer_Account_Number__c = 'test12345',SAP_Payer_Account_Key__c = '12345',SAP_Bill_To_Record_Key__c = '1234',name='TestAccount',AccountNumber='123',type = 'Vendor',SAP_Accounting_Group__c = 'ZVEN',VendorUniqueId__c = 'test12345');
			insert acct1;
            
            Account acct = new Account(RecordTypeId = cutomerRecordTypeId, SAP_Bill_To_Account_Number__c= 'test1234',SAP_Bill_To_Account_Name__c = '12345',SAP_Sold_To_Record_Key__c='12345',SAP_Sold_To_Account_Number__c='test1',Account_number__c = '1234567',SAP_Payer_Account_Number__c = 'test12345',SAP_Payer_Account_Key__c = '12345',SAP_Bill_To_Record_Key__c = '1234',name='TestAccount',AccountNumber='123',type = 'Vendor',SAP_Accounting_Group__c = 'ZVEN',VendorUniqueId__c = 'test12345');
            acct.Customer_Hierarchy_Number__c = '123';
            acct.SAP_Bill_To_Record_Key__c = '89775511';
            acct.SAP_ShippingPlant__c = '00065';
            acct.country_picklist__c = 'United States (US)';
            acct.Prospect_Division__c = 'Nexeo Plastics (32)';
            acct.Prospect_Sales_District__c = 'ADDITIVES (11100)';
            acct.Prospect_Sales_Office__c = 'CM PLASTICS ASIA (3280)';
            acct.Prospect_Sales_Group__c = 'ADVANCED (350)	';
            acct.Prospect_Customer_Group__c = 'ADDITIVES (11)';
            acct.Prospect_Customer_Group1__c = 'CHEMICAL & REFINERY (17)';
   			acct.SAP_Customer_Number__c = '00000126990';
            acct.SAP_Industry_Key__c = '1234';
            acct.SAP_Payment_Terms__c = '1234';
            acct.Type = 'Prospect';
            acct.SAP_Industry_Key__c = '89';
            acct.SAP_Payment_Terms__c = '7654';
            acct.SAP_Customer_Group_5__c = '123';
            acct.YZ_Partner__c = ST.id;
            acct.SAP_Bill_To_Account_Number__c = acct1.Id;
            acct.SAP_Sold_To_Record_Key__c = '89775511';
            acct.SAP_Sold_To_Account_Number__c= acct1.Id;
            acct.SAP_Payer_Account_Key__c = '89775511';
            acct.SAP_Payer_Account_Number__c = acct1.Id;
            acct.SAP_Customer_Group_2__c = 'SPC';
            acct.Account_number__c = '726990';
            acct.YI_Partner__c = ST.id;
            acct.YY_Partner__c = ST.id;
            accl.add(acct);
            insert accl;
			
            account_trigger_functions.setCustomerHierarchyAccount(accl);
            account_trigger_functions.PopulateAccountDetails(accl);
            account_trigger_functions.ProcessBeforeUpdate(accl, oldmap);
            Test.stopTest();

        }
        
        Public static testmethod void TestUpdate_Account_Trigger_Functions4(){
            Test.startTest();
            Profile profile = [select id from profile where name='System Administrator'];
            User u = new User(lastname='Nexeo_Integration User',Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8',  LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = profile.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true,Ashland_Employee_Number__c = 'A123000');
          insert u;
                    SAP_Plant__c sp = new SAP_Plant__c(Ashland_Legacy_Id__c = '234654',Plant_Code__c = '00065');
          insert sp;  
            
            List<Account> accl = new List<Account>();
           Map<ID, Account> oldmap = new  Map<ID, Account>();
           Id cutomerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution RTK Prospect').getRecordTypeId();

            
            Account acct = new Account(RecordTypeId = cutomerRecordTypeId, SAP_Bill_To_Account_Number__c= 'test1234',SAP_Bill_To_Account_Name__c = '12345',SAP_Sold_To_Record_Key__c='12345',SAP_Sold_To_Account_Number__c='test1',Account_number__c = '1234567',SAP_Payer_Account_Number__c = 'test12345',SAP_Payer_Account_Key__c = '12345',SAP_Bill_To_Record_Key__c = '1234',name='TestAccount',AccountNumber='123',type = 'Vendor',SAP_Accounting_Group__c = 'ZVEN',VendorUniqueId__c = 'test12345');
            acct.Customer_Hierarchy_Number__c = '123';
            acct.SAP_ShippingPlant__c = '00065';
            acct.country_picklist__c = 'United States (US)';
            acct.Prospect_Division__c = 'Nexeo Plastics (32)';
            acct.Prospect_Sales_District__c = 'ADDITIVES (11100)';
            acct.Prospect_Sales_Office__c = 'CM PLASTICS ASIA (3280)';
            acct.Prospect_Sales_Group__c = 'ADVANCED (350)	';
            acct.Prospect_Customer_Group__c = 'ADDITIVES (11)';
            acct.Prospect_Customer_Group1__c = 'CHEMICAL & REFINERY (17)';
   			acct.SAP_Customer_Number__c = '00000126990';
            acct.Type = 'Marked for Deletion';
            accl.add(acct);
            insert accl;

            account_trigger_functions.setCustomerHierarchyAccount(accl);
            Test.stopTest();

        }
        
      Public static testmethod void TestUpdate_Account_Trigger_Functions5(){
          Test.startTest();
            Profile profile = [select id from profile where name='System Administrator'];
            User u = new User(lastname='Nexeo_Integration User',Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8',  LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = profile.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true,Ashland_Employee_Number__c = 'A123000');
          insert u;
                      SAP_Plant__c sp = new SAP_Plant__c(Ashland_Legacy_Id__c = '234654',Plant_Code__c = '00065');
          insert sp;
            
            List<Account> accl = new List<Account>();
           Map<ID, Account> oldmap = new  Map<ID, Account>();
           Id cutomerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution RTK Prospect').getRecordTypeId();

            
            Account acct = new Account(RecordTypeId = cutomerRecordTypeId, SAP_Bill_To_Account_Number__c= 'test1234',SAP_Bill_To_Account_Name__c = '12345',SAP_Sold_To_Record_Key__c='12345',SAP_Sold_To_Account_Number__c='test1',Account_number__c = '1234567',SAP_Payer_Account_Number__c = 'test12345',SAP_Payer_Account_Key__c = '12345',SAP_Bill_To_Record_Key__c = '1234',name='TestAccount',AccountNumber='123',type = 'Vendor',SAP_Accounting_Group__c = 'ZVEN',VendorUniqueId__c = 'test12345');
            acct.Customer_Hierarchy_Number__c = '123';
            acct.SAP_ShippingPlant__c = '00065';
            acct.country_picklist__c = 'United States (US)';
            acct.Prospect_Division__c = 'Nexeo Plastics (32)';
            acct.Prospect_Sales_District__c = 'ADDITIVES (11100)';
            acct.Prospect_Sales_Office__c = 'CM PLASTICS ASIA (3280)';
            acct.Prospect_Sales_Group__c = 'ADVANCED (350)	';
            acct.Prospect_Customer_Group__c = 'ADDITIVES (11)';
            acct.Prospect_Customer_Group1__c = 'CHEMICAL & REFINERY (17)';
   			acct.SAP_Customer_Number__c = '00000126990';
            acct.Type = 'Marked for Deletion';
          	acct.inactive_account__c = true;
          	acct.cis_prospect_status__c = 'Inactive';
            accl.add(acct);
            insert accl;

            account_trigger_functions.setCustomerHierarchyAccount(accl);
          Test.stopTest();

        }
        
       Public static testmethod void TestUpdate_Account_Trigger_Functions6(){
           Test.startTest();
            Profile profile = [select id from profile where name='System Administrator'];
            User u = new User(lastname='Nexeo_Integration User',Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8',  LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = profile.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true,Ashland_Employee_Number__c = 'A123000');
          insert u;
            
            
            List<Account> accl = new List<Account>();
           Map<ID, Account> oldmap = new  Map<ID, Account>();
           Id cutomerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution RTK Prospect').getRecordTypeId();
          SAP_Plant__c sp = new SAP_Plant__c(Ashland_Legacy_Id__c = '234654',Plant_Code__c = '00065');
          insert sp;
            
            Account acct = new Account(RecordTypeId = cutomerRecordTypeId, SAP_Bill_To_Account_Number__c= 'test1234',SAP_Bill_To_Account_Name__c = '12345',SAP_Sold_To_Record_Key__c='12345',SAP_Sold_To_Account_Number__c='test1',Account_number__c = '1234567',SAP_Payer_Account_Number__c = 'test12345',SAP_Payer_Account_Key__c = '12345',SAP_Bill_To_Record_Key__c = '1234',name='TestAccount',AccountNumber='123',type = 'Vendor',SAP_Accounting_Group__c = 'ZVEN',VendorUniqueId__c = 'test12345');
            acct.Customer_Hierarchy_Number__c = '123';
            acct.SAP_ShippingPlant__c = '00065';
            acct.country_picklist__c = 'United States (US)';
            acct.Prospect_Division__c = 'Nexeo Plastics (32)';
            acct.Prospect_Sales_District__c = 'ADDITIVES (11100)';
            acct.Prospect_Sales_Office__c = 'CM PLASTICS ASIA (3280)';
            acct.Prospect_Sales_Group__c = 'ADVANCED (350)	';
            acct.Prospect_Customer_Group__c = 'ADDITIVES (11)';
            acct.Prospect_Customer_Group1__c = 'CHEMICAL & REFINERY (17)';
   			acct.SAP_Customer_Number__c = '00000126990';
            acct.Type = 'Customer';
          	acct.inactive_account__c = true;
          	acct.cis_prospect_status__c = 'Inactive';
           acct.SAP_Account_Group__c = '0012';
            accl.add(acct);
            insert accl;

            account_trigger_functions.setCustomerHierarchyAccount(accl);
			Test.stopTest();
        }
        
      Public static testmethod void TestUpdate_Account_Trigger_Functions7(){
          Test.startTest();
            Profile profile = [select id from profile where name='System Administrator'];
            User u = new User(lastname='Nexeo_Integration User',Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8',  LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = profile.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true,Ashland_Employee_Number__c = 'A123000');
          insert u;
                    SAP_Plant__c sp = new SAP_Plant__c(Ashland_Legacy_Id__c = '234654',Plant_Code__c = '00065');
          insert sp;  
            
            SAP_Industry_Name__c sin = new SAP_Industry_Name__c(Industry_Code__c = '89', Industry_Name__c = 'sdfd');
            insert sin;
            
            SAP_Payment_Term_Explanation__c spte = new SAP_Payment_Term_Explanation__c(Payment_Term_Code__c = '7654');
            insert spte;
            
            SAP_Customer_Group5__c scg5 = new SAP_Customer_Group5__c(Customer_Group5_Code__c = '123', Customer_Group5_Name__c = 'Cool Name');
            insert scg5;
            
                      SAP_Seller__c ss = new SAP_Seller__c(name = 'test',User__c = u.id);
          insert ss;
          
          SAP_Sales_DOG__c ssd = new SAP_Sales_DOG__c (YD_Partner__c = ss.id,YV_Partner__c = ss.id,YO_Partner__c = ss.id);
          insert ssd;
          
          SAP_Territory__c ST = new SAP_Territory__c(Name = 'test', ZS_Partner__c = ss.id, YS_Partner__c = ss.id,SAP_Sales_DOG__c = ssd.id);
          insert ST;
            
            List<Account> accl = new List<Account>();
           Map<ID, Account> oldmap = new  Map<ID, Account>();
           Id cutomerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution RTK Prospect').getRecordTypeId();

            
            Account acct = new Account(RecordTypeId = cutomerRecordTypeId, SAP_Bill_To_Account_Number__c= 'test1234',SAP_Bill_To_Account_Name__c = '12345',SAP_Sold_To_Record_Key__c='12345',SAP_Sold_To_Account_Number__c='test1',Account_number__c = '1234567',SAP_Payer_Account_Number__c = 'test12345',SAP_Payer_Account_Key__c = '12345',SAP_Bill_To_Record_Key__c = '1234',name='TestAccount',AccountNumber='123',type = 'Vendor',SAP_Accounting_Group__c = 'ZVEN',VendorUniqueId__c = 'test12345');
            acct.Customer_Hierarchy_Number__c = '123';
            acct.SAP_ShippingPlant__c = '00065';
            acct.country_picklist__c = 'United States (US)';
            acct.Prospect_Division__c = 'Nexeo Plastics (32)';
            acct.Prospect_Sales_District__c = 'ADDITIVES (11100)';
            acct.Prospect_Sales_Office__c = 'CM PLASTICS ASIA (3280)';
            acct.Prospect_Sales_Group__c = 'ADVANCED (350)	';
            acct.Prospect_Customer_Group__c = 'ADDITIVES (11)';
            acct.Prospect_Customer_Group1__c = 'CHEMICAL & REFINERY (17)';
   			acct.SAP_Customer_Number__c = '00000126990';
            acct.SAP_Industry_Key__c = '1234';
            acct.SAP_Payment_Terms__c = '1234';
            acct.Type = 'Prospect';
            acct.SAP_Industry_Key__c = '89';
            acct.SAP_Payment_Terms__c = '7654';
            acct.SAP_Customer_Group_5__c = '123';
            acct.YZ_Partner__c = ST.id;
            acct.SAP_Customer_Group_2__c = 'COM';
            acct.YI_Partner__c = ST.id;
            acct.YY_Partner__c = ST.id;
            accl.add(acct);
            insert accl;

            account_trigger_functions.setCustomerHierarchyAccount(accl);
			Test.stopTest();
        }
      
        Public static testmethod void TestUpdate_Account_Trigger_Functions8(){
            Test.startTest();
            Profile profile = [select id from profile where name='System Administrator'];
            User u = new User(lastname='Nexeo_Integration User',Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8',  LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = profile.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true,Ashland_Employee_Number__c = 'A123000');
          insert u;
                    SAP_Plant__c sp = new SAP_Plant__c(Ashland_Legacy_Id__c = '234654',Plant_Code__c = '00065');
          insert sp;  
            
            SAP_Industry_Name__c sin = new SAP_Industry_Name__c(Industry_Code__c = '89', Industry_Name__c = 'sdfd');
            insert sin;
            
            SAP_Payment_Term_Explanation__c spte = new SAP_Payment_Term_Explanation__c(Payment_Term_Code__c = '7654');
            insert spte;
            
            SAP_Customer_Group5__c scg5 = new SAP_Customer_Group5__c(Customer_Group5_Code__c = '123', Customer_Group5_Name__c = 'Cool Name');
            insert scg5;
            
                      SAP_Seller__c ss = new SAP_Seller__c(name = 'test',User__c = u.id);
          insert ss;
          
          SAP_Sales_DOG__c ssd = new SAP_Sales_DOG__c (YD_Partner__c = ss.id,YV_Partner__c = ss.id,YO_Partner__c = ss.id);
          insert ssd;
          
          SAP_Territory__c ST = new SAP_Territory__c(Name = 'test', ZS_Partner__c = ss.id, YS_Partner__c = ss.id,SAP_Sales_DOG__c = ssd.id);
          insert ST;
            
            List<Account> accl = new List<Account>();
           Map<ID, Account> oldmap = new  Map<ID, Account>();
           Id cutomerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution RTK Prospect').getRecordTypeId();

            
            Account acct = new Account();
            acct.RecordTypeId = cutomerRecordTypeId;
                acct.SAP_Bill_To_Account_Number__c= 'test1234';
                acct.SAP_Bill_To_Account_Name__c = '12345';
                acct.SAP_Sold_To_Record_Key__c='12345';
                acct.SAP_Sold_To_Account_Number__c='test1';
                acct.SAP_Payer_Account_Number__c = 'test12345';
                acct.SAP_Payer_Account_Key__c = '12345';
                acct.SAP_Bill_To_Record_Key__c = '1234';
                acct.name='TestAccount';
                acct.AccountNumber='123';
                acct.type = 'Vendor';
                acct.SAP_Accounting_Group__c = 'ZVEN';
                acct.VendorUniqueId__c = 'test12345';
            accl.add(acct);
            insert accl;
            acct.Customer_Hierarchy_Number__c = '123';
            acct.SAP_ShippingPlant__c = '00065';
            acct.country_picklist__c = 'United States (US)';
            acct.Prospect_Division__c = 'Nexeo Plastics (32)';
            acct.Prospect_Sales_District__c = 'ADDITIVES (11100)';
            acct.Prospect_Sales_Office__c = 'CM PLASTICS ASIA (3280)';
            acct.Prospect_Sales_Group__c = 'ADVANCED (350)	';
            acct.Prospect_Customer_Group__c = 'ADDITIVES (11)';
            acct.Prospect_Customer_Group1__c = 'CHEMICAL & REFINERY (17)';
   			acct.SAP_Customer_Number__c = '00000126990';
            acct.SAP_Industry_Key__c = '1234';
            acct.SAP_Payment_Terms__c = '1234';
            acct.Type = 'Prospect';
            acct.SAP_Industry_Key__c = '89';
            acct.SAP_Payment_Terms__c = '7654';
            acct.SAP_Customer_Group_5__c = '123';
            acct.YZ_Partner__c = ST.id;
            acct.SAP_Customer_Group_2__c = 'SPC';
            acct.YI_Partner__c = ST.id;
            acct.YY_Partner__c = ST.id;
			update acct;

            account_trigger_functions.setCustomerHierarchyAccount(accl);
            account_trigger_functions.Account_Relationships(accl);
            account_trigger_functions.processAfterInsert(accl);
            account_trigger_functions.processBeforeUpsert(accl,true,oldmap);
			Test.stopTest();
        } 
        
    }