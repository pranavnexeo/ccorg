public with sharing class cc_mn_api_FetchSDS 
{
	 public static cc_mn_json_MSDSResponse fetchMSDS(String materialId)
	  {
	  	  cc_mn_json_MSDSResponse sdsResponse = new cc_mn_json_MSDSResponse();

	  	  String httpResponseCodeString;

	  	  try
	  	  {
			   String storeFrontName = ccrz.cc_CallContext.storefront;

		       cc_imp_StorefrontSettings__C storefrontSettings =  cc_imp_StorefrontSettings__C.getInstance(storeFrontName);
		     
		       cc_imp_util_Http request = new cc_imp_util_Http();
		       request.method = cc_imp_util_Http.REQUEST_TYPE.POST;

		       String msdsEndpointPath = storefrontSettings.MSDSEndpointURLPath__c;

		       request.endpoint = ('callout:Nexeo_SAP_SDS_Endpoint/'+ msdsEndpointPath) ;

		       request.addQueryParameter('sap-client', '020');
		   	
		   	   cc_mn_json_MSDSRequest sdsRequest = new cc_mn_json_MSDSRequest();
		   	   sdsRequest.material = materialId;

		   	    String formattedRequestBody = cc_imp_util_Storefront.formatSerializedJSONRequest(sdsRequest.serialize());

			   request.body =  formattedRequestBody ;

		        HttpResponse httpResponse = request.submitRequest();

		        httpResponseCodeString = String.valueOf(httpResponse.getStatusCode() );

		        String responseBody =  httpResponse.getBody(); 

		       if(httpResponse.getStatusCode() == 200 )
		       {
		       	if (String.isNotBlank(responseBody))
		       	{
		       		String formattedResponseBody =  cc_imp_util_Storefront.formatJSONResponse(responseBody);

		     	    sdsResponse = cc_mn_json_MSDSResponse.parse(formattedResponseBody);
		       	}
		     	sdsResponse.responseCode  = httpResponseCodeString;
		     	sdsResponse.success = true;
		      }
		      else
		      {
		      	sdsResponse.success = false;
		      	sdsResponse.responseCode  = httpResponseCodeString;
		      }
	     }
	    catch(Exception e)
	     {
	     	sdsResponse.success = false;
	     	sdsResponse.message = e.getMessage() ;
	     	sdsResponse.responseCode  = httpResponseCodeString;
	     }

	     return sdsResponse;
	   }
}