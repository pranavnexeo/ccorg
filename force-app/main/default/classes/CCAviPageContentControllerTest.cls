@isTest
public class CCAviPageContentControllerTest {

    private static final String TEST_STOREFRONT = '3d';
    
    static testmethod void testi18n() {
        List<CC_Avi_Page_Content__c> pageContents = new List<CC_Avi_Page_Content__c> {
           new CC_Avi_Page_Content__c(
                ContentKey__c    = 'pc001',
                ContentURL__c = 'http://www.text.com/mycontent1.html',
                Storefront__c  = TEST_STOREFRONT
            ),
            new CC_Avi_Page_Content__c(
                ContentKey__c    = 'pc002',
                ContentURL__c = 'http://www.text.com/mycontent2.html',
                Storefront__c  = TEST_STOREFRONT
            ),
            new CC_Avi_Page_Content__c(
                ContentKey__c    = 'pc003',
                ContentURL__c = 'http://www.text.com/mycontent3.html',
                Storefront__c  = TEST_STOREFRONT
            )
            
        };

        insert pageContents;
        
        CC_Avi_Page_ContentI18N__c locale = new CC_Avi_Page_ContentI18N__c(
                ContentURL__c = 'http://www.text.com/mycontent4.html',
                Locale__c = 'fr_fr',
                CC_Avi_Page_Content__c = pageContents[0].id
            );
            insert locale;
        
        ccrz.cc_CallContext.userLocale='fr_fr';

        ccrz.cc_CallContext.storefront = TEST_STOREFRONT;

        Test.setMock(HttpCalloutMock.class, new HttpCalloutTestMock());

        CCAviPageContentController res1 = null;
        CCAviPageContentController res2 = null;
        CCAviPageContentController res3 = null;
        CCAviPageContentController res4 = null;

        Test.startTest();
        ApexPages.currentPage().getParameters().put('contentKey' , 'pc001');
        res1 = new CCAviPageContentController();
        ApexPages.currentPage().getParameters().put('contentKey' , 'pc002');
        res2 = new CCAviPageContentController();
        ApexPages.currentPage().getParameters().put('contentKey' , 'pc003');
        res3 = new CCAviPageContentController();
        ApexPages.currentPage().getParameters().put('contentKey' , 'pc004');
        res4 = new CCAviPageContentController();
        Test.stopTest();

        System.assert(res1 != null);
        System.assertEquals('http://www.text.com/mycontent4.html', res1.contentURL);
        System.assert(res2!= null);
        System.assertEquals('http://www.text.com/mycontent2.html', res2.contentURL);
        System.assert(res3 != null);
        System.assertEquals('http://www.text.com/mycontent3.html', res3.contentURL);
        System.assert(res4 != null);
        System.assertEquals(null, res4.contentURL);
    }

    static testmethod void testCssUrlChanges() {
        List<CC_Avi_Page_Content__c> pageContents = new List<CC_Avi_Page_Content__c> {
           new CC_Avi_Page_Content__c(
                ContentKey__c    = 'pc001',
                ContentURL__c = 'http://www.text.com/mycontent1.html',
                Storefront__c  = TEST_STOREFRONT,
                CSS_Urls__c = 'https://www.test.com/one,https://www.test.com/two'

            ),
            new CC_Avi_Page_Content__c(
                ContentKey__c    = 'pc002',
                ContentURL__c = 'http://www.text.com/mycontent2.html',
                Storefront__c  = TEST_STOREFRONT,
                CSS_Urls__c = 'https://www.test.com/three,https://www.test.com/four'

            ),
            new CC_Avi_Page_Content__c(
                ContentKey__c    = 'pc003',
                ContentURL__c = 'http://www.text.com/mycontent3.html',
                Storefront__c  = TEST_STOREFRONT,
                CSS_Urls__c = 'https://www.test.com/four,https://www.test.com/five'
            )
            
        };

        insert pageContents;

        ccrz.cc_CallContext.storefront = TEST_STOREFRONT;

        Test.setMock(HttpCalloutMock.class, new HttpCalloutTestMock());

        CCAviPageContentController res1 = null;
        CCAviPageContentController res2 = null;
        CCAviPageContentController res3 = null;

        Test.startTest();
        ApexPages.currentPage().getParameters().put('contentKey' , 'pc001');
        res1 = new CCAviPageContentController();
        ApexPages.currentPage().getParameters().put('contentKey' , 'pc002');
        res2 = new CCAviPageContentController();
        ApexPages.currentPage().getParameters().put('contentKey' , 'pc003');
        res3 = new CCAviPageContentController();

        Test.stopTest();

        System.assert(res1 != null);
        System.assertEquals(2, res1.cssUrls.size());
        System.assertEquals('https://www.test.com/two', res1.cssUrls[1]);


    }

    static testmethod void constructorTest() {
        setupTestData();

        ccrz.cc_CallContext.storefront = TEST_STOREFRONT;

        Test.setMock(HttpCalloutMock.class, new HttpCalloutTestMock());

        CCAviPageContentController res1 = null;
        CCAviPageContentController res2 = null;
        CCAviPageContentController res3 = null;
        CCAviPageContentController res4 = null;

        Test.startTest();
        ApexPages.currentPage().getParameters().put('contentKey' , 'pc001');
        res1 = new CCAviPageContentController();
        ApexPages.currentPage().getParameters().put('contentKey' , 'pc002');
        res2 = new CCAviPageContentController();
        ApexPages.currentPage().getParameters().put('contentKey' , 'pc003');
        res3 = new CCAviPageContentController();
        ApexPages.currentPage().getParameters().put('contentKey' , 'pc004');
        res4 = new CCAviPageContentController();
        Test.stopTest();

        System.assert(res1 != null);
        System.assertEquals('http://www.text.com/mycontent1.html', res1.contentURL);
        System.assert(res2!= null);
        System.assertEquals('http://www.text.com/mycontent2.html', res2.contentURL);
        System.assert(res3 != null);
        System.assertEquals('http://www.text.com/mycontent3.html', res3.contentURL);
        System.assert(res4 != null);
        System.assertEquals(null, res4.contentURL);

    }

    static testmethod void bodyTest() {
           List<CC_Avi_Page_Content__c> pageContents = new List<CC_Avi_Page_Content__c> {
           new CC_Avi_Page_Content__c(
                ContentKey__c    = 'pc001',
                ContentURL__c = 'http://www.text.com/mycontent1.html',
                Storefront__c  = TEST_STOREFRONT
            ),
            new CC_Avi_Page_Content__c(
                ContentKey__c    = 'pc002',
                ContentBody__c = '<p>Hello World</p>',
                Storefront__c  = TEST_STOREFRONT
            )
            
        };

        insert pageContents;

        ccrz.cc_CallContext.storefront = TEST_STOREFRONT;

        Test.setMock(HttpCalloutMock.class, new HttpCalloutTestMock());

        CCAviPageContentController res1 = null;
        CCAviPageContentController res2 = null;
 

        Test.startTest();
        ApexPages.currentPage().getParameters().put('contentKey' , 'pc001');
        res1 = new CCAviPageContentController();
        ApexPages.currentPage().getParameters().put('contentKey' , 'pc002');
        res2 = new CCAviPageContentController();

        Test.stopTest();

        System.assert(res2!= null);
        System.assertEquals('<p>Hello World</p>', res2.content);


    }

    private static void setupTestData() {
        List<CC_Avi_Page_Content__c> pageContents = new List<CC_Avi_Page_Content__c> {
           new CC_Avi_Page_Content__c(
                ContentKey__c    = 'pc001',
                ContentURL__c = 'http://www.text.com/mycontent1.html',
                Storefront__c  = TEST_STOREFRONT
            ),
            new CC_Avi_Page_Content__c(
                ContentKey__c    = 'pc002',
                ContentURL__c = 'http://www.text.com/mycontent2.html',
                Storefront__c  = TEST_STOREFRONT
            ),
            new CC_Avi_Page_Content__c(
                ContentKey__c    = 'pc003',
                ContentURL__c = 'http://www.text.com/mycontent3.html',
                Storefront__c  = TEST_STOREFRONT
            )
            
        };

        insert pageContents;
        
    }

    public class HttpCalloutTestMock implements HttpCalloutMock {

        public HTTPResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);
            response.setStatus('OK');
            return response;
        }
    }
}