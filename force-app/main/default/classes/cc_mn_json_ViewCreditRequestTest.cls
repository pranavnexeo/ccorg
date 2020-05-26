@IsTest
public with sharing class cc_mn_json_ViewCreditRequestTest 
{

	  static testMethod void testParse() 
	  {
	  	String json ='{"customerno": "102483", "company_code": "1000", "salesorg": "1000", "distr_chan": "30", "division": "31"}';

		cc_mn_json_ViewCreditRequest obj = cc_mn_json_ViewCreditRequest.parse(json);

		 System.assert(obj != null);
  }

}