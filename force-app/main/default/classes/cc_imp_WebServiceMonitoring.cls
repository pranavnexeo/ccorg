//Author: Francisco Garcia Gonzalez.
public with Sharing class cc_imp_WebServiceMonitoring {

    public cc_imp_WebServiceMonitoring(){
        String settingInstance = 'Monitoring';
        CC_SFDC_Settings__c wssettings = CC_SFDC_Settings__c.getInstance(settingInstance);
        //View Credit Call;
        Id acct=Id.valueOf(wssettings.CC_WS_Mon_Account_Id__c);
        if(wssettings.CC_WS_Mon_View_Credit__c){
			wssettings.CC_WS_Mon_View_Credit_Last_Call_Status__c=monCredit_Check(acct);        	
        	System.debug('-CP WSMonitoring - Viewing Credit Call.');
        }
        //End View Credit Call.    
        //MSDS Call. 
        if(wssettings.CC_WS_Mon_MSDS__c){
        	wssettings.CC_WS_Mon_MSDS_Last_Call_Status__c = monMSDS(wssettings.CC_WS_Mon_Material_Number__c);        	
        	System.debug('-CP WSMonitoring - MSDS');
        }
        //End MSDS Call.
        //Customer profile Call. 
        if(wssettings.CC_WS_Mon_Customer_Profile__c){
        	wssettings.CC_WS_Mon_Customer_Profile_Last_Call_Sta__c = monCustomerProfile(wssettings.CC_WS_Mon_ES_Account_Id__c);        	
        	System.debug('-CP WSMonitoring - Customer Profile');
        }
        //End MSDS Call.

        //Invoice call
        if(wssettings.CC_WS_Mon_Invoice__c) {
            wssettings.CC_WS_Mon_Invoice_Last_Call_Status__c = monInvoice(wssettings.CC_WS_Mon_Store_Front_Name__c, wssettings.CC_WS_Mon_Invoice_Id__c);
            System.debug('-CP WSMonitoring - Invoice');
        }
        //End Invoice Call.  
        //Track and Trace call
        if(wssettings.CC_WS_Mon_Track_and_Trace__c) {
            wssettings.CC_WS_Mon_Track_Trace_Last_Call_Status__c = monTrackAndTrace(wssettings.CC_WS_Mon_Store_Front_Name__c, wssettings.CC_WS_Mon_Track_and_Trace_Document_Id__c);
            System.debug('-CP WSMonitoring - Track and Trace');
        }
        //Profile doc call
        if(wssettings.CC_WS_Mon_Profile_Load_Doc__c) {
            wssettings.CC_WS_Mon_Profile_Doc_Last_Call_Status__c = monProfileDoc(wssettings.CC_WS_Mon_ES_Document__c);
            System.debug('-CP WSMonitoring - Load Doc');
        }        
        //Profile doc Call.   
        //Waste Man/BOL/COA call
        if(wssettings.CC_WS_Mon_MAN_BOL_COA__c) {
            wssettings.CC_WS_Mon_Man_BOL_COA_Last_Call_Status__c = monManBOLCOA('mynexeo', wssettings.CC_WS_Mon_Material_Id_COFA__c, wssettings.CC_WS_Mon_Batch_Number__c);
            System.debug('-CP WSMonitoring - Waste Man/BOL/COA');
        }
        //End Waste Man/BOL/COA call.               
        update wssettings;
        
        
    }
    public boolean monCredit_Check(Id acct){  
        cc_mn_json_ViewCreditResponse viewCreditResponse = new cc_mn_json_ViewCreditResponse();
        boolean success = false;
        try {
            
            viewCreditResponse = cc_imp_hlpr_WebServiceMonitoring.viewCredit(acct);
            if (null != viewCreditResponse) {
                success = true;
            } else {
             	cc_imp_hlpr_WebServiceMonitoring.sendEmail('CREDIT_CHECK', cc_imp_util_Storefront.formatSerializedJSONRequest(cc_imp_hlpr_WebServiceMonitoring.serializeViewCreditRequest(acct)), viewCreditResponse.statusCode, viewCreditResponse.message);	
            }
      	}
		catch(Exception ex) {
			cc_imp_hlpr_WebServiceMonitoring.sendEmail('CREDIT_CHECK', cc_imp_util_Storefront.formatSerializedJSONRequest(cc_imp_hlpr_WebServiceMonitoring.serializeViewCreditRequest(acct)), ex.getStackTraceString(), ex.getMessage());	
     	}
       
        return success;
    }    
    public boolean monMSDS(String MaterialNumber){
        cc_mn_json_MSDSResponse msdsresponse = new cc_mn_json_MSDSResponse();
  		cc_mn_json_MSDSRequest sdsRequest = new cc_mn_json_MSDSRequest();
		sdsRequest.material = MaterialNumber;
  	    String formattedRequestBody = cc_imp_util_Storefront.formatSerializedJSONRequest(sdsRequest.serialize());
        try{        
        	msdsresponse=cc_mn_api_FetchSDS.fetchMSDS(MaterialNumber);                 
        	}
        catch(exception ex){
           	cc_imp_hlpr_WebServiceMonitoring.sendEmail('MSDS', formattedRequestBody, ex.getStackTraceString(), ex.getMessage());	
        	return false;                
        }        
        if(msdsresponse.success){
        	return true;        
        }else{
            cc_imp_hlpr_WebServiceMonitoring.sendEmail('MSDS', formattedRequestBody, msdsresponse.responseCode, msdsresponse.message);	
            return false;
        }
    }    
    public boolean monCustomerProfile(String accountid){
        list<cc_mn_json_ProfileResponse> responses = new list<cc_mn_json_ProfileResponse>();
        try{
        	responses = cc_imp_hlpr_WebServiceMonitoring.FetchProfileDetail(accountid); 
            if (null == responses) {
                return false; 
            }
        }
        catch(exception ex){
            return false;
        }
        
        return true;
    }
    public boolean monManBOLCOA(String storefrontName, String materialId, String batchNumber){
        boolean isSuccessful = false;
        cc_mn_json_CofARequest request = new cc_mn_json_CofARequest();
        request.material = materialId;
        request.batch_number = batchNumber;
        String formattedRequestBody = cc_imp_util_Storefront.formatSerializedJSONRequest(request.serialize());
        
        try {
            cc_mn_json_CofAResponse callOutResponse = cc_mn_api_CofA.fetchCofA(storefrontName, materialId, batchNumber);

            if (callOutResponse.success) {
                isSuccessful = true;
            } else {

                cc_imp_hlpr_WebServiceMonitoring.sendEmail('COFA', formattedRequestBody, callOutResponse.responseCode, callOutResponse.message);	
            }
        } catch (Exception ex) {
            	cc_imp_hlpr_WebServiceMonitoring.sendEmail('COFA', formattedRequestBody, ex.getStackTraceString(), ex.getMessage());	
           		return isSuccessful;

        }
        return isSuccessful;
    }
    public boolean monInvoice(String storeFrontName, String invoiceId) {
        boolean isSuccessful = false;
        try {
          	cc_mn_json_myInvoiceResponse invoiceCallOutResponse = cc_imp_hlpr_WebServiceMonitoring.fetchMyInvoiceEncodedPdf(storeFrontName, invoiceId);
            if (invoiceCallOutResponse.success) {
                isSuccessful = true;
            }
        } catch (Exception ex) {
            
        }
        return isSuccessful;
    }
    public boolean monTrackAndTrace(String storeFrontName, String docNumber) {
        boolean isSuccessful = false;
        cc_mn_json_TrackRequest request = new cc_mn_json_TrackRequest();
        request.doc_number = docNumber;
        String formattedRequestBody = cc_imp_util_Storefront.formatSerializedJSONRequest(request.serialize());
        try {
          	cc_mn_json_TrackResponse calloutResponse = cc_mn_api_FleetTrack.fetchFleetTrack(storefrontName, docNumber);
            if (callOutResponse.success) {
               isSuccessful = true;
            } else {
                cc_imp_hlpr_WebServiceMonitoring.sendEmail('PVTFLEET', formattedRequestBody, calloutResponse.responseCode, calloutResponse.message);
            }
        } catch (Exception ex) {
            cc_imp_hlpr_WebServiceMonitoring.sendEmail('PVTFLEET', formattedRequestBody, ex.getStackTraceString(), ex.getMessage());
        }
        return isSuccessful;
    }
    public boolean monProfileDoc(String document) {
        boolean isSuccessful = false;
        try {
            	cc_mn_json_ESProfileResponse response = cc_imp_hlpr_WebServiceMonitoring.FetchProfileDoc(document);
				isSuccessful = response.success;
        } catch (Exception ex) {
            
        }
        return isSuccessful;
    }

    }