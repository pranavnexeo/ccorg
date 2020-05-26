@isTest
public with sharing class Pending_With_Seller_Test{
public static testMethod void testPendingWithSeller() {
String RequestId;
String comments;
 String approvereject;
Profile profile = [select id from profile where name='System Administrator'];

User user = new User(alias = 'standt', email='standarduser@testorg.com', 
            emailencodingkey='UTF-8', lastname='Nexeo_Integration User', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = profile.Id,Price_Coord_Region__c='US', 
            timezonesidkey='America/Los_Angeles', username='supplierMain@testorg.com');
            insert user;

Account acct = new Account(name='Test', SAP_Sales_Org__c='1000',SAP_Customer_Number__c='123456',Type='Customer',CurrencyIsoCode='USD');
insert acct;            

Price_Request_Transaction__c PRT=new Price_Request_Transaction__c(Inner_Table__c='Test',Ship_To__c=acct.id,Sold_To__c=acct.id, Approval_Status__c='Submitted',Type__c='Quote');    
insert PRT;  

Set<Id> splitstrings = new Set<Id>();
Pending_With_Seller pws = new Pending_With_Seller();
Pending_With_Seller.fetchPendingWithSeller(10,user.id);
Pending_With_Seller.fetchPendingWithSeller(0,'');

// List<String> RequestIds=new List<String>();

set<String>types = new set<String>{'Requested', 'Alternate'};

List<SAP_Price__c> sapprices = new List<SAP_Price__c>();
//sapprices.type__c = types.id;
//sapprices.Price_Request_Transaction__c = '';
 
//Pending_With_Seller.approveRejectChange(PRT.id,'Test','Approve'); 
//Pending_With_Seller.sellerApprovalActions(splitstrings ,'Test','Approve');
Pending_With_Seller.getComboGridData('test','Price_Request_Transaction__c','Approval_Status__c','Approval_Status__c!=null','name','100');
Pending_With_Seller.getDateFormat();
Approval.ProcessSubmitRequest psr = new Approval.ProcessSubmitRequest();
            psr.setObjectId(PRT.Id);
            psr.setNextApproverIds(new Id[]{user.Id});
            List<Id> newWorkItemIds = Approval.process(psr).getNewWorkitemIds();
            List<ProcessInstanceWorkitem> workitems = [Select Id, ProcessInstanceId, ProcessInstance.Status, ProcessInstance.TargetObjectId, ActorId, OriginalActorId, CreatedById, CreatedDate from ProcessInstanceWorkitem where Id In :newWorkItemIds];
            
Pending_With_Seller.approveRejectChange(PRT.id,'test123', 'Approve');
           
            
            
        
}
}