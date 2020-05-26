@isTest
public class cc_pmt_FirstDataTest {

    static testmethod void getHostedPaymentFormDataTest() {
        

        Map<String, SObject> m = cc_imp_testUtils.initData();
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        system.runas(nexeoIntegrationUser)
        {
            insert cc_imp_testUtils.createNexeoCustomSettingList();
        ccrz__E_Cart__c c = (ccrz__E_Cart__c) m.get('cart');
        ccrz__E_Cart__c cart = [SELECT ccrz__EncryptedId__c FROM ccrz__E_Cart__c WHERE Id = :c.Id];
        cc_imp_testUtils.clearContext();
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        ctx.storefront = 'mynexeo';
        ctx.currentCartId = cart.ccrz__EncryptedId__c;

        cc_imp_PaymentSettings__c settings = new cc_imp_PaymentSettings__c(
            Name = 'mynexeo',
            Relay_Response__c = '1',
            Relay_Always__c = '2',
            Relay_Response_URL__c = 'wwww.endpoint.com/test1',
            Payment_Submission_Endpoint__c = 'wwww.endpoint.com/test2',
            Show_Form__c = '5',
            Transaction_Key__c = '6',
            Transaction_Type__c = '7',
            Login__c = '8'
        );
        insert settings;

        ccrz.cc_RemoteActionResult result = null;

        Test.startTest();
        result = cc_pmt_FirstData.getHostedPaymentFormData(ctx, '');
        Test.stopTest();

        System.assert(result != null);
        System.assert(result.data != null);
        Map<String, Object> data = (Map<String, Object>) result.data;
        cc_pmt_FirstData.HPFData hpf = (cc_pmt_FirstData.HPFData) data.get('hpf');

        System.debug(hpf.cartData);
        System.assertEquals(null, hpf.amount);
        System.assertEquals(null, hpf.relay_response);
        }
    }

    static testmethod void processResponseTest() {
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        ctx.storefront = 'mynexeo';
        Map<String, Object> invoice = new Map<String,Object>();
        invoice.put(cc_pmt_FirstData_Params.PARAM_RESPONSE_CODE, '1');
        invoice.put(cc_pmt_FirstData_Params.PARAM_BANK_RESP_CODE, '1');
        invoice.put(cc_pmt_FirstData_Params.PARAM_CVV2, 'M');
        String jsonString = JSON.serialize(invoice);

        ccrz.cc_RemoteActionResult result = null;

        Test.startTest();
        result = cc_pmt_FirstData.processResponse(ctx, jsonString);
        Test.stopTest();

        System.assert(result != null);
        System.assert(result.data != null);
        Map<String, Object> data = (Map<String, Object>) result.data;

        System.assert((Boolean)data.get('approved'));
        //System.assert((Boolean)data.get('validCVV')); - CVV isn't being used
    }

    static testmethod void processResponseFailTest() {
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        ctx.storefront = 'mynexeo';
        Map<String, Object> invoice = new Map<String,Object>();
        invoice.put(cc_pmt_FirstData_Params.PARAM_RESPONSE_CODE, '0');
        invoice.put(cc_pmt_FirstData_Params.PARAM_BANK_RESP_CODE, '0');
        invoice.put(cc_pmt_FirstData_Params.PARAM_CVV2, 'F');
        String jsonString = JSON.serialize(invoice);

        ccrz.cc_RemoteActionResult result = null;

        Test.startTest();
        result = cc_pmt_FirstData.processResponse(ctx, jsonString);
        Test.stopTest();

        System.assert(result != null);
        System.assert(result.data != null);
        Map<String, Object> data = (Map<String, Object>) result.data;

        System.assert(!(Boolean)data.get('approved'));
        //System.assert(!(Boolean)data.get('validCVV')); // CVV isn't being used
    }

    /**
    * Dynamic Currency Page Configuration test methods
    *
    */
    private static final String STOREFRONT = 'nexeo3d';
    private static final String COUNTRY = 'MX';
    private static final String DEFAULT_CURRENCY = 'MX';

    private static void initPaymentConfig() {
        // Country metadata Record must exist in org.
        System.assert(countryMetadataExists(COUNTRY));

        insert cc_imp_testUtils.createNexeoCustomSettingList();

        cc_imp_PaymentSettings__c settings = new cc_imp_PaymentSettings__c(
            Name = STOREFRONT + '_' + DEFAULT_CURRENCY,
            Relay_Response__c = '1',
            Relay_Always__c = '2',
            Relay_Response_URL__c = 'wwww.endpoint.com/test1',
            Payment_Submission_Endpoint__c = 'wwww.endpoint.com/test2',
            Show_Form__c = '5',
            Transaction_Key__c = '6',
            Transaction_Type__c = '7',
            Login__c = '8'
        );
        insert settings;
    }

    private static Boolean countryMetadataExists(String countryCode) {
        List<cc_3d_Valid_Shipping_Country__mdt> countryRecord = [
            Select 
                Default_Currency__c 
            From 
                cc_3d_Valid_Shipping_Country__mdt
            Where
                Country_Code__c = :countryCode
            LIMIT 1
        ];
        
        return countryRecord.size() > 0;
    }

    @isTest
    static void test_PayConfigGetCurrency() {
        cc_pmt_FirstDatatest.initPaymentConfig();
        
        Test.startTest();

        String actualCurrency = cc_pmt_FirstData.getCurrencyForCountry(COUNTRY);

        Test.stopTest();

        System.assert(actualCurrency != NULL, 'Currency should not be NULL');
        System.assertEquals(actualCurrency, DEFAULT_CURRENCY, 'Unexpected currency value provided from country metadata record');
    }

    @isTest
    static void test_PayConfigNameExists() {
        cc_pmt_FirstDatatest.initPaymentConfig();
        
        Test.startTest();

        Boolean nonExistant = cc_pmt_FirstData.pageConfigExists('none');
        Boolean exists = cc_pmt_FirstData.pageConfigExists(STOREFRONT + '_' + DEFAULT_CURRENCY);
        
        Test.stopTest();

        System.assert(nonExistant == FALSE);
        System.assert(exists == TRUE);
    }


    @isTest
    static void test_PayConfigGetConfigName() {
        cc_pmt_FirstDatatest.initPaymentConfig();

        Test.startTest();

        String paymentPageConfigName = cc_pmt_FirstData.getPaymentPageConfigName(STOREFRONT, COUNTRY);

        Test.stopTest();

        system.assertEquals(paymentPageConfigName, STOREFRONT + '_' + DEFAULT_CURRENCY);
    }

    @isTest
    static void test_getPaymentPageConfig() {
        
        Map<String, SObject> m = cc_imp_testUtils.initData();
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        system.runas(nexeoIntegrationUser)
        {
            cc_pmt_FirstDatatest.initPaymentConfig();

        ccrz__E_Cart__c c = (ccrz__E_Cart__c) m.get('cart');
        ccrz__E_Cart__c cart = [SELECT ccrz__EncryptedId__c FROM ccrz__E_Cart__c WHERE Id = :c.Id];
        
        cc_imp_testUtils.clearContext();
        
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        ctx.storefront = STOREFRONT;
        ctx.currentCartId = cart.ccrz__EncryptedId__c;

        Test.startTest();

        ccrz.cc_RemoteActionResult result = null;
        result = cc_pmt_FirstData.getHostedPaymentFormData(ctx, COUNTRY);
        
        Test.stopTest();

        System.assert(result != null);
        System.assert(result.data != null);
        Map<String, Object> data = (Map<String, Object>) result.data;
        cc_pmt_FirstData.HPFData hpf = (cc_pmt_FirstData.HPFData) data.get('hpf');

        System.assertEquals(null, hpf.login, 'Unexpected Login value from Hosted Payment Form data');
        System.assertEquals(null, hpf.relay_response, 'Unexpected Relay Response value from Hosted Payment Form data');
        }
    }
}