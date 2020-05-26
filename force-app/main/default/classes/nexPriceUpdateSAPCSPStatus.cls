@RestResource(urlMapping='/updateStatus/*')
global with sharing class nexPriceUpdateSAPCSPStatus {
    
    @HTTPPost
    global static void updateStatus() {
        RestRequest req = RestContext.request;
        Blob body = req.requestBody;
        String bodyString = body.toString();
        List<PRTinfo> infoPRT = (List<PRTinfo>)JSON.deserialize(bodyString,List<PRTinfo>.class);
        List<String> PRTIds = new List<String>();
        Map<String,String> statusMap  = new Map<String,String>();
        Map<String,String> errormsgMap  = new Map<String,String>();
        
        for ( PRTinfo info : infoPRT ) {
              PRTIds.add(info.prtid);
              statusMap.put(info.prtid,info.status);
              errormsgMap.put(info.prtid,info.errormessage);
            }
        List<Price_Request_Transaction__c> prt = [select Id,Name,Approval_Status__c,
                                            SAPErrorMessage__c from Price_Request_Transaction__c where name in :PRTIds ];
        
       
       
       for(Price_Request_Transaction__c prtToUpdate : prt){
        
            if(statusMap.get(prtToUpdate.Name) == 'SUCCESS')
                prtToUpdate.Approval_Status__c = 'Complete';
            else{
                prtToUpdate.Approval_Status__c = 'SAP Transfer Failed';
                prtToUpdate.SAPErrorMessage__c = errormsgMap.get(prtToUpdate.Name);
            }
                
        }
        
        update prt ;
        
    }
    
    global class prtinfo{
        public String prtid{get;set;}
        public string status{get;set;}
        public String errormessage{get;set;}
    }
    
    

    
    
    static testMethod void testRest() {
    Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
       Account acct = new Account
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


       Account_Material__c am = new Account_Material__c
               (Account__c=acct.id);
        insert am; 
               
       Price_Request_Transaction__c PRT = new Price_Request_Transaction__c
            (Inner_Table__c='Test',Account_Material__c=am.id,Ship_To__c=acct.id,Sold_To__c=acct.id, Approval_Status__c='Rejected with Alternate',Type__c='CSP');    
        insert PRT; 

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
                               Effective_Date__c = system.today(), 
                               Expiration_Date__c = system.today(), 
                               currencyisocode = 'USD' );
        insert SPT;
        
        SAP_Price_Tier__c SPT1=new SAP_Price_Tier__c(SAP_Price__c=SP1.id,price__c = 2, volume__c = 2);
        insert SPT1;
        
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/updateStatus/test';
        req.httpMethod = 'POST';//HTTP Request Type
        RestContext.request = req;
        RestContext.response= res;
       
        // set up the request object
        //System.RestContext.request = new RestRequest();
        //RestContext.request.requestURI = '/getPRTDetails/';
        // Invoke the method directly
        //String blobString = '[{"ship_to_sales_org":"1000","status":"SUCCESS","ship_to_account_number":"0000094713","material":"000000000000021064","expiry_date":"2014-02-20","price_protection":"Z0 - No Protection","dist_channel":"30","prtid":"'+PRT.Name+'","drum_deposit":"X"}]';
        String blobString = '[{"PRTId":"'+PRT.Name+'","status":"SUCCESS","errorMessage":"NONE"}]';
        req.requestBody = Blob.valueof(blobString);
        //nexPriceUpdateSAPCSPStatus.prtinfo con = new nexPriceUpdateSAPCSPStatus.prtinfo();
        // set up the request object
        //System.RestContext.request = new RestRequest();
        
        
       // RestContext.request.requestURI = '/updateStatus/test';
        // Invoke the method directly
       
        nexPriceUpdateSAPCSPStatus.updateStatus();
        
    }
}