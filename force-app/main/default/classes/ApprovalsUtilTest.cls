/*
* Developed by Timba Software Corp. www.timbasoftware.com admin@timbasoftware.com
*/

/**
* Test Class to cover code from AccountEditController 
* @author Guillermo Lacordelle
*/ 

@isTest private class ApprovalsUtilTest

{

    public static testMethod void run()
    {
    User testSysAdminUser = new User(alias = 'standt', email='frodo@nexeosolutions.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileId = [select id from profile where name='System Administrator' LIMIT 1].Id, 
            timezonesidkey='America/Los_Angeles', username='ASstandarduser@testorg.com');
            
        insert testSysAdminUser;
        
        System.runAs(testSysAdminUser)
        {
        ApprovalsUtil.isTest = true;
        Map<String, String> params = ApexPages.currentPage().getHeaders();
        
        params.put('User-Agent', 'iPhone');
        ApprovalsUtil.getBrowserName();
        
        ApprovalsUtil.getGoogleMapsKey();
        
        params.put('User-Agent', 'Salesforce');
        ApprovalsUtil.getBrowserName();
        
        params.put('User-Agent', 'BlackBerry');
        ApprovalsUtil.getBrowserName();
        
        params.put('User-Agent', 'other');
        ApprovalsUtil.getBrowserName();
        
        ApprovalsUtil.getDomain();
        
        ApprovalsUtil.strValue('hello');
       // ApprovalsUtil.strValue(null);
        
        System.currentPageReference().getHeaders().put('Referer','http://www.google.com');
        boolean b = true;
        //boolean b = ApprovalsUtil.isCSRF(ApexPages.currentPage());
        
        try
        {
            ApprovalsUtil.doGetRequest('https://login.salesforce.com', null);
        }
        catch (Exception e)
        {
            System.debug(e.getMessage());
        }
        
        try
        {
            ApprovalsUtil.doGetRequest('https://login.salesforce.com', 'some_cookie_value=true;');
        }
        catch (Exception e)
        {
            System.debug(e.getMessage());
        }
        
        
        ApprovalsUtil.encode('String to encode');
        pagereference test;
        ApprovalsUtil.isCSRF(test);
        System.assert(ApprovalsUtil.getMatch('Hello world', 'w(.*)d', 1) == 'orl');
        
        System.assert(ApprovalsUtil.boundLower('This is a string', 'is') == ' is a string');
        
        System.assert(ApprovalsUtil.boundUpper('This is a string', 'a') == 'This is ');
        
        System.assert(ApprovalsUtil.bound('This is a string', 'a', 'ing') == ' str');
    }
    
}
}