@isTest
private class cc_imp_util_StorefrontTest {
	
	@isTest static void test_getSettingsForStorefront() {
		String storefrontName = 'sfname';
		CC_Settings__c settings = new CC_Settings__c();
		settings.Name = storefrontName;
		insert settings;

		CC_Settings__c retrievedSettings = cc_imp_util_Storefront.getSettingsForStorefront(storefrontName);
		System.assertEquals(settings.Name, retrievedSettings.Name);
	}

	@isTest static void test_getSettingsForStorefront_NullStorefront() {
		String storefrontName = null;

		CC_Settings__c retrievedSettings = cc_imp_util_Storefront.getSettingsForStorefront(storefrontName);
		System.assertEquals(null, retrievedSettings);
	}

	@isTest static void test_getRecordTypeIdByNameAndSObjectType() {
		RecordType rt = [
			SELECT
				Id
				, Name
				, DeveloperName
				, SObjectType
			FROM
				RecordType
			WHERE
				IsActive = TRUE
			LIMIT
				1
		];

		Id rtId = cc_imp_util_Storefront.getRecordTypeIdByNameAndSObjectType(rt.DeveloperName, rt.SObjectType);

		System.assertEquals(rt.Id, rtId);
	}
	
}