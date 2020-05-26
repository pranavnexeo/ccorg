@isTest
private class cc_3d_api_VATValidatorTest 
{
	
	 @isTest static void fetchVATValidationPositive() 
	{


	   List <cc_imp_StorefrontSettings__c > storeFrontSettingsList	= cc_imp_testUtils.createNexeoCustomSettingList();

	   insert storeFrontSettingsList ;

       Map <String, String> headerMap = new Map<String, String> ();
       headerMap.put('Content-Type', 'text/xml;charset=UTF-8');
       headerMap.put('SOAPAction', 'urn:ec.europa.eu:taxud:vies:services:checkVat#checkVat');

	   cc_imp_testUtils.clearContext();

	   ccrz.cc_CallContext.storefront = 'nexeo3d';

       Test.startTest();

       Test.setMock(HttpCalloutMock.class, new cc_imp_3d_FetchVATValidator_HttpResponse(200,'success',mockResponse(), headerMap));

	   //cc_imp_testUtils.clearContext();

	   String countryCode = 'FR';
	   String vatNumber = '100';

	   
	   
	   cc_3d_VATResponse vatResponse = cc_3d_api_VATValidator.fetchVATValidation(countryCode, countryCode + vatNumber);

	   System.assert(vatResponse != null);
	   System.assert(vatResponse.vatIsValid);
	   System.assert(vatResponse.callSuccessful);

	   Test.stopTest();
	}

	 @isTest static void fetchVATValidationPositiveResponseCountryMismatch() 
	{


	   List <cc_imp_StorefrontSettings__c > storeFrontSettingsList	= cc_imp_testUtils.createNexeoCustomSettingList();

	   insert storeFrontSettingsList ;

       Map <String, String> headerMap = new Map<String, String> ();
       headerMap.put('Content-Type', 'text/xml;charset=UTF-8');
       headerMap.put('SOAPAction', 'urn:ec.europa.eu:taxud:vies:services:checkVat#checkVat');

	   cc_imp_testUtils.clearContext();

	   ccrz.cc_CallContext.storefront = 'nexeo3d';

       Test.startTest();

       Test.setMock(HttpCalloutMock.class, new cc_imp_3d_FetchVATValidator_HttpResponse(200,'success',mockResponse(), headerMap));

	   //cc_imp_testUtils.clearContext();

	   String countryCode = 'FR';
	   String vatNumber = '100';
	   String vatCountryCode = 'NL';

	   
	   
	   cc_3d_VATResponse vatResponse = cc_3d_api_VATValidator.fetchVATValidation(countryCode, vatCountryCode + vatNumber);

	   System.assert(vatResponse != null);
	   System.assert(!vatResponse.vatIsValid);
	   System.assert(vatResponse.callSuccessful);

	   Test.stopTest();
	}




	 @isTest static void fetchVATValidationNegative() 
	{

	   List <cc_imp_StorefrontSettings__c > storeFrontSettingsList	= cc_imp_testUtils.createNexeoCustomSettingList();

	   insert storeFrontSettingsList ;

       Map <String, String> headerMap = new Map<String, String> ();
       headerMap.put('Content-Type', 'text/xml;charset=UTF-8');
       headerMap.put('SOAPAction', 'urn:ec.europa.eu:taxud:vies:services:checkVat#checkVat');

       Test.setMock(HttpCalloutMock.class, new cc_imp_3d_FetchVATValidator_HttpResponse(200,'success',mockNegativeResponse(), headerMap));

	   cc_imp_testUtils.clearContext();

	   ccrz.cc_CallContext.storefront = 'nexeo3d';

	   String countryCode = 'NL';
	   String vatNumber = '200';

	   Test.startTest();
	   
	   cc_3d_VATResponse vatResponse = cc_3d_api_VATValidator.fetchVATValidation(countryCode,countryCode + vatNumber);

	   System.assert(vatResponse != null);
	   System.assert( ! vatResponse.vatIsValid);
	   System.assert(vatResponse.callSuccessful);

	   Test.stopTest();
	}

	@isTest static void fetchVATValidationUnsuccessfulCall() 
	{

	   List <cc_imp_StorefrontSettings__c > storeFrontSettingsList	= cc_imp_testUtils.createNexeoCustomSettingList();

	   insert storeFrontSettingsList ;

       Map <String, String> headerMap = new Map<String, String> ();
       headerMap.put('Content-Type', 'text/xml;charset=UTF-8');
       headerMap.put('SOAPAction', 'urn:ec.europa.eu:taxud:vies:services:checkVat#checkVat');

       Test.setMock(HttpCalloutMock.class, new cc_imp_3d_FetchVATValidator_HttpResponse(500,'success',mockNegativeResponse(), headerMap));

	   cc_imp_testUtils.clearContext();

	   ccrz.cc_CallContext.storefront = 'nexeo3d';

	   String countryCode = 'NL';
	   String vatNumber = '200';

	   Test.startTest();
	   
	   cc_3d_VATResponse vatResponse = cc_3d_api_VATValidator.fetchVATValidation(countryCode,vatNumber);

	   System.assert(vatResponse != null);
	   System.assert(!vatResponse.callSuccessful);

	   Test.stopTest();
	}

	  private static String mockResponse()
      {
     	String response =  '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">';
     	response += '<soap:Body>';
     	response += '<checkVatResponse xmlns="urn:ec.europa.eu:taxud:vies:services:checkVat:types">';
     	response += '<countryCode>NL</countryCode>';
     	response += '<vatNumber>100</vatNumber>';
     	response += '<requestDate>2016-09-01+02:00</requestDate>';
     	response += '<valid>true</valid>';
     	response += '<name>John Doe</name>';
     	response += '<address>123 Main St, Anytown, UK</address>';
     	response += '</checkVatResponse>';
     	response += '</soap:Body>';
     	response += '</soap:Envelope>';
     	return response;
     }

     private static String mockNegativeResponse()
      {
     	String response =  '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">';
     	response += '<soap:Body>';
     	response += '<checkVatResponse xmlns="urn:ec.europa.eu:taxud:vies:services:checkVat:types">';
     	response += '<countryCode>NL</countryCode>';
     	response += '<vatNumber>100</vatNumber>';
     	response += '<requestDate>2016-09-01+02:00</requestDate>';
     	response += '<valid>false</valid>';
     	response += '<name>John Doe</name>';
     	response += '<address>123 Main St, Anytown, UK</address>';
     	response += '</checkVatResponse>';
     	response += '</soap:Body>';
     	response += '</soap:Envelope>';
     	return response;
     }
	
}