public with sharing class cc_mn_api_ViewCredit 
{
	 public static cc_mn_json_ViewCreditResponse fetchViewCreditInfo()
	 {
	  	 cc_mn_json_ViewCreditResponse viewCreditResponse = new cc_mn_json_ViewCreditResponse();

	  	 String httpResponseCodeString;

	  	try 
	  	{
		  	String storeFrontName = ccrz.cc_CallContext.storefront;

			cc_imp_StorefrontSettings__C storefrontSettings =  cc_imp_StorefrontSettings__C.getInstance(storeFrontName);
		  
		  	cc_imp_util_Http request = new cc_imp_util_Http();
		  	request.method = cc_imp_util_Http.REQUEST_TYPE.POST;

		  	String endpointPath = storefrontSettings.ViewCreditHistoryURLPath__c;

		  	request.endpoint = ('callout:Nexeo_SAP_Endpoint/'+ endpointPath) ;

			request.addQueryParameter('sap-client', '020');
		
		    String formattedRequestBody = cc_imp_util_Storefront.formatSerializedJSONRequest(serializeViewCreditRequest());

			request.body =  formattedRequestBody ;
			
			HttpResponse httpResponse = request.submitRequest();

			httpResponseCodeString = String.valueOf(httpResponse.getStatusCode() );

			String responseBody =  httpResponse.getBody(); 

			if(httpResponse.getStatusCode() == 200 )
			{
				if ( String.isNotBlank(responseBody))
				{
					 String formattedResponseBody =  cc_imp_util_Storefront.formatJSONResponse(responseBody);

			  		 viewCreditResponse  = cc_mn_json_ViewCreditResponse.parse(formattedResponseBody );
				}
			   viewCreditResponse.statusCode = httpResponseCodeString;
			   viewCreditResponse.success = true;
			}
			else
			{
				viewCreditResponse.success = false;
				viewCreditResponse.statusCode = httpResponseCodeString;
			}
      	}
		catch(Exception e)
     	{
     		viewCreditResponse.success = false;
			viewCreditResponse.statusCode = httpResponseCodeString;
			viewCreditResponse.message = e.getMessage();	
     	}

     	return viewCreditResponse;
     }




      private static String serializeViewCreditRequest()
	  {
	    Account account =  cc_imp_dao_Account.getAccountForViewCreditRequest(ccrz.cc_CallContext.currAccountId);					     

	  	cc_mn_json_ViewCreditRequest viewCreditRequest = new cc_mn_json_ViewCreditRequest();
		viewCreditRequest.customerno = account.SAP_Customer_Number__c;
		viewCreditRequest.salesorg = account.SAP_Sales_Org__c;
		viewCreditRequest.company_code = account.SAP_Sales_Org__c;
		viewCreditRequest.distr_chan = account.SAP_DistChannel__c;
		viewCreditRequest.division = account.SAP_DivisionCode__c;

       return viewCreditRequest.serialize();
	  }

 }