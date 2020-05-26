public with sharing class cc_mn_api_FetchInvoice  
{

	  public static cc_mn_json_myInvoiceResponse fetchMyInvoiceEncodedPdf(String invoiceId)
	  {
	  	  cc_mn_json_myInvoiceResponse myInvoiceResponse = new cc_mn_json_myInvoiceResponse();

	  	  String httpResponseCodeString;

	  	  try
	  	  {
			   String storeFrontName = ccrz.cc_CallContext.storefront;

		       cc_imp_StorefrontSettings__C storefrontSettings =  cc_imp_StorefrontSettings__C.getInstance(storeFrontName);
		     
		       cc_imp_util_Http request = new cc_imp_util_Http();
		       request.method = cc_imp_util_Http.REQUEST_TYPE.POST;

		       String myInvoiceEndpointPath = storefrontSettings.MyInvoiceEndpointURLPath__c;

		       request.endpoint = ('callout:Nexeo_SAP_Endpoint/'+ myInvoiceEndpointPath) ;

		       request.addQueryParameter('sap-client', '020');
		   	
		   	   cc_mn_json_myInvoiceRequest myInvoiceRequest = new cc_mn_json_myInvoiceRequest();
		   	   myInvoiceRequest.document = invoiceId;

		   	    String formattedRequestBody = cc_imp_util_Storefront.formatSerializedJSONRequest(myInvoiceRequest.serialize());

			   request.body =  formattedRequestBody ;

		        HttpResponse httpResponse = request.submitRequest();

		        httpResponseCodeString = String.valueOf(httpResponse.getStatusCode() );

		        String responseBody =  httpResponse.getBody(); 

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
		      else
		      {
		      	myInvoiceResponse.success = false;
		      	myInvoiceResponse.responseCode  = httpResponseCodeString;
		      }
	     }
	    catch(Exception e)
	     {
	     	myInvoiceResponse.success = false;
	     	myInvoiceResponse.message = e.getMessage() ;
	     	myInvoiceResponse.responseCode  = httpResponseCodeString;
	     }

	     return myInvoiceResponse;
	   }
	
}