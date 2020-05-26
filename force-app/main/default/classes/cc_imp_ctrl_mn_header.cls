/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        11/06/2017
*    Author:             Francisco Garcia
*   Last Modified:       
*   Last Modified By:    
*
*   Short Description:  Language Switcher controller.
*   **********************************************************************************************************************/

global with sharing class cc_imp_ctrl_mn_header {
    
    public static Boolean isESUser { get; private set;}
    public Boolean loginAsExternalUser { get; private set;}
    public String emailField { get; private set;}
    public String passwordField { get; private set;}    
    
 public cc_imp_ctrl_mn_header(){
     String loginType = '';
     loginAsExternalUser = false;
	 Map<String, String> UrlParameterMap = ApexPages.currentPage().getParameters();
     if (UrlParameterMap.containsKey('logintype')){ 
         loginType = UrlParameterMap.get('logintype');
         if (loginType.contains('external')) {
             emailField = ApexPages.currentPage().getParameters().get('username');
             passwordField = ApexPages.currentPage().getParameters().get('password');
             if (String.isNotEmpty(emailField) && String.isNotEmpty(passwordField)) {
					loginAsExternalUser = true;			
             }
     	 }
     }	     
     isESUser();
   }
     @RemoteAction
    global static void updateLocale(String locale) {     
        String userLocale = ccrz.cc_CallContext.userLocale;
        String userID    = ccrz.cc_CallContext.currUserId;  
        //String cclclParam = ApexPages.currentPage().getParameters().get('cclcl');
        String cclclParam = locale;
        System.debug('FGG User Locale '+userLocale);
        System.debug('FGG cclcl Param '+cclclparam);
        if(cclclParam!=null) {
            if(userLocale!=cclclParam){
              // updateLocale(userID,cclclParam);
               User u=[select id,LocaleSidKey from user where id=:userID];
                  u.LocaleSidKey=cclclParam;
                  update u;
            } 
        }              
        System.debug('FGG Got to the remote Action!!');
    }
    
        // In order to set the cookie
    global static void isESUser() {    
        System.debug('ccrz.cc_CallContext.effAccountId ' + ccrz.cc_CallContext.effAccountId);
        System.debug('ccrz.cc_CallContext.currAccount.Id ' + ccrz.cc_CallContext.currAccount.Id);
        try {
        Account a = cc_imp_dao_Account.queryAccountByAccountId(ccrz.cc_CallContext.effAccountId);     
        Boolean isES = false;
        if(a.SAP_DivisionCode__c != null){
            if(a.SAP_DivisionCode__c == '34') {
              isES = true;  
            }
        }
        isESUser = isES;     
        // setting a session cookie
        Cookie isESUser = new Cookie('isESUser', String.valueOf(isES), '/mynexeo' , -1, true);
        ApexPages.currentPage().setCookies(new Cookie[]{isESUser}); 
        } catch (Exception e) {
            
        }
    }
}