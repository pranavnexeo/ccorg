public class cc_imp_hlpr_WebServiceMonitoring {
    
    //Helper Methods.
    public static void sendEmail(string test_type, string request, string response, String error){
        String settingInstance = 'Monitoring';
        CC_SFDC_Settings__c wssettings = CC_SFDC_Settings__c.getInstance(settingInstance);
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = wssettings.CC_WS_Mon_Email_Exception__c.split(',');
        message.subject = 'CP-Exception Monitoring: [' + test_type + ']';
        String plainText = ' \n Request : \n ' + request;
        plainText += ' \n Response : \n ' + response;
        plainText += ' \n Error : \n ' + error;
        message.plainTextBody = plainText;
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);       
    }
    
  	public static String serializeViewCreditRequest(Id acct) {
	    Account account =  cc_imp_dao_Account.getAccountForViewCreditRequest(acct);					     

	  	cc_mn_json_ViewCreditRequest viewCreditRequest = new cc_mn_json_ViewCreditRequest();
		viewCreditRequest.customerno = account.SAP_Customer_Number__c;
		viewCreditRequest.salesorg = account.SAP_Sales_Org__c;
		viewCreditRequest.company_code = account.SAP_Sales_Org__c;
		viewCreditRequest.distr_chan = account.SAP_DistChannel__c;
		viewCreditRequest.division = account.SAP_DivisionCode__c;

       return viewCreditRequest.serialize();
	  }
    
    public static List<cc_mn_json_ProfileResponse>  FetchProfileDetail(string accountid){
        String responseBody;
        String formattedRequestBody;
        try
        {
                Account acc= new account();
                if(test.isrunningtest())
                {
                    acc.SAP_Sales_Org__c='34321';
                    acc.SAP_DistChannel__c='34321';
                    acc.SAP_DivisionCode__c  ='34321';
                    
                   // response.document='test';
                }
                else
                {
                    for(account a :[select id,SAP_Customer_Number__c,SAP_Sales_Org__c,SAP_DistChannel__c ,SAP_DivisionCode__c    from account where AccountNumber=:accountid])
                    {
                        acc =a;
                    }
                }
        
            list<cc_mn_json_ProfileResponse> lstResponse = new list<cc_mn_json_ProfileResponse>();
            cc_imp_StorefrontSettings__C storefrontSettings =  cc_imp_StorefrontSettings__C.getInstance('mynexeo');
            Http http = new Http();
            HttpRequest httpRequest = new HttpRequest();
            system.debug('httpRequest=='+httpRequest);
            
            String endpointPath = storefrontSettings.ProfilePath__c;
            
            List<WrapRequest> wrpReq = new List<WrapRequest>();
            WrapRequest objR = new WrapRequest();
            objR.CUSTOMER= accountid;//acc.SAP_Customer_Number__c;
            objR.SALES_ORG = acc.SAP_Sales_Org__c;
            objR.DISTR_CHAN = acc.SAP_DistChannel__c;
            objR.DIVISION = acc.SAP_DivisionCode__c;
            wrpReq.add(objR);
           // String formattedRequestBody =  '[{"CUSTOMER":"'+accountid+'"}]';
            
            formattedRequestBody =  JSON.serialize(wrpReq,true);
            system.debug('body'+formattedRequestBody);
            
            httpRequest.setHeader('Content-Type', 'application/json');
            httpRequest.setBody(formattedRequestBody);
            httpRequest.setendpoint('callout:Nexeo_SAP_Endpoint/'+ endpointPath);
            httpRequest.setMethod('GET');
            httpRequest.settimeout(60000);
            system.debug('httpRequest=='+httpRequest);
            
            HttpResponse httpResponse = http.send(httpRequest);
            system.debug('httpResponse::'+httpResponse);
            responseBody = httpResponse.getBody();
            system.debug('httpResponse.StatusCode::'+responseBody);
            if (String.isNotBlank(httpResponse.getBody()) && httpResponse.getStatusCode() == 200) 
            {
                responseBody = httpResponse.getBody().unescapeEcmaScript();
                lstResponse = cc_mn_json_ProfileResponse.parse(responseBody);  
                return lstResponse;
            } else {
                sendEmail('CP_CUST_WASTE_PROFIL', formattedRequestBody, responseBody, String.valueOf(httpResponse.getStatusCode()));
                return null;
            }
            
            }
        catch(Exception e){
            sendEmail('CP_CUST_WASTE_PROFIL', formattedRequestBody, responseBody, e.getMessage());
            return null;
        }

    }
    
    public class WrapRequest {
        public string CUSTOMER;
        public string SALES_ORG;
        public string DISTR_CHAN;
        public string DIVISION;
    }
    
    public static cc_mn_json_myInvoiceResponse fetchMyInvoiceEncodedPdf(String storeFrontName, String invoiceId) {
 		  cc_mn_json_myInvoiceResponse myInvoiceResponse = new cc_mn_json_myInvoiceResponse();

	  	  String httpResponseCodeString;
          String responseBody;
          String formattedRequestBody;

	  	  try
	  	  {

		       cc_imp_StorefrontSettings__C storefrontSettings =  cc_imp_StorefrontSettings__C.getInstance(storeFrontName);
		     
		       cc_imp_util_Http request = new cc_imp_util_Http();
		       request.method = cc_imp_util_Http.REQUEST_TYPE.POST;

		       String myInvoiceEndpointPath = storefrontSettings.MyInvoiceEndpointURLPath__c;

		       request.endpoint = ('callout:Nexeo_SAP_Endpoint/'+ myInvoiceEndpointPath) ;

		       request.addQueryParameter('sap-client', '020');
		   	
		   	   cc_mn_json_myInvoiceRequest myInvoiceRequest = new cc_mn_json_myInvoiceRequest();
		   	   myInvoiceRequest.document = invoiceId;

			   formattedRequestBody = cc_imp_util_Storefront.formatSerializedJSONRequest(myInvoiceRequest.serialize());

			   request.body =  formattedRequestBody ;

		        HttpResponse httpResponse = request.submitRequest();

		        httpResponseCodeString = String.valueOf(httpResponse.getStatusCode() );

		        responseBody =  httpResponse.getBody(); 

		       if(httpResponse.getStatusCode() == 200 )
		       {
		       	if (String.isNotBlank(responseBody))
		       	{
		       		String formattedResponseBody =  cc_imp_util_Storefront.formatJSONResponse(responseBody);

		     	    myInvoiceResponse = cc_mn_json_myInvoiceResponse.parse(formattedResponseBody);
		       	}
		      	
		     	myInvoiceResponse.responseCode  = httpResponseCodeString;
		     	myInvoiceResponse.success = true;
		      }
		      else {
		      	myInvoiceResponse.success = false;
		      	myInvoiceResponse.responseCode  = httpResponseCodeString;
                sendEmail('BILLING_PDF', formattedRequestBody, responseBody, httpResponseCodeString);
		      }
	     }
	    catch(Exception e){
	     	myInvoiceResponse.success = false;
	     	myInvoiceResponse.message = e.getMessage() ;
	     	myInvoiceResponse.responseCode  = httpResponseCodeString;
            sendEmail('BILLING_PDF', formattedRequestBody, responseBody, e.getMessage());
	     }

	     return myInvoiceResponse;        

    }
    
    public static cc_mn_json_ESProfileResponse FetchProfileDoc(String strProfileId) {
		cc_mn_json_ESProfileResponse response = new cc_mn_json_ESProfileResponse();
        if(!String.isBlank(strProfileId )) {
            system.debug('pass from here1==='+strProfileId);
            
            String httpResponseCodeString = '';
            String formattedRequestBody;
            try {
                cc_imp_StorefrontSettings__C storefrontSettings =  cc_imp_StorefrontSettings__C.getInstance('mynexeo');
                cc_imp_util_Http httpRequest = new cc_imp_util_Http();
                httpRequest.method = cc_imp_util_Http.REQUEST_TYPE.POST;
                String endpointPath = storefrontSettings.ProfileDocEndpointURLPath__c;//'sap/bc/ZSD_GET_PROFILE?sap_client=020';
                //string endpointpath = '';
                httpRequest.endpoint = ('callout:Nexeo_SAP_Endpoint/'+ endpointPath);
                cc_mn_json_CofARequest request = new cc_mn_json_CofARequest();
                list<ES_Order_Document__c> obj = new list<ES_Order_Document__c>();
                obj =[select id from ES_Order_Document__c];
                if(obj == null || obj.size() ==0) {
                    obj = new list<ES_Order_Document__c>();
                    obj.add(new ES_Order_Document__c());
                }    
                formattedRequestBody =  '[{"SPECIFICATION":"'+strProfileId +'"}]'; 
                
                httpRequest.body = formattedRequestBody;
                HttpResponse httpResponse = httpRequest.submitRequest();
                system.debug('httpResponse::'+httpResponse.getBody());
                string responseBody = httpResponse.getBody();
                httpResponseCodeString = String.valueOf(httpResponse.getStatusCode());
               
                if (String.isNotBlank(responseBody)) {
                    String formattedResponseBody =  cc_imp_util_Storefront.formatJSONResponse(responseBody);
                    response = cc_mn_json_ESProfileResponse.parse(formattedResponseBody);
                }
                
				if(httpResponseCodeString != '200'){
					response.success = false;
                    sendEmail('CP_WASTE_PROFILE', formattedRequestBody, responseBody, httpResponseCodeString);

                } else {
                    response.success = true;
                }
               
            } catch (Exception e) {
                System.debug(System.LoggingLevel.ERROR, e);
                response.success = false;
                response.message = e.getMessage();
                response.responseCode  = httpResponseCodeString;
                system.debug('response code'+httpresponsecodestring);
                system.debug('message'+e.getmessage());
                if( response.responseCode!='200'){
                    
                }
                sendEmail('CP_WASTE_PROFILE', formattedRequestBody, httpResponseCodeString, e.getMessage());

            }
            system.debug('response.document ==='+response.document );
            
        }
        return response;
    }
    
    public static cc_mn_json_ViewCreditResponse viewCredit(String accountId){
		cc_mn_json_ViewCreditResponse viewCreditResponse = new cc_mn_json_ViewCreditResponse();
     	 boolean Success=false;
	  	 String httpResponseCodeString;
		 String formattedRequestBody = '';
         String responseBody = '';
	  	try 
	  	{
		  	String storeFrontName = 'mynexeo';
			cc_imp_StorefrontSettings__C storefrontSettings =  cc_imp_StorefrontSettings__C.getInstance(storeFrontName);		  
		  	cc_imp_util_Http request = new cc_imp_util_Http();
		  	request.method = cc_imp_util_Http.REQUEST_TYPE.POST;
		  	String endpointPath = storefrontSettings.ViewCreditHistoryURLPath__c;
		  	request.endpoint = ('callout:Nexeo_SAP_Endpoint/'+ endpointPath) ;
			request.addQueryParameter('sap-client', '020');		
		    formattedRequestBody = cc_imp_util_Storefront.formatSerializedJSONRequest(serializeViewCreditRequest(accountId));
			request.body =  formattedRequestBody ;		
			HttpResponse httpResponse = request.submitRequest();
			httpResponseCodeString = String.valueOf(httpResponse.getStatusCode() );
			responseBody =  httpResponse.getBody(); 
			if(httpResponse.getStatusCode() == 200 )
			{
				if ( String.isNotBlank(responseBody))
				{
					 viewCreditResponse.success = true;				
				}			   			   
			}
			else
			{
				viewCreditResponse.success=false;    
                cc_imp_hlpr_WebServiceMonitoring.sendEmail('CREDIT_CHECK', formattedRequestBody, responseBody, String.valueOf(httpResponse.getStatusCode()));
			}
      	}
		catch(Exception e)
     	{
            viewCreditResponse.success=false;
     		//viewCreditResponse.success = false;
			//viewCreditResponse.statusCode = httpResponseCodeString;
			//viewCreditResponse.message = e.getMessage();
			cc_imp_hlpr_WebServiceMonitoring.sendEmail('CREDIT_CHECK', formattedRequestBody, responseBody, e.getMessage());	
     	}
        return viewCreditResponse;        
    }

            

    
}