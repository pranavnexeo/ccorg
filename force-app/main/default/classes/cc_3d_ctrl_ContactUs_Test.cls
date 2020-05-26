/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        07/24/2018
*    Author:             Ignacio Gonzalez
*   Last Modified:       
*   Last Modified By:    
*
*   Short Description:  Unit test for Controller cc_3d_ctrl_ContactUs
*   
*   
*	
*   **********************************************************************************************************************/
@IsTest
public class cc_3d_ctrl_ContactUs_Test {
    
    @IsTest
    public static void sendEmail() {
 
        List<cc_imp_StorefrontSettings__c>  listSettings = cc_imp_testUtils.createNexeoCustomSettingList();
        insert listSettings;
        String userName = 'userNameToTest';
        String userEmail = 'emailTest@test.com';
        String userPhone = '23456';
        String userCountry = 'US';
        String userComment = 'Comments';
        Boolean result = cc_3d_ctrl_ContactUs.sendEmail(userName, userEmail, userPhone, userCountry, userComment);
        System.assertEquals(true, result);
    }

}