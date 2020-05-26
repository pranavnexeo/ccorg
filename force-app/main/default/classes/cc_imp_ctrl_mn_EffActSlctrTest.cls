@isTest

private class cc_imp_ctrl_mn_EffActSlctrTest {

    @isTest 
    static void test_checkPricingStatus() {

        Test.startTest();

        List <cc_imp_StorefrontSettings__c > storeFrontSettingsList = cc_imp_testUtils.createNexeoCustomSettingList();

        insert storeFrontSettingsList ;
        List<String> orderIds = new List <String>();

        Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.MYNEXEO_USER_COMMUNITY_PROFILE];

        ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
        insert userAccountGroup;
		Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
  
        Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
        insert userAccount;
        userAccount.SAP_Sold_To_Account_Id__c = userAccount.Id;
        update userAccount;

        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();

        cc_imp_testUtils.clearContext();

        ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_MYNEXEO_STOREFRONT;
        ccrz.cc_CallContext.currAccountId = userAccount.Id;
        ccrz.cc_CallContext.currAccount = userAccount;


        
        CC_SFDC_Settings__c cusSetting=CC_SFDC_Settings__c.getInstance('CPI_MyNexeo');
		if(cusSetting == null){
            cusSetting = new CC_SFDC_Settings__c(Name = 'CPI_MyNexeo', Pricing_Refresh_time__c=2);
			insert cusSetting;

        }



        ccrz.cc_RemoteActionResult res = cc_imp_ctrl_mn_EffectiveAccountSelector.checkPricingStatus(ctx);
        List<Id> accIds = new List<Id>();
		accIds.add(userAccount.id);
		cc_imp_ctrl_mn_EffectiveAccountSelector.updatePricingForAccount(accIds);



        System.assert(res != null);
        //System.assertEquals(res.success,false);

		 

       Test.stopTest(); 

    }

    @isTest 
    static void test_checkPricingStatusWithEAParam() {


        List <cc_imp_StorefrontSettings__c > storeFrontSettingsList = cc_imp_testUtils.createNexeoCustomSettingList();

        insert storeFrontSettingsList ;
        List<String> orderIds = new List <String>();

        Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.MYNEXEO_USER_COMMUNITY_PROFILE];

        ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
        insert userAccountGroup;
		Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        
        Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
        insert userAccount;

        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();

        cc_imp_testUtils.clearContext();

        ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_MYNEXEO_STOREFRONT;
        ccrz.cc_CallContext.currAccountId = userAccount.Id;
        ccrz.cc_CallContext.currAccount = userAccount;



        PageReference pageRef = new PageReference('/');
        pageRef.getParameters().put('effectiveAccount', userAccount.Id);
        Test.setCurrentPage(pageRef);

        ccrz.cc_RemoteActionResult res;
        Test.startTest();
        res = cc_imp_ctrl_mn_EffectiveAccountSelector.checkPricingStatus(ctx);
        Test.stopTest();


        System.assert(res != null);
        //System.assertEquals(res.success,false);

    }

    @isTest 
    static void test_shouldDisplayEffectiveAccountDialog() {

         

        
        Map<String, SObject> settings = cc_imp_testUtils.initData();
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc4535@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A12456563002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
          system.runAs(nexeoIntegrationUser)
        {
                    List <cc_imp_StorefrontSettings__c > storeFrontSettingsList = cc_imp_testUtils.createNexeoCustomSettingList();
        insert storeFrontSettingsList ;
        Account a = (Account) settings.get('userAccount');

        PageReference pageRef = new PageReference('/');
        

        pageRef.getParameters().put('effectiveAccount', a.Id);
        Test.setCurrentPage(pageRef);
        Test.startTest();
        cc_imp_ctrl_mn_EffectiveAccountSelector ctrl = new cc_imp_ctrl_mn_EffectiveAccountSelector();
        System.assert(! ctrl.showEffAccountSelector);
        Test.stopTest();
        }

    }

    @isTest
    static void test_checkPricingStatusWithException() {


        List <cc_imp_StorefrontSettings__c > storeFrontSettingsList = cc_imp_testUtils.createNexeoCustomSettingList();

		Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;

        insert storeFrontSettingsList ;
        List<String> orderIds = new List <String>();

        Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.MYNEXEO_USER_COMMUNITY_PROFILE];

        ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
        insert userAccountGroup;
		
        Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
        insert userAccount;

        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();

        cc_imp_testUtils.clearContext();

        // ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_MYNEXEO_STOREFRONT;
        ccrz.cc_CallContext.currAccountId = userAccount.Id;
        //ccrz.cc_CallContext.currAccount = userAccount;



        // PageReference pageRef = new PageReference('/');
        // pageRef.getParameters().put('effectiveAccount', userAccount.Id);
        // Test.setCurrentPage(pageRef);

        ccrz.cc_RemoteActionResult res;
        Test.startTest();
        res = cc_imp_ctrl_mn_EffectiveAccountSelector.checkPricingStatus(ctx);
        Test.stopTest();


        System.assert(res != null);
        //System.assertEquals(res.success,false);

    }

    @isTest
    static void test_usedByCloudCrazeCheckbox(){
        

        Map<String, SObject> settings = cc_imp_testUtils.initData();
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sb3wrerhdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A134523002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        system.runAs(nexeoIntegrationUser)
        {
            List <cc_imp_StorefrontSettings__c > storeFrontSettingsList = cc_imp_testUtils.createNexeoCustomSettingList();

        insert storeFrontSettingsList ;
        List<String> orderIds = new List <String>();
        Account userAccount = (Account) settings.get('userAccount');
        userAccount.ccrz__UsedByCloudcraze__c = true;
        update userAccount;
        Contact userContact = (Contact) settings.get('userContact');

        ccrz.cc_CallContext.currContact.Id = userContact.id;


        List<Account> childAccts = new List<Account>();
        Account secondAccount = new Account(Name='Child Account one', Parent_Account__c=userAccount.Id, ccrz__UsedByCloudcraze__c = true);
        childAccts.add(secondAccount);

        Account thirdAccount = new Account(Name='Child Account twwo', Parent_Account__c=userAccount.Id, ccrz__UsedByCloudcraze__c = false);
        childAccts.add(thirdAccount);

        Account fourthAccount = new Account(Name='Child Account three', Parent_Account__c=userAccount.Id, ccrz__UsedByCloudcraze__c = true);
        childAccts.add(fourthAccount);

        insert childAccts;

        cc_imp_ctrl_mn_EffectiveAccountSelector controller = new cc_imp_ctrl_mn_EffectiveAccountSelector();
        List<cc_imp_ctrl_mn_EffectiveAccountSelector.CustAccount> myaccounts = controller.accounts;

        System.assertEquals(3,myaccounts.size());
        }
    }


}