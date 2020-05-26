public with sharing class cc_3d_api_VATValidator {

	/** 
	 * The vatNumber is parsed to use the first two characters as the country code, and the remaining
	 * characters as the vat number.  If the VAT Validation service returns that the vatNumber is valid,
	 * the first two characters of the supplied vatNumber are compared to the supplied countryCode.  If 
	 * the countryCode does not match the first two characters of the vatNumber, the VAT number is
	 * marked invalid.
	 */
	public static cc_3d_VATResponse fetchVATValidation(String countryCode, String vatNumber){
	
	    cc_3d_VATResponse vatResponse = new cc_3d_VATResponse();
	    String httpResponseCodeString;
	    String parsedCountry = null;
	    String parsedVat = null;


		try{
	    		parsedCountry = vatNumber.subString(0,2);
	    		parsedVat = vatNumber.subString(2);

				String requestXml = '<?xml version="1.0" encoding="UTF-8"?>';
				requestXml += '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:ec.europa.eu:taxud:vies:services:checkVat:types">';
				requestXml += '<SOAP-ENV:Body>';
				requestXml += '<ns1:checkVat>';
				requestXml += '<ns1:countryCode>';
				// requestXml += countryCode;
				requestXml += parsedCountry;
				requestXml += '</ns1:countryCode>';
				requestXml += '<ns1:vatNumber>';
				// requestXml += vatNumber;
				requestXml += parsedVat;
				requestXml += '</ns1:vatNumber>';
				requestXml += '</ns1:checkVat>';
				requestXml += '</SOAP-ENV:Body>';
				requestXml += '</SOAP-ENV:Envelope>';

		
				cc_imp_util_Http request = new cc_imp_util_Http();

				system.debug('Before Calling getInstance');

				String storeFrontName = ccrz.cc_CallContext.storefront;
				cc_imp_StorefrontSettings__C settings =  cc_imp_StorefrontSettings__C.getInstance(storeFrontName);
				system.debug(storeFrontName);
				request.endpoint = settings.VATValidatorEndpointURLPath__c;

				system.debug('After Calling getInstance');

				//request.endpoint = 'http://ec.europa.eu/taxation_customs/vies/services/checkVatTestService';
				request.method = cc_imp_util_Http.REQUEST_TYPE.POST;
				request.addHeader('Content-Type', 'text/xml;charset=UTF-8');
				//request.addHeader('SOAPAction', 'checkVat');
				request.setBody(requestXml);


				HttpResponse response = request.submitRequest();

				system.debug(response.getBody());

				httpResponseCodeString = String.valueOf( response.getStatusCode() );

				if(response.getStatusCode() == 200 ){

					vatResponse.callSuccessful = true;
					//Dom.Document doc = new Dom.Document();
					//doc.load(response.getBody())  ;
					Dom.Document doc = response.getBodyDocument();
					Dom.XMLNode envelope = doc.getRootElement();

				String msg7 = 'RANDALL7';
				system.debug(msg7);

					Dom.XMLNode body= Envelope.getChildElements()[0];

					Dom.XMLNode checkVatResponse = body.getChildElements()[0];

					vatResponse.vatIsValid = false;

					// If the supplied country code does not match the first 2 characters from the 
					// vatNumber, the vat is considered not valid.
					if(parsedCountry == countryCode){
						for(Dom.XMLNode child : checkVatResponse.getChildElements()) {

							if(child.getName().equals('valid')){
	
								String validString = child.getText();
								if(validString.equals('true')){
									vatResponse.vatIsValid = true;
								}else{
									vatResponse.vatIsValid = false;
								}
								break;
							}

						}
					}
		
				}else{
						vatResponse.callSuccessful = false;
						vatResponse.responseCode = httpResponseCodeString;
				}
		}catch( Exception e ){
			vatResponse.callSuccessful = false;
	     	vatResponse.responseMessage = e.getMessage() ;
	     	vatResponse.responseCode  = httpResponseCodeString;
		}
	

					String msg11 = 'RANDALL11';
				system.debug(msg11);
		return vatResponse;
		
				
	}


}