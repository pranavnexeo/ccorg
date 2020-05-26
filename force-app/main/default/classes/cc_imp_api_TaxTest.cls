@isTest
public class cc_imp_api_TaxTest {
	
    static testmethod void  calculateTaxTest() {
        

        Map<String, SObject> m = cc_imp_testUtils.initData();
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='231sbhdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = '12A123002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
          system.runAs(nexeoIntegrationUser)
        {
            List<cc_imp_StorefrontSettings__c> setList = cc_imp_testUtils.createNexeoCustomSettingList();
        insert setList;
        ccrz__E_Cart__c c = (ccrz__E_Cart__c) m.get('cart');
        ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_NEXEO3D_STOREFRONT;
        ccrz.cc_CallContext.effAccountGroup = ccrz.cc_CallContext.currAccountGroup;

        Test.setMock(HttpCalloutMock.class, new TaxCalloutMock());

        Decimal tax = null;

        String vatNumber = '123';
        String taxClassification = '0';

        Test.startTest();
        tax = cc_imp_api_Tax.calculateTax(c.Id, vatNumber, taxClassification);

        Test.stopTest();
        }

        //System.assertEquals(6.99, tax);
    }

    static testmethod void  calculateMyNexeoTaxTest() {
        

        Map<String, SObject> m = cc_imp_testUtils.initData();
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='67sbhdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = '67A123002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
          system.runAs(nexeoIntegrationUser)
        {
        cc_imp_StorefrontSettings__c setList = cc_imp_testUtils.createMyNexeoCustomSetting();
        insert setList;
        ccrz__E_Cart__c c = (ccrz__E_Cart__c) m.get('cart');
        ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_MYNEXEO_STOREFRONT;
        ccrz.cc_CallContext.effAccountGroup = ccrz.cc_CallContext.currAccountGroup;

        Test.setMock(HttpCalloutMock.class, new TaxCalloutMock());

        Decimal tax = null;
        String vatNumber = '123';
        String taxClassification = '0';

        Test.startTest();
        tax = cc_imp_api_Tax.calculateTax(c.Id, vatNumber, taxClassification);

        Test.stopTest();
        }

        //System.assertEquals(6.99, tax);
    }

    public class TaxCalloutMock implements HttpCalloutMock {

        public HTTPResponse respond(HTTPRequest req) {
            System.assertEquals('POST', req.getMethod());
        
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(cc_imp_json_TaxResponseTest.json);
            res.setStatusCode(200);
            return res;
        }

    }

	
}