@isTest
private class Price_Req_Appr_Controller_Test {
public static testMethod void testpricerequestcoord1() {
    Role_Reportee__c rr = new Role_Reportee__c(user__c = userinfo.getuserid(),role__c = 'AD Sales' );
    Price_Request_Approver__c pa = new Price_Request_Approver__c(Approver__c = userinfo.getuserid());
    insert pa;
    insert rr;
    List<String> RequestIds=new List<String>();
    Profile profile = [select id from profile where name='System Administrator'];
    User user = new User(alias = 'standt', email='standarduser@testorg.com', 
                emailencodingkey='UTF-8', lastname='Nexeo_Integration User', languagelocalekey='en_US', 
                localesidkey='en_US', profileid = profile.Id,Price_Coord_Region__c='US', 
                timezonesidkey='America/Los_Angeles', username='supplierMain@testorg.com');
                insert user;
    Account acct = new Account(name='Test');
    insert acct;
    
    
    Price_Request_Transaction__c PRT=new Price_Request_Transaction__c(Inner_Table__c='Test',Ship_To__c=acct.id,Sold_To__c=acct.id, Approval_Status__c='Pending Entry',Type__c='Quote');    
    insert PRT; 
    RequestIds.add(PRT.Id);
    Date YEAR_AGO = system.today()-365;
    Price_Request_Transaction__c PRTdata =new Price_Request_Transaction__c(Approver__c = userinfo.getuserid(),Approval_Backup__c = userinfo.getuserid(),Inner_Table__c='Test',Ship_To__c=acct.id,Sold_To__c=acct.id, Approval_Status__c= 'Submitted',Type__c= 'CSP',CreatedDate = YEAR_AGO);    
    insert PRTdata; 
    RequestIds.add(PRTdata.Id); 
    Price_Request_Transaction__c PRT1data =new Price_Request_Transaction__c(Approver__c = userinfo.getuserid(),Approval_Backup__c = userinfo.getuserid(),Inner_Table__c='Test',Ship_To__c=acct.id,Sold_To__c=acct.id, Approval_Status__c= 'Submitted',Type__c= 'CSP',CreatedDate = YEAR_AGO);    
    insert PRT1data; 
    RequestIds.add(PRT1data.Id);  
    
    SAP_Price__c SP = new SAP_Price__c();
    SAP_Price__c SP1 = new SAP_Price__c();
    SAP_Price__c SP2 = new SAP_Price__c();
    SAP_Price_Tier__c SPT = new SAP_Price_Tier__c();
    SAP_Price_Tier__c SPT1 = new SAP_Price_Tier__c();
    SAP_Price_Tier__c SPT2 = new SAP_Price_Tier__c();
    
    SP=new SAP_Price__c(Price_Request_Transaction__c=PRT1data.id,type__c = 'Requested');
    insert SP; 
    SP1=new SAP_Price__c(Price_Request_Transaction__c=PRT1data.id,type__c = 'Alternate');
    insert SP1; 
    SP2=new SAP_Price__c(Price_Request_Transaction__c=PRTdata.id,type__c = 'Requested');
    insert SP2; 
    
    SPT=new SAP_Price_Tier__c(SAP_Price__c=SP.id);
    insert SPT;
    SPT1=new SAP_Price_Tier__c(SAP_Price__c=SP1.id);
    insert SPT1;
    SPT2=new SAP_Price_Tier__c(SAP_Price__c=SP2.id);
    insert SPT2;
    
    Price_Req_Appr_Controller controller = new Price_Req_Appr_Controller();
    Price_Req_Appr_Controller.FetchApprovalTable(); 
    Price_Req_Appr_Controller.getDateFormat();
    
    List<formData> data=new List<formData>();
    
    Price_Req_Appr_Controller.SimulateForm(RequestIds,data,'simulate','test');
    String FullName = userinfo.getLastName()+','+' '+ userinfo.getFirstName();
    
    List<String> Idlist=new List<String>();
    Price_Req_Appr_Controller.reassignupdate(PRT.Id,FullName);
    Price_Req_Appr_Controller.getApproversList('i');
    Price_Req_Appr_Controller.getComboGridData('test','Price_Request_Transaction__c','Approval_Status__c','Approval_Status__c!=null','name','100');
    Price_Req_Appr_Controller.approverecords(PRT1data.Id,'test');
    Price_Req_Appr_Controller.pendingsupplier('test');
    Price_Req_Appr_Controller.psrSubmitForm(PRT.id,data); //Spuran: added correct input parameters for the method for more coverage
    
   }
   
   static testMethod void myUnitTest2(){
   
   Role_Reportee__c rr = new Role_Reportee__c(user__c = userinfo.getuserid(),role__c = 'AD Sales' );
    Price_Request_Approver__c pa = new Price_Request_Approver__c(Approver__c = userinfo.getuserid());
    insert pa;
    insert rr;
    List<String> RequestIds=new List<String>();
    Profile profile = [select id from profile where name='System Administrator'];
    User user = new User(alias = 'standt', email='standarduser@testorg.com', 
                emailencodingkey='UTF-8', lastname='Nexeo_Integration User', languagelocalekey='en_US', 
                localesidkey='en_US', profileid = profile.Id,Price_Coord_Region__c='US', 
                timezonesidkey='America/Los_Angeles', username='supplierMain@testorg.com');
                insert user;
    Account acct = new Account(name='Test');
    insert acct;
    
    
    Price_Request_Transaction__c PRT=new Price_Request_Transaction__c(Inner_Table__c='Test',Ship_To__c=acct.id,Sold_To__c=acct.id, Approval_Status__c='Pending Entry',Type__c='Quote');    
    insert PRT; 
    RequestIds.add(PRT.Id);
    Date YEAR_AGO = system.today()-365;
    Price_Request_Transaction__c PRTdata =new Price_Request_Transaction__c(Approver__c = userinfo.getuserid(),Approval_Backup__c = userinfo.getuserid(),Inner_Table__c='Test',Ship_To__c=acct.id,Sold_To__c=acct.id, Approval_Status__c= 'Submitted',Type__c= 'CSP',CreatedDate = YEAR_AGO);    
    insert PRTdata; 
    RequestIds.add(PRTdata.Id); 
    Price_Request_Transaction__c PRT1data =new Price_Request_Transaction__c(Approver__c = userinfo.getuserid(),Approval_Backup__c = userinfo.getuserid(),Inner_Table__c='Test',Ship_To__c=acct.id,Sold_To__c=acct.id, Approval_Status__c= 'Submitted',Type__c= 'CSP',CreatedDate = YEAR_AGO);    
    insert PRT1data; 
    RequestIds.add(PRT1data.Id);  
    
    SAP_Price__c SP = new SAP_Price__c();
    SAP_Price__c SP1 = new SAP_Price__c();
    SAP_Price__c SP2 = new SAP_Price__c();
    SAP_Price_Tier__c SPT = new SAP_Price_Tier__c();
    SAP_Price_Tier__c SPT1 = new SAP_Price_Tier__c();
    SAP_Price_Tier__c SPT2 = new SAP_Price_Tier__c();
    
    SP=new SAP_Price__c(Price_Request_Transaction__c=PRT1data.id,type__c = 'Requested');
    insert SP; 
    SP1=new SAP_Price__c(Price_Request_Transaction__c=PRT1data.id,type__c = 'Alternate');
    insert SP1; 
    SP2=new SAP_Price__c(Price_Request_Transaction__c=PRTdata.id,type__c = 'Requested');
    insert SP2; 
    
    SPT=new SAP_Price_Tier__c(SAP_Price__c=SP.id);
    insert SPT;
    SPT1=new SAP_Price_Tier__c(SAP_Price__c=SP1.id);
    insert SPT1;
    SPT2=new SAP_Price_Tier__c(SAP_Price__c=SP2.id);
    insert SPT2;
    Price_Req_Appr_Controller controller = new Price_Req_Appr_Controller();
     Price_Req_Appr_Controller.rejectprt(PRTdata.Id,'test');
    Price_Req_Appr_Controller.pricesupportdata(RequestIds);
    Price_Req_Appr_Controller.getsapplant('test1');
    
    
    
    try{
    Price_Req_Appr_Controller.sendemailsupplier('plemails=test@test.com&hiddenplid'+prtdata.id,'test');//Spuran: added correct input for the method for more coverage
    }
    catch(exception e){}
    try{
    Price_Req_Appr_Controller.getpsrsuppliers('test');
    }
    catch(exception e){}
   }
}