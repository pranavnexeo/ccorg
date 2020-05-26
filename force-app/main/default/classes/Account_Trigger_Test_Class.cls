@isTest
private class Account_Trigger_Test_Class  {

//******************
//Test Method 
//******************
  static testMethod void TestMe() {
    
    Account acct1 = new Account();
    Account acct2 = new Account();
    Account acct3 = new Account();
    Account acct4 = new Account();
    Account acct5 = new Account();
    Account acct6 = new Account();
    Account acct7 = new Account();
    
    List<Account> accts = new List<Account>();
    
    //Adding code to prevent have hardcoded IDs
	Map<String, SObject> testData = NexeoTestUtils_Test.initData();  
	User u = (User) testData.get('testUser1');
  
    
    acct1.Name = 'Test 1';
    acct2.Name = 'Test 2';
    acct3.Name = 'Test 3';
    acct4.Name = 'Test 4';
    acct5.Name = 'Test 5';
    
    
    acct1.SAP_Country__c = 'FR';
    acct1.SAP_Partner_Functions__c = 'test';
    acct2.SAP_Country__c = 'US';
    acct2.SAP_Partner_Functions__c = 'SOLD';
    acct5.SAP_Country__c = 'FR';
    
    
    
    acct1.BillingStreet = 'Test1 \n Test2 \n Test3 \n Test4';
    acct4.BillingStreet = '';
    acct4.country_picklist__c = 'US';
    acct4.Prospect_Division__c = 'Chemicals (31)';
    acct4.Prospect_Sales_District__c = 'VP CHEMICALS (36000)';
    acct4.Prospect_Sales_Office__c = 'AHWT DIRECT SLS NA (1092)';
    acct4.Prospect_Sales_Group__c = 'DM US CHEM S CAL (382)';
    acct4.Prospect_Customer_Group__c = 'PULP MILL (1M)';
    acct4.Prospect_Customer_Group1__c = 'PULP MILL (1M)';
    //acct4.Prospect_Customer_Group2__c = 'PULP MILL (1M)';
    acct4.SAP_Sold_To_Account__c = '12345';
    acct4.Sold_To_Customer_Number__c = '12345';
    acct4.SAP_Sold_To_Account_Owner_Name__c = 'Josep Pau Clariana';
    
    acct2.SAP_Customer_Number__c = '12345';
    
    
    acct1.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Prospect','Account');
    acct2.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Customer','Account');
   
    acct3.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Prospect','Account');
    acct4.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Customer','Account');
   
   // acct3.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Aqualon Account','Account');
   // acct4.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Aqualon Prospect','Account');

    accts.add(acct1);
    accts.add(acct2);
    accts.add(acct3);
    accts.add(acct4);
    
    insert accts;
    
    acct6.SAP_Country__c = 'FR';
    acct7.SAP_Country__c = 'FR';
    acct6.Name = 'Test 6';
    acct7.Name = 'Test 7';
    acct6.parentid = acct5.id;
    acct7.parentid = acct5.id;
    acct6.BillingStreet = '';
    acct6.country_picklist__c = 'US';
    acct6.Prospect_Division__c = 'Chemicals (31)';
    acct6.Prospect_Sales_District__c = 'VP CHEMICALS (36000)';
    acct6.Prospect_Sales_Office__c = 'AHWT DIRECT SLS NA (1092)';
    acct6.Prospect_Sales_Group__c = 'DM US CHEM S CAL (382)';
    acct6.Prospect_Customer_Group__c = 'PULP MILL (1M)';
    acct6.Prospect_Customer_Group1__c = 'PULP MILL (1M)';
    //acct6.Prospect_Customer_Group2__c = 'PULP MILL (1M)';
    
    acct6.SAP_Sold_To_Account_Id__C = '001E000000H67gH';
    acct6.SAP_Sold_To_Account_Owner__c = u.Id ;
    acct6.SAP_Sold_To_Account__c = '12365';
    acct6.Sold_To_Customer_Number__c = '12365';
    acct6.SAP_Sold_To_Account_Owner_Name__c = 'Josep Pau Clariana';
    acct7.BillingStreet = '';
    acct7.country_picklist__c = 'US';
    acct7.Prospect_Division__c = 'Chemicals (31)';
    acct7.Prospect_Sales_District__c = 'VP CHEMICALS (36000)';
    acct7.Prospect_Sales_Office__c = 'AHWT DIRECT SLS NA (1092)';
    acct7.Prospect_Sales_Group__c = 'DM US CHEM S CAL (382)';
    acct7.Prospect_Customer_Group__c = 'PULP MILL (1M)';
    acct7.Prospect_Customer_Group1__c = 'PULP MILL (1M)';
    //acct7.Prospect_Customer_Group2__c = 'PULP MILL (1M)';
    acct7.SAP_Sold_To_Account__c = '12375';
    acct7.Sold_To_Customer_Number__c = '12375';
    acct7.SAP_Sold_To_Account_Owner_Name__c = 'Josep Pau Clariana';
    acct1.SAP_Partner_Functions__c  = 'Ship To,Sold To';
    acct7.SAP_Sales_Org__c = '1000';
    acct7.SAP_DistChannel__c = '30';
    acct7.SAP_DivisionCode__c = '31';
    acct7.AccountNumber = '0000427067';
    acct7.SAP_Bill_To_Account_Number__c = '0000427067';
    acct7.SAP_Bill_To_Record_Key__c = '000042706710003031';
    acct7.SAP_Payer_Account_Number__c = '0000427067';
    acct7.SAP_Payer_Account_Key__c = '000042706710003031';
    acct7.SAP_Sold_To_Account_Number__c = '0000427067';
    acct7.SAP_Sold_To_Record_Key__c = '000042706710003031';
    acct7.SAP_Customer_Group_5__c = '200';
    acct7.Customer_Hierarchy_Number__c = '100';
    acct7.SAP_Industry_Key__c = '190';
    acct7.SAP_Payment_Terms__c = 'ZTERM';
    acct7.SAP_Industry_Key_Desc__c = '199';
    acct7.SAP_Payment_Terms_Desc__c = 'Test';
    List<Account> accts1 = new List<Account>();
    
     accts1.add(acct6);
     accts1.add(acct7);
     
    insert accts1;
    update accts;
    Account_Trigger_Functions.PopulateAccountDetails(accts);
    Account_Trigger_Functions.processAfterInsert(accts);
    
    delete accts;
  }

//The End
}