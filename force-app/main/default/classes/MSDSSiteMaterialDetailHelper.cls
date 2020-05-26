public class MSDSSiteMaterialDetailHelper {
    
    public static String createMSDSDocument(MSDSDocument pdfBody, String dockey) {
        if (String.isEmpty(pdfBody.document)) {
            return null;
        } else {
            List<ES_Order_Document__c> obj = new List<ES_Order_Document__c>();
            obj =[SELECT Id FROM ES_Order_Document__c];
            if(obj == null || obj.size() ==0) {
                obj = new list<ES_Order_Document__c>();
                obj.add(new ES_Order_Document__c());
             }
            //create pdf document
           Attachment MSDSDocument = new Attachment (ContentType ='application/pdf',body =  EncodingUtil.base64Decode(pdfBody.document), parentid = obj[0].id, name = dockey);
           //Attachment MSDSDocument = new Attachment (ContentType ='application/msword',body =  EncodingUtil.base64Decode(pdfBody.document), parentid = obj[0].id, name = dockey);
           insert MSDSDocument;
           return MSDSDocument.Id;
        }
    }
    
      public static String getMaterialName(String materialNumber) {
        String fullName = '';
        try {
            //Complete with landing zeros to have 18 char
            MSDS_Site__c siteSettings = MSDS_Site__c.getInstance();
            System.debug('siteSettings.Landing_Zeros_Material_Number__c ' + siteSettings.Landing_Zeros_Material_Number__c);
            String fullMaterialNumber = materialNumber.leftPad(Integer.valueOf(siteSettings.Landing_Zeros_Material_Number__c), '0');
            Material_Description__c  materialToRetrieve = [SELECT Material_Description__c, Material_Number__c FROM Material_Description__c  WHERE Material_Number__c =: fullMaterialNumber LIMIT 1];
            fullName = materialToRetrieve.Material_Description__c;
        } catch (Exception ex) {
            System.debug(' MSDS Exception Cause' + ex.getCause());
            System.debug(' MSDS Exception Line Number ' + ex.getLineNumber());
            System.debug(' MSDS Exception Message' + ex.getMessage());
            System.debug(' MSDS Exception Stack Trace String' + ex.getStackTraceString());
            fullName = Label.MSDSMaterialNumberNotFound;
        }
        return fullName;
    }
    
    public static MSDSResponse getSDSDocumentsList(String materialNumber) {
        MSDSResponse formattedResponseBody = new MSDSResponse();
        try {
            //Complete with landing zeros to have 18 char
            MSDS_Site__c siteSettings = MSDS_Site__c.getInstance();
            String fullMaterialNumber = materialNumber.leftPad(Integer.valueOf(siteSettings.Landing_Zeros_Material_Number__c), '0');
            //String
            // Instantiate an http protocol class
          Http http = new Http();
            // Instantiate http request class
            HttpRequest request = new HttpRequest();
            request.setEndPoint('callout:Nexeo_SAP_SDS_Endpoint/'+ siteSettings.MSDS_EndpointPath__c + '?' + siteSettings.MSDS_EndpointPath_Query_Parameter__c);
            request.setMethod('POST');
            request.setBody(siteSettings.Get_SDS_Document_List_Body_Internal__c.replace('PLACE_HOLDER', fullMaterialNumber));
            HttpResponse response;
            System.debug('MSDS request Body ' + request.getBody());
      response = http.send(request);
            
            String responseBody =  response.getBody();
            System.debug(' MSDS response Body' + responseBody);
            if(response.getStatusCode() == 200 ) {
                if (responseBody != null && String.isNotEmpty(responseBody)) {
                     formattedResponseBody.documents = MSDSDocument.parse(responseBody);
                    formattedResponseBody.Status = String.valueOf(response.getStatusCode());
                }
            } else {
                formattedResponseBody.Status = String.valueOf(response.getStatusCode());
            }
 
        } catch (Exception ex) {
            formattedResponseBody.Status = '-1';
            System.debug(' MSDS Exception Cause' + ex.getCause());
            System.debug(' MSDS Exception Line Number ' + ex.getLineNumber());
            System.debug(' MSDS Exception Message' + ex.getMessage());
            System.debug(' MSDS Exception Stack Trace String' + ex.getStackTraceString());
        }
    return formattedResponseBody;
    }
    
    public static MSDSResponse getSDSDocument(String materialNumber, String renchNumber) {
        MSDSResponse formattedResponseBody = new MSDSResponse();
        try {

            //Complete with landing zeros to have 18 char
            MSDS_Site__c siteSettings = MSDS_Site__c.getInstance();
            String fullMaterialNumber = materialNumber.leftPad(Integer.valueOf(siteSettings.Landing_Zeros_Material_Number__c), '0');
            //String
            // Instantiate an http protocol class
          Http http = new Http();
            // Instantiate http request class
            HttpRequest request = new HttpRequest();
            request.setEndPoint('callout:Nexeo_SAP_SDS_Endpoint/'+ siteSettings.MSDS_EndpointPath__c  + '?' + siteSettings.MSDS_EndpointPath_Query_Parameter__c);
            request.setMethod('POST');
            request.setBody(siteSettings.Get_SDS_Document_Body__c.replace('PLACE_HOLDER_0', fullMaterialNumber).replace('PLACE_HOLDER_1', renchNumber));
            System.debug('MSDS request Body ' + request.getBody());
            HttpResponse response;
            
      response = http.send(request);
            
            String responseBody =  response.getBody();
            System.debug(' MSDS response Body' + responseBody);
            if(response.getStatusCode() == 200 ) {
                if (responseBody != null && String.isNotEmpty(responseBody)) {
                    if (responseBody.contains('message')) {
                        Map<String, Object> mapJSONResponse = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

                        formattedResponseBody.Status = (String) mapJSONResponse.get('message');
                    } else {
                    	formattedResponseBody.documents = MSDSDocument.parse(responseBody);
                    	formattedResponseBody.Status = String.valueOf(response.getStatusCode()); 
                    }

                }
            } else {
                formattedResponseBody.Status = String.valueOf(response.getStatusCode());
            }

        } catch (Exception ex) {
            formattedResponseBody.Status = '-1';
            System.debug(' MSDS Exception Cause' + ex.getCause());
            System.debug(' MSDS Exception Line Number ' + ex.getLineNumber());
            System.debug(' MSDS Exception Message' + ex.getMessage());
            System.debug(' MSDS Exception Stack Trace String' + ex.getStackTraceString());
        }
    return formattedResponseBody;
    }    

}