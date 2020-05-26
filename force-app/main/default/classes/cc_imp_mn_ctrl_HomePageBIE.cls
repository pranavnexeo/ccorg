/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        2/1/2016
*    Author:             Francisco Garcia
*   Last Modified:       
*   Last Modified By: 
*	VF Component:		 cc_imp_mn_CheckProspectAccount
*	VF Page:			 cc_imp_mn_HomePageBIE			
*   Short Description:   Define if the current user of customer portal is a Prospect account if yes, display a Message.
*   **********************************************************************************************************************/

global without sharing class cc_imp_mn_ctrl_HomePageBIE {
    global String prospectMessage { get; set; }    
    global cc_imp_mn_ctrl_HomePageBIE(){
        
        User currentUser=ccrz.cc_CallContext.currUser;
        Id curUserId = ccrz.cc_CallContext.currUserId;
        
        System.debug('FGG'+curUserId);
        //prospectMessage='Test'+curUserId;
        
       // if(curUserId!=null && curUserId!='' && curUserId!='Undefined'){
        CC_SFDC_Settings__c cusSetting=CC_SFDC_Settings__c.getInstance('CPI_MyNexeo');
        
        if(currentUser.ProfileId!=cusSetting.GuestProfileId__c) {
        User curUser = [
            SELECT
                Contact.cc_imp_Is_MyNexeo_Admin__c              
                , Contact.Account.AccountNumber
                , Name
            FROM
                User
            WHERE
                Id = :curUserId
            LIMIT
                1
        ];
            
                if(curUser!=null){
        if(curUser.Contact.Account.AccountNumber.startsWith('P')){
      
          if(cusSetting!=null){
                    prospectMessage=cusSetting.prospectMessage__c;
            }
            
        }
        }
        }
      
    
        }
}