global with sharing class cc_imp_ctrl_FileUpload {

	public String extendedCheckoutCartJSON {get; set;}
    public String nexeoCurrency {get; set;}	


	public cc_imp_ctrl_FileUpload() {
		String encryptedCartId = ApexPages.currentPage().getParameters().get('cartId');

       	this.extendedCheckoutCartJSON = JSON.serialize(buildExtendedCartItemMap(encryptedCartId));
     
		 List<ccrz__E_Cart__c> cartSFDCid = [
            select 
            	id,
            	ccrz__CurrencyISOCode__c,
            	ccrz__TotalQuantity__c
            from
            	ccrz__E_Cart__c
            where 
            	ccrz__EncryptedId__c = : encryptedCartId Limit 1
        ];
      if(!cartSFDCid.isEmpty()){
        for(ccrz__E_Cart__c cart : cartSFDCid){
            if(cart.ccrz__TotalQuantity__c==0){
                this.nexeoCurrency='';
            }else{
                this.nexeoCurrency=cart.ccrz__CurrencyISOCode__c;
            }
            } 
            
        }
        else{
                this.nexeoCurrency='';
            
        }
	}


	@RemoteAction
	global static ccrz.cc_RemoteActionResult uploadFile(ccrz.cc_RemoteActionContext ctx, String fileName, String contentType, String fileType, String fileBody, String comments) {
		Boolean success = true;
		ccrz.cc_RemoteActionResult response = cc_imp_hlpr_RemoteActionHelper.remoteInit(ctx);

		try {

		NexCare__c nexCare = new NexCare__c();
		nexCare.Account_Name__c = ccrz.cc_CallContext.currAccountId;
		nexCare.Contact_Name__c = ccrz.cc_CallContext.currContact.Id;
        nexCare.Short_Description__c = fileType;
		nexCare.Description__c = comments;
		nexCare.Tier_1__c = 'Request';
		nexCare.Tier_2__c = 'Upload Document';
		cc_imp_hlpr_FileUpload.insertNexCare(nexCare);

		// Save the file
		Attachment theAtt = new Attachment();
		// theAtt.ParentId = theCase.Id;
		theAtt.ParentId = nexCare.Id;
		theAtt.Name = fileName;
		theAtt.ContentType = contentType;
		theAtt.Body = EncodingUtil.base64Decode(fileBody);
		// Do not insert the attachment directly since the owner is not the community user
		cc_imp_hlpr_FileUpload.insertAttachment(theAtt);


		// Return the result
     		cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, true, 
     			new Map<String,Object>{
     				'success' => success
     			}
        	);
     	}
     	catch(Exception e){
	     	cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, true, new Map<String,Object>{'success' => false, 'message' => e.getMessage(), 'cause' => e.getCause(), 'trace' => e.getStackTraceString()});	
     	}

     	return response;

	}

	private Map<String,ExtendedCheckoutCartItem> buildExtendedCartItemMap(String encryptedCartId) {
        Map<String, ExtendedCheckoutCartItem> extendedCartItemMap = new Map<String, ExtendedCheckoutCartItem>();
        String cartCurrency='';
		 List<ccrz__E_Cart__c> cartSFDCid = [
            select 
            	id,
            	ccrz__CurrencyISOCode__c,
            	ccrz__TotalQuantity__c
            from
            	ccrz__E_Cart__c
            where 
            	ccrz__EncryptedId__c = : encryptedCartId Limit 1
        ];
      if(!cartSFDCid.isEmpty()){
        for(ccrz__E_Cart__c cart : cartSFDCid){
            if(cart.ccrz__TotalQuantity__c==0){
                cartCurrency='';
            }else{
                cartCurrency=cart.ccrz__CurrencyISOCode__c;
            }
            } 
            
        }
        else{
                cartCurrency='';
            
        }
        List<ccrz__E_CartItem__c> cartItemList = new List<ccrz__E_CartItem__c>(
            [
                SELECT
                    Id
                    , ccrz__Product__c,Price_Per_Unit__c
                FROM
                    ccrz__E_CartItem__c
                WHERE
                    ccrz__Cart__r.ccrz__EncryptedId__c = :encryptedCartId
            ]
        );

        Set<Id> productIdSet = new Set<Id>();
        for (ccrz__E_CartItem__c item : cartItemList) {
            productIdSet.add(item.ccrz__Product__c);
        }
        Map<Id, ccrz__E_PriceListItem__c> pliMap = cc_imp_hlpr_PriceListHelper.getPriceListItemsBySequence(new List<Id>(productIdSet));

        for (ccrz__E_CartItem__c item : cartItemList) {
            ExtendedCheckoutCartItem newExtendedCartItem = new ExtendedCheckoutCartItem();
            ccrz__E_PriceListItem__c pli = pliMap.get(item.ccrz__Product__c);
            if (pli != null && pli.CPI__c != null) {
                newExtendedCartItem.customerMaterialNumber = pli.CPI__r.Customer_Material_Number__c;
                newExtendedCartItem.priceperunit=item.Price_Per_Unit__c;
                newExtendedCartItem.productNumber=String.valueOf(Integer.valueOf(pli.ccrz__Product__r.Product_Number__c));
                newExtendedCartItem.cartCurrency=cartCurrency;
            }

            extendedCartItemMap.put(item.Id, newExtendedCartItem);
        }

        return extendedCartItemMap;
    }

    global class ExtendedCheckoutCartItem {
        public String customerMaterialNumber {get; set;}
        public String productNumber {get; set;}    
        public String cartCurrency {get; set;}
        public Decimal priceperunit {get; set;}
    }
}