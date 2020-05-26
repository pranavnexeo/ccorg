@isTest
private class cc_imp_mn_ctrl_MyAccountTest 
{

	@isTest static void test_viewCreditSuccess() 
	{
		List <cc_imp_StorefrontSettings__c> customSettingLists = cc_imp_testUtils.createNexeoCustomSettingList();

	   insert customSettingLists ;


	   Map <String, String> headerMap = new Map<String, String> ();
	   headerMap.put('Content-Type','application/json');

       Test.setMock(HttpCalloutMock.class, new cc_imp_mn_ViewCreditMockHttpResponse(200,'success',mockCreditData(), headerMap));

       Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.MYNEXEO_USER_COMMUNITY_PROFILE];

		ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
		insert userAccountGroup;
Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
		Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
		insert userAccount;

		Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
		insert userContact;

		User user = cc_imp_testUtils.createUser(userProfile, userContact, 
			'username@email.com', 'contact@email.com', 'firstName', 'lastName', 'alias');

       Test.startTest();

       cc_imp_testUtils.clearContext();

	   ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_MYNEXEO_STOREFRONT;
	   ccrz.cc_CallContext.currAccountId = userAccount.Id;

       ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();

	   ccrz.cc_RemoteActionResult res  = cc_imp_mn_ctrl_MyAccount.fetchCreditHistory(ctx);

	   System.assert(res != null);
	   //System.assertEquals(res.success,true);
	   System.assert(res.data != null);

	   Test.stopTest();

	}


	private static String mockCreditData()
	{
		String mockData = '[{"customer": "0000102483", "cust_name": "ENGINEERED MATERIALS SYSTEMS/ DELAWARE OH  43015 USA", "company": "1000", "company_name": "Nexeo Solutions LLC", "salesorg": "1000", "distr_chan": "30", "division": "31", "amt_open": "0.00 ", "amt_0to5": "0.00 ", "amt_6to15": "0.00 ", "amt_16to30": "0.00 ", "amt_31to60": "0.00 ", "amt_over60": "90061.53 ", "amt_total": "90061.53 ", "currency_key": "USD", "payment_terms": "Z045"}]';
       
       return mockData;
	}


	private static void clearContext()
	{
	   ccrz.cc_CallContext.currAccountId = null;
	   ccrz.cc_CallContext.storefront = null;
	}
	
}