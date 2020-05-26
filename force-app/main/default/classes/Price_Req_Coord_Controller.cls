public with sharing class Price_Req_Coord_Controller {
    private static final string mockResponse1 = '';
    Public static List<expiryResponse> deserializedresponses = new List<expiryResponse>();
    private static final string mockResponse = '[{"PRTId": "999999", "status": "SUCCESS", "errorMessage": ""}]';
    Public static List<id> prtidsList= new List<Id>();
    
    Public Price_Req_Coord_Controller(){}
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
    
    @RemoteAction
     Public Static void SendSAP(List<String> Idlist) {
     
     List<String> cspPRT = new List<String>();
     List<String> expiryPRT = new List<String>();
     
     List<Price_Request_Transaction__c> prtToSend = [Select Id,  Type__c from Price_Request_Transaction__c where Id in :Idlist];
     
     for(Price_Request_Transaction__c prt :prtToSend)
         if(prt.Type__c == 'CSP')
             cspPRT.add(prt.Id);
         else if(prt.Type__c == 'Expired CSP')
             expiryPRT.add(prt.Id); 
     
     if(expiryPRT.size()>0)        
         expirePRT(expiryPRT);
         
     if(cspPRT.size()>0)    
         SendToSAP(cspPRT);
     system.debug('expiryPRT:'+expiryPRT);
     system.debug('cspPRT:'+cspPRT);
     
     
     }
    
    
     Public Static void expirePRT(List<String> Idlist) {
         
        List<ExpiryRequest> SendtoSAP = new List<ExpiryRequest>(); 
        for(Price_Request_Transaction__c PRT: [select Id,Approval_Status__c,Sold_To_Account_Number__c,Name,Estimated_Order_Qty_UoM__c,Type__c,Ship_To_Account_Number__c,Ship_To_Sales_Org__c,
        SAP_Material__r.material_number__c,CSP_tiers__c,Account_Material__c,Requested_Price_Protection__c,
        ship_to__r.SAP_DistChannel__c,Requested_Drum_Deposit__c,ExpCSP_Expiration_Date__c from Price_Request_Transaction__c 
        where Id in :Idlist])
        { 
        
            ExpiryRequest req = new ExpiryRequest();
            req.soldtonumber = PRT.Ship_To_Account_Number__c;
            req.shiptonumber = PRT.Ship_To_Account_Number__c;
            req.salesorg = PRT.Ship_To_Sales_Org__c;
            req.materialnumber = PRT.SAP_Material__r.material_number__c;
            req.expiry_date = PRT.ExpCSP_Expiration_Date__c;
            req.priceprot = PRT.Requested_Price_Protection__c;
            req.distchannel = PRT.ship_to__r.SAP_DistChannel__c;
            req.drumdep = PRT.Requested_Drum_Deposit__c;
            req.prtid = PRT.Name;
            SendtoSAP.add(req);
        
        }
        
        
        nexPrice_Settings__c settings = nexPrice_Settings__c.getOrgDefaults();
        String endpoint = settings.AutoCSP_URL__c;
        system.debug('endpoint:'+endpoint);
        if(endpoint == null || endpoint == '')
            endpoint = 'https://sfwss.nexeosolutions.com:8152/sap/bc/zsd_csp_expire';  
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
        system.debug('JSON to SAP: '  + s);
        deserializedResponses = (List<expiryResponse>)JSON.deserialize(s, List<expiryResponse>.class); 
        Map<String,String> prtidstatusMap = new Map<String,String>();
        Map<String,String> PRTIdMessageMap= new Map<String,String>();
        for(expiryResponse expres : deserializedResponses ){
        prtidstatusMap.put(expres.PRTId, expres.status);
        PRTIdMessageMap.put(expres.PRTId, expres.errorMessage);
        }
        List<Price_Request_transaction__c> toUpdate = new List<Price_Request_transaction__c>();
        for(Price_Request_transaction__c prt: [select Id, Name,Approval_Status__c, SAPerrormessage__c from Price_Request_transaction__c where Name in:prtidstatusMap.keyset() ]){
        if(prtidstatusMap.get(prt.Name) == 'SUCCESS'){
            prt.approval_status__c = 'Complete';
        }
        else if(prtidstatusMap.get(prt.Name) == 'FAILURE'){
            prt.approval_status__c = 'SAP Transfer Failed';
            prt.SAPerrormessage__c = PRTIdMessageMap.get(prt.Name);
        }
        toUpdate.add(prt);
        }
        update toUpdate ;
     
     }
    
    @RemoteAction
    public static List<Price_Request_Transaction__c> fetchPendingEntries(){
      String userId = userinfo.getuserid();
      List<String> whereClause = new List<String>();
      String toAdd = '';
      List<User> userList = [Select Id,Price_Coord_Region__c from User where Id =: userId];
      if (userList[0].Price_Coord_Region__c != null && userList[0].Price_Coord_Region__c != ''){
        
        if(userList[0].Price_Coord_Region__c.contains('US'))
          whereClause.add(' ((ship_to__r.sap_Sales_org__c = \'1000\' or ship_to__r.sap_Sales_org__c = \'1800\' or ship_to__r.sap_Sales_org__c = \'1031\') and ship_to__r.sap_corporate_account_id__c = null) ');
        if(userList[0].Price_Coord_Region__c.contains('Canada'))
          whereClause.add(' (ship_to__r.sap_Sales_org__c = \'1700\' and ship_to__r.sap_corporate_account_id__c = null )');
        if(userList[0].Price_Coord_Region__c.contains('Corporate Accounts'))
          whereClause.add('(ship_to__r.sap_corporate_account_id__c != null) ');
        
        toAdd = String.join(whereClause,' OR ');
      }
      
      String query = 'select Id,Inner_Table__c, name,Ship_to__r.SAP_Corporate_Account_Manager__r.Name, SAP_Corporate_Account__c, Corporate_Account_Number__c,SAP_SoldTo_Account__c,';
        query += ' SAP_ShipTo_Account__c, Sold_To_Account_Number__c,Ship_To_Sales_Org__c,Ship_To_Account_Number__c,Sales_Org_Code_and_Desc__c, ship_to__r.sap_sales_group_desc__c, ship_to__r.owner.name,' ;
        
    query += ' sap_material__r.name, requested_effective_date__c,Requested_Effective_Date_Text__c,Requested_Expiration_Date_Text__c, requested_expiration_date__c, Volume__c, Requested_UoM__c,';
        query += ' Price__c, Requested_Price_UoM__c,Approval_Status__c,Type__c ,requested_price_Protection__c, comments__c ,additional_dates__c,SAPErrorMessage__c,Approval_Rejection_Comments__c, Owner.Name  ';
        query += ' from Price_Request_Transaction__c where (Approval_Status__c = \'Pending Entry\' OR Approval_Status__c = \'SAP Transfer Failed\' OR Approval_Status__c = \'SAP Transfer Open\' OR Approval_Status__c = \'Pending Expiry\') AND  Type__c != \'Price Letter\' ';
    
    if(toAdd != '')
      query += ' and ( ' +toAdd+ ' )';
    else
      query += ' and Id = null';  
        
        query += ' order by requested_effective_date__c desc';
               
        List<Price_Request_Transaction__c> pendingPRTList = Database.query(query);
        return pendingPRTList;
    }


  @RemoteAction
   Public Static List <Price_Request_Transaction__c> SimulateForm(List<String> RequestIds, List<formData> data, String Operation){
        List <Price_Request_Transaction__c> PRT = new List <Price_Request_Transaction__c>();
        Map<String, string> wheres = new Map<String, String>();
        for(formData fd:data){
            wheres.put(fd.name, fd.value);
        }
        List<Price_Request_Transaction__c> toReject = [Select Id,approval_status__c, 
                  Approval_Level__c,
                  Approver__r.name,
                  Approver__c,
                  average_order_qty__c,
                  Average_Order_Qty_UoM__c,
                  Approval_Backup__c,
                  Type__c,
                  Reason_Code__c,
                  Ship_To__r.Owner.Name,
                  Ship_To__r.SAP_Customer_Group_5__c,
                  SAP_SoldTo_Account__c,
                  SAP_ShipTo_Account__c,
                  SAP_Material__r.Name,
                  plant__c,
                  Requested_Effective_Date__c,
                  Requested_Effective_Date_Text__c,
                  Requested_Expiration_Date__c,
                  Requested_Expiration_Date_Text__c,
                  quantity__c,
                  Volume__c,
                  Requested_UoM__c,
                  Price__c,
                  Requested_Price_UoM__c,
                  TPI__c,
                  Comments__c,
                  Approval_Rejection_Comments__c,
                  Coordinator_Comments__c,
                  createdById, 
                  Account_Material__c,
                  SAP_Data__c, Requested_Tiers__c, CSP_Tiers__c, Ship_To__r.SAP_DivisionCode__c
                  from  Price_Request_Transaction__c where Id in : requestids];
                  
    if(Operation == 'simulate'){
        PRT = Account_Material_Functions.getTransactions(toReject , wheres);}
    if(Operation == 'savesubmit'){
        PRT = Account_Material_Functions.upsertTransactions(toReject , wheres, 'Coordinator');
        
        //Send email to the approver if status is submitted
        List<User> toaddressespertransaction = new List<User>();
        List<User> toaddressespertransactionall = new List<User>();
        Map<String, List<String>> IdToAddresses = new Map<String, List<String>>();
        Map<String, List<String>> IdToAddressesAll = new Map<String, List<String>>();
        List<Id> PRTIds = new List<Id>();
        List<Id> AllPRTIds = new List<Id>();
        
        for(Price_Request_Transaction__c t:PRT){  
            if(t.approval_level__c != 'Auto-Approved' && t.Approval_Status__c == 'Submitted'){
                List<String> UserEmail = new List<String>();
                Set<String> toemail = new Set<String>();
                if(t.approver__c != null)
                    toemail.add(t.approver__c);
                if(t.approval_backup__c != null)
                    toemail.add(t.approval_backup__c);
             
                toaddressespertransaction = [Select email from User where id IN :toemail];
             
                for(User u: toaddressespertransaction)
                 UserEmail.add(u.email);
                system.debug(UserEmail);  
                IdToAddresses.put(t.id,UserEmail); 
                PRTIds.add(t.id);
            }
            List<String> UserEmailAll = new List<String>();
            toaddressespertransactionall = [Select email from User where id =:t.createdbyId];
            for(User u: toaddressespertransactionall)
                 UserEmailAll.add(u.email);
            IdToAddressesAll.put(t.id,UserEmailAll);
            AllPRTIds.add(t.id);
        }
        //Calling Email Functions to send email to aprover
        if(PRTIds.size()>0){
            nexprice_settings__c ns = nexprice_settings__c.getOrgDefaults();
            system.debug('ns.Email__c is : '+ns.Email__c);
            if(ns.Email__c != null && ns.Email__c != '')
                Email_Functions.sendEmailwithTemplate(IdToAddresses,PRTIds,'Template_To_ApproverFromCoord_Level1_12',ns.Email__c);  
        }  
        
        //Sending Email to Seller informing about the update done by Coordinator
        if(AllPRTIds.size()>0)
            Email_Functions.sendEmailwithTemplate(IdToAddressesAll,AllPRTIds,'Template_To_Seller','');  
        
      }  
      

      return PRT;
    }
  
    @RemoteAction
    public static void CloseRecords(List<String> Idlist){
        
        List<Price_Request_Transaction__c> toclose = [Select Id,Account_Material__c,Quantity__c,approval_status__c from  Price_Request_Transaction__c where Id in : Idlist];
        Map<Id,Decimal> amIdEOQMap = new Map<Id,Decimal>(); 
        Map<Id,String> amIdCompMap = new Map<Id,String>(); 
        String userId = userinfo.getuserid();
        //system.debug('userId:'+userId);
        
        for(Price_Request_Transaction__c prt:toclose)
        {   
            prt.approval_status__c = 'Complete';
            amIdEOQMap.put(prt.Account_Material__c, prt.Quantity__c);
            prt.Coordinator__c=userId;
        }
        List<Account_Material__c> amUpdateList = [Select Id,Estimated_Order_Quantity__c from Account_Material__c where Id in :amIdEOQMap.keyset()];
        for(Account_Material__c a:amUpdateList){
            a.Estimated_Order_Quantity__c = amIdEOQMap.get(a.Id);
            a.Competitor__c = amIdCompMap.get(a.Id);
        }
        upsert amUpdateList;
        update toclose;

    }
    
         
    public static void SendToSAP(List<String> Idlist){
        
        List<Price_Request_Transaction__c> toRetrigger = [Select Id,Account_Material__c,Quantity__c,approval_status__c from Price_Request_Transaction__c where Id in : Idlist];
        Map<Id,Decimal> amIdEOQMap = new Map<Id,Decimal>(); 
        String userId = userinfo.getuserid();
       
        for(Price_Request_Transaction__c prt:toRetrigger)
        {   
            if(prt.approval_status__c == 'Pending Entry' || prt.Approval_status__c == 'SAP Transfer failed'){
                prt.approval_status__c = 'SAP Transfer Open';
                amIdEOQMap.put(prt.Account_Material__c, prt.Quantity__c);
                prt.Coordinator__c=userId;
            }    
        }
        
        List<Account_Material__c> amUpdateList = [Select Id,Estimated_Order_Quantity__c from Account_Material__c where Id in :amIdEOQMap.keyset()];
        for(Account_Material__c a:amUpdateList)
            a.Estimated_Order_Quantity__c = amIdEOQMap.get(a.Id);
        upsert amUpdateList;
        update toRetrigger;

    }
   
   @RemoteAction
    Public static combogriddata getComboGridData(string q, string obj, string fields, string filters, string orderby, string mylimit){ 
    List<sobject> records = new list<SObject>();
    if(obj != '' && fields != '')
    {
      String query = '\'%' + q.escapeEcmaScript() + '%\'';
      system.debug('filters***'+filters);
      string f = fields.replaceall('-id', '');
      string qstring = 'SELECT id, ' + f + ' from ' + obj + ' where id != null';
      if(filters != null && filters != '')
        qstring += ' and ' + filters;
    
      List<String> myfields = fields.split(',');
      if(q != null && q != '' && myfields.size() > 0)
      {
        qstring += ' and (';
        for(integer i=0; i<myfields.size(); i++)
        { string s = myfields.get(i);
          if(!s.contains('-id'))
          {
          if(i != 0)
            qstring += ' OR ';
          qstring += s + ' LIKE ' + query;
          }
        }
        qstring += ')';
      }
      if(orderby != '' && orderby != null)
        qstring += ' ORDER BY ' + orderby;
      else
        qstring += ' ORDER BY Name ';
      qstring += ' LIMIT ' + mylimit;
      
      records = database.query(qstring);
    }
     combogriddata data = new combogriddata(records);
     
     return data;
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