@isTest
private class cc_imp_dao_UserTest {
	
	@isTest static void test_queryUserForContactId() {
		
		// Create Account, Contact (as admin), User
		Map<String, SObject> dataMap = cc_imp_testUtils.initData();
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdertc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123565002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
          system.runAs(nexeoIntegrationUser)
        {
            List<cc_imp_StorefrontSettings__c> setList = cc_imp_testUtils.createNexeoCustomSettingList();
		insert setList;

		Contact c = (Contact)dataMap.get('userContact');
		User u = (User)dataMap.get('portalUser');

		User foundUser = cc_imp_dao_User.queryUserForContactId(c.Id);
		System.assertEquals(u.Id, foundUser.Id);
        }
	}

	@isTest static void test_queryUserForUserId() {
		

		// Create Account, Contact (as admin), User
		Map<String, SObject> dataMap = cc_imp_testUtils.initData();
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhsdfddc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A12sdf3002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
          system.runAs(nexeoIntegrationUser)
        {
            List<cc_imp_StorefrontSettings__c> setList = cc_imp_testUtils.createNexeoCustomSettingList();
		insert setList;
		Contact c = (Contact)dataMap.get('userContact');
		User u = (User)dataMap.get('portalUser');

		User foundUser = cc_imp_dao_User.queryUserForUserId(u.Id);
		System.assertEquals(u.Id, foundUser.Id);
        }

	}

	@isTest static void test_queryUserForAccounts() {
		

		// Create Account, Contact (as admin), User
		Map<String, SObject> dataMap = cc_imp_testUtils.initData();
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhd456c@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A12464563002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
          system.runAs(nexeoIntegrationUser)
        {
            List<cc_imp_StorefrontSettings__c> setList = cc_imp_testUtils.createNexeoCustomSettingList();
		insert setList;
		Contact c = (Contact)dataMap.get('userContact');
		User u = (User)dataMap.get('portalUser');
		Account a = (Account)dataMap.get('userAccount');

		Map<Id, User> userMap = cc_imp_dao_User.queryUsersForAccounts(new Set<Id>{a.Id});
		System.assertEquals(1, userMap.values().size());
        }

	}
}