/**
* Product API Service
*
* HTTP Methods Used:
*
* GET
* POST
* PUT
*
*/
@RestResource(urlMapping='/nex/v1/products/*')
global with sharing class cc_imp_api_Product {
	
    /**
    * Handle POST
    *
    */
    @HttpPost
    global static ResponseWrapper doPost(PostRequestWrapper request) {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        PostResponseWrapper response = new PostResponseWrapper();

        ccrz__E_Product__c product = new ccrz__E_Product__c();
        product.name = request.name;
        product.ccrz__shortDesc__c = request.shortDescription;
        product.ccrz__sku__c = request.sku;

        try {
            insert product;
        } catch (Exception e) {
            system.debug('Error inserting product : ' + e.getMessage());
            res.statusCode = 400;
            return new ErrorResponseWrapper('error message');
        }

        response.productId = '';

        return response;

    }

    /**
    * Handle GET
    *
    * Expected URI - /product/:id
    */
    @HttpGet
    global static GetResponseWrapper doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        GetResponseWrapper response = new GetResponseWrapper();

        String productId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);
        
        if (productId != NULL && !''.equals(productId)) {
            ccrz__E_Product__c productRec = [
                SELECT
                    id,
                    name, 
                    ccrz__shortDesc__c, 
                    ccrz__sku__c 
                FROM
                    ccrz__E_Product__c
                LIMIT 1
            ];

            response.name = productRec.name;
            response.shortDescription = productRec.ccrz__shortDesc__c;
            response.sku = productRec.ccrz__sku__c;
         
        } else {

            // ... Return a list of products with pagination.

        }

        return response;
    }

    /**
    * Handle PUT
    *
    * Expected URI - /product/:id
    */
    @HttpPut
    global static String doPut() {

        return '';
    }

    /**
    * GET response wrapper
    *
    *
    */
    global class GetResponseWrapper {

        // Insert fields available to GET
        String name;
        String shortDescription;
        String sku;

        public getResponseWrapper() {

        }
    }

    /**
    * PUT request wrapper
    *
    *
    */
    global class PutRequestWrapper {

        // Insert fields available to PUT
        String name;
        String shortDescription;
        String sku;

        //public patchRequestWrapper() {

        //}
    }

    /**
    * PUT response wrapper
    *
    *
    */
    global class PutResponseWrapper {

        // Insert fields available to PUT

        //public patchResponseWrapper() {

        //}
    }

    /**
    * POST request wrapper
    *
    */
    global class postRequestWrapper {

        // All fields expected in request
        String name;
        String shortDescription;
        String sku;

        public postRequestWrapper() {

        }
    }

    /**
    * POST response wrapper
    *
    */
    global class PostResponseWrapper implements ResponseWrapper {
        
        String productId;

        public postResponseWrapper() {

        }
    }

    /**
    * Generic Error response wrapper
    *
    */
    global class ErrorResponseWrapper implements ResponseWrapper {

        String message;

        public errorResponseWrapper(String errorMessage) {
            message = errorMessage;
        }

    }

    /**
    * REST Response Interface
    *
    */
    global interface ResponseWrapper {

    }

}