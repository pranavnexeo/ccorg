@istest(SeeAllData=false)

public class nexPriceinsertExpiryPRT_test{
 //public static final String DELIM = CISRelationships_Functions.DELIM;
    
    public static testmethod void testRest(){
    
  		//Adding code to prevent have hardcoded IDs
  		Map<String, SObject> testData = NexeoTestUtils_Test.initData();
        
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
                               currencyisocode = 'USD',
                               Validity_Over__c = False);
        insert SPT;
        
        SAP_Price_Tier__c SPT1=new SAP_Price_Tier__c(SAP_Price__c=SP1.id,price__c = 2, volume__c = 2);
        insert SPT1;
       
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/insertExpiryPRT/';
        req.httpMethod = 'POST';//HTTP Request Type
        RestContext.request = req;
        RestContext.response= res;
       
        // set up the request object
        //System.RestContext.request = new RestRequest();
        //RestContext.request.requestURI = '/getPRTDetails/';
        // Invoke the method directly
        String blobString = '[{"Inner_Table__c":"Test","Account_Material__c":"'+am.id+'","Ship_To__c":"0000094713","Type__c":"Expired CSP","Approval_Status__c":"Expired"}]';
        req.requestBody = Blob.valueof(blobString );
        nexPriceinsertExpiryPRT.insertExpiryPRT();
        delete prt;
        }   
        
        }