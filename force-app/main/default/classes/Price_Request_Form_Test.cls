@istest(seeAlldata=false)
public class Price_Request_Form_Test{

      public static testMethod void pricerequestform() {
          
        //Adding code to prevent have hardcoded IDs
        Map<String, SObject> testData = NexeoTestUtils_Test.initData();
          
           Profile profile = [select id from profile where name='System Administrator'];
User user = new User(alias = 'standt', email='standarduser@testorg.com', 
            emailencodingkey='UTF-8', lastname='Nexeo_Integration User', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = profile.Id,Price_Coord_Region__c='US', 
            timezonesidkey='America/Los_Angeles', username='supplierMain@testorg.com');
            insert user;
Account acct = new Account(name='TestAccount',SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Vendor',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA',AccountNumber='123');
insert acct;
system.debug('----acct----'+acct.AccountNumber);

Material_Sales_Data2__c m = new Material_Sales_Data2__c(name = 'Test Material', Material_Number__c = '12344321', Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',   Record_Key__c = 'Test Record Key');        
insert m;

Account_Material__c am=new Account_Material__c(Account__c=acct.id,SAP_Material__c = m.id);
insert am;


Account_Material__c am1=new Account_Material__c(Account__c=acct.id,SAP_Material__c = m.id);
insert am1;

PageReference pageRef = Page.nexprice_12;
           Test.setCurrentPage(pageRef);
           String amID = am.id+'-'+am1.id;
           apexpages.currentpage().getparameters().put('ids',amID); 
           apexpages.currentpage().getparameters().put('opt','Quote'); 
           Price_Request_Form con = new Price_Request_Form();
//List<Account_Material__c> amlist = new List<Account_Material__c>();
//amlist.add(am); 
system.debug('----am----'+am.id);
system.debug('----am----'+am.Account__r.AccountNumber);                
Price_Request_Transaction__c PRT=new Price_Request_Transaction__c(Inner_Table__c='Test',Account_Material__c=am.id,Ship_To__c=acct.id,Sold_To__c=acct.id, Approval_Status__c='Pending Entry',Type__c='Quote');    
insert PRT; 
system.debug('----PRT.id---'+PRT.id);
SAP_Price__c SP=new SAP_Price__c(Price_Request_Transaction__c=PRT.id,type__c = 'Requested');
insert SP; 
SAP_Price__c SP1=new SAP_Price__c(Price_Request_Transaction__c=PRT.id,type__c = 'Alternate');
insert SP1; 
SAP_Price_Tier__c SPT=new SAP_Price_Tier__c(SAP_Price__c=SP.id);
insert SPT;
SAP_Price_Tier__c SPT1=new SAP_Price_Tier__c(SAP_Price__c=SP1.id);
insert SPT1;
system.debug('----PRT.id----'+PRT.id);
       String ids='PRT.id'; 
       List <Price_Request_Transaction__c> prtrec = new List <Price_Request_Transaction__c>();
       prtrec.add(PRT);
       
          Price_Request_Form.Stringtodouble('125.34');
          Price_Request_Form.Stringtodouble('1000000.231');
          Price_Request_Form.Stringtodouble(100000000.23);
          Price_Request_Form.Stringtodouble('10-23');
          Price_Request_Form.Stringtodouble(10);
          Price_Request_Form.Stringtodouble('');
          
          Price_Request_Form prf = new Price_Request_Form();
          prf.type = 'test';
          prf.eavuom = 'test1';
          prf.getFreightTerms2();
          prf.eoq = 3.14159;
          prf.psrsupplier ='test11';
          prf.aggrnum='test11';
          prf.plantid='test11';
          prf.psfreight='test11';
          prf.suppPrice= 3.14159;
          prf.suppdisc1= 3.14159;
          prf.plantname ='test';
          prf.upfront = 'test12';
          prf.disc1type= 'test1';
          prf.disc2type= 'test13';
          prf.psruom= 'test11';
          
      }
       public static testMethod void pricerequestform1() {
                //Adding code to prevent have hardcoded IDs
        Map<String, SObject> testData = NexeoTestUtils_Test.initData();
           
       Account acct = new Account(name='TestAccount',SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Vendor',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA',AccountNumber='123');
insert acct;
system.debug('----acct----'+acct.AccountNumber);

Material_Sales_Data2__c m = new Material_Sales_Data2__c(name = 'Test Material', Material_Number__c = '12344321', Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',   Record_Key__c = 'Test Record Key');        
insert m;
       Account_Material__c am=new Account_Material__c(Account__c=acct.id,SAP_Material__c = m.id);
       insert am;


        Account_Material__c am1=new Account_Material__c(Account__c=acct.id,SAP_Material__c = m.id);
        insert am1;
       PageReference pageRef = Page.nexprice_12;
           Test.setCurrentPage(pageRef);
           String amID = am.id+'-'+am1.id;
           apexpages.currentpage().getparameters().put('ids',amID); 
           apexpages.currentpage().getparameters().put('opt','CSP'); 
           Price_Request_Form con = new Price_Request_Form();
       }
       public static testMethod void pricerequestform2() {
                    //Adding code to prevent have hardcoded IDs
        Map<String, SObject> testData = NexeoTestUtils_Test.initData();
           
      Account acct = new Account(name='TestAccount',SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Vendor',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA',AccountNumber='123');
insert acct;
system.debug('----acct----'+acct.AccountNumber);

Material_Sales_Data2__c m = new Material_Sales_Data2__c(name = 'Test Material', Material_Number__c = '12344321', Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',   Record_Key__c = 'Test Record Key');        
insert m;
      Account_Material__c am=new Account_Material__c(Account__c=acct.id,SAP_Material__c = m.id);
       insert am;


        Account_Material__c am1=new Account_Material__c(Account__c=acct.id,SAP_Material__c = m.id);
        insert am1;
        
        SAP_Price_Support__c sps = new SAP_Price_Support__c(Agreement_Number__c ='test', Supplier_Name__c = 'test1',Supplier_Number__c='abc',Supplier_Supported_Price__c=10.2,X1st_Discount_Sell__c =10.21,Region_Code__c='testg',Region_Description__c='testing');
        insert sps;
       PageReference pageRef = Page.nexprice_12;
           Test.setCurrentPage(pageRef);
           String amID = am.id+'-'+am1.id;
           apexpages.currentpage().getparameters().put('ids',amID); 
           apexpages.currentpage().getparameters().put('opt','RFQ'); 
           Price_Request_Form con = new Price_Request_Form();
           List<Price_Request_Transaction__c> prts = new List<Price_Request_Transaction__c>();
           con.transactions = prts;
       }
}