Public class cc_imp_mn_ViewESDoc
{
    public string strDocId;
    public string strDocType;
    public string strSOID;
    public string doc{get;set;}
    public id docId{get;set;}
    public pagereference ViewESDoc()
    {
        strSOID = ApexPages.currentPage().getParameters().get('strSOID');
        strDocid = ApexPages.currentPage().getParameters().get('strDocId');
        strDocType= ApexPages.currentPage().getParameters().get('strDocType');
        doc = '';
       try
       {
        system.debug('pass from here==='+strDocid +'=='+strDocType+'=='+strSOID);
        if(!String.isBlank(strDocid) && !String.isBlank(strDocType) &&  !String.isBlank(strSOID))
        {
            system.debug('pass from here1==='+strDocType);
            cc_mn_json_ESAResponse response = new cc_mn_json_ESAResponse();
            if(strDocType.toUpperCase() =='WASTEMANIFEST')
            {
                response = FetchDoc(strSOID,strDocid ,'ZESWM');
                
            }
            else if(strDocType.toUpperCase() =='CERTOFDISPOSAL')
            {
                response =FetchDoc(strSOID,strDocid ,'ZESCD001');
            }
            else if(strDocType.toUpperCase() =='BIllOFLADING')
            {
               response = FetchDoc(strSOID,strDocid,'ZESBOL001' );
            }
            list<ES_Order_Document__c> obj = new list<ES_Order_Document__c>();
            obj =[select id from ES_Order_Document__c];
            if(obj == null || obj.size() ==0)
            {
                obj = new list<ES_Order_Document__c>();
                obj.add(new ES_Order_Document__c());
            } 
            
            if(response.document  != null )
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
       }
        Catch(Exception e)
        {
             system.debug(' e.getMessage() ==='+ e.getMessage());
             /*cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, false, 
                                                             new Map<String,Object>
                                                             {
                                                                 'success' => false,
                                                                     'message' => e.getMessage(),
                                                                     'cause' => e.getCause(),
                                                                     'trace' => httpResponseCodeString
                                                                     }
                                                            );*/
        }
        return null;
    }
    public cc_mn_json_ESAResponse FetchDoc(string soID,string DocId,string ObjectName)
    {
        system.debug('in FetchDoc==');
        string httpResponseCodeString = '';
        cc_mn_json_ESAResponse response = new cc_mn_json_ESAResponse();
        try
        {
            cc_imp_StorefrontSettings__C storefrontSettings =  cc_imp_StorefrontSettings__C.getInstance('mynexeo');
            cc_imp_util_Http httpRequest = new cc_imp_util_Http();
            httpRequest.method = cc_imp_util_Http.REQUEST_TYPE.POST;
            String endpointPath = storefrontSettings.ESScreenReportsEndpoint__c;
            httpRequest.endpoint = ('callout:Nexeo_SAP_Endpoint/'+ endpointPath) ;
            //httpRequest.addQueryParameter('sap-client', '020');
            cc_mn_json_ESARequest request = new cc_mn_json_ESARequest();
           /* request.Sales_order = '79830891';
            request.ARC_DOC_ID = '0050569E713D1ED888C8CC9B1A9640D9';//DocId; 
            request.AR_OBJECT = 'ZESBOL001';//ObjectName; 
            */
            request.Sales_order = soID;
            request.ARC_DOC_ID = DocId; 
            request.AR_OBJECT = ObjectName; 
            System.debug('request=='+request);
            String formattedRequestBody = cc_imp_util_Storefront.formatSerializedJSONRequest(request.serialize());
            //String formattedRequestBody =  '[{"Sales_order":"0007983089","ARC_DOC_ID":"0050569E713D1ED88E880182024160D9","AR_OBJECT":"ZESWM"}]';
            httpRequest.body = formattedRequestBody ;
            HttpResponse httpResponse = httpRequest.submitRequest();
            httpResponseCodeString = String.valueOf(httpResponse.getStatusCode());
            System.debug('httpResponse=='+httpResponse);
            String responseBody =  httpResponse.getBody(); 
            System.debug('responseBody=='+responseBody);
            
            if (String.isNotBlank(responseBody)) 
            {
                String formattedResponseBody =  cc_imp_util_Storefront.formatJSONResponse(responseBody);
                response = cc_mn_json_ESAResponse.parse(formattedResponseBody);
            }
            System.debug('response=='+response);
        }
        Catch(Exception e){}
        return response;
    }
    
    
    
}