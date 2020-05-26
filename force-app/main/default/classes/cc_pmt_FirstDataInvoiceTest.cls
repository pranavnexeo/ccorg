@isTest
public class cc_pmt_FirstDataInvoiceTest {

    static testmethod void getHostedPaymentFormDataTest() {
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        ctx.storefront = 'mynexeo';
        Map<String, Object> theMap = new Map<String,Object>();
        Map<String, Object> invoice = new Map<String,Object>();
        invoice.put('name', 'I-00000001');
        invoice.put('remainingAmount', 100.00);
        theMap.put('invoice', invoice);
        String jsonString = JSON.serialize(theMap);

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
        result = cc_pmt_FirstDataInvoice.getHostedPaymentFormData(ctx, jsonString);
        Test.stopTest();

        System.assert(result != null);
        System.assert(result.data != null);
        Map<String, Object> data = (Map<String, Object>) result.data;
        cc_pmt_FirstDataInvoice.HPFData hpf = (cc_pmt_FirstDataInvoice.HPFData) data.get('hpf');

        System.assertEquals('100.00', hpf.amount);
        System.assertEquals('1', hpf.relay_response);
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
        result = cc_pmt_FirstDataInvoice.processResponse(ctx, jsonString);
        Test.stopTest();

        System.assert(result != null);
        System.assert(result.data != null);
        Map<String, Object> data = (Map<String, Object>) result.data;

        System.assert((Boolean)data.get('approved'));
        System.assert((Boolean)data.get('validCVV'));
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
        result = cc_pmt_FirstDataInvoice.processResponse(ctx, jsonString);
        Test.stopTest();

        System.assert(result != null);
        System.assert(result.data != null);
        Map<String, Object> data = (Map<String, Object>) result.data;

        System.assert(!(Boolean)data.get('approved'));
        System.assert(!(Boolean)data.get('validCVV'));
    }

}