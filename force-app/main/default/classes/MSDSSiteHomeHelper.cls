public without sharing class MSDSSiteHomeHelper {
    
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
            request.setBody(siteSettings.Get_SDS_Document_List_Body__c.replace('PLACE_HOLDER', fullMaterialNumber));
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

    public static List<MaterialSearchResponse> getMaterialSearchResults(String valueToSearch, String formatSelected, String languageSelected, String searchSelected) {
        List<MaterialSearchResponse> searchResponse = new List<MaterialSearchResponse>();
        //String json = '[{"material_list":[{"material":"0000000000005586151","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"0000000000005586152","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"0000000000005586153","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"}],"exceed_flag":"","status":[{"type":"E","id":"ZOTC","number":"137","message":"Material not found in System","log_no":"","log_msg_no":"000000","message_v1":"","message_v2":"","message_v3":"","message_v4":"","parameter":"","row":"0 ","field":"","system":""}]}]';
        //searchResponse = MaterialSearchResponse.parse(json);

        try{
            //Complete with landing zeros to have 18 char
            MSDS_Site__c siteSettings = MSDS_Site__c.getInstance();
            String fullMaterialNumber = '';
            String fullMaterialName = '';
            String jsonSearchString = '';
            System.debug('searchSelected ' + searchSelected);
            if (searchSelected == siteSettings.Search_By_Material_Name__c) {
               // fullMaterialNumber = valueToSearch.leftPad(Integer.valueOf(siteSettings.Landing_Zeros_Material_Number__c), '0');
                fullMaterialNumber = valueToSearch;
            } else {
                fullMaterialName = valueToSearch.toUpperCase();
            }

            jsonSearchString = siteSettings.Get_External_Material_Search_Body__c.replace('PLACE_HOLDER_0', fullMaterialNumber).replace('PLACE_HOLDER_1', fullMaterialName);
            System.debug(' MSDS jsonSearchString' + jsonSearchString);
            // Instantiate an http protocol class
            Http http = new Http();
            // Instantiate http request class
            HttpRequest request = new HttpRequest();
            request.setEndPoint('callout:Nexeo_SAP_SDS_Endpoint/'+ siteSettings.MSDS_Material_Search_Endpoint__c);
            request.setMethod('POST');
            request.setBody(jsonSearchString);
            HttpResponse response;
            response = http.send(request);

            String responseBody =  response.getBody();
            System.debug(' MSDS response Body' + responseBody);
            if(response.getStatusCode() == 200 ) {
                if (responseBody != null && String.isNotEmpty(responseBody)) {
                    if (!responseBody.contains('material_list')){
                        responseBody = '[{"material_list":[],"exceed_flag":"","status":[' + responseBody + ']}]';
                    }
					
                    
                    //responseBody = responseBody.replace('\\', '');
                    System.debug(' MSDS response Body' + responseBody);
                    searchResponse = MaterialSearchResponse.parse(responseBody.replace('\\', ''));
                } else {
                    List<MaterialSearchResponse.status> statuses = new List<MaterialSearchResponse.status>();
                    MaterialSearchResponse.status currentStatus = new MaterialSearchResponse.status();
                    currentStatus.message = label.MSDSErrorCallingWebService;
                    statuses.add(currentStatus);
                    MaterialSearchResponse errorMesasge = new MaterialSearchResponse();
                    errorMesasge.status = statuses;
                    searchResponse.add( errorMesasge);
                }
            } else {
                List<MaterialSearchResponse.status> statuses = new List<MaterialSearchResponse.status>();
                MaterialSearchResponse.status currentStatus = new MaterialSearchResponse.status();
                currentStatus.message = label.MSDSErrorCallingWebService;
                statuses.add(currentStatus);
                MaterialSearchResponse errorMesasge = new MaterialSearchResponse();
                errorMesasge.status = statuses;
                searchResponse.add( errorMesasge);
            }
           // [{"MATERIAL":"000000000000558615","PRODUCT_NAME":"","LANGU":"","GENVAR":""}]
        } catch(Exception ex) {
           List<MaterialSearchResponse.status> statuses = new List<MaterialSearchResponse.status>();
           MaterialSearchResponse.status currentStatus = new MaterialSearchResponse.status();
           currentStatus.message = label.MSDSErrorCallingWebService;
           statuses.add(currentStatus);
           MaterialSearchResponse errorMesasge = new MaterialSearchResponse();
           errorMesasge.status = statuses;
           searchResponse.add( errorMesasge);
            System.debug(' MSDS Exception Cause' + ex.getCause());
            System.debug(' MSDS Exception Line Number ' + ex.getLineNumber());
            System.debug(' MSDS Exception Message' + ex.getMessage());
            System.debug(' MSDS Exception Stack Trace String' + ex.getStackTraceString());
        }
        System.debug(searchResponse);
        return searchResponse;
    }
}