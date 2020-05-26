@RestResource(urlMapping='/easyOrderStatusUpdate/*')
global with sharing class easyOrderStatusUpdate {

    @HttpDelete
    global static void doDelete() {

    }
    
 @HttpPost
    global static String doPost() {
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        Easyorder_Settings__c setting = Easyorder_Settings__c.getOrgDefaults();
                      
        
        // Instantiate a new http object to update the data.
        Http h = new Http();

        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest req2 = new HttpRequest();
                
        String username = setting.username__c;
        String password = setting.Password__c;

        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'BASIC ' +
        EncodingUtil.base64Encode(headerValue);
        req2.setHeader('Authorization', authorizationHeader);
        req2.setHeader('X-Parse-Application-Id', setting.X_Parse_Application_Id__c);
        req2.setHeader('X-Parse-REST-API-Key', setting.X_Parse_REST_API_Key__c);
        req2.setHeader('X-Parse-Revocable-Session', '1');
        req2.setHeader('Content-Type', 'application/json');               

        String parseId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);

        // backend changed Feb 2017
        String url = setting.Easy_Order_StatusUpdate_URL__c+ parseId;
             
        Blob body = req.requestBody;
        String bodyString = body.toString();
        String payLoad = bodyString;
        
        req2.setEndpoint(url);
        req2.setMethod('PUT');
        req2.setBody(payLoad);

 
        // Send the request, and return a response
        HttpResponse res2 = h.send(req2);
        
        //System.debug(res2.getBody());
        
        // logic to catch the situation where the easyPrice service is unavailable.
        String responseString = res2.getBody();
        Integer responseCode = res2.getStatusCode();
        String responseStatus = res2.getStatus();
        String connectionError = 'Connection Error to EasyOrder ' + string.valueof(responseCode) + ' ' + responseStatus; 
        
        // check to see if we have a connection failure, which will be indicated by html presence (503 error) and
        // have to scan the response to see if this is invalid;
        if(responseString != null && responseString.indexOf('<html>') != -1)
        {
          responseString = '{\"error\":\"' + connectionError + '\"}';
        }
        
        return responseString;
    }
  }