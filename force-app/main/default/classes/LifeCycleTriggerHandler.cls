/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        02/14/2018
*   Author:             Ignacio Gonzalez
*   Last Modified:       
*   Last Modified By:    
*
*   Short Description: Handler Trigger for LifeCycleTrigger trigger
*   
*   
*	
*   **********************************************************************************************************************/
public with sharing class LifeCycleTriggerHandler {
	

 	@future(callout=true)
	public static void OnAfterInsertAsync(Set<ID> newRecordIDs){
        System.debug('  newRecordIDs ' +newRecordIDs);
		//We are going to send a request to SAP in order to create a lifecycle report
		//At this moment we are only sending one request (first one)
        List<LifeCycle_Report_Request__c> newRecords = [SELECT Id, Name, From_Date__c, To_Date__c, Contact__c, Contact__r.Email,Account_Numbers__c,
                                                        Account__r.SAP_DivisionCode__c, Account__r.SAP_DistChannel__c, Account__r.SAP_Sales_Org__c,
                                                        Account__r.AccountNumber FROM LifeCycle_Report_Request__c WHERE Id IN :newRecordIDs];
        //Build request to call SAP
        //Get custom settings from mynexeo
		cc_imp_StorefrontSettings__C storefrontSettings =  cc_imp_StorefrontSettings__C.getInstance('mynexeo');
        //In order to process several requests
        for (LifeCycle_Report_Request__c requestToCreate : newRecords) {
        // we do not want to hit limits
        String accountNumbers=requestToCreate.Account_Numbers__c;		
        accountNumbers.removeEnd(',');
		List<String> accountsList=new List<String>();
		accountNumbers.removeEnd(',');
		accountsList=accountNumbers.split(',');
            
            
 
        if (Limits.getLimitFutureCalls() > Limits.getCallouts()) {
        //Using cc_imp_util_Http to create the POST request to SAP
        	String wasteSummaryEndpointPath = storefrontSettings.MyWasteSummaryEndpointPath__c;
            String httpResponseCodeString;
            cc_imp_util_Http request = new cc_imp_util_Http();
            request.method = cc_imp_util_Http.REQUEST_TYPE.POST;
			request.endpoint = ('callout:Nexeo_SAP_Endpoint' + wasteSummaryEndpointPath);
           	request.addHeader('Content-Type', 'application/json');
        	request.addHeader('Accept', 'application/json');
            //using current name credential for SAP and the wasteSummary enpoint to build the full endopoint URL
            List<WasteSummaryReportRequest> wsrr=new List<WasteSummaryReportRequest>();
		for(String account: accountsList){
            //using custom object to build the body to send to API
            WasteSummaryReportRequest newWasteSummary = new WasteSummaryReportRequest();
            //newWasteSummary.CUSTOMER = requestToCreate.Account__r.AccountNumber;
            newWasteSummary.CUSTOMER = account;
            newWasteSummary.SALES_ORG = requestToCreate.Account__r.SAP_Sales_Org__c;
            newWasteSummary.DISTR_CHAN = requestToCreate.Account__r.SAP_DistChannel__c;
            newWasteSummary.DIVISION = requestToCreate.Account__r.SAP_DivisionCode__c;
            //format to send date is yearmonthday: 20180131
            //using leftPad to add padding zeros at begenning of day and month
            String startDate = String.valueOf(requestToCreate.From_Date__c.year()) + String.valueOf(requestToCreate.From_Date__c.month()).leftPad(2,'0') + String.valueOf(requestToCreate.From_Date__c.day()).leftPad(2,'0');
            String endDate = String.valueOf(requestToCreate.To_Date__c.year()) + String.valueOf(requestToCreate.To_Date__c.month()).leftPad(2,'0') + String.valueOf(requestToCreate.To_Date__c.day()).leftPad(2,'0');
            newWasteSummary.DELV_PICKUP_FDATE = startDate;
            newWasteSummary.DELV_PICKUP_EDATE = endDate;
            newWasteSummary.CUST_EMAIL = requestToCreate.Contact__r.Email;
            newWasteSummary.REPORT_ID = requestToCreate.Name;
            wsrr.add(newWasteSummary);            
        }  
            request.setBody(JSON.serialize(wsrr));
            try {
                //HttpResponse in order to process the response from SAP
                HttpResponse httpResponse = request.submitRequest();
    
                httpResponseCodeString = String.valueOf(httpResponse.getStatusCode() );
        
                String responseBody =  httpResponse.getBody(); 
                
                if(httpResponse.getStatusCode() != 200 ) {
                    System.debug('Error status was not 200 to create a Waste Report');
                }
            } catch (Exception ex) {

                System.debug('Error calling endpoint');
                //Insert on Log
            }
      	}
        }        

  	}
    
    
    /**
   	 * Class to send to SAP a request of a Waste Summary Report
    * */  
  	public class WasteSummaryReportRequest{
        public String CUSTOMER { get; set; }
        public String SALES_ORG { get; set; }
        public String DISTR_CHAN { get; set; }
        public String DIVISION { get; set; }
        public String DELV_PICKUP_FDATE { get; set; }
        public String DELV_PICKUP_EDATE  { get; set; }
        public String CUST_EMAIL { get; set; }
        public String REPORT_ID { get; set; }        

 	}


}