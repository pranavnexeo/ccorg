@isTest
private class cc_mn_api_ViewCreditTest {
	
	@isTest static void test_fetchViewCreditInfo_Exception() {
		cc_mn_json_ViewCreditResponse response = cc_mn_api_ViewCredit.fetchViewCreditInfo();
		System.assert(!response.success);

	}
	
}