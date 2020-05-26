/**
* URL Rewriter
*
* Utilizes Platform Org Cache to minimize querying for URL
* Map records.
*
* NOTE: The local cache partition must be provisioned in the Salesforce Org.
*
* Potential Features to add:
* - Custom setting for cache partition values
* - Custom setting trigger to use/not use cache
*
*/

global with sharing class CCAviSiteURLRewriter implements Site.UrlRewriter {

    /**
    * Org Cache Settings
    */
    
    @TestVisible private final String ORG_CACHE_NAMESPACE = 'local'; // GlobalAVI partition Must be provisioned in the org
    @TestVisible private final String ORG_CACHE_PARTITION = 'GlobalAVI';
    @TestVisible private final String ORG_CACHE_KEY_POSTFIX = 'urlRewriteMapping';
    private final Integer ONE_HOUR = 3600;

    /**
    * CloudCraze Page Names and ID's
    */
    global static final String CCRZ_NAMESPACE = 'ccrz__';
    global static final String CCRZ_CATEGORIES ='Products?';
    global static final String CATEGORY_ID ='categoryId='; // Used for Categories reference
    global static final String CCRZ_PRODUCTDETAILS ='ProductDetails?';
    global static final String SKU_ID ='sku='; // Used for Product Details reference
    
    /**
    * Specific Request URLs to Map.
    * These are one off cases to handle since they use entity references in the request.
    */
    @TestVisible global static final String CATEGORIES ='/Categories/';
    @TestVisible global static final String PRODUCT_DETAILS ='/ProductDetails/';

    /**
    * Map request URL to real URL
    *
    * @param siteUrl The requested Site URL
    * @returns The PageReference to send the user to
    */
    global PageReference mapRequestUrl(PageReference siteUrl) {
        String url = siteUrl.getUrl();
        System.debug('SITE URL');

        System.debug('--- mapRequestUrl: url=' + url);
        //remove any arguments passed in with the URL
        if(url.indexOf('?') > 0 ){
            String urlWithoutArgs = url.substring(0,url.indexOf('?'));
            url = urlWithoutArgs;
        }
                
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'P:testURLMap', url);

        if(url.startsWith(CATEGORIES)) {
            String categoryID = url.substring(url.indexOf(CATEGORIES) + CATEGORIES.length(), url.length());
            System.debug('--- mapRequestUrl: categoryID=' + categoryID);
                
            return new PageReference(CCRZ_NAMESPACE+CCRZ_CATEGORIES+CATEGORY_ID+ categoryId);       
        }
        
        if(url.startsWith(PRODUCT_DETAILS)) {
            String sku = url.substring(url.indexOf(PRODUCT_DETAILS) + PRODUCT_DETAILS.length(), url.length());
            System.debug('--- mapRequestUrl: sku=' + sku);

            return new PageReference(CCRZ_NAMESPACE+CCRZ_PRODUCTDETAILS+SKU_ID+ sku);
        }

        /*
        * AVI Implementation
        */
        String requestUrlValue = url;
        
        // Get relevant URL mappings
        Map<String, String> urlMappings = getURLMapping();

        System.debug(' @@ urlMappings: ');
        System.debug(urlMappings);

        //if (urlMappings.containsKey(requestUrlValue)) {
        if (urlMappings.get(requestUrlValue)!=null) {

            String realUrl = urlMappings.get(requestUrlValue);

            return new PageReference(realUrl);
        }
        
        return null; // Redirect to HomePage rather than a 404/Not Found page?
    }

    /**
    * Generate URLs
    *
    * @param CCUrls Page references to generate URLs for?
    * @returns List of PageReferences with their URLs
    */
    global List<PageReference> generateUrlFor(List<PageReference> CCUrls) {
        return CCUrls;
    }

    /**
    * Get URL Map from Mapping Records.
    *
    * Leverages Salesforce Org Cache
    *
    * @returns Map <Request Url => Real URL>
    */
    @TestVisible
    private Map<String, String> getURLMapping() {

        String storefront = ccrz.CC_CallContext.storefront;


        final String CACHE_KEY = getCacheKey(storefront);


        Map<String, String> cacheValue = getFromCache(CACHE_KEY);
        if (cacheValue != NULL) {
            return cacheValue;
        }

        // No value cached. Get new mapping and add to cache.
        List<CC_Avi_URL_Map__c> urlMapRecordList = getURLMapRecords(storefront);
        
        Map<String, String> resultMap = new Map<String, String>();

        for (Integer i=0; i < urlMapRecordList.size(); i++) {
            CC_Avi_URL_Map__c item = urlMapRecordList.get(i);
            resultMap.put(item.Request_Url__c, item.Real_Url__c);
        }

        addToCache(CACHE_KEY, resultMap);

        return resultMap;
    }

    /**
    * Add value to cache
    *
    * @param key - Key that the data will be stored at
    * @param mapping - Mapping to be stored along with the key
    */
    @TestVisible
    private void addToCache(String key, Map<String, String> mapping) {
        try {
        	Cache.org.put(key, mapping, ONE_HOUR);
        }
        catch(Exception e){
            // no-op - the cache isn't configured, but this is not catastrophic
        }
    }

    /**
    * Get value from cache
    *
    * @param key - Key to retrieve from Cache
    * @returns The value retrieved from Cache or Null if none exists
    */
    @TestVisible
    private Map<String, String> getFromCache(String key) {
        try {
        	return (Map<String, String>) Cache.Org.get(key); // Can a null object be casted? NPE?
        }
        catch(Exception e){
            // no-op - the cache isn't configured, but this is not catastrophic
        }
        return null;
    }

    /**
    * Get unique Cache key for a provided storefront
    *
    * @param storefront - Storefront string to use in generating the cache key
    * @returns String - The resulting cache key to use
    */
    @TestVisible
    private String getCacheKey(String storefront) {
        return  ORG_CACHE_NAMESPACE + '.' + 
                ORG_CACHE_PARTITION + '.' + 
                cleanString(storefront) + ORG_CACHE_KEY_POSTFIX;
    }

    /**
    * Clean a provided string
    *
    * The idea is that any resulting string will
    * not be able to break the Cache functionality.
    *
    * @param value - String value to clean
    * @returns - Cleansed string value
    */
    @TestVisible
    private String cleanString(String value) {
        return value.trim().toLowerCase();
    }

    /**
    * Get URL Map Records for the provided storefront
    *
    * @param storefront The storefront to get the URL Map Records for
    * @returns List of CCAviUrlMap__c records for this storefront
    */
    @TestVisible
    private List<CC_Avi_URL_Map__c> getURLMapRecords(String storefront) {
        List<CC_Avi_URL_Map__c> urlMapList = [
            Select
                  Id
                , Name
                , Request_Url__c
                , Real_Url__c
            From
                CC_Avi_URL_Map__c
            Where
                Storefront__c = :storefront            
        ];

        return urlMapList;
    }

}