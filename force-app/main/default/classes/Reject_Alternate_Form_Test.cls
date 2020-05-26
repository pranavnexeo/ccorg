@istest(seeAlldata=false)
public class Reject_Alternate_Form_Test{

    public static testMethod void rejectalternateform() {
    Profile profile = [select id from profile where name='System Administrator'];
User user = new User(alias = 'standt', email='standarduser@testorg.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = profile.Id,Price_Coord_Region__c='US', 
            timezonesidkey='America/Los_Angeles', username='supplierMain@testorg.com');
            insert user;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true,Ashland_Employee_Number__c = 'A123000');
          insert u;
        nexPrice_Settings__c obj = new nexPrice_Settings__c(name='test');
       obj.Mini_EndPoint__c='https://google.com/v1';
       insert obj;
Account acct = new Account(name='TestAccount',SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Vendor',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA',AccountNumber='123');
insert acct;
system.debug('----acct----'+acct.AccountNumber);

Account_Material__c am=new Account_Material__c(Account__c=acct.id);
insert am; 
system.debug('----am----'+am.id);
system.debug('----am----'+am.Account__r.AccountNumber);                
Price_Request_Transaction__c PRT=new Price_Request_Transaction__c(Inner_Table__c='Test',Account_Material__c=am.id,Ship_To__c=acct.id,Sold_To__c=acct.id, Approval_Status__c='Pending Entry',Type__c='Quote');    
insert PRT; 
system.debug('----PRT.id---'+PRT.id);
SAP_Price__c SP=new SAP_Price__c(Price_Request_Transaction__c=PRT.id,type__c = 'Requested');
insert SP; 
SAP_Price__c SP1=new SAP_Price__c(Price_Request_Transaction__c=PRT.id,type__c = 'Alternate');
insert SP1; 
SAP_Price_Tier__c SPT=new SAP_Price_Tier__c(SAP_Price__c=SP.id,price__c = 2, volume__c = 2);
insert SPT;
SAP_Price_Tier__c SPT1=new SAP_Price_Tier__c(SAP_Price__c=SP1.id,price__c = 2, volume__c = 2);
insert SPT1;
system.debug('----PRT.id----'+PRT.id);
       String ids='PRT.id'; 
       List <Price_Request_Transaction__c> prtrec = new List <Price_Request_Transaction__c>();
       prtrec.add(PRT);
       List<double> t = new List<double> ();
       ApexPages.currentPage().getParameters().put('ids', PRT.Id);
       //Test.setCurrentPage(Page.Reject_Alternate_Form);
       Reject_Alternate_Form con=new Reject_Alternate_Form();
       con.FormOnLoad();
       Reject_Alternate_Form.Stringtodouble('125.34');
       Reject_Alternate_Form.Stringtodouble('1000000.231');
       Reject_Alternate_Form.Stringtodouble(100000000.23);
       Reject_Alternate_Form.Stringtodouble('10-23');
       Reject_Alternate_Form.Stringtodouble(10);
       Reject_Alternate_Form.Stringtodouble('');
       //con.FormOnLoad();
       con.Date_Today = 'test';
       con.Date_One_Year = 'test';
       con.reqtier = 'test';
       con.psrsupplier= 'test';
       con.aggrnum= 'test';
       con.plantid= 'test';
       con.plantname= 'test';
       con.psfreight = 'test';
       con.suppPrice= 3.14159;
       con.suppdisc1= 3.14159;
       con.Tiers = t;
       con.transactions = prtrec;
       con.disc1type='test';
       con.disc2type = 'test1';
       }
   
}