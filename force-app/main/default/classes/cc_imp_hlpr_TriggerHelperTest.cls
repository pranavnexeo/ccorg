@isTest

private class cc_imp_hlpr_TriggerHelperTest {

	@isTest static void test_trigger_helper_3d() {

		Test.startTest();
		List <cc_imp_StorefrontSettings__c > storeFrontSettingsList = cc_imp_testUtils.createNexeoCustomSettingList();
        insert storeFrontSettingsList ;

        Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.MYNEXEO_USER_COMMUNITY_PROFILE];

        ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
        insert userAccountGroup;
		Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        /*
        * Account
        */
        Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
        userAccount.ccrz__CustomField1__c = 'Test1';
        userAccount.ccrz__CustomField2__c = 'Test2';
        userAccount.VAT_Number__c = '100';
        insert userAccount;

        /*
        * Contact
        */
        Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
        userContact.signupNewsLetterFlag__c = true ;
        insert userContact;

		Set<Id> idSet = new Set<Id>();
		idSet.add(userContact.Id);

		cc_imp_hlpr_TriggerHelper triggerHelper = new cc_imp_hlpr_TriggerHelper( );

		List<Contact> contacts = cc_imp_hlpr_TriggerHelper.fetchContactAndAccountFieldsForNexeo3D(idSet );

		Contact testContact = contacts.get(0);

		System.assert(testContact.signupNewsLetterFlag__c );

		Test.stopTest();	


	}

		@isTest static void test_trigger_helper_Nexeo() {

		Test.startTest();
		List <cc_imp_StorefrontSettings__c > storeFrontSettingsList = cc_imp_testUtils.createNexeoCustomSettingList();
        insert storeFrontSettingsList ;

        Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.MYNEXEO_USER_COMMUNITY_PROFILE];

        ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
        insert userAccountGroup;
		Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        /*
        * Account
        */
        Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
        userAccount.ccrz__CustomField1__c = 'Test1';
        userAccount.ccrz__CustomField2__c = 'Test2';
        userAccount.VAT_Number__c = '100';
        insert userAccount;

        /*
        * Contact
        */
        Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
        userContact.signupNewsLetterFlag__c = true ;
        insert userContact;

		Set<Id> idSet = new Set<Id>();
		idSet.add(userContact.Id);

		cc_imp_hlpr_TriggerHelper triggerHelper = new cc_imp_hlpr_TriggerHelper( );

		List<Contact> contacts = cc_imp_hlpr_TriggerHelper.fetchContactAndAccountFieldsForMyNexeo(idSet );

		Contact testContact = contacts.get(0);

		System.assert(testContact.Account.ccrz__CustomField1__c == 'Test1' );

		Test.stopTest();	


	}

	

	@isTest static void test_trigger_helper_update() {

		Test.startTest();
		List <cc_imp_StorefrontSettings__c > storeFrontSettingsList = cc_imp_testUtils.createNexeoCustomSettingList();
        insert storeFrontSettingsList ;

        Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.MYNEXEO_USER_COMMUNITY_PROFILE];

        ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
        insert userAccountGroup;
		Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        /*
        * Account
        */
        Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
        userAccount.ccrz__CustomField1__c = 'Test1';
        userAccount.ccrz__CustomField2__c = 'Test2';
        userAccount.VAT_Number__c = '100';
        insert userAccount;

        /*
        * Contact
        */
        Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
        insert userContact;

        userContact.FirstName ='Randall';
        List<Contact> updateList = new List<Contact>();
        updateList.add(userContact);

        cc_imp_hlpr_TriggerHelper.updateContacts( updateList );

        Contact laterContact=[SELECT Id, FirstName from Contact where Id = :userContact.Id];

		System.assert(laterContact.FirstName=='Randall');

		Test.stopTest();	

	}


}