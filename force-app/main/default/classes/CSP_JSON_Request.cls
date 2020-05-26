Public Class CSP_JSON_Request{

private static final string mockResponse = '[{"business_line": "", "sold_to": "0000127771", "ship_to": "0000127771", "material_nbr": "000000000000069917", "lbs_unit": "", "sales_unit": "DR", "price_date": "11/19/2012", "return_type": "S", "return_message": "Price generated successfully", "sfdc_account_id": "001E000000CTuUXIA1", "sfdc_material_id": "a56c0000000Ce3fAAC", "last_changed": "21.11.2012", "last_changed_tim": "02:19:02", "avg_order_qty": "0.000 ", "avg_order_unit": "", "tbl_sales_units": [{"material_nbr": "000000000000069917", "sales_unit": "DR", "numerator": "17917 ", "denominator": "100 ", "base_unit": "KG"}, {"material_nbr": "000000000000069917", "sales_unit": "GLL", "numerator": "3270 ", "denominator": "1000 ", "base_unit": "KG"}, {"material_nbr": "000000000000069917", "sales_unit": "KG", "numerator": "1 ", "denominator": "1 ", "base_unit": "KG"}, {"material_nbr": "000000000000069917", "sales_unit": "LB", "numerator": "32523 ", "denominator": "71701 ", "base_unit": "KG"}, {"material_nbr": "000000000000069917", "sales_unit": "PAL", "numerator": "71668 ", "denominator": "100 ", "base_unit": "KG"}, {"material_nbr": "000000000000069917", "sales_unit": "RCU", "numerator": "17917 ", "denominator": "100 ", "base_unit": "KG"}], "tbl_csp_prices": [{"csp_tier": "1 ", "csp_price": "6.7100 ", "csp_volume": "1", "csp_price_unit": "1 ", "csp_uom": "GLL", "csp_currency": "USD", "csp_effective_date": "20121001", "csp_expiration_date": "99991231", "csp_price_protection_code": "Z5", "csp_price_protection_desc": "Qtrly - 1st of Qtr", "csp_drum_deposit_code": "", "csp_scale_uom": "DR", "csp_condition_nbr": "0035036317", "csp_sfdc_pricereq_nbr": "", "csp_tpi": ""}], "tbl_target_prices": [{"target_tier": "1 ", "tier_volume": "1.000 ", "target_price": "0.8900 ", "target_price_unit": "1", "target_price_uom": "LB", "target_price_currency": "USD", "total_target_price": "", "exception1_price": "0.8722", "exception2_price": "0.8544", "target_scale_uom": "DR", "dpl_price": "", "dpl_price_unit": "", "dpl_price_uom": "", "dpl_price_currency": ""}, {"target_tier": "2 ", "tier_volume": "4.000 ", "target_price": "0.8600 ", "target_price_unit": "1", "target_price_uom": "LB", "target_price_currency": "USD", "total_target_price": "", "exception1_price": "0.8428", "exception2_price": "0.8256", "target_scale_uom": "DR", "dpl_price": "", "dpl_price_unit": "", "dpl_price_uom": "", "dpl_price_currency": ""}, {"target_tier": "3 ", "tier_volume": "10.000 ", "target_price": "0.8400 ", "target_price_unit": "1", "target_price_uom": "LB", "target_price_currency": "USD", "total_target_price": "", "exception1_price": "0.8232", "exception2_price": "0.8064", "target_scale_uom": "DR", "dpl_price": "", "dpl_price_unit": "", "dpl_price_uom": "", "dpl_price_currency": ""}, {"target_tier": "4 ", "tier_volume": "40.000 ", "target_price": "0.8100 ", "target_price_unit": "1", "target_price_uom": "LB", "target_price_currency": "USD", "total_target_price": "", "exception1_price": "0.7938", "exception2_price": "0.7776", "target_scale_uom": "DR", "dpl_price": "", "dpl_price_unit": "", "dpl_price_uom": "", "dpl_price_currency": ""}]}]';
Public Static List<CSP_JSON_Response> Submit_Request(List<CSP_JSON_Request_Item> items){

        List<CSP_JSON_Response> deserializedResponses = new List<CSP_JSON_Response>();
        
        nexPrice_Settings__c settings = nexPrice_Settings__c.getOrgDefaults();
        String endpoint = settings.EasyPrice_EndPoint__c;
        if(items.size() > 0)
        {
        String JSONString = JSON.serialize(items);
        system.debug('JSONString: ' + JSONString);
        Http http = new Http();
        HttpRequest hreq = new HttpRequest();
        hreq.setHeader('Content-Type', 'application/xml');  
        hreq.settimeout(60000);
        hreq.setBody(JSONString);    
        hreq.setEndpoint(endpoint);
        hreq.setMethod('POST');
        string s = mockResponse;
        if(Test.isRunningTest() == false)
        {
          httpResponse res = http.send(hreq); 
          s = res.getbody();
        }
        
        system.debug('Raw Response: ' + s);
        s = s.unescapeEcmaScript();
        s = s.unescapeEcmaScript();
        //system.debug('JSON: '  + s);
        deserializedResponses = (List<CSP_JSON_Response>)JSON.deserialize(s, List<CSP_JSON_Response>.class);  
        }
        
        return deserializedResponses;
      
    }
Public Static List<CSP_JSON_Response> Submit_Request_m(List<CSP_JSON_Request_Item> items){

        nexPrice_Settings__c settings = nexPrice_Settings__c.getOrgDefaults();
        List<CSP_JSON_Response> deserializedResponses = new List<CSP_JSON_Response>();
        
        String endpoint = settings.Mini_EndPoint__c;
        system.debug('items size: ' + items.size());
        
        if(items.size() > 0){
        String JSONString = JSON.serialize(items);
        system.debug('JSONString: ' + JSONString);
            system.debug('settings:== ' + settings);
                system.debug('endpoint:== ' + endpoint);
        Http http = new Http();
        HttpRequest hreq = new HttpRequest();
        hreq.setHeader('Content-Type', 'application/xml');  
        hreq.settimeout(60000);
        hreq.setBody(JSONString);    
        hreq.setEndpoint(endpoint);
        hreq.setMethod('POST');
        string s = mockResponse;
        if(Test.isRunningTest() == false)
        {
          httpResponse res = http.send(hreq); 
          s = res.getbody();
        }
        system.debug('Raw Response: ' + s);
        s = s.unescapeEcmaScript();
        s = s.unescapeEcmaScript();
        system.debug('JSON: '  + s);
        deserializedResponses = (List<CSP_JSON_Response>)JSON.deserialize(s, List<CSP_JSON_Response>.class);
        }  
        return deserializedResponses;
      
    }
Public Static List<CSP_JSON_Response> Submit_Request_m(List<List<CSP_JSON_Request_Item>> listofitems){

       
        
        integer max_calls = listofitems.size();
        if(max_calls > 10)
          max_calls = 10;
        
        List<CSP_JSON_Response> Responses = new List<CSP_JSON_Response>();
        
        for(integer i=0; i<max_calls; i++)
        {
        List<CSP_JSON_Request_Item> items = listofitems.get(i);
        List<CSP_JSON_Response> deserializedResponses = new List<CSP_JSON_Response>();
        if(items.size() > 0)
        {
        nexPrice_Settings__c settings = nexPrice_Settings__c.getOrgDefaults();
        String endpoint = settings.Mini_EndPoint__c;
        String JSONString = JSON.serialize(items);
        system.debug('JSONString: ' + JSONString);
        Http http = new Http();
        HttpRequest hreq = new HttpRequest();
        hreq.setHeader('Content-Type', 'application/xml');  
        hreq.settimeout(60000);
        hreq.setBody(JSONString);    
        hreq.setEndpoint(endpoint);
        hreq.setMethod('POST');
        string s = mockResponse;
        if(Test.isRunningTest() == false)
        {
          httpResponse res = http.send(hreq); 
          s = res.getbody();
        }
       // system.debug('Raw Response: ' + s);
        s = s.unescapeEcmaScript();
        s = s.unescapeEcmaScript();
        system.debug('JSON: '  + s);
    
        deserializedResponses = (List<CSP_JSON_Response>)JSON.deserialize(s, List<CSP_JSON_Response>.class);  
        Responses.addall(deserializedResponses);
        }
        }
        return responses;
    }
    
Public Static List<CSP_JSON_Response> Submit_History_Request(List<CSP_History_JSON_Request_Item> items){
        
        
        nexPrice_Settings__c settings = nexPrice_Settings__c.getOrgDefaults();
        String endpoint = settings.History_EndPoint__c;
        List<CSP_JSON_Response> deserializedResponses = new  List<CSP_JSON_Response>();
        
        if(items.size() > 0){
        String JSONString = JSON.serialize(items);
        system.debug('JSONString: ' + JSONString);
        Http http = new Http();
        HttpRequest hreq = new HttpRequest();
        hreq.setHeader('Content-Type', 'application/xml');  
        hreq.settimeout(60000);
        hreq.setBody(JSONString);    
        hreq.setEndpoint(endpoint);
        hreq.setMethod('POST');
        string s = mockResponse;
        if(Test.isRunningTest() == false)
        {
          httpResponse res = http.send(hreq); 
          s = res.getbody();
        }
        system.debug('History Raw Response: ' + s);
        s = s.unescapeEcmaScript();
        s = s.unescapeEcmaScript();
         
        if(s.contains('['))
          deserializedResponses = (List<CSP_JSON_Response>)JSON.deserialize(s, List<CSP_JSON_Response>.class);  
        else
        {  CSP_JSON_Response deserializedResponse = (CSP_JSON_Response)JSON.deserialize(s, CSP_JSON_Response.class);
           deserializedresponses.add(deserializedresponse);
        
        }
        }
        return deserializedResponses;
    }

Public Static List<CM_JSON_Response> Submit_Request_CM(List<CM_JSON_Request_Item> items){
             
        nexPrice_Settings__c settings = nexPrice_Settings__c.getOrgDefaults();
        List<CM_JSON_Response> deserializedResponses = new List<CM_JSON_Response>();
        
        String endpoint = settings.Contribution_Margin_Endpoint__c;
        system.debug('items size: ' + items.size());
        
        if(items.size() > 0){
        String JSONString = JSON.serialize(items);
        system.debug('JSONString: ' + JSONString);
        Http http = new Http();
        HttpRequest hreq = new HttpRequest();
        hreq.setHeader('Content-Type', 'application/xml');  
        hreq.settimeout(120000);
        hreq.setBody(JSONString);    
        hreq.setEndpoint(endpoint);
        hreq.setMethod('POST');
        string s = mockResponse;
        if(Test.isRunningTest() == false)
        {
          httpResponse res = http.send(hreq); 
          s = res.getbody();
        }
        system.debug('CM Raw Response: ' + s);
        s = s.unescapeEcmaScript();
        s = s.unescapeEcmaScript();
        system.debug('CM JSON: '  + s);
        deserializedResponses = (List<CM_JSON_Response>)JSON.deserialize(s, List<CM_JSON_Response>.class);
        }  
        return deserializedResponses;
        
        
           
    }
      
Public Static string Submit_Request_String(List<CSP_JSON_Request_Item> items){
             
        nexPrice_Settings__c settings = nexPrice_Settings__c.getOrgDefaults();
        String endpoint = settings.EasyPrice_EndPoint__c;
        String JSONString = JSON.serialize(items);
        Http http = new Http();
        HttpRequest hreq = new HttpRequest();
        hreq.setHeader('Content-Type', 'application/xml');  
        hreq.settimeout(120000);
        hreq.setBody(JSONString);    
        hreq.setEndpoint(endpoint);
        hreq.setMethod('POST');
        string s = mockResponse;
        if(Test.isRunningTest() == false)
        {
          httpResponse res = http.send(hreq); 
          s = res.getbody();
        }
        return s;   
    }
    
Public Static string Submit_History_Request_String(List<CSP_History_JSON_Request_Item> items){
             
        nexPrice_Settings__c settings = nexPrice_Settings__c.getOrgDefaults();
        String endpoint = settings.History_EndPoint__c;
        String JSONString = JSON.serialize(items);
        Http http = new Http();
        HttpRequest hreq = new HttpRequest();
        hreq.setHeader('Content-Type', 'application/xml');  
        hreq.settimeout(120000);
        hreq.setBody(JSONString);    
        hreq.setEndpoint(endpoint);
        hreq.setMethod('POST');
        string s = mockResponse;
        if(Test.isRunningTest() == false)
        {
          httpResponse res = http.send(hreq); 
          s = res.getbody();
        }
        return s;  
    }
}