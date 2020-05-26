@isTest
private class cc_mn_ctrl_MyAccountBIETest {
    
    @isTest static void test_isAdmin() {
        Map<String, SObject> dataMap = cc_imp_testUtils.initData();
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        system.runas(nexeoIntegrationUser)
        {
        List<cc_imp_StorefrontSettings__c> setList = cc_imp_testUtils.createNexeoCustomSettingList();
        insert setList;


        // Create Account, Contact (as admin), User
        
        Contact c = (Contact)dataMap.get('userContact');
        c.cc_imp_Is_MyNexeo_Admin__c = true;
        update c;

        // Query the user
        User u = (User)dataMap.get('portalUser');
        ccrz.cc_CallContext.currUserId = u.Id;
        cc_mn_ctrl_MyAccountBIE ctrl = new cc_mn_ctrl_MyAccountBIE();

        // Assert the user is an admin
        System.assert(ctrl.isAdmin);
        }
    }
    
    @isTest static void test_isNotAdmin() {
        Map<String, SObject> dataMap = cc_imp_testUtils.initData();
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        system.runas(nexeoIntegrationUser)
        {
        List<cc_imp_StorefrontSettings__c> setList = cc_imp_testUtils.createNexeoCustomSettingList();
        insert setList;

        // Create Account, Contact (as not admin), User
        
        Contact c = (Contact)dataMap.get('userContact');
        c.cc_imp_Is_MyNexeo_Admin__c = false;
        update c;

        // Query the user
        User u = (User)dataMap.get('portalUser');
        ccrz.cc_CallContext.currUserId = u.Id;
        cc_mn_ctrl_MyAccountBIE ctrl = new cc_mn_ctrl_MyAccountBIE();

        // Assert the user is not an admin
        System.assert(!ctrl.isAdmin);
        }
    }
    
}