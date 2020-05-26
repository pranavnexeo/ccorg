@isTest
private class cc_mn_json_OrderQueryWrapperTest {
	
	@isTest static void test_parseAndSerialize() {
		cc_mn_json_OrderQueryWrapper wrap = new cc_mn_json_OrderQueryWrapper();
	
		wrap.searchOrderInput = '1'; 
		wrap.searchOrderStatus = '2';
		wrap.fromDateStr = '3';
		wrap.toDateStr = '4';
		wrap.ascending = '5';
		wrap.sortCriteria = '6';
		wrap.sortDir = '7';	

		String msg = wrap.serialize();

		cc_mn_json_OrderQueryWrapper wrap2 = cc_mn_json_OrderQueryWrapper.parse(msg);

		System.assertEquals(wrap.toDateStr, wrap2.toDateStr);

	}	
}