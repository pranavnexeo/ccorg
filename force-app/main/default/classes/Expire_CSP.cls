public class Expire_CSP {
    Public String Date_Today{Get; set;}
    private static final string mockResponse = '[{"PRTId": "999999", "status": "SUCCESS", "errorMessage": ""}]';
    Public static List<expiryResponse> deserializedresponses = new List<expiryResponse>();
    @TestVisible
    private static string mockResponse1 = '["a6K170000004K3EEAU"]';
    Public static List<id> prtids= new List<Id>();
    Public Expire_CSP(){
        date_today = system.today().format();
        
    }
 
 
 
   @RemoteAction
   Public Static List<Account_Material__c> getRecordsToDisplay(String paramid) {
   
        system.debug('paramid is:'+paramid);
        List<Price_Support_Ids__c> PSIds = new List<Price_Support_Ids__c>();
        List<String> amids = new List<String>();
        PSIds = [Select Ids__c from Price_Support_Ids__c where Id =: paramid];
        
        if(PSIds.size()>0)
            amids = PSIds[0].Ids__c.split('-');
        system.debug('amids:'+amids);
               
        List<Account_Material__c> amList = [select id , Material_Division__c, Account_Number__c, Account_City__c, UoMs__c, CSP_UoM__c, currencyisocode, Has_Unit_Options__c, Account_Name__c, has_open_prt__c, Has_CSP__c, Account_Sales_Org_Code__c, Inner_Table__c, Account_Division_Code__c, Account_Industry_Code__c, Account_Sold_To_Id__c,  Account_Sold_To__c, Account_Sold_To_Owner_Id__c, Account_Corp_Account_Id__c, Account_Corp_Account_Owner_Id__c, Account_Owner_Id__c, Account_Sales_Org__c, Account_Division__c, Account_Industry__c, Account_HQ_Sales_Office__c, Account_SAP_Sales_Group__c, Account_Sold_To_Seller__c,
         Material_Container_Code__c,  CSP_Tier_UoM__c, Material_Base__c, material_group_1__c, Material_Product_Class__c, Competitive_UoM__c, Created_From_CPI__c, Material_Supplier__c, Material_Family__c, Material_Segment__c, Material_SubSegment__c, Material_Base_Code__c, Material__c, CSP_Expiration_Date__c,
         Account__r.SAP_Sold_To_Account__c, Account__r.SAP_DistChannel__c,Account__r.Name, Account__c, PH4__c, PH5__c, PH6__c, PH7__c, SAP_Material__c, iDisplayindex__c, Account_Owner_Name__c, Material_Name__c, Avg_Order__c,  Avg_Order_Qty__c, Avg_Order_Qty_Uom__c, Estimated_Order_Qty__c, Estimated_Order_Qty_uom__c, Estimated_Order_Quantity__c, Account__r.SAP_Corporate_Account__c, Account__r.SAP_State__c,
         CSP__c, CSP_Effective_Date__c, TPI__c,  CSP_Effective_Date_Text__c, CSP_Tier__c, CSP_Price__c, Target__c, Target_Unit__c, Target_UoM__c, Target_Price__c, Target_Tier__c, Drum_Deposit__c, Price_Protection__c, Prospect_Material__c, SAP_Material__r.material_number__c, Account__r.accountnumber, SAP_Material__r.Sales_UOM__r.Alternative_UOM__c
         from Account_material__c where Id IN :amids];
     
        return amList; 
    }
     
   @RemoteAction
   Public Static String expirePRT(Map<String, String> a) {
   
   List<SAP_Price__c> sapprices = new List<SAP_Price__c>();
   List<Price_Request_Transaction__c> transactions = new List<Price_Request_Transaction__c>();
   List<ExpiryRequest> SendtoSAP = new List<ExpiryRequest>();
   Map<Id, Price_Request_Transaction__c> tmap = new map<Id, Price_Request_Transaction__c>();
   List<SAP_Price_Tier__c> alltiers = new List<SAP_Price_Tier__c>();
   String returnMsg = '';
   integer successRec = 0;
   integer failedRec = 0;
   system.debug('a in savesubmit is:'+a);
   Set<String> amSet = new Set<String>();
   amSet = a.keySet();
   system.debug(amSet);
   
   List<String> amids = new List<String>();
   
   for(String s :amSet)
       amids.add(s);
   
   String exdate = null;   
   Date expirydate = null;
   Date cspeffdate = null;
   Date cspexdate = null;
   
   List<Account_Material__c> ams = Account_Material_Functions.getAccountMaterials(amids);
   List<PRT_Movement_Settings__c> PRTMovmntSett = PRT_Movement_Settings__c.getall().values();
   Map<String,Boolean> customSettMap = new Map<String,Boolean>();
   Map<String,Boolean> CustGrpSettMap = new Map<String,Boolean>();
   
   for(PRT_Movement_Settings__c PRTsett : PRTMovmntSett){
        customSettMap.put(PRTsett.Name,PRTsett.Switch__c);
        CustGrpSettMap.put(PRTsett.Name,PRTsett.CG5__c);
   }
   
  for(Account_material__c am:ams)
  {
    exdate = a.get(am.id);
    expirydate = datetime.newinstance(long.valueof(exdate)).dategmt(); 
    system.debug('expirydate is:'+expirydate);
           
    Price_Request_Transaction__c PRT = new Price_Request_Transaction__c();
    PRT.SAP_Data__c = am.SAP_Data__c;
    CSP_JSON_Response response = (CSP_JSON_Response)JSON.deserialize(am.SAP_Data__c, CSP_JSON_Response.class);
    system.debug(response);
    
    PRT.Account_Material__c = am.id;
    PRT.Account_Material__r = am;
    PRT.SAP_Material__c = am.SAP_Material__c;
    PRT.SAP_Material__r = am.SAP_Material__r;
    PRT.ship_to__c = am.Account__c;
    PRT.Ship_to_dm__c = am.Account__r.owner.managerid;
    
    PRT.ship_to__r = am.Account__r;
    //PRT.sold_to__c = am.Account_Sold_To_Id__c;
    //PRT.Corporate_account__c = am.Account_Corp_Account_Id__c;
    
    PRT.average_order_qty__c = am.Avg_Order_Qty__c;
    PRT.average_Order_Qty_UoM__c = am.Avg_Order_Qty_Uom__c;
    PRT.type__c = 'Expired CSP';
    if(PRT.ship_to__r.SAP_DivisionCode__c != null){
    
        String divCode = PRT.ship_to__r.SAP_DivisionCode__c;
        if(customSettMap.get(divCode) == true){
         if(CustGrpSettMap.get(divCode) == true){
                       PRT.approval_Status__c = 'SAP Transfer Open';
                    }
                    else{
                        if(PRT.Ship_To__r.SAP_Customer_Group_5__c == '11' || PRT.Ship_To__r.SAP_Customer_Group_5__c == '12' || PRT.Ship_To__r.SAP_Customer_Group_5__c == '13'){
                           PRT.approval_Status__c = 'Pending Expiry';
                        }
                        else{
                           PRT.approval_Status__c = 'SAP Transfer Open';
                        }
                    }
            
        }
        else
            PRT.approval_Status__c = 'Pending Expiry';
    
    }
   
   
   List<SAP_Price_Tier__c> CSPs = new List<SAP_Price_Tier__c>();
   for(integer i=0; i<response.tbl_CSP_prices.size(); i++)       
   {
             CSP_JSON_Response.tbl_CSP_prices CSP = response.tbl_CSP_prices.get(i);
             SAP_Price_Tier__c t = new SAP_Price_Tier__c();
             if(csp.csp_price != '')
               t.Price__c = stringtodouble(CSP.csp_price);
             if(csp.csp_volume != '')
               t.Volume__c = stringtodouble(csp.csp_volume);
             if(csp.csp_currency != null)
               if(csp.csp_currency.length() > 3)
                 t.CurrencyIsoCode = csp.csp_currency.substring(0,3);
               else
                 t.currencyIsoCode = csp.csp_currency;
             if(csp.csp_price_unit != '')
               t.Price_Unit__c = stringtodouble(csp.csp_price_unit);
             if(csp.csp_uom != '')
                t.price_uom__c = csp.csp_uom; 
             if(csp.csp_scale_uom != '')
                t.volume_uom__c = csp.csp_scale_uom;             
                  
             if(stringtodate(csp.csp_effective_date) <= expirydate  && stringtodate(csp.csp_expiration_date) >= expirydate){
                 t.Expiration_Date__c = expirydate;
                 PRT.ExpCSP_Expiration_Date__c = expirydate;
                 }
             else if(stringtodate(csp.csp_effective_date) >= expirydate)
              {   t.Marked_for_Deletion__c = true;
                  t.Expiration_Date__c = stringtodate(csp.csp_expiration_date);
              }
              else 
                  t.Expiration_Date__c = stringtodate(csp.csp_expiration_date);
             
           
             if(csp.csp_effective_date != '' && !csp.csp_effective_date.contains('9999'))
             { t.Effective_Date__c = stringtodate(csp.csp_effective_date);      
             }

             t.price_protection_code__c = csp.csp_price_protection_code;
             t.price_protection_desc__c = csp.csp_price_protection_desc;
             
             if((t.price_protection_code__c != null || t.price_protection_desc__c != '') && i == 0)
                PRT.Requested_Price_Protection__c= t.price_protection_code__c + ' - ' + t.price_protection_desc__c;
             
             if((t.price_protection_code__c == null || t.price_protection_desc__c == '') && i == 0)
                PRT.Requested_Price_Protection__c='Z0 - No Protection';
              
             t.drum_deposit_code__c = csp.csp_drum_deposit_code;
             t.Condition_Number__c = csp.csp_condition_nbr;
             if(t.effective_date__c != null || t.expiration_date__c != null || t.volume__c != null || t.price__c != null)
             CSPs.add(t);
       }
       PRT.CSP_Tiers__c = JSON.serialize(CSPs);
       transactions.add(PRT); 
       
       
    }  
    
    
    /*Calling Webservice to insert PRTs. This needs to be done because "insert transactions" statement 
    needs to be executed ina different context. DML statements are not allowed in the 
    same context your are doing a http callout.*/
    
    
    
    http h1 = new http();
    httprequest req1 = new httprequest();       
    req1.setHeader('Content-Type', 'application/json'); 
     
    req1.setHeader('Authorization', 'OAuth ' + UserInfo.getsessionId());  
    req1.settimeout(60000); 
    req1.setMethod('POST');
    
    String result1 =  JSON.serialize(transactions);
    nexprice_settings__c ns = nexprice_settings__c.getOrgDefaults();
    String InsertExpiryURL = ns.InsertExpiryRecord_URL__c;
    if(InsertExpiryURL == null || InsertExpiryURL =='')
        InsertExpiryURL = 'https://cs22.salesforce.com/services/apexrest/insertExpiryPRT';
    
    System.debug('InsertExpiryURL :'+InsertExpiryURL );
    
    req1.setBody(result1);    
    req1.setEndpoint(InsertExpiryURL);
    //req1.setEndpoint('https://cs8.salesforce.com/services/apexrest/insertExpiryPRT');

    String s1 = mockResponse1 ;
    //MAKE CALLOUT IF NOT RUNNING TEST
    if(Test.isRunningTest() == false){
        httpresponse res1 = h1.send(req1);
        s1 = res1.getbody();
    }
    
    system.debug('JSON: '  + s1);
    prtids= (List<Id>)JSON.deserialize(s1, List<Id>.class);     
    
            
    for(Price_Request_Transaction__c PRT: [select Id,Name,Estimated_Order_Qty_UoM__c,Type__c,Sold_To_Account_Number__c,Ship_To_Account_Number__c,Ship_To_Sales_Org__c,
                                    SAP_Material__r.material_number__c,CSP_tiers__c,Account_Material__c,Requested_Price_Protection__c,
                                    ship_to__r.SAP_DistChannel__c,Approval_Status__c,Requested_Drum_Deposit__c from Price_Request_Transaction__c 
                                    where Id in :prtids])
    { 
        tmap.put(prt.id,prt);
        sap_price__c csp = new SAP_Price__c();
        csp.Price_Request_Transaction__c = PRT.id;
        csp.type__c = 'CSP';
        csp.Estimated_Order_Qty_UoM__c = PRT.Estimated_Order_Qty_UoM__c;
        csp.PRT_Type__c = PRT.Type__c;
        sapprices.add(csp);
        
        if(PRT.Approval_Status__c == 'SAP Transfer Open'){
        
        ExpiryRequest req = new ExpiryRequest();
        req.soldtonumber = PRT.Sold_To_Account_Number__c;
        req.shiptonumber = PRT.Ship_To_Account_Number__c;
        req.salesorg = PRT.Ship_To_Sales_Org__c;
        req.materialnumber = PRT.SAP_Material__r.material_number__c;
        req.expiry_date = datetime.newinstance(long.valueof(a.get(PRT.Account_Material__c))).dategmt(); 
        req.priceprot = PRT.Requested_Price_Protection__c;
        req.distchannel = PRT.ship_to__r.SAP_DistChannel__c;
        req.drumdep = PRT.Requested_Drum_Deposit__c;
        req.prtid = PRT.Name;
        SendtoSAP.add(req);
       }
       
    }
      
    if(SendtoSAP!=null && SendtoSAP.size()>0){
      //  nexPrice_Settings__c settings = nexPrice_Settings__c.getOrgDefaults();
        String endpoint = ns.AutoCSP_URL__c;
        system.debug('endpoint:'+endpoint);
        if(endpoint == null || endpoint == '')
            endpoint = 'https://cs22.salesforce.com/services/apexrest/insertExpiryPRT';
        //SERIALIZE THE LIST OF REQUESTS
        String JSONString = JSON.serialize(SendtoSAP);
        system.debug('JSONString is '+JSONString);
        
        //SETUP CALLOUT
        Http http = new Http();
        HttpRequest hreq = new HttpRequest();
        hreq.setHeader('Content-Type', 'application/json');  
        hreq.settimeout(60000);
        hreq.setBody(JSONString);    
        hreq.setEndpoint(endpoint);
        hreq.setMethod('POST');
         String s = mockResponse ;
        //MAKE CALLOUT IF NOT RUNNING TEST
        if(Test.isRunningTest() == false){
            httpResponse res = http.send(hreq); 
            s = res.getbody();
        }
        
        
    
    
    
    
  
        
            //Processing Response
            
            system.debug('Raw Response: ' + s);
            s = s.unescapeEcmaScript();
            s = s.unescapeEcmaScript();
            system.debug('JSON from SAP: '  + s);
            deserializedResponses = (List<expiryResponse>)JSON.deserialize(s, List<expiryResponse>.class); 
            Map<String,String> PRTIdStatusMap = new Map<String,String>();
            Map<String,String> PRTIdMessageMap= new Map<String,String>();
            for(expiryResponse expres : deserializedResponses ){
                PRTIdStatusMap.put(expres.PRTId, expres.status);
                PRTIdMessageMap.put(expres.PRTId, expres.errorMessage);
            }
            List<Price_Request_transaction__c> toUpdate = new List<Price_Request_transaction__c>();
            for(Price_Request_transaction__c prt: [select Id, Name,Approval_Status__c, SAPerrormessage__c from Price_Request_transaction__c where Name in:PRTIdStatusMap.keyset() ]){
                if(PRTIdStatusMap.get(prt.Name) == 'SUCCESS'){
                    prt.approval_status__c = 'Complete';
                    successRec++;
                }
                else if(prtidstatusMap.get(prt.Name) == 'FAILURE'){
                    prt.approval_status__c = 'SAP Transfer Failed';
                    prt.SAPerrormessage__c = PRTIdMessageMap.get(prt.Name);
                    failedRec++;
                }
                toUpdate.add(prt);
            }
            update toUpdate ;
        returnMsg = 'Status:: '+ successRec  + ' records transferred to SAP Succesfully. \n ' + failedRec + ' records failed.';
       }
       
       
       if(sapprices !=null && sapprices.size() > 0)
           insert sapprices;
       
       if(sapprices !=null && sapprices.size() > 0){
           for(SAP_Price__c pr:sapprices)
        {
            List<SAP_Price_Tier__c> tiers = new List<SAP_Price_Tier__c>();
            if(tmap.get(pr.Price_Request_transaction__c).CSP_tiers__c != null)
                tiers = (list<SAP_Price_Tier__c>)JSON.deserialize(tmap.get(pr.Price_Request_transaction__c).CSP_tiers__c, List<SAP_Price_Tier__c>.class);   
            
            for(SAP_Price_Tier__c t:tiers)
                t.SAP_Price__c = pr.id;
                
            alltiers.addall(tiers);
        }
    
    }
       
       if(alltiers!=null && alltiers.size() > 0)
        insert alltiers;
        
        system.debug('returnMsg:'+returnMsg);
      return returnMsg;
   }
      
     
   @RemoteAction
   Public Static combogriddata validateDate(Map<String, String> a) {
        
        system.debug('a in savesubmit is:'+a);
        Set<String> amids = new Set<String>();
        amids = a.keySet();
        system.debug(amids);
               
        Boolean Valid;
        String exdate = null;
        Date expirydate= null;
        Date cspeffdate = null;
        Date cspexdate = null;
        
        Set<Boolean> Values = new Set<Boolean>();
        List<Account_Material__c> amsInvalid = new List<Account_Material__c>(); 
        

       List<Account_Material__c> ams = [Select Id, Material__c, SAP_Data__c from Account_Material__c where id IN :amids];
       CSP_JSON_Response response;
   
       for(Account_Material__c am: ams)
       {
           Valid = False;
           Values.clear();
           exdate = a.get(am.id);
           expirydate = datetime.newinstance(long.valueof(exdate)).dategmt(); 
           system.debug('expirydate is:'+expirydate);
           if(am.SAP_Data__c != null)
               response = (CSP_JSON_Response)JSON.deserialize(am.SAP_Data__c, CSP_JSON_Response.class);
            
             //system.debug('CSPs are:'+ response);
             //system.debug('csp size: ' + response.tbl_CSP_prices.size());
             if(response.tbl_CSP_prices.size() > 0){
                 for(integer i=0; i< response.tbl_CSP_prices.size(); i++)
                 {
                    CSP_JSON_Response.tbl_CSP_prices CSP = response.tbl_CSP_prices.get(i);
                    
                    cspeffdate = stringtodate(csp.csp_effective_date);
                    //system.debug('cspeffdate:'+cspeffdate);
                    cspexdate = stringtodate(csp.csp_Expiration_date);
                    //system.debug('cspexdate:'+cspexdate); 
                    
                    if(Valid == False)  
                      if((cspeffdate != null && cspexdate != null)&&(expirydate>= cspeffdate && expirydate<= cspexdate))
                          Valid = True;
                      else
                          Valid = False;
                    
                    Values.add(Valid);
                    
                }
                
            }
            if(!Values.contains(True))
            {   system.debug('Inside loop'); 
                Valid = False;
                 amsInvalid.add(am); }
            system.debug('am:'+am.Material__c+'@@Values:'+Values+'@@Valid:'+Valid);
                      
            
            
       }          
       System.debug('amsInvalid:'+amsInvalid );
       //System.debug('Values:'+Values);
     for(Account_Material__c m :amsInvalid)
         system.debug('material:'+m.Material__c);
   combogriddata data = new combogriddata(amsInvalid);
   System.debug('data is:'+data);    
   return data;
             
     
        
    }

    
    Public static Date stringtodate(string s){
  
      date d = null;
      try{
        d = Date.valueof(s.substring(0, 4) + '-' + s.substring(4, 6) + '-' + s.substring(6)); 
      }catch(exception e){system.debug('***DATE CONVERT ERROR***: ' + s + ' ERROR: ' + e.getmessage());} 
      return d;
    }
    
    Public static String formatDate(date d){
      if(d != null)
        return d.format();
      else
        return '';
    }
    
    public static Double Stringtodouble(Double d){ return d; }
    public static Double Stringtodouble(Decimal d){ return Double.valueof(d); }
    public static Double stringtodouble(String sIn){
      string temp = '';
      if(sIn != '' && sIn != null)
      {
        if(sIn.contains('-'))
        {  temp = sIn.replaceall('-', '');
           temp = '-' + temp;
        }
        else{ temp = sIn; }
        if(temp.contains(','))
          temp = temp.replaceall(',','');
        return double.valueof(temp);
      }
      else{ return null; }
    }
    
    Public static string getDateFormat(){
      date d = Date.valueof('1999-01-22');
      string dformat = d.format();
      string f = '';
    
      if(dformat.indexof('22') < dformat.indexof('01'))
        f = 'dd/mm';
      else
        f = 'mm/dd';
      if(dformat.indexof('01') < dformat.indexof('1999'))
        f = f + '/yy';
      else
        f = 'yy/' + f;
      return f;
      
    }

public class ExpiryRequest{
    public String soldtonumber{Get; set;}
    public String shiptonumber{Get; set;}
    public String salesorg{Get; set;}
    public String materialnumber{get; set;}
    public Date expiry_date{get; set;}
    Public String priceprot{get; set;}
    Public String distchannel{get; set;}
    public String prtid{get; set;}
    public String drumdep{get; set;}
  }
  
  public class ExpiryResponse{
    public String prtid{Get; set;}
    public String status{Get; set;}
    public String errormessage{get; set;}
   
  }
  
  }