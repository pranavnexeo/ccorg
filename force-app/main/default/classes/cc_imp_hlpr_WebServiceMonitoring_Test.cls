@IsTest
public class cc_imp_hlpr_WebServiceMonitoring_Test {
   
    static Map<String, SObject> initialData;
    
    static {
       initialData = cc_imp_mon_testUtils.initData(); 
    }
    
    static testmethod  void testSendEmailMonitoring(){
        cc_imp_hlpr_WebServiceMonitoring.sendEmail('TESTING', 'Test Mock', 'Test Response', 'Error Message');
    }

    static testmethod  void testSerializeViewCreditRequestMonitoring(){
        Account monoAccount = (Account) initialData.get('monoAccount');
        String jsonValue = cc_imp_hlpr_WebServiceMonitoring.serializeViewCreditRequest(monoAccount.Id);
        System.assert(null != jsonValue);
    }
    
    static testmethod  void testFetchProfileDetailMonitoring(){
       // cc_imp_testUtils.initData();
       // Account monoAccount = (Account) initialData.get('monoAccount');
        //cc_imp_hlpr_WebServiceMonitoring.FetchProfileDetail(monoAccount.Id);
    } 
    
    static testmethod  void testfetchMyInvoiceEncodedPdfMonitoring(){
 		 cc_imp_StorefrontSettings__c myNexeoCustomSetting = cc_imp_testUtils.createMyNexeoCustomSetting();

         insert myNexeoCustomSetting ;
    
         Map <String, String> headerMap = new Map<String, String> ();
         headerMap.put('Content-Type','application/json');
    
         Test.setMock(HttpCalloutMock.class, new cc_imp_mn_FetchInvoiceMock_HttpResponse(200,'success',mockResponse(), headerMap));
        
         String invoiceId = '123454646446';
    
         Test.startTest();
         cc_mn_json_myInvoiceResponse res = cc_imp_hlpr_WebServiceMonitoring.fetchMyInvoiceEncodedPdf('mynexeo', invoiceId);
    
         System.assert(res != null);
    
         Test.stopTest();
     
    } 
    
    static testmethod  void testFetchProfileDocMonitoring(){
        test.starttest();
        cc_imp_StorefrontSettings__C objCS = new cc_imp_StorefrontSettings__C(name='mynexeo',SDS_End_Point__c='test');
        insert objCs;
        map<string,string> maptest = new map<string,string>();
        maptest.put('a','b');
        Test.setMock(HttpCalloutMock.class, new cc_imp_mn_FetchInvoiceMock_HttpResponse (1,'test','test',maptest));
        cc_mn_json_ESProfileResponse res = cc_imp_hlpr_WebServiceMonitoring.FetchProfileDoc('1233456');
      
        test.stoptest();
    }   
    
    static testmethod  void testViewCreditMonitoring(){
        test.starttest();
        cc_mn_json_ViewCreditResponse res = cc_imp_hlpr_WebServiceMonitoring.viewCredit('1233456');
        test.stoptest();
    }
    
    private static String mockResponse() {
        return '{\"document\": \"643774\"}';
    }
    
    

}