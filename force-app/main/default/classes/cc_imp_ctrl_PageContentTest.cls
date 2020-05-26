@isTest
private class cc_imp_ctrl_PageContentTest {
	private static final String TEST_STOREFRONT = 'teststore';

	@isTest static void test_fetch() {
		setupTestData();
		cc_imp_ctrl_ProductDetails ctrl = new cc_imp_ctrl_ProductDetails();

		ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
		ctx.storefront                  = TEST_STOREFRONT;

		ccrz.cc_RemoteActionResult res  = cc_imp_ctrl_PageContent.fetch(ctx, 'pc001');
		System.assert(res != null);
		System.assert(res.success);
		System.assert( ((Map<String,Object>) res.data).containsKey('contentBody'));

		res  = cc_imp_ctrl_PageContent.fetch(ctx, 'dne');
		System.assert(res != null);
		System.assert(!res.success);
	}

	private static void setupTestData() {
		List<cc_imp_PageContent__c> pageContents = new List<cc_imp_PageContent__c> {
			new cc_imp_PageContent__c(
				ContentKey__c    = 'pc001'
				, ContentBody__c = '<span>001</span>'
				, Storefront__c  = TEST_STOREFRONT
			),

			new cc_imp_PageContent__c(
				ContentKey__c    = 'pc002'
				, ContentBody__c = '<span>002</span>'
				, Storefront__c  = TEST_STOREFRONT
			),

			new cc_imp_PageContent__c(
				ContentKey__c    = 'pc003'
				, ContentBody__c = '<span>003</span>'
				, Storefront__c  = TEST_STOREFRONT
			)
		};

		insert pageContents;
	}
}