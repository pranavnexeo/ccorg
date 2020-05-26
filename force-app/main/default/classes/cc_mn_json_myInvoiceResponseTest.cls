@IsTest
public class cc_mn_json_myInvoiceResponseTest {
	
	static testMethod void testParse() 
	{
		String json = '{"document": "643774"}';
		cc_mn_json_myInvoiceResponse obj = cc_mn_json_myInvoiceResponse.parse(json);
		System.assert(obj != null);
		System.assertNotEquals(null, obj.serialize());
	}
}