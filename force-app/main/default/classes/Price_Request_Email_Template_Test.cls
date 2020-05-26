@isTest
private class Price_Request_Email_Template_Test {
 static testMethod void myUnitTest() {
 Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
 Price_Request_Email_Template pr = new Price_Request_Email_Template();
 Account acct = new Account(name='TestAccount',SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Vendor',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA',AccountNumber='123');
 insert acct;
 Material_Sales_Data2__c m = new Material_Sales_Data2__c(name = 'Test Material', Material_Number__c = '12344321', Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',   Record_Key__c = 'Test Record Key');        
 insert m;
 Account_Material__c am=new Account_Material__c(Account__c=acct.id,SAP_Material__c = m.id);
 insert am;
 Price_Request_Transaction__c pTran =new Price_Request_Transaction__c(corporate_account__c = acct.id, CurrencyIsoCode ='USD',Inner_Table__c='Test',Account_Material__c=am.id,Ship_To__c=acct.id,Sold_To__c=acct.id, Approval_Status__c='Pending Entry',Type__c='Quote');    
 insert pTran;
 SAP_Price__c sPrice = new SAP_Price__c(Type__c ='Requested',Price_Request_Transaction__c =pTran.id);
 insert sPrice;
 SAP_Price_Support__c sp = new SAP_Price_Support__c(Customer_Name__c = acct.id,Agreement_Number__c = '0039943564',Effective_Date__c=system.today());
 insert sp ;
 pr.recordid =pTran.Id;
 pr.gettrans();
 pr.getRequested_History();
 pr.getCSP_History();
 pr.getTarget_Tiers();
 pr.getRequested_Tiers();
 pr.getTarget_History();
 pr.getCSP_Tiers();
 pr.getAlternate_Tiers();
 pr.getPriceSupports();
 pr.AppComments = 'test';
}
}