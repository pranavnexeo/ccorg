public with sharing class cc_mn_ctrl_MyAccountBIE {
	
    public Boolean isAdmin {get; private set;}
    public Boolean isES {get; private set;}
    
	public cc_mn_ctrl_MyAccountBIE() {
		User u = [SELECT Contact.cc_imp_Is_MyNexeo_Admin__c from User where Id = :ccrz.cc_CallContext.currUserId limit 1];
		isAdmin = u.Contact.cc_imp_Is_MyNexeo_Admin__c;
        
        Account a = cc_imp_dao_Account.queryAccountByAccountId(ccrz.cc_CallContext.effAccountId);        
        isES = False;
        if(a.SAP_DivisionCode__c!=null){
            if(a.SAP_DivisionCode__c=='34')
            {
              isES=True;  
            }
        }
	}
}