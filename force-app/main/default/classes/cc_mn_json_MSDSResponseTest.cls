@IsTest
public with sharing class cc_mn_json_MSDSResponseTest 
{

  static testMethod void testParse() 
	{
		String json = '{\"document\": \"643774\"}';
		cc_mn_json_MSDSResponse obj = cc_mn_json_MSDSResponse.parse(json);
		System.assert(obj != null);
		System.assertNotEquals(null, obj.serialize());
	}
}