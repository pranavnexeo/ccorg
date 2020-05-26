//Test class for OpportunityOwnerBatch
@isTest
private class OpportunityOwnerBatch_test{
string test= 'test123';

     Public static testmethod void TestThisBatch1(){
     
     List<Opportunity> opplist = new List<Opportunity>();
     
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        Profile p1 = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
        
        User u1 = new User(Alias = 'standt', Email='xxx@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p1.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='jsnbcnbs@testorg.com', IsActive = true);
        insert u1;
        
         SAP_Seller__c s = new SAP_Seller__c(Name = 'test', user__c = u.id);
              insert s; 
             
         SAP_Territory__c ST = new SAP_Territory__c(Name = 'test', ZS_Partner__c = s.id, YS_Partner__c = s.id);
             insert ST;

       /* Account acct = new Account
           (name='TestAccount',
           SAP_Vendor_Purchase_Org__c='1000',
           SAP_Supplier_Number__c='123456',
           VendorUniqueId__c='1234561000',
           Type='Vendor',
           SAP_Accounting_Group__c='ZVEN',
           SAP_PartnerFunctionCodeText__c='123456',
           SAP_PartnerFunctionText__c='ZA',
           YY_Partner__c = ST.id , 
           SAP_Customer_Group_2_Desc__c = 'COMMODITY',
           AccountNumber='123');
           insert acct; */
           
           Account acct1 = new Account
           (name='TestAccount',
           SAP_Vendor_Purchase_Org__c='1000',
           SAP_Supplier_Number__c='123456',
           VendorUniqueId__c='1234561000',
           Type='Vendor',
           SAP_Accounting_Group__c='ZVEN',
           SAP_PartnerFunctionCodeText__c='123456',
           SAP_PartnerFunctionText__c='ZA',
           YZ_Partner__c = ST.id , 
           SAP_Customer_Group_2_Desc__c = 'SPECIALTY',
           AccountNumber='123');
           insert acct1;
           
          /* Opportunity opp = new Opportunity(Country__c='Canada',accountid = acct.id, Name='12345',StageName='close-won',CloseDate=system.today());
           opplist.add(opp);*/
           
           Opportunity opp1 = new Opportunity(Country__c='Canada',accountid = acct1.id, Name='12346',StageName='close-won',CloseDate=system.today());
           opplist.add(opp1);
           
           try{
               insert opplist;
           }catch(DmlException e) {
            }
            
        
        OpportunityOwnerBatch s1 = new OpportunityOwnerBatch('test');
        //ID idBatch = Database.executeBatch(s1);
        try{
               s1.execute(null,opplist);
           }catch(DmlException e) {
            }
        
    
     }

}