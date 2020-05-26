global with sharing class atpInventoryCallOut{
    private static final string mockResponse = '[{"STATUS": "SUCCESS","MESSAGES": [ { "MESSAGE": "No Errors" } ],"ATP_RESPONSE": [{"MATERIAL": "000000000000696738","REQ_DATE": "2018-04-07","STATUS": "SUCCESS","MESSAGES": [ { "MESSAGE": "Delivery by 04/07/2018 for quantity 1,000.000 LB confirmed." } ]}]}]';
    public static final String PARTNER_ROLE_SOLD_TO_VALUE = 'AG';
    public static final String PARTNER_ROLE_SHIP_TO_VALUE = 'WE';
    global atpInventoryCallOut(){}
    global static Map<string,string> doPost(List<Account_Material__c> aList, Account acc, string source){
    
     Map<string,string> respMap = new Map<string,string>();
        
     List<inventory_Request> invRequests = new List<inventory_Request>();
     
     inventory_Request req = new inventory_Request();
     
     List<inventory_Request.header> header= buildheader(acc);
     List<inventory_Request.Partners> partners = buildPartners(acc);
     List<inventory_Request.items> items= builditems(aList);
     List<inventory_Request.switches> switches = buildSwitches();
     
     req.header = header;
     req.partners = partners;
     req.items = items;
     req.switches = switches;
     req.client = source;
     
     invRequests.add(req);
     
     nexPrice_Settings__c settings = nexPrice_Settings__c.getOrgDefaults();
     String endpoint = settings.ATP_Check_Endpoint__c;
     String requestBody = JSON.serialize(invRequests, true);
     System.debug('Request: ' + requestBody);
     string username = settings.atp_username__c;
     string password = settings.atp_password__c;
     
     Blob headerValue = Blob.valueOf(username + ':' + password);
     String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
     
     Http http = new Http();
     HttpRequest hreq = new HttpRequest();
     hreq.setHeader('Content-Type', 'application/json');
     hreq.setHeader('Authorization',authorizationHeader);
     hreq.settimeout(60000);
     hreq.setBody(requestBody); 
     hreq.setEndpoint(endpoint);
     hreq.setMethod('GET');
     String s = mockResponse;
     //MAKE CALLOUT IF NOT RUNNING TEST
     if(!Test.isRunningTest()){
         httpResponse res = http.send(hreq); 
         s = res.getbody();
     }
      
      system.debug('response of the service'+s);
      
      List<inventory_Response> responses = inventory_Response.parse(s);
      string indMessage;
      for(inventory_Response res :responses) {
          if (res.status == 'SUCCESS') {
              for(inventory_Response.atp_Response item :res.atp_response){
                  string material = item.material;
                  List<inventory_response.messages> messages = new List<inventory_response.messages>();
                  for(inventory_response.messages msg : item.messages){
                      indMessage = msg.message;
                      break;
                  }
                  string message = indMessage;
                  string reqdate = getStringdate(item.req_date);
                  string respMessage = message+':'+reqdate;
                  respMap.put(material,message);
              }
          }
          if(res.status == 'FAILED'){
              List<inventory_response.messages> messages = new List<inventory_response.messages>();
              for(inventory_response.messages msg : res.messages){
                      indMessage = msg.message;
                      break;
                  }
              String defaultString = Label.Atp_Default_Label;
              string message = indMessage+'. '+defaultString;
              for(Account_Material__c am : alist){
                  respMap.put(am.SAP_Material__r.Material_Number__c,message);
              }
              
          }
       } 
     system.debug('this is the response map'+respMap);
     return respMap; 
     
    }
    private static List<inventory_Request.Partners> buildPartners(Account acc) {
        List<inventory_Request.Partners> partners = new List<inventory_Request.Partners>();
        inventory_Request.Partners partnerSoldTo = new inventory_Request.Partners();
        partnerSoldTo.partn_role = PARTNER_ROLE_SOLD_TO_VALUE;
        //partnerSoldTo.partn_numb = acc.SAP_Sold_To_Account_Number__c;
        partnerSoldTo.partn_numb = acc.Sold_To_Customer_Number__c; 
        partners.add(partnerSoldTo);
        
        inventory_Request.Partners partnerShipTo = new inventory_Request.Partners();
        partnerShipTo.partn_role = PARTNER_ROLE_SHIP_TO_VALUE;
        partnerShipTo.partn_numb = acc.AccountNumber; 
        partners.add(partnerShipTo);
        return partners;
    }
    private static List<inventory_Request.header> buildheader(Account acc){
        List<inventory_Request.header> headers = new List<inventory_Request.header>();
        inventory_Request.header mainhead = new inventory_Request.header();
        mainhead.sales_org = acc.SAP_Sales_Org__c;
        mainhead.distr_chan = acc.SAP_DistChannel__c;
        mainhead.division = acc.SAP_DivisionCode__c;
        mainhead.language = userLanguage(); 
        headers.add(mainhead);
        return headers;
    }
    
    private static List<inventory_Request.items> builditems(List<Account_Material__c> alist){
        List<inventory_Request.items> items = new List<inventory_Request.items>();
        
        for(Account_Material__c am : alist){
            inventory_Request.items item = new inventory_Request.items();
            item.material = am.SAP_Material__r.Material_Number__c;
            system.debug('material info'+item.material);
            item.plant = am.SAP_Plant_Code__c;
            system.debug('plnat info'+item.plant);
            item.req_qty = am.Quantity__c.format();
            item.sales_unit = am.ATP_UOM__c;
            //String sMonth = String.valueof(am.Ship_Date__c.month());
            //String sDay = String.valueof(am.Ship_Date__c.day());
            //if(sMonth.length()==1){
            //    sMonth = '0' + sMonth;
            //}
            //if(sDay.length()==1){
            //     sDay = '0' + sDay;
            //}
            //String sDate = String.valueof(am.Ship_Date__c.year()) + sMonth + sDay ;
            
            
            item.req_date = am.Ship_Date__c;
            items.add(item);
        }
        return items;
    }
    
    public static List<inventory_request.switches> buildSwitches(){
        list<inventory_request.switches> swtchs = new list<inventory_request.switches>();
        inventory_request.switches swt = new inventory_request.switches();
        
        List<inventory_request.ATP> atps = new List<inventory_request.ATP>();
        inventory_request.ATP at = new inventory_request.ATP();
        at.swtchOn = 'X';
        at.locale = Userinfo.getLocale();
        atps.add(at);
        
        swt.ATP = atps;
        swtchs.add(swt);
        return swtchs;
    }
    
    private static string userLanguage(){
        String language;
        string userLanguage = UserInfo.getLanguage();
        for(PicklistEntry value: User.LanguageLocalekey.getDescribe().getPicklistValues()) {
            if(value.getValue() == userLanguage) {
                language = value.getLabel();
                break;
            }
        }
        return language;
    }
    
  
    public static string getStringdate(string s){
        //string y = s.substring(0,4);
        //string m = s.substring(4,6);
        //string d = s.substring(6,8);
        if(s != null){
            date dt = Date.valueof(s);
            string stDt = dt.format();
            return stDt;
        }
        else{
            return system.today().format();
        }
    }
    
    
}