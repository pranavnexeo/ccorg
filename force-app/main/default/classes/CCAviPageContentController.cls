global with sharing class CCAviPageContentController {

    public String contentURL {get; set;}
    public String contentType {get; set;}
    public String contentHeight {get; set;}
    public String content {get; set;}
    public List<String> cssUrls {get; set;}
    public String body { get; set;}

    public CCAviPageContentController() {
        String key = ApexPages.currentPage().getParameters().get('contentKey');

        try {
            List<CC_Avi_Page_Content__c> pageContents = getPageContents(key, ccrz.cc_CallContext.storefront);

            if (!pageContents.isEmpty()) {
                cssUrls = new List<String>();
                String cssUrlsString = pageContents[0].CSS_Urls__c;
                 System.debug('URL STRING = ' + cssUrlsString);
                if(cssUrlsString != null){
                    cssUrls = cssUrlsString.split(',');
                }                

                String locale=ccrz.cc_CallContext.userLocale;
                List<CC_Avi_Page_ContentI18N__c> translatedlist = getTranslatedContent(pageContents[0].Id,locale);
                if (translatedlist!=null && translatedlist.size()>0){ 
                    if(translatedList[0].ContentURL__c != null ){
                        //if they provided a content url in the i18n object, then we don't check the body.
                        this.contentURL = translatedlist[0].ContentURL__c;
                    }else{
                        // no content url provided check if there is body content
                        this.body = translatedlist[0].ContentBody__c;

                    }
                    
                }else{
                    //there is no translation.  Use the default version
                    if(pageContents[0].ContentURL__c != null )
                        this.contentURL = pageContents[0].ContentURL__c;
                    else{
                        this.body = pageContents[0].ContentBody__c;
                    }

                }
                this.contentHeight = pageContents[0].ContentHeight__c;
                this.contentType = pageContents[0].ContentType__c;
                if( this.contentURL != null ){
                        if (pageContents[0].ContentType__c == 'FRAGMENT') {
                            this.content = getContent(this.contentURL);
                        }
                        if (pageContents[0].ContentType__c == 'WP-JSON') {
                            String jsonContent = getContent(this.contentURL);
                            if(jsonContent!=null && jsonContent.length()>0) {
                                Map<String, Object> root = (Map<String, Object>)JSON.deserializeUntyped(jsonContent);
                                Map<String, Object> content = (Map<String, Object>)root.get('content');
                                this.content = (String)content.get('rendered');
                            }
                        }

                }else{
                    this.content = this.body;
                }

            }

        }

        catch (Exception ex) {
            System.debug(System.LoggingLevel.Error, ex.getMessage());
        }
    }

    private static List<CC_Avi_Page_Content__c> getPageContents(String key, String storefront) {
        List<CC_Avi_Page_Content__c> pageContents = [
            SELECT
                ContentURL__c, ContentBody__c, ContentHeight__c, ContentType__c,CSS_Urls__c
            FROM
                CC_Avi_Page_Content__c
            WHERE
                ContentKey__c = :key AND Storefront__c INCLUDES (:storefront)
        ];
        return pageContents;
    }
    
     
    private static List<CC_Avi_Page_ContentI18n__c> getTranslatedContent(Id masterid, String locale){
       List<CC_Avi_Page_ContentI18n__c> pageContents = [
            SELECT
                ContentURL__c, ContentBody__c
            FROM
                CC_Avi_Page_ContentI18n__c
            WHERE
                Locale__c = :locale AND CC_Avi_Page_Content__c = :masterid
        ];
        return pageContents;
       }

    private static String getContent(String url) {
        String content = null;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
        HTTPResponse res = new Http().send(req);
        if (res.getStatusCode() == 200) {
            content = res.getBody();
        }
        return content;
    }   
}