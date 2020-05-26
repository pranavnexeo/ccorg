public with sharing class cc_mn_api_CofA {
    public static cc_mn_json_CofAResponse fetchCofA(String storefront, String materialId, String batchNumber) {
        cc_mn_json_CofAResponse response = new cc_mn_json_CofAResponse();

        String httpResponseCodeString = null;

        try {
            cc_imp_StorefrontSettings__C storefrontSettings =  cc_imp_StorefrontSettings__C.getInstance(storefront);
             
            cc_imp_util_Http httpRequest = new cc_imp_util_Http();
            httpRequest.method = cc_imp_util_Http.REQUEST_TYPE.POST;

            String endpointPath = storefrontSettings.CofAEndpointURLPath__c;

            httpRequest.endpoint = ('callout:Nexeo_SAP_Endpoint/'+ endpointPath) ;

            httpRequest.addQueryParameter('sap-client', '020');
            
            cc_mn_json_CofARequest request = new cc_mn_json_CofARequest();
            request.material = materialId;
            request.batch_number = batchNumber;

            String formattedRequestBody = cc_imp_util_Storefront.formatSerializedJSONRequest(request.serialize());

            httpRequest.body = formattedRequestBody ;

            HttpResponse httpResponse = httpRequest.submitRequest();

            httpResponseCodeString = String.valueOf(httpResponse.getStatusCode());

            String responseBody =  httpResponse.getBody(); 

            if (httpResponse.getStatusCode() == 200) {
                if (String.isNotBlank(responseBody)) {
                    String formattedResponseBody =  cc_imp_util_Storefront.formatJSONResponse(responseBody);
                    response = cc_mn_json_CofAResponse.parse(formattedResponseBody);
                }
                response.responseCode = httpResponseCodeString;
                response.success = true;
            }
            else {
                response.success = false;
                response.responseCode  = httpResponseCodeString;
            }
        }
        catch (Exception e) {
            System.debug(System.LoggingLevel.ERROR, e);
            response.success = false;
            response.message = e.getMessage();
            response.responseCode  = httpResponseCodeString;
        }

        return response;
    }
}