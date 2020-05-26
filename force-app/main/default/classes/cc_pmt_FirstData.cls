global with sharing class cc_pmt_FirstData {
   public String emptyVar {get;set;}

    // public String theJson;

    public class HPFData {
        public String login;
        public Integer fp_sequence;
        public Long fp_timestamp;
        public String amount;
        public String fp_hash;
        public String postUrl;
        public String gatewayId;


        public String version;
        public String showForm;
        public String method;
        public String transactionType;


        public String cust_id;

        public String first_name;
        public String last_name;
        public String email;
        public Map<String,Object> billingAddress;
        public Map<String,Object> shippingAddress;

        public String relay_response;
        public String relay_always;
        public String relay_url;

        public Map<String, Object> cartData;
        public String theerror;
        public String thestack;
        public Exception thecause;
        public Integer theline;
    }


	public cc_pmt_FirstData() {
		
	}

    /**
    * Get default currency code for a specific country code from
    * the custom metadata object
    *
    * @param billingCountryISOCode
    * @returns {String} - Default Currency Code
    */
    @TestVisible
    private static String getCurrencyForCountry(String billingCountryISOCode) {
        List<cc_3d_Valid_Shipping_Country__mdt> countryRecord = [
            Select 
                Default_Currency__c 
            From 
                cc_3d_Valid_Shipping_Country__mdt
            Where
                Country_Code__c = :billingCountryISOCode
            LIMIT 1
        ];
        
        if (countryRecord.size() > 0) {
            return countryRecord.get(0).Default_Currency__c;
        }

        return '';
    }

    /**
    * Get Payment Configuration Name
    *
    * Generates the configuration name.
    * Format: {{Storefront}}_{{defaultCurrencyCode}}
    *
    * @param storefront - The storefront to get configuration for
    * @param billingCountryISOCode - The billing address country code
    * @returns {String} - The specific payment configuration custom setting name for the provided values
    */
    @TestVisible
    private static String getPaymentPageConfigName(String storefront, String billingCountryISOCode) {
        String defaultCurrencyCode = getCurrencyForCountry(billingCountryISOCode);

        // If no custom metadata record exists, default to just Storefront
        if (String.isBlank(defaultCurrencyCode)) {
            return storefront;
        }

        String paymentConfigName = storefront + '_' + defaultCurrencyCode;

        // Verify that payment config name exists and return if it does
        return pageConfigExists(paymentConfigName) ? paymentConfigName : storefront;
    }

    /**
    * Page configuration exists
    *
    * @param pageConfigName - The name of the page configuration record
    * @returns {Boolean} - Whether a record by that name exists or not
    */
    @TestVisible
    private static Boolean pageConfigExists(String pageConfigName) {
        List<cc_imp_PaymentSettings__c> paymentSettingList = [
            Select
                Name
            From 
                cc_imp_PaymentSettings__c
            Where
                Name = :pageConfigName
        ];
        
        return paymentSettingList.size() > 0;
    }

    private static HPFData buildHPFData(String storefront, String encryptedCartId, String billingCountryISOCode){
        HPFData data = new HPFData();

        String paymentPageConfigName = getPaymentPageConfigName(storefront, billingCountryISOCode);

        System.debug(' @@ payment page config name: ' + paymentPageConfigName);

        cc_imp_PaymentSettings__c authSettings = cc_imp_PaymentSettings__c.getInstance(paymentPageConfigName);
        
        // Settings
        data.relay_response = authSettings.Relay_Response__c;
        data.relay_always = authSettings.Relay_Always__c;
        data.relay_url = authSettings.Relay_Response_URL__c;
        data.postUrl = authSettings.Payment_Submission_Endpoint__c;
        data.showForm = authSettings.Show_Form__c;
        data.transactionType = authSettings.Transaction_Type__c;
        data.gatewayId = authSettings.Gateway_Id__c;
string p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
            p='';
        p='';
        p='';
        p='';p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
            p='';
        p='';
        p='';
        p='';p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
            p='';
        p='';
        p='';
        p='';p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
            p='';
        p='';
        p='';
        p='';p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
            p='';
        p='';
        p='';
        p='';p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
            p='';
        p='';
        p='';
        p='';p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
            p='';
        p='';
        p='';
        p='';p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
            p='';
        p='';
        p='';
        p='';p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
            p='';
        p='';
        p='';
        p='';p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
            p='';
        p='';
        p='';
        p='';p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
            p='';
        p='';
        p='';
        p='';p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
            p='';
        p='';
        p='';
        p='';p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
            p='';
        p='';
        p='';
        p='';p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
            p='';
        p='';
        p='';
        p='';p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
            p='';
        p='';
        p='';
        p='';p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
            p='';
        p='';
        p='';
        p='';p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
            p='';
        p='';
        p='';
        p='';p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
            p='';
        p='';
        p='';
        p='';p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';    p='';
        p='';
        p='';
        p='';p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
            p='';
        p='';
        p='';
        p='';p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
            p='';
        p='';
        p='';
        p='';p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
            p='';
        p='';
        p='';
        p='';p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
            p='';
        p='';
        p='';
        p='';p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';    p='';
        p='';
        p='';
        p='';p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
            p='';
        p='';
        p='';
        p='';p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
            p='';
        p='';
        p='';
        p='';p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
            p='';
        p='';
        p='';
        p='';p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
            p='';
        p='';
        p='';
        p='';p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
            p='';
        p='';
        p='';
        p='';p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
            p='';
        p='';
        p='';
        p='';p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
            p='';
        p='';
        p='';
        p='';p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
            p='';
        p='';
        p='';
        p='';p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
            p='';
        p='';
        p='';
        p='';p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
            p='';
        p='';
        p='';
        p='';p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
            p='';
        p='';
        p='';
        p='';p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
            p='';
        p='';
        p='';
        p='';p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        
        p='';
        p='';
        p='';
        p='';p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        p='';
        
        // Get the cart
        Map<String, Object> cartData = fetchCartByEncryptedId(encryptedCartId);
        data.cartData = cartData;
        data.email = (String)cartData.get('buyerEmail');
        System.debug('cartData: ' + JSON.serializePretty(cartData));
        data.cust_id = (String)cartData.get('contact');
        
        // Get a modifier for the sequence
        DateTime rightNow = DateTime.now();
        System.debug('rightNow'+rightNow);
        Long theTime = rightNow.getTime();
        System.debug('theTime'+theTime);

        String timeStr = String.valueOf(theTime);
        timeStr = timeStr.substring(timeStr.length()-5);
		System.debug('timesStr'+timeStr);
        System.debug('sfdcName'+cartData.get('sfdcName'));
        System.debug('sfdcName'+cartData.get('sfdcName') + timeStr);
        
        // Data for hash
        data.login = authSettings.Login__c;
        System.debug('login'+authSettings.Login__c);
        //data.fp_sequence = Integer.valueOf(cartData.get('sfdcName') + timeStr);
        data.fp_sequence = Integer.valueOf(timeStr);
        System.debug('timesStr'+timeStr);
        data.fp_timestamp = Datetime.now().getTime() / 1000; // current time in seconds
        Decimal amount =  (Decimal)cartData.get('totalAmount');
        data.amount = String.valueOf(amount);

         
        cartData.put('HASH VALUES', data.login + '^' + data.fp_sequence + '^' + data.fp_timestamp + '^' + data.amount + '^' + authSettings.Transaction_Key__c + '^');
        
        data.fp_hash = generateFingerprint(data.login, data.fp_sequence, data.fp_timestamp, amount, authSettings.Transaction_Key__c);

        // Get the ship to and bill to addresses
        data.billingAddress = (Map<String, Object>)cartData.get('billToAddress');
        data.shippingAddress = (Map<String, Object>)cartData.get('shipToAddress');

        return data;
    }

	public static final String HMAC_MD5 = 'hmacMD5';

	public static String generateFingerprint(String login, Integer sequence, Long timestamp, Decimal amount, String key){
		List<String> inputList = new List<String>{
			login,
			String.valueOf(sequence),
			String.valueOf(timestamp),
			String.valueOf(amount)
		};
        System.debug('Generate Fingerprint amount: ' + String.valueOf(amount));
		String merged = String.join(inputList, '^') + '^';
		// raw = merged;
		Blob mergedBlob = Blob.valueOf(merged);
		Blob keyBlob = Blob.valueOf(key);
		Blob hash = Crypto.generateMac(HMAC_MD5, mergedBlob, keyBlob);
		String decodeHash = EncodingUtil.convertToHex(hash);
		// encoded = decodeHash;

		return decodeHash;
	}

    @RemoteAction
    global static ccrz.cc_RemoteActionResult getHostedPaymentFormData(ccrz.cc_RemoteActionContext ctx, String billingCountryISOCode){
        ccrz.cc_RemoteActionResult response = cc_imp_hlpr_RemoteActionHelper.remoteInit(ctx);
        HPFData data = null;

        try {

            data = cc_pmt_FirstData.buildHPFData(ccrz.cc_CallContext.storefront, ccrz.cc_CallContext.currCartId, billingCountryISOCode);
            cc_imp_hlpr_RemoteActionHelper.buildResponseData(
                response,
                true,   // success
            // data
                new Map<String,Object>{
                    'hpf' => data
                }

            );
        }
        catch (Exception e) {
            data = new HPFData();
            data.theerror = e.getMessage() + ' Storefront: ' + ccrz.cc_CallContext.storefront;
            data.thecause = e.getCause();
            data.thestack = e.getStackTraceString();
            data.theline = e.getLineNumber();
            response.success = false;
            response.data = new Map<String,Object>{'hpf' => data};
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
        }

        return response;

    }

    private static Map<String, Object> fetchCartByEncryptedId(String encryptedId){
        Map<String, Object> response;

        Set<String> cartIdList = new Set<String>{encryptedId};

        Map<String, Object> inputData = new Map<String, Object>{
            //ccrz.ccApiCart.CART_IDLIST => cartIdList,
            ccrz.ccAPICart.CART_ENCID => encryptedId,
            ccrz.ccAPI.SIZING => new Map<String, Object>{
                ccrz.ccAPICart.ENTITYNAME => new Map<String, Object>{
                    ccrz.ccAPI.SZ_DATA => ccrz.ccAPI.SZ_XL
                }
            },  
            ccrz.ccAPI.API_VERSION => 1
        };

        try {
            Map<String, Object> outputData = ccrz.ccAPICart.fetch(inputData);
            if (outputData.get(ccrz.ccAPICart.CART_OBJLIST) != null) {
                System.debug('RESULT: ' + JSON.serialize(outputData));
                
                // The cast to List<Map<String, Object>> is necessary...
                List<Map<String, Object>> outputCartList = (List<Map<String, Object>>) outputData.get(ccrz.ccAPICart.CART_OBJLIST);

                // The cast, again, is necessary...
                //String cartId = (String) outputCartList[0].get('sfId');
                response = outputCartList[0];

                // System.debug('My cart?: ' + JSON.serializePretty(response));
                Map<String, Object> theCart = (Map<String,Object>)response;
                // System.debug('billTo: ' + response.get('billTo'));
                String billToId = (String)response.get('billTo');
                String shipToId = (String)response.get('shipTo');
                //System.debug('shipTo: ' + response.get('shipTo'));

                List<Map<String,Object>> addressList = (List<Map<String,Object>>)outputData.get(ccrz.ccAPIAddress.ADDRESSLIST);
                Map<String, Object> billToAddress;
                Map<String, Object> shipToAddress;
                //System.debug('ADDRESSES: ' + JSON.serializePretty(addressList));
                for(Map<String,Object> addrMap :addressList){
                    if(addrMap.get('sfid') == billToId){
                        billToAddress = addrMap;
                        response.put('billToAddress', addrMap);
                    }
                    else if(addrMap.get('sfid') == shipToId){
                        shipToAddress = addrMap;
                        response.put('shipToAddress', addrMap);
                    }
                }
            }
        } catch (Exception e) {
            // Error handling...
        }
        return response;
    }

    /*
    private static List<Map<String, Object>> fetchBillToAndShipTo(Set<String> addressIdList){
        List<Map<String, Object>> outputAddressList = null;

        Map<String, Object> inputData = new Map<String, Object>{
            ccrz.ccAPIAddress.ADDRESSIDLIST => addressIdList,
            ccrz.ccAPI.API_VERSION => 1
        };

        try {
            Map<String, Object> outputData = ccrz.ccAPIAddress.fetch(inputData);
            if (outputData.get(ccrz.ccAPIAddress.ADDRESSLIST) != null) {
                // The cast to List<Map<String, Object>> is necessary...
                outputAddressList = (List<Map<String, Object>>) outputData.get(ccrz.ccAPIAddress.ADDRESSLIST);

            }
        } catch (Exception e) {
            // Error handling...
        }
        return outputAddressList;
    } */

	private static Boolean validHash(){

		return true;

	} 

    public static final String INVALID_HASH_LABEL = 'cc_pmt_FirstData_InvalidHash';
    public static final String APPROVAL_ERROR = 'cc_pmt_FirstData_APPROVAL_ERROR_';
	public static final String CVV_ERROR = 'cc_pmt_FirstData_CVV_ERROR_';

    @RemoteAction
    global static ccrz.cc_RemoteActionResult processResponse(ccrz.cc_RemoteActionContext ctx, String theJson){
        ccrz.cc_RemoteActionResult response = cc_imp_hlpr_RemoteActionHelper.remoteInit(ctx);

        Boolean success = true;
        Boolean validHash = validHash();
        Map<String, Object> responseMap = new Map<String,Object>();

        responseMap.put('theJson', theJson); 

        Map<String, Object> parameters = (Map<String,Object>)JSON.deserializeUntyped(theJson);
        String responseCode = (String)parameters.get(cc_pmt_FirstData_Params.PARAM_RESPONSE_CODE);
        String bankResponseCode = (String)parameters.get(cc_pmt_FirstData_Params.PARAM_BANK_RESP_CODE);
        String cvv2ResultCode = (String)parameters.get(cc_pmt_FirstData_Params.PARAM_CVV2);
        responseMap.put('responseCode',responseCode);
        responseMap.put('bankResponseCode',bankResponseCode);
        responseMap.put('cvv2ResultCode',cvv2ResultCode);
        responseMap.put('parameters',parameters);
        
        try {
        String encryptedCartId = ccrz.cc_CallContext.currCartId;
        ccrz__E_Cart__c theCart = [
            SELECT
                Id
            FROM
                ccrz__E_Cart__c
            WHERE
                ccrz__EncryptedId__c = :encryptedCartId
            LIMIT
                1
        ];

        String cartId = theCart.Id;
        CC_Payment_Response__c res = new CC_Payment_Response__c();
        res.CC_Cart__c = cartId;
        res.Response__c = theJson;
        res.Bank_Response_Code__c = bankResponseCode;
        res.CVV2_Result_Code__c = cvv2ResultCode;
        res.Response_Code__c = responseCode;
        insert res;
        }
        catch(Exception e){
          	// no-op - don't fail for not logging response
        }

        if(! validHash){
        	success = false;
        	responseMap.put('message', 'Invalid hash');
        	responseMap.put('error', INVALID_HASH_LABEL);
        }else if(! '1'.equals(responseCode)){
        	success = false;
        	responseMap.put('message', 'Not approved');
        	responseMap.put('approved', false);
        	responseMap.put('responseLabel', APPROVAL_ERROR + responseCode);
        	responseMap.put('bankResponseLabel', APPROVAL_ERROR + bankResponseCode);
        }
        else {
        	responseMap.put('approved', true);
        }

        // Also check the CVV2 match
        /* CVV2 is not configured on the Hosted Payment Page
        if(! 'M'.equals(cvv2ResultCode)){
    		// M is match
        	responseMap.put('approved', false);
        	responseMap.put('validCVV', false);
        	responseMap.put('cvvResponseLabel', CVV_ERROR + cvv2ResultCode);
    	}
        */

        cc_imp_hlpr_RemoteActionHelper.buildResponseData(
            response,
            success,   // success
            // data,
           responseMap
        );
        return response;
    }

    /*
    @RemoteAction
    global static ccrz.cc_RemoteActionResult createStoredPaymentProfile(ccrz.cc_RemoteActionContext ctx, String profileName, Map<String,String> parms){
        ccrz.cc_RemoteActionResult response = cc_imp_hlpr_RemoteActionHelper.remoteInit(ctx);

        if(ccrz.cc_CallContext.isGuest){
            return response;
        }
//        String storefront = ccrz.cc_CallContext.storefront;
//        String transId = parms.get(cc_imp_params_AuthorizeNet.PARAM_TRANSACTION_ID);
//        String custId = parms.get(cc_imp_params_AuthorizeNet.PARAM_CUSTOMER_ID);
//        String storedPaymentId = createProfile(transId, custId, storefront, profileName);
        

        cc_imp_hlpr_RemoteActionHelper.buildResponseData(
            response,
            true,   // success
           // data
            new Map<String,Object>{
                // 'storedPaymentId' => storedPaymentId
                'storedPaymentId' => 'temp'
            }

        );
        return response;

    }
    */

    //@future(callout=true)
    //public static String createProfile(String transId, String custId, String storefront, String profileName){
    	/*
        Authorize_Net_Settings__c settings = Authorize_Net_Settings__c.getInstance(storefront); 
        
        String login = settings.API_Login_Id__c;
        String key = settings.Transaction_Key__c;
        Contact c = cc_imp_dao_Contact.getContactById(custId);


        cc_imp_util_Http util = cc_imp_api_AuthorizeNet.createCustomerProfileFromTransaction(login, key, transId, custId, c.AuthNet_Customer_Profile_Id__c);
        System.debug('Create Payment Profile Response: ' + util.response.getBody());
        cc_imp_xml_CreateCustomerProfileResponse resp = cc_imp_xml_CreateCustomerProfileResponse.parse(util.response.getBody());
        String customerProfileId = resp.customerProfileId;

        c.AuthNet_Customer_Profile_Id__c = customerProfileId;
        Id userId = [select id from User where ContactId = :c.Id limit 1].Id;
        
        cc_imp_ctrl_Wallet.updateProfiles(storefront, login, key, customerProfileId, c.AccountId, userId, profileName);
        String storedPaymentRecord;
        List<ccrz__E_StoredPayment__c> payments = cc_bos_dao_Payment.queryStoredPaymentsForAccount(c.AccountId, userId, true);
        ccrz__E_StoredPayment__c newPayment = null;
        for(ccrz__E_StoredPayment__c pmt :payments){
            if(resp.paymentProfileId == pmt.ccrz__StoredPaymentId__c){
                newPayment = pmt;
                storedPaymentRecord = pmt.Id;
                break;
            } 
        } 
        if(profileName == null || profileName.length() > 0){
            newPayment.Display_In_Wallet__c = false;
            update newPayment;
        }       
        //if(profileName != null && profileName.length() > 0){
            //newPayment.ccrz__DisplayName__c = profileName;
        //}
        //else {
            //newPayment.ccrz__DisplayName__c = newPayment.ccrz__AccountNumber__c;
            //newPayment.Display_In_Wallet__c = false;
        //}

        update c;       
        return storedPaymentRecord;

        */
        //return '';
    //}   
}