@RestResource(urlMapping='/getPRTDetails/*')
global class neXpriceSendPRTInfoToSAP {
    @HTTPPost
    // commenting this list of PRTids will be received
    //global static response PRTDetails(string PRTID) {
      global static List<Response> PRTDetails() {   
        
        RestRequest req = RestContext.request;
        Blob body = req.requestBody;
        
        
        String bodyString = body.toString();
        system.debug('bodyString '+bodyString);
        List<String> PRTID = (List<String>)JSON.deserialize(bodyString,List<String>.class);
        
        
        List<SAP_Price_Tier__c> priceTiers  = [select id,sap_price__r.Price_Request_Transaction__r.Name,Price__c,Price_UoM__c,Volume__c,Volume_UoM__c,Expiration_Date__c,Effective_Date__c, SAP_Price__c, Req_Price__c
                                                from SAP_Price_Tier__c where sap_price__r.type__c = 'Requested' and Validity_Over__c = False  
                                                and sap_price__r.Price_Request_Transaction__r.Name in :PRTID];
                                                
        List<Price_Request_Transaction__c> prtAll = [Select Sold_To_Account_Number__c,Ship_To_Account_Number__c,Name,SAP_Material__r.Material_Number__c,Requested_Drum_Deposit__c,CurrencyIsoCode,Ship_To_Sales_Org__c,
                                                Ship_To_Dist_Channel__c,Requested_Price_Protection__c,  freight_terms__c, CSP_Currency__c from Price_Request_Transaction__c where Name in :PRTID];
                                                
        
        List<Response> respList = new List<Response>();
        Map<String,List<Tier>>  tierlistMap = new Map<String,List<Tier>>();
        List<Tier> tierListToAdd = new List<Tier>();
                      
        if(priceTiers!=null && priceTiers.size() > 0){
            for(SAP_Price_Tier__c ti: priceTiers){
                 
                 Tier t = new Tier();
                 t.price = ti.req_Price__c.replaceAll(',','');
                 //t.price = ti.Price__c;
                 t.priceUOM = ti.Price_UoM__c;
                 t.volume = ti.Volume__c;
                 t.volUOM = ti.Volume_UoM__c;
                 t.expDate = ti.Expiration_Date__c;
                 t.startDate = ti.Effective_Date__c;
                 
                 
                 if(tierlistMap.keyset().contains(ti.sap_price__r.Price_Request_Transaction__r.Name)){
                     tierListToAdd  = tierlistMap.get(ti.sap_price__r.Price_Request_Transaction__r.Name);
                     tierListToAdd.add(t);
                     tierlistMap.put(ti.sap_price__r.Price_Request_Transaction__r.Name,tierListToAdd);
                 }
                 
                 else{
                     tierlistMap.put(ti.sap_price__r.Price_Request_Transaction__r.Name,new List<Tier>{t});
                     }
       
              } 
              } 
              
              
            if(prtAll!=null && prtAll.size()>0){
                for(Price_Request_Transaction__c pr : prtAll){
                     Response r = new Response();
                     r.PRTId= pr.Name;
                     r.SoldToNumber = pr.Sold_To_Account_Number__c;
                     r.ShipToNumber = pr.Ship_To_Account_Number__c;
                     r.MaterialNumber = pr.SAP_Material__r.Material_Number__c;
                     r.DrumDep = pr.Requested_Drum_Deposit__c;
                     r.PRTCurrency = pr.CSP_Currency__c;
                     //r.PRTCurrency = pr.CurrencyIsoCode;
                     r.SalesORG = pr.Ship_To_Sales_Org__c;
                     r.PriceProt = pr.Requested_Price_Protection__c;
                     r.DistChannel = pr.Ship_To_Dist_Channel__c;
                     r.reqTiers  = tierlistMap.get(pr.Name); 
                     if(pr.freight_Terms__c != null && pr.freight_terms__c != '')
                     r.freight_terms = (pr.freight_terms__c).substring(0,3);
                     else{ r.freight_terms = ''; } 
                     respList.add(r);  
                 }
            }   
   system.debug('respList is : '+respList);
   return respList;
   
}
    
    global class TIER{
        //public double price{get; set;}
        public String price{get; set;}
        public string priceuom{get; set;}
        public double volume{Get; set;}
        public string voluom{get; set;}
        public Date startdate{Get; set;}
        public Date expdate{get; set;}
    
    }
    global class RESPONSE{
        public string prtid{get; set;}
        public string soldtonumber{get; set;}
        public string shiptonumber{get; set;}
        public string materialnumber{get; set;}
        public string prtcurrency{Get; set;}
        public string salesorg{get; set;}
        public string distchannel{get; set;}
        public string priceprot{Get; set;}
        public string drumdep{Get; set;}
        public List<tier> reqtiers{Get; set;}
        public string freight_terms{get;set;}
    
    } 
    
    static testMethod void testRest() {
   Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
    
    /*neXpriceSendPRTInfoToSAP.RESPONSE nex = new neXpriceSendPRTInfoToSAP.RESPONSE();
    
    nex.prtid = 'test';
    nex.soldtonumber = 'test2';
    nex.shiptonumber = 'abc';
    nex.materialnumber = 'abcd';
    nex.prtcurrency = 'test8';
    nex.salesorg = 'tes2';
    nex.distchannel = 'test4';
    nex.priceprot = 'sad';
    nex.drumdep = 'test12';
    
     neXpriceSendPRTInfoToSAP.TIER nexe = new neXpriceSendPRTInfoToSAP.TIER();
    
    nexe.priceuom = 'acd';
    nexe.voluom = 'test22';
    nexe.price = 100;
    nexe.volume = 110;
    //nexe.startdate = System.now();*/
    
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
				PRT = [SELECT Id , Name FROM Price_Request_Transaction__c Where Id = : PRT.Id];
        SAP_Price__c SP=new SAP_Price__c(Price_Request_Transaction__c=PRT.id,type__c = 'Requested');
        insert SP; 
        SAP_Price__c SP1=new SAP_Price__c(Price_Request_Transaction__c=PRT.id,type__c = 'Requested');
        insert SP1; 
        
        SAP_Price_Tier__c SPT=new SAP_Price_Tier__c
                              (SAP_Price__c=SP.id,
                               Req_Price__c = '2,000',
                               price__c = 2, 
                               volume__c = 2,
                               price_uom__c ='LB',
                               volume_uom__c = 'KG',  
                               Effective_Date__c = system.today(), 
                               Expiration_Date__c = system.today(), 
                               currencyisocode = 'USD',
                               Validity_Over__c = False);
        insert SPT;
        
        SAP_Price_Tier__c SPT1=new SAP_Price_Tier__c(SAP_Price__c=SP1.id,price__c = 2, volume__c = 2, Req_Price__c = '2');
        insert SPT1;
       
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/getPRTDetails/';
         req.addParameter('recordId', PRT.id);

        req.httpMethod = 'POST';//HTTP Request Type

       
        // set up the request object
        //System.RestContext.request = new RestRequest();
        //RestContext.request.requestURI = '/getPRTDetails/';
        // Invoke the method directly
        System.debug('PRT.Name ' + PRT.Name);
        String blobString = '[{"ship_to_sales_org":"1000","ship_to_account_number":"0000094713","material":"000000000000021064","expiry_date":"2014-02-20","price_protection":"Z0 - No Protection","dist_channel":"30","prtid":"'+PRT.Name+'","drum_deposit":"X"}]';
        req.requestBody = Blob.valueof(blobString);
        RestContext.request = req;
        RestContext.response= res;
        neXpriceSendPRTInfoToSAP.PRTDetails();
        neXpriceSendPRTInfoToSAP.TIER tier = new neXpriceSendPRTInfoToSAP.TIER();
        neXpriceSendPRTInfoToSAP.RESPONSE resp = new neXpriceSendPRTInfoToSAP.RESPONSE();
        }      

}