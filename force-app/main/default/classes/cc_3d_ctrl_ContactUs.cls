/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        07/19/2018
*    Author:             Ignacio Gonzalez
*   Last Modified:       
*   Last Modified By:    
*
*   Short Description:  Controller for Contact Us Nexeo 3D
*   
*   
*	
*   **********************************************************************************************************************/
global without sharing class cc_3d_ctrl_ContactUs {
    
   
    
    @RemoteAction
    global static boolean sendEmail(String userName, String userEmail, String userPhone, String userCountry, String userComment) {
        boolean isSuccesfully = false;
        //If all fields are not empty
        //validations over data has been performed on view
        //for userEmail Field
        if (String.isNotEmpty(userName) && String.isNotEmpty(userEmail) && String.isNotEmpty(userComment)) {
            if (userPhone == null || String.isEmpty(userPhone)) {
                userPhone =  '';
            }
            if (userCountry == null || String.isEmpty(userCountry)) {
                userCountry = '';
            }
            cc_imp_StorefrontSettings__c customSettings = cc_imp_StorefrontSettings__c.getInstance('nexeo3d');
                
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                
                
            String[] toAddresses = customSettings.Contact_Us_3D_Email__c.split(',');
            Map<Id, String> pageLabels = new Map<Id, String> ();
            for (ccrz__E_PageLabel__c pageLabel : [SELECT Id, ccrz__ValueRT__c FROM ccrz__E_PageLabel__c WHERE Id =:customSettings.Contact_Us_3D_Email_Body__c OR Id =:customSettings.Contact_Us_3D_Email_Subject__c]) {
                    pageLabels.put(pageLabel.Id, pageLabel.ccrz__ValueRT__c);
            }
            String body = pageLabels.get(customSettings.Contact_Us_3D_Email_Body__c);
            List<String> arguments = new List<String>();
			arguments.add(userName);
			arguments.add(userEmail);
			arguments.add(userPhone);
            arguments.add(userCountry);
            arguments.add(userComment);    
            // Building email
            email.setSubject(pageLabels.get(customSettings.Contact_Us_3D_Email_Subject__c));
            email.setToAddresses( toAddresses );

           
            email.setHtmlBody(String.format(body, arguments));
        
            // Send email
            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {email};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages); 
            isSuccesfully = results[0].isSuccess();

        }
        return isSuccesfully;
    }
}