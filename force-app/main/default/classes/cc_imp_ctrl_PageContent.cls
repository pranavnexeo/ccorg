global with sharing class cc_imp_ctrl_PageContent {

	/**
	 *
	 * gets the Page Content specified by the Content Key and
	 * current User's storefront
	 *
	 * @param: ctx		   CloudCraze remote action context
	 * @param: contentKey	the Page Content key
	 * @return the Page Content Body
	 */
	@RemoteAction
	global static ccrz.cc_RemoteActionResult fetch(ccrz.cc_RemoteActionContext ctx, String contentKey) {
		ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
		res.success					= false;
		res.inputContext			   = ctx;

		final Map<String,Object> data = new Map<String,Object>();
		try {
			ccrz.cc_CallContext.initRemoteContext(ctx);
			List<cc_imp_PageContent__c> pageContents = [SELECT
														ContentBody__c, ContentURL__c, ContentHeight__c
													 FROM
													 	cc_imp_PageContent__c
													 WHERE
													 	ContentKey__c = :contentKey
														AND Storefront__c INCLUDES (:ctx.storefront) LIMIT 1];

			if (!pageContents.isEmpty()) {
                data.put('contentBody', pageContents[0].ContentBody__c);
                data.put('contentURL', pageContents[0].ContentURL__c);
                data.put('contentHeight', pageContents[0].ContentHeight__c);
				res.success = true;
			}

            res.data = data;
		}

		catch (Exception ex) {
			System.debug(System.LoggingLevel.Error, ex.getMessage());
			System.debug(System.LoggingLevel.Error, ex.getStackTraceString());
		}

		return res;
	}
}