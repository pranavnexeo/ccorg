@isTest
private class cc_mn_json_InvoiceQueryWrapperTest {
	
	@isTest static void test_parseAndSerialize() {
		cc_mn_json_InvoiceQueryWrapper wrap = new cc_mn_json_InvoiceQueryWrapper();
	
		wrap.fromDateStr = '1'; 
		wrap.searchInvoiceInput = '2';
		wrap.searchInvoiceStatus = '3';
		wrap.searchInvoiceType = '4';
		wrap.sortCriteria = '5';
		wrap.sortDir = '6';
		wrap.toDateStr = '7';	

		String msg = wrap.serialize();


		cc_mn_json_InvoiceQueryWrapper wrap2 = cc_mn_json_InvoiceQueryWrapper.parse(msg);

		System.assertEquals(wrap.toDateStr, wrap2.toDateStr);

	}
}