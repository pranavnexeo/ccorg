@isTest
public class cc_pmt_FirstData_RelayTest {

    static testmethod void postPaymentResponseTest() {

        Test.setCurrentPage(Page.cc_pmt_FirstData_Relay);
        System.currentPageReference().getParameters().put('name', 'value');

        cc_pmt_FirstData_Relay controller = null;

        Test.startTest();
        controller = new cc_pmt_FirstData_Relay();
        controller.postPaymentResponse();
        Test.stopTest();

        System.assert(controller != null);
        System.assert(controller.theJSON != null);
    }

    static testmethod void postPaymentResponseExceptionTest() {

        cc_pmt_FirstData_Relay controller = null;

        Test.startTest();
        controller = new cc_pmt_FirstData_Relay();
        controller.postPaymentResponse();
        Test.stopTest();
    }
}