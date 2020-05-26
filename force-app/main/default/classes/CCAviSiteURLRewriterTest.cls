/**
* Site URL Rewriter Test Class
*
*
*/

@isTest
public with sharing class CCAviSiteURLRewriterTest { 
    
    private static Final String STOREFRONT = 'nexeo3d';

    @isTest
    public static void test_getURLMapRecords() {

        CC_Avi_URL_Map__c urlMap = createUrlMap('/requestUrl', 'ccrz__HomePage', STOREFRONT);
        insert urlMap;

        Test.startTest();

        CCAviSiteURLRewriter urlRewriter = new CCAviSiteURLRewriter();
        List<CC_Avi_URL_Map__c> urlMapList = urlRewriter.getURLMapRecords(STOREFRONT);

        Test.stopTest();

        System.assert(urlMapList.size() > 0);
    }

    @isTest
    public static void test_getCacheKey() {
        CCAviSiteURLRewriter urlRewriter = new CCAviSiteURLRewriter();
        String key = urlRewriter.getCacheKey(STOREFRONT);

        String expected = urlRewriter.ORG_CACHE_NAMESPACE + '.' +
            urlRewriter.ORG_CACHE_PARTITION + '.' +
            urlRewriter.cleanString(STOREFRONT) + 
            urlRewriter.ORG_CACHE_KEY_POSTFIX;

        System.assert(key.equals(expected));
    }

    @isTest
    public static void test_getURLMapping() {

        CC_Avi_URL_Map__c urlMapRecord = createUrlMap('/requestUrl', 'ccrz__HomePage', STOREFRONT);
        insert urlMapRecord;

        Test.startTest();

        CCAviSiteURLRewriter urlRewriter = new CCAviSiteURLRewriter();

        String key = urlRewriter.getCacheKey(STOREFRONT);
System.debug('CACHE KEY IS' + key);

        // Assert cache is empty
        System.assert(urlRewriter.getFromCache(key) == NULL);

        Map<String, String> urlMap = urlRewriter.getURLMapping();

        // Assert the record was retrieved correctly
        System.assert(urlMap.containsKey('/requestUrl'));
        
        // Assert that the cache partition was created - It's ok to work without cache
        //System.assert(urlRewriter.getFromCache(key) != NULL);
    }

    @isTest
    public static void test_mapRequestUrl() {
        CC_Avi_URL_Map__c urlMap = createUrlMap('/requestUrl', 'ccrz__HomePage', STOREFRONT);
        insert urlMap;

        Test.startTest();

        CCAviSiteURLRewriter urlRewriter = new CCAviSiteURLRewriter();
        
        PageReference result = urlRewriter.mapRequestUrl(new PageReference('/requestUrl'));

        Test.stopTest();

        System.assert(result.getUrl().equals('ccrz__HomePage'));
    }

    @isTest
    public static void test_mapRequestUrl_Invalid() {
        CC_Avi_URL_Map__c urlMap = createUrlMap('/requestUrl', 'ccrz__HomePage', STOREFRONT);
        insert urlMap;

        Test.startTest();

        CCAviSiteURLRewriter urlRewriter = new CCAviSiteURLRewriter();
        
        PageReference result = urlRewriter.mapRequestUrl(new PageReference('/NonExistant'));

        Test.stopTest();

        System.assert(result == NULL);
    }

    @isTest
    public static void test_mapRequestUrl_Empty() {
        CC_Avi_URL_Map__c urlMap = createUrlMap('/requestUrl', 'ccrz__HomePage', STOREFRONT);
        insert urlMap;

        Test.startTest();

        CCAviSiteURLRewriter urlRewriter = new CCAviSiteURLRewriter();
        
        PageReference result = urlRewriter.mapRequestUrl(new PageReference(''));

        Test.stopTest();

        System.assert(result == NULL);
    }

    @isTest
    public static void test_mapRequestUrl_Home() {
        CC_Avi_URL_Map__c urlMap = createUrlMap('/requestUrl', 'ccrz__HomePage', STOREFRONT);
        insert urlMap;

        Test.startTest();

        CCAviSiteURLRewriter urlRewriter = new CCAviSiteURLRewriter();
        
        PageReference result = urlRewriter.mapRequestUrl(new PageReference('/'));

        Test.stopTest();

        System.assert(result == NULL);
    }

    @isTest
    public static void test_mapRequestUrl_Categories() {
        Test.startTest();

        CCAviSiteURLRewriter urlRewriter = new CCAviSiteURLRewriter();
        
        PageReference result = urlRewriter.mapRequestUrl(new PageReference(CCAviSiteUrlRewriter.CATEGORIES+'categoryId123'));

        Test.stopTest();

        System.assert(result != NULL);

        // TODO - Add test with real category
    }

    @isTest
    public static void test_mapRequestUrl_ProductDetails() {
        Test.startTest();

        CCAviSiteURLRewriter urlRewriter = new CCAviSiteURLRewriter();
        
        PageReference result = urlRewriter.mapRequestUrl(new PageReference(CCAviSiteUrlRewriter.PRODUCT_DETAILS+'productSku123'));

        Test.stopTest();

        System.assert(result != NULL);

        // TODO - Add test with real product SKU    
    }

    /**
    * No current implementation for this. Only used for coverage.
    */
    @isTest
    public static void test_generateUrlFor() {
        CCAviSiteURLRewriter urlRewriter = new CCAviSiteURLRewriter();
        List<PageReference> result = urlRewriter.generateUrlFor(new List<PageReference>());
    }

    /**
    * Utility method to create CCAviURLMap record
    *
    * @param requestUrl Request URL field value
    * @param realUrl Real URL field value
    * @param theStorefront Storefront field value
    * @returns New CCAviUrlMap object that has not been inserted
    */
    private static CC_Avi_URL_Map__c createUrlMap(String requestUrl, String realUrl, String theStorefront) {
        ccrz.CC_CallContext.storefront = theStorefront;
        return new CC_Avi_URL_Map__c(
            request_url__c = requestUrl,
            real_url__c = realUrl,
            Storefront__c = theStorefront
        );
    }

    @isTest
    public static void test_mapRequestUrlSlashes() {
        CC_Avi_URL_Map__c urlMap = createUrlMap('/automotive/ccrz__ccpage', '/ccrz__ccpage?pagekey=ds-content&contentkey=automotive', STOREFRONT);
        insert urlMap;

        Test.startTest();

        CCAviSiteURLRewriter urlRewriter = new CCAviSiteURLRewriter();
        
        PageReference result = urlRewriter.mapRequestUrl(new PageReference('/automotive/ccrz__ccpage?isCSRFlow=true&portalUser=&store=one'));

        Test.stopTest();

        System.debug(' RESULT URL IS ' + result.getUrl());

        System.assert(result.getUrl().equals('/ccrz__ccpage?contentkey=automotive&pagekey=ds-content'));
    }
}