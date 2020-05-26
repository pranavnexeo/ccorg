@isTest
public class cc_imp_mn_ViewProfileDocTest {
    
    @isTest static void ValidateViewProfileDoc()
    {
        test.starttest();
        cc_imp_StorefrontSettings__C objCS = new cc_imp_StorefrontSettings__C(name='mynexeo',ESScreenReportsEndpoint__c='test');
        insert objCs;
        map<string,string> maptest = new map<string,string>();
        maptest.put('a','b');
        Test.setMock(HttpCalloutMock.class, new cc_imp_mn_FetchInvoiceMock_HttpResponse (1,'test','test',maptest));
        ApexPages.currentPage().getParameters().put('strPid', '23');
        cc_imp_mn_ViewProfileDoc obj = new cc_imp_mn_ViewProfileDoc();
        obj.FetchProfileDoc();
      
        test.stoptest();
    }
     @isTest static void ValidateViewProfileDoc1()
    {
           test.starttest();
        cc_imp_StorefrontSettings__C objCS = new cc_imp_StorefrontSettings__C(name='mynexeo',ESScreenReportsEndpoint__c='test');
        insert objCs;
        map<string,string> maptest = new map<string,string>();
        maptest.put('a','b');
        Test.setMock(HttpCalloutMock.class, new cc_imp_mn_FetchInvoiceMock_HttpResponse (1,'test','test',maptest));
        ApexPages.currentPage().getParameters().put('strPid', '23');
        ES_Order_Document__c obj1 = new ES_Order_Document__c();
        insert obj1;
            
        cc_imp_mn_ViewProfileDoc obj = new cc_imp_mn_ViewProfileDoc();
        obj.FetchProfileDoc();
           test.stoptest();
    }
}