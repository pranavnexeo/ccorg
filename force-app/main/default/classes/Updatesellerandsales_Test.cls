@isTest

Private class Updatesellerandsales_Test{

    Private static testMethod void Updatesellerandsales_isCommodity(){
       Map<String, SObject> testData = NexeoTestUtils_Test.initData();
       Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      
       User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true);
             insert u;
             
         SAP_Seller__c s = new SAP_Seller__c(Name = 'test', user__c = u.id);
          insert s; 
             
         SAP_Territory__c ST = new SAP_Territory__c(Name = 'test', ZS_Partner__c = s.id, YS_Partner__c = s.id);
          insert ST;
             
             
         Account acct = new Account
           (name='TestAccount',
           SAP_Vendor_Purchase_Org__c='1000',
           SAP_Supplier_Number__c='123456',
           VendorUniqueId__c='1234561000',
           Type='Customer',
           SAP_Accounting_Group__c='ZVEN',
           SAP_PartnerFunctionCodeText__c='123456',
           SAP_PartnerFunctionText__c='ZA',
           YY_Partner__c = ST.id , 
           SAP_Customer_Group_2_Desc__c = 'COMMODITY',
           AccountNumber='123',SAP_Sales_Org__c ='1000');
           insert acct;
           
                        
         Material_Sales_Data2__c matlist = new Material_Sales_Data2__c(name = 'Test Material',Material_Group3_Desc__c = 'COMMODITY', Material_Number__c = '12344321', Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',   Record_Key__c = 'Test Record Key');        
            insert matlist;
            
        Contract Ct = new Contract(Name = 'Test',Accountid = acct.id,SAP_Material__c = matlist.id);
        insert Ct;
        
                     
      }
      
       Private static testMethod void Updatesellerandsales_isSpecialty(){
    
       Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      
       User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true);
             insert u;
             id ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
              SAP_Seller__c s = new SAP_Seller__c(Name = 'test', user__c = u.id);
              insert s; 
             
             SAP_Territory__c ST = new SAP_Territory__c(Name = 'test', ZS_Partner__c = s.id, YS_Partner__c = s.id);
             insert ST;
             
             
            Account acct = new Account
           (name='TestAccount',
           SAP_Vendor_Purchase_Org__c='1000',
           SAP_Supplier_Number__c='123456',
           VendorUniqueId__c='1234561000',
           Type='Customer',
           SAP_Accounting_Group__c='ZVEN',
           SAP_PartnerFunctionCodeText__c='123456',
           SAP_PartnerFunctionText__c='ZA',
           YZ_Partner__c = ST.id , 
           SAP_Customer_Group_2_Desc__c = 'SPECIALTY',
           AccountNumber='123');
           insert acct;
             
                  Material_Sales_Data2__c matlist = new Material_Sales_Data2__c(name = 'Test Material', Material_Group3_Desc__c = 'SPECIALTY', Material_Number__c = '12344321', Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',   Record_Key__c = 'Test Record Key');        
        insert matlist;
        
        Contract Ct = new Contract(Name = 'Test',Accountid = acct.id,SAP_Material__c = matlist.id);
        insert Ct;
        
                    
      }
  }