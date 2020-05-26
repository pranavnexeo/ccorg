@isTest(seeAlldata=false)
public class CSP_Reject_Alternate_Form_Test{ 
static Account acct;
static Account_Material__c am;
static Price_Request_Transaction__c PRT;
static Price_Request_Transaction__c PRT1;
static Price_Request_Transaction__c PRT2;

   public static testMethod void csprejectalternateform() {
     Profile profile = [select id from profile where name='System Administrator'];
User user = new User(alias = 'standt', email='standarduser@testorg.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = profile.Id,Price_Coord_Region__c='US', 
            timezonesidkey='America/Los_Angeles', username='supplierMain@testorg.com');
            insert user;
User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId =profile.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true,Ashland_Employee_Number__c = 'A123000');
          insert u;
       
       nexPrice_Settings__c obj = new nexPrice_Settings__c(name='test');
       obj.Mini_EndPoint__c='https://google.com/v1';
       insert obj;
acct = new Account
       (name='TestAccount',
       SAP_Vendor_Purchase_Org__c='1000',
       SAP_Supplier_Number__c='123456',
       VendorUniqueId__c='1234561000',
       Type='Vendor',
       SAP_Accounting_Group__c='ZVEN',
       SAP_PartnerFunctionCodeText__c='123456',
       SAP_PartnerFunctionText__c='ZA',
       AccountNumber='123');
insert acct;


am = new Account_Material__c
       (Account__c=acct.id);
insert am; 
               
PRT = new Price_Request_Transaction__c
    (Inner_Table__c='Test',Account_Material__c=am.id,Ship_To__c=acct.id,Sold_To__c=acct.id, Approval_Status__c='Rejected with Alternate',Type__c='CSP',Requested_Effective_Date__c = system.today(),Requested_Expiration_Date__c = system.today());    
insert PRT; 

PRT1 = new Price_Request_Transaction__c
    (Inner_Table__c='Test1',Account_Material__c=am.id,Ship_To__c=acct.id,Sold_To__c=acct.id, Approval_Status__c='Rejected with Alternate',Type__c='CSP',Requested_Effective_Date__c = system.today(),Requested_Expiration_Date__c = system.today());    
insert PRT1; 

PRT2 = new Price_Request_Transaction__c
    (Inner_Table__c='Test2',Account_Material__c=am.id,Ship_To__c=acct.id,Sold_To__c=acct.id, Approval_Status__c='Rejected with Alternate',Type__c='CSP');    
insert PRT2;

SAP_Price__c SP=new SAP_Price__c(Price_Request_Transaction__c=PRT.id,type__c = 'Requested');
insert SP; 
SAP_Price__c SP1=new SAP_Price__c(Price_Request_Transaction__c=PRT.id,type__c = 'Alternate');
insert SP1; 
SAP_Price_Tier__c SPT=new SAP_Price_Tier__c
                      (SAP_Price__c=SP.id,
                       price__c = 2, 
                       volume__c = 2,
                       price_uom__c ='LB',
                       volume_uom__c = 'KG',  
                       Effective_Date__c = Date.today(), 
                       Expiration_Date__c = Date.today(), 
                       currencyisocode = 'USD' );
insert SPT;
SAP_Price_Tier__c SPT1=new SAP_Price_Tier__c(SAP_Price__c=SP1.id,price__c = 2, volume__c = 2);
insert SPT1;

       String ids=PRT.id+'-'+PRT1.Id+'-'+PRT2.Id; 
       List <Price_Request_Transaction__c> prtrec = new List <Price_Request_Transaction__c>();
       prtrec.add(PRT);
       
       
       PageReference pageRef = Page.nexprice_12;
           Test.setCurrentPage(pageRef);
           
           apexpages.currentpage().getparameters().put('ids',PRT.id); 
           apexpages.currentpage().getparameters().put('opt','CSP'); 
           apexpages.currentpage().getparameters().put('mat',am.id);
       
       List<Price_Request_Transaction__c> p = new List<Price_Request_Transaction__c>();
       List<double> db = new List<double>();
       
       CSP_Reject_Alternate_Form craf=new CSP_Reject_Alternate_Form();
       CSP_Reject_Alternate_Form.pacCode = '';
       craf.FormOnLoad();
       craf.Date_Today='test';
       craf.Date_One_Year='test1';
       craf.transactions=p;
       craf.Tiers = db;
       craf.reqtier='test';
       
       CSP_Reject_Alternate_Form.Stringtodouble('125.34');
       CSP_Reject_Alternate_Form.Stringtodouble('1000000.231');
       CSP_Reject_Alternate_Form.Stringtodouble(100000000.23);
       CSP_Reject_Alternate_Form.Stringtodouble('10-23');
       CSP_Reject_Alternate_Form.Stringtodouble(10);
       CSP_Reject_Alternate_Form.Stringtodouble('');
       
       
       }
   
     
  

}