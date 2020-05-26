@IsTest
public class cc_mn_json_myInvoiceRequestTest {
	
	static testMethod void testParse() 
	{
		String json = '{\"document\": \"643774\"}';
		cc_mn_json_myInvoiceRequest obj = cc_mn_json_myInvoiceRequest.parse(json);
		System.assert(obj != null);
	}
}