public with sharing class Email_Service_Functions {

    public static String getEmailServiceAddress(String serviceName) {
    	String emailAddress = null;
        List<EmailServicesAddress> elist = [select LocalPart, EmailDomainName 
                                              from EmailServicesAddress 
                                             where IsActive = true
                                               and Function.IsActive = true 
                                               and Function.FunctionName = :serviceName];
        if (!elist.isEmpty()) {
        	EmailServicesAddress e = elist[0];
        	emailAddress = e.LocalPart + '@' + e.EmailDomainName;
        }
        return emailAddress;
    }
    
    public static Id getEmailTemplateId(String templateName) {
    	Id templateId = null;
    	List<EmailTemplate> tlist = [select Id
    	                               from EmailTemplate
    	                              where IsActive = true
    	                                and DeveloperName = :templateName];
    	if (!tlist.isEmpty()) {
    		templateId = tlist[0].Id;
    	}
    	return templateId;
    }
    
    static TestMethod void testMe() {
    	System.debug(getEmailServiceAddress('Label_Request_Email_Service'));
        System.debug(getEmailTemplateId('AlmatekLabelRequest'));
    }
}