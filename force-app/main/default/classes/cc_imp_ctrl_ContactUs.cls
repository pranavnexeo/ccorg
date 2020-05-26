global without sharing class cc_imp_ctrl_ContactUs 
{
    global String csrName { get; set; }  
    global String csrTel { get; set; }  
    global String csrEmail { get; set; }      
    global String sellerName { get; set;}
    global String sellerTel { get; set;}
    global String sellerEmail { get; set;}
    //In order to prevent liveAgent settings be hardcoded
    global String liveAgentId { get; set;}
	global String liveAgentJSComponent { get; set;}
	global String liveAgentORGId { get; set;}
	global String liveAgentURL { get; set;}
    
   public String reasonCodeOptions { get { return JSON.serialize(getCaseCreateReasonCodes());} set; }
   public String subjectOptions { get { return JSON.serialize(getCaseCreateSubject());} set; }
  
    global cc_imp_ctrl_ContactUs(){
        string idCSR;        
        idCSR=cc_imp_dao_Account.getCSRForAccount(ccrz.cc_CallContext.currAccountId);
        Account a = cc_imp_dao_Account.queryAccountByAccountId(ccrz.cc_CallContext.currAccountId);
        // As the liveAgent is always shown on the page, the setting are being populating from
        // beginning
        cc_imp_StorefrontSettings__c portalCustomSettings = cc_imp_StorefrontSettings__c.getInstance('mynexeo');
        liveAgentId = portalCustomSettings.Live_Agent_Id__c;
        liveAgentJSComponent = portalCustomSettings.Live_Agent_JS_Component__c;
        liveAgentORGId = portalCustomSettings.Live_Agent_Org_Id__c;
        liveAgentURL = portalCustomSettings.Live_Agent_URL__c;
        if(a.AccountNumber.startsWith('P')){
            CC_SFDC_Settings__c cusSetting=CC_SFDC_Settings__c.getInstance('CPI_MyNexeo');
        
        
            csrName=cusSetting.ProspectCSRName__c;  
    		csrTel=cusSetting.ProspectCSRTel__c;
    		csrEmail=cusSetting.ProspectCSREmail__c;
        	sellerName=cusSetting.ProspectSellerName__c;
        	sellerTel=cusSetting.ProspectSellerTel__c;
        	sellerEmail=cusSetting.ProspectSellerEmail__c;  
        }
        else{
            
        SAP_Seller__c csrRecord=queryCSR(idCSR);
          if(csrRecord.User_Name__c==null)
              	csrName='';
            		else
                        csrName=csrRecord.User_Name__c;
  		
            if(csrRecord.Phone__c==null)
                csrTel='';
            		else
                        csrTel=FormatPhone(csrRecord.Phone__c);
                        
            if(csrRecord.Email__c==null)
                csrEmail='';
            		else
                        csrEmail=csrRecord.Email__c;                
            try{
        string idSeller=cc_imp_dao_Account.getSellerForAccount(ccrz.cc_CallContext.currAccountId);
        User sellerUser=querySeller(idSeller);
          
         if(sellerUser.Full_Name__c==null)
             sellerName='';
            	else
                    sellerName=sellerUser.Full_Name__c;
         if(sellerUser.Phone==null)
        	sellerTel='';
                else
                    sellerTel=FormatPhone(sellerUser.Phone);
        if(sellerUser.Email==null)
            sellerEmail='';
            	else
                    sellerEmail=sellerUser.Email;   
                
                  }
            catch(Exception e){
                System.debug('ERROR cc_imp_ctrl_ContactUs '+e.getMessage() +' on line '+e.getLineNumber());
            }
            
            }
    }
    public static User querySeller(id Seller){
        User sellerUser=[SELECT
                        	Email,
                         	Full_Name__c,
							Phone
                         FROM 
                         	User
                         Where
                         	Id =:Seller
                        Limit
                         1
                        ];
        return sellerUser;        
    }
  	public static SAP_Seller__c queryCSR(Id ZCPartner){
		SAP_Seller__c csr=[
			SELECT
				Email__c,
            	User_Name__c,
            	Phone__c
			FROM
				SAP_Seller__c
			WHERE
				Id = :ZCPartner
			LIMIT
				1
		];
        return csr;
	}
    
  
public String FormatPhone(String Phone) {
  string nondigits = '[^0-9]';
  string PhoneDigits;
  
  // remove all non numeric
  PhoneDigits = Phone.replaceAll(nondigits,'');
  
  // 10 digit: reformat with dashes
  if (PhoneDigits.length() == 10) 
    return PhoneDigits.substring(0,3) + '-' +
           PhoneDigits.substring(3,6) + '-' +
           PhoneDigits.substring(6,10);
  // 11 digit: if starts with 1, format as 10 digit 
  if (PhoneDigits.length() == 11) {
    if (PhoneDigits.substring(0,1) == '1') {
      return  '('+PhoneDigits.substring(1,4)+')' + '-' +
              PhoneDigits.substring(4,7) + '-' +
              PhoneDigits.substring(7,11);
    }
  }
 
  // if it isn't a 10 or 11 digit number, return the original because
  // it may contain an extension or special information
  return( Phone );
}
  
	
	 @RemoteAction
	global static ccrz.cc_RemoteActionResult createCase(ccrz.cc_RemoteActionContext ctx, String subject, String reason, String comments) 
	{
		ccrz.cc_RemoteActionResult response = cc_imp_hlpr_RemoteActionHelper.remoteInit(ctx);
		try 
		{
			Map<String, cc_imp_CaseCreationSubject__c>  caseCreationReasonCodes = 	cc_imp_CaseCreationSubject__c.getAll();
			Id caseOWnerId  = cc_imp_dao_Account.getCSRForAccount(ccrz.cc_CallContext.currAccountId);

			if (caseOWnerId == null || String.isBlank(caseOWnerId))
			{
				if (String.isNotBlank(ccrz.cc_CallContext.storefront ))
				{
					cc_imp_StorefrontSettings__C storefrontSettings =  cc_imp_StorefrontSettings__C.getInstance(ccrz.cc_CallContext.storefront);

					caseOWnerId = cc_imp_util_Storefront.getQueueIdByName(storefrontSettings.Default_CSR_Queue_Name__c);
				}
			}

			// Case caseToCreate = new Case();
			// caseToCreate.AccountId = ccrz.cc_CallContext.currAccountId;
			// caseToCreate.Reason = reason;
			// caseToCreate.ContactId = ccrz.cc_CallContext.currContact.Id;
			// caseToCreate.Description = reason + '\n' + subject + '\n' + comments;
			// caseToCreate.OwnerId =  caseOWnerId ;
			// cc_imp_hlpr_ContactUsCreateCase.insertCase(caseToCreate);

			NexCare__c nexCare = new NexCare__c();
			nexCare.RecordTypeId = cc_imp_hlpr_ContactUsCreateCase.getNexCareRecordId();
			nexCare.Account_Name__c = ccrz.cc_CallContext.currAccountId;
			// nexCare.Tier_1__c = reason;
			nexCare.Tier_1__c = 'Request';
			nexCare.Contact_Name__c = ccrz.cc_CallContext.currContact.Id;
			// nexCare.Tier_2__c = subject;
			nexCare.Tier_2__c = getTier2ValueFromSubject(subject, caseCreationReasonCodes.values());

			nexCare.Short_Description__c = 'Contact Us Form';
			nexCare.Description__c =  reason + '\n' + subject + '\n' + comments;
//			nexCare.OwnerId = caseOwnerId;
			cc_imp_hlpr_ContactUsCreateCase.insertNexCare(nexCare);

     		cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, true, new Map<String,Object>{'success' => true });
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

	private static String getTier2ValueFromSubject(String subject, List<cc_imp_CaseCreationSubject__c> subjects) {
		String value = 'Web Form – General';
		for (cc_imp_CaseCreationSubject__c s : subjects) {
			if (subject == s.optionsValue__c) {
				value = s.NexCare_Tier_2_Value__c;
			}
		}
		return value;
	}
 
	@RemoteAction   
   	global static ccrz.cc_RemoteActionResult fetchMyInvoicePdf(ccrz.cc_RemoteActionContext ctx, String invoiceId)
   	{
      	ccrz.cc_RemoteActionResult response = cc_imp_hlpr_RemoteActionHelper.remoteInit(ctx);

	  	cc_mn_json_myInvoiceResponse invoiceCallOutResponse = cc_mn_api_FetchInvoice.fetchMyInvoiceEncodedPdf(invoiceId);

	  	cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, invoiceCallOutResponse.success, 
			new Map<String,Object>{'success' => invoiceCallOutResponse.success, 'invoiceData' => invoiceCallOutResponse.document, 'message' => invoiceCallOutResponse.message
		});
	
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
			new Map<String,Object>{'success' => invoiceCallOutResponse.success, 'invoiceData' => theId, 'message' => invoiceCallOutResponse.message
		});
	
	  	return response;
  	}

	public static List<cc_imp_bean_SelectOption> getCaseCreateReasonCodes() 
	{
		 Map<String, cc_imp_CaseCreationReasonCodes__c>  caseCreationReasonCodes = cc_imp_CaseCreationReasonCodes__c.getAll();
		 List<cc_imp_CaseCreationReasonCodes__c> theReasons = caseCreationReasonCodes.values();
		 theReasons.sort();

		  List<SelectOption> options = new List<SelectOption>();

		  String storeFrontName = ccrz.cc_CallContext.storefront;

		  for(cc_imp_caseCreationReasonCodes__c reasonCode : theReasons)
		  {
		  	 String storefrontNameInCustomSetting =  reasonCode.storefront__c;

		  	if (String.isNotBlank(storeFrontName) && storeFrontName.equalsIgnoreCase(storefrontNameInCustomSetting))
		  	{
		  		options.add(new SelectOption(reasonCode.optionsValue__c,reasonCode.optionsLabel__c ));
		  	}	
		  }

		return buildSelectOptionBeansList(options);
	}

	public  static List<cc_imp_bean_SelectOption> getCaseCreateSubject() 
	{
		Map<String, cc_imp_CaseCreationSubject__c>  caseCreationReasonCodes = 	cc_imp_CaseCreationSubject__c.getAll();

		  List<SelectOption> options = new List<SelectOption>();

		  String storeFrontName = ccrz.cc_CallContext.storefront;

		  for(cc_imp_caseCreationSubject__c subject : caseCreationReasonCodes.values()) 
		  {
		  	String storefrontNameInCustomSetting =  subject.storefront__c;

		  	if (String.isNotBlank(storeFrontName) && storeFrontName.equalsIgnoreCase(storefrontNameInCustomSetting))
		  	{
		  		String label = subject.PageLabelName__c;
		  		if (label == null) {
		  			label = subject.optionsLabel__c;
		  		}
		  		options.add(new SelectOption(subject.optionsValue__c, label));
		  	}
		  }

		return buildSelectOptionBeansList(options);
	}



	public  static List<cc_imp_bean_SelectOption> buildSelectOptionBeansList(List<SelectOption> selectOptions) 
	{
		List<cc_imp_bean_SelectOption> selectOptionBeans = new List<cc_imp_bean_SelectOption>();

		for (SelectOption selectOption : selectOptions) 
		{
			if (selectOption != null)
			 {
				cc_imp_bean_SelectOption optionBean = new cc_imp_bean_SelectOption(selectOption);

				selectOptionBeans.add(optionBean);
			}
		}
		return selectOptionBeans;
	}

	@RemoteAction 
	global static ccrz.cc_RemoteActionResult getAllInvoicesForShipToAddress( ccrz.cc_RemoteActionContext ctx ) {

		ccrz.cc_RemoteActionResult response = cc_imp_hlpr_RemoteActionHelper.remoteInit(ctx);

		try 
		{
			Id accountId = ccrz.cc_CallContext.effAccountId;
			if(accountId == null){
				accountId = ccrz.cc_CallContext.currAccount.Id;
			}

			List<Map<String,Object>> invoices = cc_imp_hlpr_MyAccountInvoices.getAllInvoices(accountId );

			cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, true, 
				new Map<String,Object>{'success' => true, 'invoices' => invoices
			});

		}catch(Exception e)
     	{
	     		cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, false, 
	 				new Map<String,Object>{'success' => false, 'message' => e.getMessage(), 'cause' => e.getCause(), 'trace' => e.getStackTraceString()}
	        	);	
     	}
	    
        return response;


		
	}  

	@RemoteAction 
	global static ccrz.cc_RemoteActionResult disputeInvoice(ccrz.cc_RemoteActionContext ctx, String sfid) {

		ccrz.cc_RemoteActionResult response = cc_imp_hlpr_RemoteActionHelper.remoteInit(ctx);

		try {
			cc_imp_hlpr_MyAccountInvoices.disputeInvoice(sfid);

			cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, true, new Map<String,Object>{'success' => true});

		}
		catch(Exception e) {
	     	cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, false, new Map<String,Object>{'success' => false, 'message' => e.getMessage(), 'cause' => e.getCause(), 'trace' => e.getStackTraceString()});	
     	}
	    
        return response;


		
	}  

}