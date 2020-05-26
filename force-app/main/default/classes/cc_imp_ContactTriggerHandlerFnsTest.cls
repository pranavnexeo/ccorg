@isTest
private class cc_imp_ContactTriggerHandlerFnsTest {
	
	@isTest static void test_processNexeo3DContactUpdates() {
		//List<cc_imp_StorefrontSettings__c> setList = cc_imp_testUtils.createNexeoCustomSettingList();
		//insert setList;

		// Create Account, Contact (as admin), User
		User u;
        Contact c;
        Set<Id> contactIds ;
		Map<String, SObject> dataMap = cc_imp_testUtils.initData();
		Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc62325765@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123567500223', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
          system.runAs(nexeoIntegrationUser)
        {
		 u = (User)dataMap.get('portalUser');

		cc_imp_StorefrontSettings__C storefrontSettings =  cc_imp_StorefrontSettings__C.getInstance('nexeo3d');
		Profile profile = [SELECT Id, name from Profile where Id = :u.ProfileId];
		//storefrontSettings.Profile_Name__c = profile.Name;
		//update storefrontSettings;

		Account a = (Account)dataMap.get('userAccount');
		a.ccrz__CustomField1__c = 'true';
		update a;
		 c = (Contact)dataMap.get('userContact');
		contactIds = new Set<Id>{c.Id};
        }

		System.runAs(u){
			//cc_imp_ContactTriggerHandlerFunctions.processNexeo3DContactBeforeUpdates(new List<Contact>{c});
			//cc_imp_ContactTriggerHandlerFunctions.processNexeo3DContactUpdates(contactIds);
		}
		// System.assertEquals('testVat', newAccounts[0].VAT_Number__c);

	}	
	

	@isTest static void test_processMyNexeoContactUpdates() {

		// Create Account, Contact (as admin), User
		User u;
        Contact c;
        Set<Id> contactIds ;
		Map<String, SObject> dataMap = cc_imp_testUtils.initData();
		Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='s43bhdc62325765@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A13423567500223', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
          system.runAs(nexeoIntegrationUser)
        {
		cc_imp_StorefrontSettings__c setList = cc_imp_testUtils.createMyNexeoCustomSetting();
		insert setList;
		u = (User)dataMap.get('portalUser');

		cc_imp_StorefrontSettings__C storefrontSettings =  cc_imp_StorefrontSettings__C.getInstance('mynexeo');
		Profile profile = [SELECT Id, name from Profile where Id = :u.ProfileId];
		storefrontSettings.Profile_Name__c = profile.Name;
		storefrontSettings.DefaultPrimarySellerUserId__c = u.Username; // the userName, not the Id

		update storefrontSettings;

		Account a = (Account)dataMap.get('userAccount');
		a.ccrz__CustomField1__c = '12345';
		a.ccrz__CustomField2__c = '100.00';
		update a;
		 c = (Contact)dataMap.get('userContact');
		contactIds = new Set<Id>{c.Id};
            }

		System.runAs(u){
			//cc_imp_ContactTriggerHandlerFunctions.processMyNexeoContactBeforeUpdates(new List<Contact>{c});
			//cc_imp_ContactTriggerHandlerFunctions.processMyNexeoContactUpdates(contactIds);
		}
		// System.assertEquals('testVat', newAccounts[0].VAT_Number__c);

	}



}