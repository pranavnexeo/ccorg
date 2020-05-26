Public class cc_imp_mn_ViewProfileDoc
{
    public string strProfileId;
    public String pdf {get;set;}
    public string doc{get;set;}
    public id docId{get;set;}

    public pagereference FetchProfileDoc()
    {
        strProfileId = ApexPages.currentPage().getParameters().get('strPid');
        doc = '';
        if(!String.isBlank(strProfileId ))
        {
            system.debug('pass from here1==='+strProfileId);
            cc_mn_json_ESProfileResponse response = new cc_mn_json_ESProfileResponse();
            string httpResponseCodeString = '';
            try
            {
                cc_imp_StorefrontSettings__C storefrontSettings =  cc_imp_StorefrontSettings__C.getInstance('mynexeo');
                cc_imp_util_Http httpRequest = new cc_imp_util_Http();
                httpRequest.method = cc_imp_util_Http.REQUEST_TYPE.POST;
                String endpointPath = storefrontSettings.ProfileDocEndpointURLPath__c;//'sap/bc/ZSD_GET_PROFILE?sap_client=020';
                //string endpointpath = '';
                httpRequest.endpoint = ('callout:Nexeo_SAP_Endpoint/'+ endpointPath);
                cc_mn_json_CofARequest request = new cc_mn_json_CofARequest();
                list<ES_Order_Document__c> obj = new list<ES_Order_Document__c>();
                obj =[select id from ES_Order_Document__c];
                if(obj == null || obj.size() ==0)
                {
                    obj = new list<ES_Order_Document__c>();
                    obj.add(new ES_Order_Document__c());
                }    
                String formattedRequestBody =  '[{"SPECIFICATION":"'+strProfileId+'"}]'; 
                
                httpRequest.body = formattedRequestBody;
                HttpResponse httpResponse = httpRequest.submitRequest();
                system.debug('httpResponse::'+httpResponse.getBody());
                string responseBody = httpResponse.getBody();
                httpResponseCodeString = String.valueOf(httpResponse.getStatusCode());
               
                if (String.isNotBlank(responseBody)) 
                {
                    String formattedResponseBody =  cc_imp_util_Storefront.formatJSONResponse(responseBody);
                    response = cc_mn_json_ESProfileResponse.parse(formattedResponseBody);
                }
                
                 if(response.document != null )
                {
                    doc='found';
                    Attachment Fetchatt = new Attachment (ContentType ='application/pdf',body =  EncodingUtil.base64Decode(response.document),parentid=obj[0].id,name='ESDOC');
                    insert Fetchatt;
                    docId = Fetchatt.id;
                }
                else if(response.responseCode != '200')
                {
                    doc = 'negative';   
                }
               
            }
            catch (Exception e) 
            {
                System.debug(System.LoggingLevel.ERROR, e);
                response.success = false;
                response.message = e.getMessage();
                response.responseCode  = httpResponseCodeString;
                system.debug('response code'+httpresponsecodestring);
                system.debug('message'+e.getmessage());
                if( response.responseCode!='200')
                    pdf='negative';
            }
            system.debug('response.document ==='+response.document );
            
        }
        return null;
    }
    
    
}