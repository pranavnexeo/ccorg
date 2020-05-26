@IsTest
public with sharing class cc_mn_json_MSDSRequestTest 
{
	static testMethod void testParse() 
	{
		String json = '{\"material\": \"643774\"}';
		cc_mn_json_MSDSRequest obj = cc_mn_json_MSDSRequest.parse(json);
		System.assert(obj != null);
	}
}