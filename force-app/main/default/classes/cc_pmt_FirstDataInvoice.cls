global with sharing class cc_pmt_FirstDataInvoice {
    public String emptyVar {get;set;}

    public class HPFData {
        public String login;
        public String fp_sequence;
        public Long fp_timestamp;
        public String amount;
        public String fp_hash;
        public String postUrl;
        public String hashValues;

        public String version;
        public String showForm;
        public String method;
        public String transactionType;

        public String relay_response;
        public String relay_always;
        public String relay_url;

        public String theerror;
        public String thestack;
        public Exception thecause;
        public Integer theline;
    }

   private static HPFData buildHPFData(Map<String, Object> invoice) {
       HPFData data = new HPFData();
       String storefront = ccrz.cc_CallContext.storefront;
       try {


        cc_imp_PaymentSettings__c authSettings = cc_imp_PaymentSettings__c.getInstance(storefront);
        
        // Settings
        data.relay_response = authSettings.Relay_Response__c;
        data.relay_always = authSettings.Relay_Always__c;
        data.relay_url = authSettings.Relay_Response_URL__c;
        data.postUrl = authSettings.Payment_Submission_Endpoint__c;
        data.showForm = authSettings.Show_Form__c;
        data.transactionType = authSettings.Transaction_Type__c;

        // Data for hash
        data.login = authSettings.Login__c;
        data.fp_sequence = (String)invoice.get('name');
        data.fp_timestamp = Datetime.now().getTime() / 1000; // current time in seconds
        Decimal amount =  (Decimal)invoice.get('remainingAmount');
        data.amount = String.valueOf(amount);

        data.hashValues = data.login + '^' + data.fp_sequence + '^' + data.fp_timestamp + '^' + data.amount + '^' + authSettings.Transaction_Key__c + '^';
        data.fp_hash = generateFingerprint(data.login, data.fp_sequence, data.fp_timestamp, amount, authSettings.Transaction_Key__c);

        }
        catch(Exception e){
            data.theerror = e.getMessage() + ' Storefront: ' + storefront;
            data.thecause = e.getCause();
            data.thestack = e.getStackTraceString();
            data.theline = e.getLineNumber();
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
        }
        return data;
    }

    public static final String HMAC_MD5 = 'hmacMD5';

    public static String generateFingerprint(String login, String sequence, Long timestamp, Decimal amount, String key) {
        List<String> inputList = new List<String>{
            login,
            sequence,
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
    global static ccrz.cc_RemoteActionResult getHostedPaymentFormData(ccrz.cc_RemoteActionContext ctx, String dataString) {
        ccrz.cc_RemoteActionResult response = cc_imp_hlpr_RemoteActionHelper.remoteInit(ctx);
        Map<String, Object> theMap = (Map<String,Object>)JSON.deserializeUntyped(dataString);
        Map<String, Object> invoice = (Map<String,Object>) theMap.get('invoice');

        HPFData data = buildHPFData(invoice);

        cc_imp_hlpr_RemoteActionHelper.buildResponseData(
            response,
            true,   // success
           // data
            new Map<String,Object>{
                'hpf' => data
            }

        );
        return response;

    }

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

        responseMap.put('theJson', theJson); // temporary

        Map<String, Object> parameters = (Map<String,Object>)JSON.deserializeUntyped(theJson);
        String responseCode = (String)parameters.get(cc_pmt_FirstData_Params.PARAM_RESPONSE_CODE);
        String bankResponseCode = (String)parameters.get(cc_pmt_FirstData_Params.PARAM_BANK_RESP_CODE);
        String cvv2ResultCode = (String)parameters.get(cc_pmt_FirstData_Params.PARAM_CVV2);


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
        if(! 'M'.equals(cvv2ResultCode)){
            // M is match
            responseMap.put('approved', false);
            responseMap.put('validCVV', false);
            responseMap.put('cvvResponseLabel', CVV_ERROR + cvv2ResultCode);
        }
        else {
            responseMap.put('validCVV', true);
        }

        cc_imp_hlpr_RemoteActionHelper.buildResponseData(
            response,
            success,   // success
           // data
           responseMap
        );
        return response;
    }

}