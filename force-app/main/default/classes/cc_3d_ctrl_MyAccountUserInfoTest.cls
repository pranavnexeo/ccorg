@isTest
private class cc_3d_ctrl_MyAccountUserInfoTest { 

    @isTest static void test_getVatNumber3d() {

        Test.startTest();
        userRole ur = [SELECT id from userrole  where developername= 'NEXEOSOLUTIONSORG' limit 1];
        id ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123002', FirstName = 'Nexeo_Integration',UserRoleId = ur.Id);
        insert nexeoIntegrationUser;
         system.runAs(nexeoIntegrationUser)
        {
       List <cc_imp_StorefrontSettings__c > storeFrontSettingsList  = cc_imp_testUtils.createNexeoCustomSettingList();

       insert storeFrontSettingsList ;
       List<String> orderIds = new List <String>();

        Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.NEXEO3D_USER_COMMUNITY_PROFILE];

        ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
        insert userAccountGroup;

        Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
        userAccount.VAT_Number__c = '100';
        insert userAccount;


        Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
        insert userContact;

        User user = cc_imp_testUtils.createUser(userProfile, userContact, 
            'username@email.com', 'contact@email.com', 'firstName', 'lastName', 'alias');
        insert user;

        cc_imp_testUtils.clearContext();

        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();

        ccrz.cc_CallContext.currAccount = userAccount;

        ccrz.cc_RemoteActionResult res = cc_3d_ctrl_MyAccountUserInfo.getVatNumber(ctx);

        Map<String,Object> holder = (Map<String,Object>)res.data;

        String vatNumberResult = (String)holder.get('vatNumber');

        System.assert(res != null);
        System.assert(res.data != null);
        System.assertEquals(res.success,true);
        System.assert( vatNumberResult == '100');
    }
        Test.stopTest();    

    }

    @isTest 
    static void test_validateExceptionHandling_get() {
    
        Test.startTest();
       
        userRole ur = [SELECT id from userrole  where developername= 'NEXEOSOLUTIONSORG' limit 1];
id ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123002', FirstName = 'Nexeo_Integration',UserRoleId = ur.Id);
        insert nexeoIntegrationUser;
         system.runAs(nexeoIntegrationUser)
        {
       List <cc_imp_StorefrontSettings__c > storeFrontSettingsList  = cc_imp_testUtils.createNexeoCustomSettingList();

       insert storeFrontSettingsList ;
       List<String> orderIds = new List <String>();

        Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.NEXEO3D_USER_COMMUNITY_PROFILE];

        ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
        insert userAccountGroup;

        Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
        userAccount.VAT_Number__c = '123Error';
        insert userAccount;

        Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
        insert userContact;

        User user = cc_imp_testUtils.createUser(userProfile, userContact, 
        'username@email.com', 'contact@email.com', 'firstName', 'lastName', 'alias');
        insert user;

        cc_imp_testUtils.clearContext();

        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();

        ccrz.cc_CallContext.currAccount = userAccount;

        ccrz.cc_RemoteActionResult res = cc_3d_ctrl_MyAccountUserInfo.getVatNumber(ctx);

        System.assert(res != null);
        System.assert(res.data != null);
    }
        Test.stopTest();    


    }

    @isTest static void test_setVatNumber3d() {

        Test.startTest();
        userRole ur = [SELECT id from userrole  where developername= 'NEXEOSOLUTIONSORG' limit 1];
id ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123002', FirstName = 'Nexeo_Integration',UserRoleId = ur.Id);
        insert nexeoIntegrationUser;
        system.runAs(nexeoIntegrationUser)
        {
       List <cc_imp_StorefrontSettings__c > storeFrontSettingsList  = cc_imp_testUtils.createNexeoCustomSettingList();

       insert storeFrontSettingsList ;
       List<String> orderIds = new List <String>();

        Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.NEXEO3D_USER_COMMUNITY_PROFILE];

        ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
        insert userAccountGroup;

        Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
        userAccount.VAT_Number__c = '100';
        insert userAccount;

        Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
        insert userContact;

        User user = cc_imp_testUtils.createUser(userProfile, userContact, 
            'username@email.com', 'contact@email.com', 'firstName', 'lastName', 'alias');
        insert user;

        cc_imp_testUtils.clearContext();

        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();

        ccrz.cc_CallContext.currAccount = userAccount;

        ccrz.cc_RemoteActionResult res = cc_3d_ctrl_MyAccountUserInfo.setVatNumber(ctx, '99999');

        ccrz.cc_RemoteActionResult res2 = cc_3d_ctrl_MyAccountUserInfo.getVatNumber(ctx);



        Map<String,Object> holder = (Map<String,Object>)res2.data;

        String vatNumberResult = (String)holder.get('vatNumber');

        System.assert(res2 != null);
        System.assert(res2.data != null);
        System.assertEquals(res2.success,true);
        System.assert( vatNumberResult == '99999');
    }
        Test.stopTest();    

    }


    @isTest 
    static void test_validateExceptionHandling_set() {
    
        Test.startTest();
        userRole ur = [SELECT id from userrole  where developername= 'NEXEOSOLUTIONSORG' limit 1];
id ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123002', FirstName = 'Nexeo_Integration',UserRoleId = ur.Id);
        insert nexeoIntegrationUser;
        system.runAs(nexeoIntegrationUser)
        {
       List <cc_imp_StorefrontSettings__c > storeFrontSettingsList  = cc_imp_testUtils.createNexeoCustomSettingList();

       insert storeFrontSettingsList ;
       List<String> orderIds = new List <String>();

        Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.NEXEO3D_USER_COMMUNITY_PROFILE];

        ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
        insert userAccountGroup;

        Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
        userAccount.VAT_Number__c = '123Error';
        insert userAccount;

        Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
        insert userContact;

        User user = cc_imp_testUtils.createUser(userProfile, userContact, 
            'username@email.com', 'contact@email.com', 'firstName', 'lastName', 'alias');
        insert user;

        cc_imp_testUtils.clearContext();

        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        ccrz.cc_CallContext.currAccount = userAccount;

        ccrz.cc_RemoteActionResult res = cc_3d_ctrl_MyAccountUserInfo.setVatNumber(ctx,'99999');

        System.assert(res != null);
        System.assert(res.data != null);
        }
        Test.stopTest();    
        

    }

}