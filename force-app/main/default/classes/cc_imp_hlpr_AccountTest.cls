@isTest

private class cc_imp_hlpr_AccountTest {

	@isTest 
	static void test_accountLookup() {

	   Test.startTest();

	   List <cc_imp_StorefrontSettings__c > storeFrontSettingsList	= cc_imp_testUtils.createNexeoCustomSettingList();

	   insert storeFrontSettingsList ;
       List<String> orderIds = new List <String>();
		Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.MYNEXEO_USER_COMMUNITY_PROFILE];

		ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
		insert userAccountGroup;

		Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
		insert userAccount;

		Map<Id, Account> accountMap = cc_imp_hlpr_Account.queryAccessibleAccountsById(userAccount.Id);

		System.assertEquals(1,accountMap.size());
	}


	@isTest 
	static void test_accountForRepricingLookup() {
	   Test.startTest();

	   List <cc_imp_StorefrontSettings__c > storeFrontSettingsList	= cc_imp_testUtils.createNexeoCustomSettingList();

	   insert storeFrontSettingsList ;
       List<String> orderIds = new List <String>();
	
        Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.MYNEXEO_USER_COMMUNITY_PROFILE];
Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
		ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
		insert userAccountGroup;

		Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
		insert userAccount;

		List<Id> inputIds = new List<Id>();
		inputIds.add(userAccount.Id);

		List<Account> accountList = cc_imp_hlpr_Account.lookupAccountsForRepricing(inputIds);

		System.assertEquals(1,accountList.size());


	}

		@isTest 
	static void test_updateAccountRepricingRefreshed() {
	   Test.startTest();

	   List <cc_imp_StorefrontSettings__c > storeFrontSettingsList	= cc_imp_testUtils.createNexeoCustomSettingList();
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
        
        ccrz__E_PriceList__c priceList = cc_imp_testUtils.createPriceList('General', cc_imp_testUtils.DEFAULT_STOREFRONT);
        insert priceList;

        ccrz__E_AccountGroupPriceList__c agrpPriceList =  cc_imp_testUtils.createAccountGroupPriceList(userAccountGroup, priceList);
        insert agrpPriceList;
        
        userAccount.cc_imp_MyProductList__c = priceList.Id;
        update userAccount;

		List<Id> inputIds = new List<Id>();
		inputIds.add(userAccount.Id);
	
        List<Id> accountIds = new List<Id>();
        accountIds.add(userAccount.Id);
		cc_imp_hlpr_Account.updateAccountRepricingRefreshed(accountIds);

		List<Account> accountList = cc_imp_hlpr_Account.lookupAccountsForRepricing(inputIds);

		if(accountList != null && accountList.size() == 0){
			Account act = accountList.get(0);

			System.assert(act.Pricing_Last_Refreshed__c != null && System.now()>=act.Pricing_Last_Refreshed__c);
		}


	}

	

}