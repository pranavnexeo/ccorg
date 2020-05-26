@isTest
 Public Class BlankUpdateCPI_Test{
  
      Public static testmethod void TestBatch(){
      
      //Account a = new Account(name = 'Test Account', sap_salesgroup__c = '1000',sap_city__c = 'Newyork',SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Vendor',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA',AccountNumber='123');
      //insert a;
      Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
       Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution Customer').getRecordTypeId();
      Account a = new Account(Name = 'Test',RecordtypeId=RecordTypeId,SAP_Sales_Org__c = 'Test', SAP_DivisionCode__c = 'Test', SAP_Industry_Key__c ='Test',HQ_Sales_Office__c = 'Test', SAP_SalesGroup__c = 'Test');
      insert a;
       
      Material_Sales_Data2__c matlist = new Material_Sales_Data2__c(name = 'Test Material', Material_Number__c = '12344321', Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',   Record_Key__c = 'Test Record Key');        
      insert matlist;
      
      SAP_Plant__c sp = new SAP_Plant__c(Ashland_Legacy_Id__c = '234654',Plant_Code__c = 'w0077');
      insert sp;
      
      SAP_INCO_Term__c sit = new SAP_INCO_Term__c(INCO_Term_Code__c = '784',Ashland_Legacy_Id__c = '12234',Language_Code__c ='US');
      insert sit;
      
      List<sObject> CPItoUpdate = new List<sObject>();
      Customer_Product_Info__c cpi = new Customer_Product_Info__c(Sales_Org_Code__c = '1000',Material_Number__c = '098765',Distribution_Channel_Code__c = '30',Customer_Number__c = '09876',CPI_Record_Type__c = 'r',Chem_Account__c = a.id,CPI_Account__c = a.id,Record_Key__c = '12243545',SAP_INCO_Term__c =sit.id,SAP_Material__c = matlist.id, SAP_Plant__c = sp.id);
      insert cpi;
      CPItoUpdate.add(cpi);
      
      BlankUpdateCPI atb = new BlankUpdateCPI();
      ID idBatch = Database.executeBatch(atb);
      atb.execute(null,CPItoUpdate); 
      
      
      }
      
 }