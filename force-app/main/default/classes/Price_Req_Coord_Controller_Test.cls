@isTest
private class Price_Req_Coord_Controller_Test {
public static testMethod void testpricerequestcoord() {
try{
Profile profile = [select id from profile where name='System Administrator'];
User user = new User(alias = 'standt', email='standarduser@testorg.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = profile.Id,Price_Coord_Region__c='US', 
            timezonesidkey='America/Los_Angeles', username='supplierMain@testorg.com');
            insert user;
Account acct = new Account(name='TestAccount',Type='Prospect');
insert acct; 
           
Price_Request_Transaction__c PRT=new Price_Request_Transaction__c(Inner_Table__c='Test',Ship_To__c=acct.id,Sold_To__c=acct.id, Approval_Status__c='Pending Entry',Type__c='Quote');    
insert PRT;

Price_Request_Transaction__c PRT4 =new Price_Request_Transaction__c(Inner_Table__c='Test',Ship_To__c=acct.id,Sold_To__c=acct.id, Approval_Status__c='Pending Entry',Type__c='CSP');    
insert PRT4;

Price_Request_Transaction__c PRT5 =new Price_Request_Transaction__c(Inner_Table__c='Test',Ship_To__c=acct.id,Sold_To__c=acct.id, Approval_Status__c='Pending Entry',Type__c='CSP');    
insert PRT5;

//Price_Request_Transaction__c PRT6 =new Price_Request_Transaction__c(Inner_Table__c='Test',Ship_To__c=acct.id,Sold_To__c=acct.id, Approval_Status__c='Pending Entry',Type__c='Expired CSP');    
//insert PRT6;


//Price_Request_Transaction__c PRT7 =new Price_Request_Transaction__c(Inner_Table__c='Test',Ship_To__c=acct.id,Sold_To__c=acct.id,Approval_level__c = 'Exception 1', Approval_Status__c = 'Submitted',Type__c='CSP');    
//insert PRT7;

List <Id> list1 = new List <Id>();

list1.add(PRT5.Id);
//list1.add(PRT7.Id);

List <Id> list2 = new List <Id>();
list2.add(PRT5.Id);

List <Price_Request_Transaction__c> PRTlist = new List <Price_Request_Transaction__c>();
PRTlist.add(PRT);
List <Price_Request_Transaction__c> PRT1 = new List <Price_Request_Transaction__c>();
Map<String, string> wheres = new Map<String, String>(); 

List<String> Idlist=new List<String>();
List<String> Idlist1=new List<String>();
Idlist1.add(PRT4.Id);
//Idlist1.add(PRT7.Id);


Price_Req_Coord_Controller.CloseRecords(Idlist);

Price_Req_Coord_Controller.SendSAP(Idlist1);
Price_Req_Coord_Controller.expirePRT(list2);
Price_Req_Coord_Controller.getComboGridData('test','Price_Request_Transaction__c','Approval_Status__c','Approval_Status__c!=null','name','100');
Price_Req_Coord_Controller.ExpiryRequest expReq = new Price_Req_Coord_Controller.ExpiryRequest();
expReq.soldtonumber='12345';
}catch(exception e){}

}

public static testMethod void testpricerequestcoord2() {
try{
Profile profile = [select id from profile where name='System Administrator'];
User user = new User(alias = 'standt', email='standarduser@testorg.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = profile.Id,Price_Coord_Region__c='US', 
            timezonesidkey='America/Los_Angeles', username='supplierMain@testorg.com');
            insert user;
Account acct = new Account(name='TestAccount',Type='Prospect');
insert acct; 
           
Price_Request_Transaction__c PRT=new Price_Request_Transaction__c(Inner_Table__c='Test',Ship_To__c=acct.id,Sold_To__c=acct.id, Approval_Status__c='Pending Entry',Type__c='Quote');    
insert PRT;

Price_Request_Transaction__c PRT4 =new Price_Request_Transaction__c(Inner_Table__c='Test',Ship_To__c=acct.id,Sold_To__c=acct.id, Approval_Status__c='Pending Entry',Type__c='CSP');    
insert PRT4;

Price_Request_Transaction__c PRT5 =new Price_Request_Transaction__c(Inner_Table__c='Test',Ship_To__c=acct.id,Sold_To__c=acct.id, Approval_Status__c='Pending Entry',Type__c='CSP');    
insert PRT5;

Price_Request_Transaction__c PRT6 =new Price_Request_Transaction__c(Inner_Table__c='Test',Ship_To__c=acct.id,Sold_To__c=acct.id, Approval_Status__c='Pending Entry',Type__c='Expired CSP');    
insert PRT6;


//Price_Request_Transaction__c PRT7 =new Price_Request_Transaction__c(Inner_Table__c='Test',Ship_To__c=acct.id,Sold_To__c=acct.id,Approval_level__c = 'Exception 1', Approval_Status__c = 'Submitted',Type__c='CSP');    
//insert PRT7;

List <Id> list1 = new List <Id>();

list1.add(PRT5.Id);
list1.add(PRT6.Id);

List <Id> list2 = new List <Id>();
list2.add(PRT5.Id);

List <Price_Request_Transaction__c> PRTlist = new List <Price_Request_Transaction__c>();
PRTlist.add(PRT);
List <Price_Request_Transaction__c> PRT1 = new List <Price_Request_Transaction__c>();
Map<String, string> wheres = new Map<String, String>(); 
PRT1 = Account_Material_Functions.upsertTransactions(PRTlist , wheres, 'Coordinator');       
Price_Req_Coord_Controller controller=new Price_Req_Coord_Controller();

}catch(exception e){}




}

public static testMethod void testpricerequestcoord3() {

Profile profile = [select id from profile where name='System Administrator'];
User user = new User(alias = 'standt', email='standarduser@testorg.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = profile.Id,Price_Coord_Region__c='US', 
            timezonesidkey='America/Los_Angeles', username='supplierMain@testorg.com');
            insert user;
Account acct = new Account(name='TestAccount',Type='Prospect');
insert acct; 
           
Price_Request_Transaction__c PRT=new Price_Request_Transaction__c(Inner_Table__c='Test',Ship_To__c=acct.id,Sold_To__c=acct.id, Approval_Status__c='Pending Entry',Type__c='Quote');    
insert PRT;

Price_Request_Transaction__c PRT4 =new Price_Request_Transaction__c(Inner_Table__c='Test',Ship_To__c=acct.id,Sold_To__c=acct.id, Approval_Status__c='Pending Entry',Type__c='CSP');    
insert PRT4;

Price_Request_Transaction__c PRT5 =new Price_Request_Transaction__c(Inner_Table__c='Test',Ship_To__c=acct.id,Sold_To__c=acct.id, Approval_Status__c='Pending Entry',Type__c='CSP');    
insert PRT5;

Price_Request_Transaction__c PRT6 =new Price_Request_Transaction__c(Inner_Table__c='Test',Ship_To__c=acct.id,Sold_To__c=acct.id, Approval_Status__c='Pending Entry',Type__c='Expired CSP');    
insert PRT6;


Price_Request_Transaction__c PRT7 =new Price_Request_Transaction__c(Inner_Table__c='Test',Ship_To__c=acct.id,Sold_To__c=acct.id,Approval_level__c = 'Exception 1', Approval_Status__c = 'Submitted',Type__c='CSP');    
insert PRT7;

List <Id> list1 = new List <Id>();

list1.add(PRT5.Id);
list1.add(PRT6.Id);

List <Id> list2 = new List <Id>();
list2.add(PRT5.Id);

List <Price_Request_Transaction__c> PRTlist = new List <Price_Request_Transaction__c>();
PRTlist.add(PRT);
List <Price_Request_Transaction__c> PRT1 = new List <Price_Request_Transaction__c>();
Map<String, string> wheres = new Map<String, String>(); 
List<formData> data=new List<formData>();
List<String> RequestIds=new List<String>();
List<String> Idlist2 = new List<String>();
Idlist2.add(PRT7.Id);
Price_Req_Coord_Controller.SimulateForm(Idlist2,data,'simulate');
Price_Req_Coord_Controller.SimulateForm(RequestIds,data,'savesubmit'); 
Price_Req_Coord_Controller.fetchPendingEntries();
Price_Req_Coord_Controller.getDateFormat();

}

}