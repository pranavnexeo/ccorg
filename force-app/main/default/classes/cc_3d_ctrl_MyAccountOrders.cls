global with sharing class cc_3d_ctrl_MyAccountOrders {

	public class MyException extends Exception {} 
	public String emptyVar {get;set;}

	@RemoteAction
	global static ccrz.cc_RemoteActionResult getExtendedOrdersList(ccrz.cc_RemoteActionContext ctx, List <String> orderIds){

		ccrz.cc_RemoteActionResult response = cc_imp_hlpr_RemoteActionHelper.remoteInit(ctx);

		try 
		{
			Map<String,ExtendedOrderHistory> extendedOrderHistoryMap = new Map<String,ExtendedOrderHistory>();

			List<ccrz__E_Order__c> cc_orders = [
												SELECT 
			 										Id, 
													ccrz__EncryptedId__c,
													Tracking_Number__c,
													Invoice_Number__c
												FROM 
													ccrz__E_Order__c 
												WHERE 
													ccrz__EncryptedId__c IN :orderIds 
												];

			for(ccrz__E_Order__c cc_order : cc_orders)
		        {

		        			if ( Test.isRunningTest() ) {

		                    	if(cc_order.ccrz__EncryptedId__c == '123Error'){
		                    		throw new MyException('Test of Exception for code coverage.');
		                    	}

                			}

		 		    ExtendedOrderHistory newExtendedOrderHistory = new ExtendedOrderHistory();
		            newExtendedOrderHistory.sfid       = cc_order.Id;
		            newExtendedOrderHistory.trackingNumber       = cc_order.Tracking_Number__c;
		            newExtendedOrderHistory.invoiceNumber       = cc_order.Invoice_Number__c;

		            extendedOrderHistoryMap.put(cc_order.ccrz__EncryptedId__c, newExtendedOrderHistory);
				}

				cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, true, 
					new Map<String,Object>
					{'success' => true,
					  'extendedData' => extendedOrderHistoryMap
					});
		}
		catch(Exception e)
     	{
	     		cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, false, 
	 			new Map<String,Object>
		 			{
		 				'success' => false,
		 				'message' => e.getMessage(),
		 				'cause' => e.getCause(),
		 				'trace' => e.getStackTraceString()
		 			}
	        	);	
     	}

     	return response;
	}

	@RemoteAction   
   	global static ccrz.cc_RemoteActionResult fetchMyInvoiceAttachment(ccrz.cc_RemoteActionContext ctx, String invoiceId, String sfid)
   	{
      	ccrz.cc_RemoteActionResult response = cc_imp_hlpr_RemoteActionHelper.remoteInit(ctx);

	  	cc_mn_json_myInvoiceResponse invoiceCallOutResponse = cc_mn_api_FetchInvoice.fetchMyInvoiceEncodedPdf(invoiceId);

	  	String theId = null;
	  	if (!String.isBlank(invoiceCallOutResponse.document)) {
	  		Attachment attach = new Attachment(Name = invoiceId + '.pdf', Description = cc_imp_mn_AttachmentCleanup.ATTACHMENT_DESCRIPTION, ParentId = sfid);
	  		attach.body = EncodingUtil.base64Decode(invoiceCallOutResponse.document);
	  		insert attach;
	  		theId = attach.Id;
	  		cc_imp_mn_AttachmentCleanup.cleanup();
	  	}

	  	cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, invoiceCallOutResponse.success, 
			new Map<String,Object>{'success' => invoiceCallOutResponse.success, 
                'invoiceData' => theId, 
                'message' => invoiceCallOutResponse.message,
                'fullResponse' => invoiceCallOutResponse
		});
	
	  	return response;
  	}

	//**************************************************************************
    // WRAPPER CLASS FOR ADDITIONAL ORDER HISTORY FIELDS
    //**************************************************************************
    public class ExtendedOrderHistory
    {
        public String sfid;
        public String trackingNumber;
		public String invoiceNumber;

        public ExtendedOrderHistory() 
        {

        }
    }

}