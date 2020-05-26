@isTest
private class cc_imp_dao_AccountTest {
	
	@isTest
	static void test_queryAccountByAccountId(){
		SAP_Seller__c seller = new SAP_Seller__c();
		insert seller;



		List <cc_imp_StorefrontSettings__c > storeFrontSettingsList	= cc_imp_testUtils.createNexeoCustomSettingList();

	   insert storeFrontSettingsList ;

	   Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.MYNEXEO_USER_COMMUNITY_PROFILE];

		ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
		insert userAccountGroup;
		Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
		Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
		insert userAccount;

		Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
		insert userContact;

		User user = cc_imp_testUtils.createUser(userProfile, userContact, 
			'username@email.com', 'contact@email.com', 'firstName', 'lastName', 'alias');


		Account tsta = cc_imp_dao_Account.queryAccountByAccountId(userAccount.Id);
		System.assertEquals(userAccount.Id, tsta.Id);
			
	}
	
	@isTest
	static void test_getCSRForAccount(){
		SAP_Seller__c seller = new SAP_Seller__c();
		insert seller;


	   Profile csrProfile = [SELECT Id, name from Profile where Name = 'System Administrator'];

		User csr = new User(
			FirstName         = 'csr',
			LastName          = 'csr',
			Email             = 'cc_imp_csr@nexeo.com',
			Alias             = 'csr',
			Username          = 'cc_imp_csr@nexeo.com',
			LocaleSidKey      = 'en_US',
			TimeZoneSidKey    = 'GMT',
			ProfileID         = csrProfile.Id,
			LanguageLocaleKey = 'en_US',
			EmailEncodingKey  = 'UTF-8'
		);
		insert csr;

	   	Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.MYNEXEO_USER_COMMUNITY_PROFILE];

		List <cc_imp_StorefrontSettings__c > storeFrontSettingsList	= cc_imp_testUtils.createNexeoCustomSettingList();

	   	insert storeFrontSettingsList ;


		ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
		insert userAccountGroup;
		Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
		Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
		userAccount.ZC_Partner__c = seller.Id;
		insert userAccount;

		Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
		insert userContact;

		User user = cc_imp_testUtils.createUser(userProfile, userContact, 
			'username@email.com', 'contact@email.com', 'firstName', 'lastName', 'alias');

		Id tsta = cc_imp_dao_Account.getCSRForAccount(userAccount.Id);
		System.assertEquals(seller.Id, tsta);
			
	}

	@isTest
	static void test_queryAccessibleAccounts(){
		SAP_Seller__c seller = new SAP_Seller__c();
		insert seller;


	   Profile csrProfile = [SELECT Id, name from Profile where Name = 'System Administrator'];

		User csr = new User(
			FirstName         = 'csr',
			LastName          = 'csr',
			Email             = 'cc_imp_csr@nexeo.com',
			Alias             = 'csr',
			Username          = 'cc_imp_csr@nexeo.com',
			LocaleSidKey      = 'en_US',
			TimeZoneSidKey    = 'GMT',
			ProfileID         = csrProfile.Id,
			LanguageLocaleKey = 'en_US',
			EmailEncodingKey  = 'UTF-8'
		);
		insert csr;

	   	Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.MYNEXEO_USER_COMMUNITY_PROFILE];

		List <cc_imp_StorefrontSettings__c > storeFrontSettingsList	= cc_imp_testUtils.createNexeoCustomSettingList();

	   	insert storeFrontSettingsList ;

		Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
		ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
		insert userAccountGroup;

		Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
		userAccount.ZC_Partner__c = seller.Id;
		insert userAccount;

		Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
		insert userContact;

		User user = cc_imp_testUtils.createUser(userProfile, userContact, 
			'username@email.com', 'contact@email.com', 'firstName', 'lastName', 'alias');

		Map<Id, Account> actList = cc_imp_dao_Account.queryAccessibleAccounts();
		System.assertEquals(1, actList.size());
			
	}
	

	@isTest
	static void test_getAccountForViewCreditRequest(){
		SAP_Seller__c seller = new SAP_Seller__c();
		insert seller;


	   Profile csrProfile = [SELECT Id, name from Profile where Name = 'System Administrator'];

		User csr = new User(
			FirstName         = 'csr',
			LastName          = 'csr',
			Email             = 'cc_imp_csr@nexeo.com',
			Alias             = 'csr',
			Username          = 'cc_imp_csr@nexeo.com',
			LocaleSidKey      = 'en_US',
			TimeZoneSidKey    = 'GMT',
			ProfileID         = csrProfile.Id,
			LanguageLocaleKey = 'en_US',
			EmailEncodingKey  = 'UTF-8'
		);
		insert csr;

	   	Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.MYNEXEO_USER_COMMUNITY_PROFILE];

		List <cc_imp_StorefrontSettings__c > storeFrontSettingsList	= cc_imp_testUtils.createNexeoCustomSettingList();

	   	insert storeFrontSettingsList ;


		ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
		insert userAccountGroup;
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        Account payerAccount = cc_imp_testUtils.createAccount(userAccountGroup);
		payerAccount.ZC_Partner__c = seller.Id;
		insert payerAccount;

		Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
		userAccount.ZC_Partner__c = seller.Id;
        userAccount.SAP_Payer_Account_Id__c = string.valueof(payerAccount.id);
		insert userAccount;

		Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
		insert userContact;

		User user = cc_imp_testUtils.createUser(userProfile, userContact, 
			'username@email.com', 'contact@email.com', 'firstName', 'lastName', 'alias');

		Account act = cc_imp_dao_Account.getAccountForViewCreditRequest(userAccount.Id);
		System.assertEquals(payerAccount.Id, act.Id);
			
	}

	@isTest
	static void test_getShippingAddresses(){
		
		Map<String, Object> dataMap = cc_imp_testUtils.initData();
		Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbh3443dc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123433002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
          system.runAs(nexeoIntegrationUser)
        {
            List<cc_imp_StorefrontSettings__c> setList = cc_imp_testUtils.createNexeoCustomSettingList();
		insert setList;

		/*
		SAP_Seller__c seller = new SAP_Seller__c();
		insert seller;


	   Profile csrProfile = [SELECT Id, name from Profile where Name = 'System Administrator'];

		User csr = new User(
			FirstName         = 'csr',
			LastName          = 'csr',
			Email             = 'csr@nexeo.com',
			Alias             = 'csr',
			Username          = 'csr@nexeo.com',
			LocaleSidKey      = 'en_US',
			TimeZoneSidKey    = 'GMT',
			ProfileID         = csrProfile.Id,
			LanguageLocaleKey = 'en_US',
			EmailEncodingKey  = 'UTF-8'
		);
		insert csr;

	   	Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.MYNEXEO_USER_COMMUNITY_PROFILE];

		List <cc_imp_StorefrontSettings__c > storeFrontSettingsList	= cc_imp_testUtils.createNexeoCustomSettingList();

	   	insert storeFrontSettingsList ;


		ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
		insert userAccountGroup;

		Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
		userAccount.ZC_Partner__c = seller.Id;
		insert userAccount;

		Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
		insert userContact;

		User user = cc_imp_testUtils.createUser(userProfile, userContact, 
			'username@email.com', 'contact@email.com', 'firstName', 'lastName', 'alias');

		ccrz__E_ContactAddr__c addr = new ccrz__E_ContactAddr__c(
			ccrz__AddressFirstLine__c = 'first',
			ccrz__City__c = 'city',
			ccrz__StateISOCode__c = 'IL'
		);
		insert addr;


		ccrz__E_AccountAddressBook__c addrBk = new ccrz__E_AccountAddressBook__c(
			ccrz__Account__c = userAccount.Id
		);
		insert addrBk;
		*/

		Account act = (Account)dataMap.get('userAccount');

		// Map<Id, ccrz__E_AccountAddressBook__c> addrMap = cc_imp_dao_Account.getShippingAddresses(new Set<Id>{userAccount.Id});
		Map<Id, ccrz__E_AccountAddressBook__c> addrMap = cc_imp_dao_Account.getShippingAddresses(new Set<Id>{act.Id});
		System.assertEquals(1, addrMap.size());
        }
			
	}


}