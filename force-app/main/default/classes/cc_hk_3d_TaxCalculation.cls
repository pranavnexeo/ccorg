global class cc_hk_3d_TaxCalculation extends ccrz.cc_hk_TaxCalculation{
	
	global override Decimal getTaxAmount(Map<String, Object> inputData){	
		Decimal txAmt = 0.0;
		try {
			String cartId = (String)inputData.get(ccrz.cc_hk_TaxCalculation.PARAM_CARTID);
			ccrz.cc_bean_MockContactAddress contactAddress = (ccrz.cc_bean_MockContactAddress)inputData.get(ccrz.cc_hk_TaxCalculation.PARAM_SHIPADDR);

			ccrz__E_Cart__c cart = cc_imp_dao_Cart.queryVatNumberByCartId( Id.valueOf(cartId) );

			String vatNumber = cart.ccrz__Account__r.VAT_Number__c;

			String countryCode = contactAddress.countryCode;
			String stateName = contactAddress.state;

			cc_3d_Valid_Shipping_Country__mdt countryDetail;
			cc_3d_State_Tax_Rule__mdt stateDetail;

			ccrz.CCLog.log('*** Tax Country: ' + countryCode);
			List<cc_3d_Valid_Shipping_Country__mdt> codes = [SELECT Id, Country_Code__c, Uses_EU_VAT_Validation__c, Uses_US_Tax_Calc__c, Include_Ship_Amount_In_Tax_Calc__c, Tax_Percent__c, Tax_Classification__c FROM cc_3d_Valid_Shipping_Country__mdt where Country_Code__c =:countryCode ];
			if( codes != null && codes.size()==1){
				countryDetail = codes[0];
				List<cc_3d_State_Tax_Rule__mdt> stateTaxRules = [SELECT State_Name__c, State_Tax_Percent__c, Tax_Classification__c from cc_3d_State_Tax_Rule__mdt where Valid_Shipping_Country__c =:countryDetail.Id and State_Name__c = :stateName];
				if(stateTaxRules.size() > 0){
					stateDetail = stateTaxRules[0];
				}
			}

			// validate the VAT, if required by configuration
			boolean validVat = false;
			String taxClassification = null; // 0=no tax, 1=tax

			// Determine whether to calculate tax, and how to set the tax classification
			ccrz.CCLog.log('*** Before country: ' + countryDetail.Tax_Classification__c);
			if(countryDetail.Tax_Classification__c == null || countryDetail.Tax_Classification__c == ''){
				taxClassification = '';
			} 
			else {
				taxClassification = countryDetail.Tax_Classification__c;
			}
			ccrz.CCLog.log('*** After country: ' + taxClassification);

			ccrz.CCLog.log('*** State: ' + stateDetail);
			if(stateDetail != null && stateDetail.Tax_Classification__c != null && stateDetail.Tax_Classification__c != ''){
				ccrz.CCLog.log('*** State in: ' + stateDetail.Tax_Classification__c);
				taxClassification = stateDetail.Tax_Classification__c;
			}
			ccrz.CCLog.log('*** Tax Classification: ' + taxClassification);

			// Validate the VAT for European countries
			ccrz.CCLog.log('*** Uses EU Vat: ' + countryDetail.Uses_EU_VAT_Validation__c);
			if(countryDetail.Uses_EU_VAT_Validation__c){
				cc_3d_VATResponse vatResponse = cc_3d_api_VATValidator.fetchVATValidation(countryCode,vatNumber);
				validVat = (vatResponse.callSuccessful && vatResponse.vatIsValid);
				if(validVat){
					taxClassification = '0';
				}
                else {
                    vatNumber = '';
                }
			}
			ccrz.CCLog.log('*** Valid vat: ' + validVat);
			ccrz.CCLog.log('*** Tax Class after VAT: ' + taxClassification);

			// call the tax api - pass the cart, validVat, vatNumber, taxClassification
			ccrz.CCLog.log('** Calling calculate tax: ' + taxClassification);
            ccrz.CCLog.log('**** Sending vatNumber: ' + vatNumber);
			txAmt = cc_imp_api_Tax.calculateTax(cartId, vatNumber, taxClassification);
			ccrz.CCLog.log('** After calculate tax: ' + taxClassification);
			ccrz.CCLog.log('** After calculate tax amount: ' + txAmt);
			if((txAmt != null)&&(txAmt == 0)){
				txAmt = 0.00;
			}

			updateCart(cart.Id, vatNumber, taxClassification);
		}
		catch(Exception e){
			ccrz.CCLog.log('Error making tax call: ' + e.getMessage());
			return null;
		}

		return txAmt;
	}


	private void updateCart(String cartId, String vatNumber, String taxClassification){
		ccrz__E_Cart__c cart =  [	
			SELECT 
				Id,
				VAT_Number__c,
				VAT_Tax_Classification__c
			FROM 
				ccrz__E_Cart__c	 
			WHERE
				ID =: cartId
			LIMIT
				1
		];		
		cart.VAT_Number__c = vatNumber;
		if(taxClassification != null && taxClassification != ''){
			cart.VAT_Tax_Classification__c = Integer.valueOf(taxClassification);
		}
		update cart;
	}


	//global override Decimal getTaxAmountOld(Map<String, Object> inputData){	
		/*
	global Decimal getTaxAmountOld(Map<String, Object> inputData){	

		Decimal txAmt = 0.0;

		String cartId = (String)inputData.get(ccrz.cc_hk_TaxCalculation.PARAM_CARTID);

		ccrz.cc_bean_MockContactAddress contactAddress = (ccrz.cc_bean_MockContactAddress)inputData.get(ccrz.cc_hk_TaxCalculation.PARAM_SHIPADDR);
		System.debug(contactAddress);

		ccrz__E_Cart__c cart = cc_imp_dao_Cart.queryVatNumberByCartId( Id.valueOf(cartId) );

		String vatNumber = cart.ccrz__Account__r.VAT_Number__c;
		Decimal subtotal = cart.ccrz__SubtotalAmount__c;
		Decimal shipAmount = cart.ccrz__ShipAmount__c;
		Decimal taxableValue = 0.0;

		//User cart id to get account id

		String countryCode = contactAddress.countryCode;
		String stateName = contactAddress.state;
		Boolean europeanCalc = false;

		List<cc_3d_Valid_Shipping_Country__mdt> codes = [SELECT Id, Country_Code__c, Uses_EU_VAT_Validation__c, Uses_US_Tax_Calc__c, Include_Ship_Amount_In_Tax_Calc__c, Tax_Percent__c FROM cc_3d_Valid_Shipping_Country__mdt where Country_Code__c =:countryCode ];

		System.debug(' @@ Country Code: ' + countryCode);

		if( codes != null && codes.size()==1){
			cc_3d_Valid_Shipping_Country__mdt countryDetail = codes.get(0);	
			List<cc_3d_State_Tax_Rule__mdt> stateTaxRules = [SELECT State_Name__c, State_Tax_Percent__c from cc_3d_State_Tax_Rule__mdt where Valid_Shipping_Country__c =:countryDetail.Id];
			if(countryDetail.Uses_US_Tax_Calc__c){
				//Country is configured to use the US tax calculation
				//txAmt = cc_imp_api_Tax.calculateTax(cartId);
			}
			else{
				europeanCalc = true;
				taxableValue += subtotal;
				if(countryDetail.Include_Ship_Amount_In_Tax_Calc__c){
					if(shipAmount != null){
						taxableValue += shipAmount;
					}
					
				}

				if(countryDetail.Uses_EU_VAT_Validation__c){
					cc_3d_VATResponse vatResponse = cc_3d_api_VATValidator.fetchVATValidation(countryCode,vatNumber);
					if(vatResponse.callSuccessful && vatResponse.vatIsValid){
						System.debug('VAT IS VALID');
						txAmt = 0.0;
					}else{
						System.debug('VAT IS INVALID');
						System.debug( 'Call Successful response: '+ vatResponse.callSuccessful );
						System.debug( 'Call isValid response: '+ vatResponse.vatIsValid );
						txAmt = checkStateRulesandCalcTax( stateTaxRules, taxableValue,stateName,countryDetail);
						vatNumber = '';
					}

				}else{

					txAmt = checkStateRulesandCalcTax( stateTaxRules, taxableValue,stateName,countryDetail);

				}

			}
	


		}
		if(europeanCalc){
			// A requirement was added to update the CC Order with details about the tax calculation
			ccrz__E_Order__c order = cc_imp_dao_Cart.getOrderForAccountAndCart(cart.Id, cart.ccrz__Account__c, cart.ccrz__Contact__c );
			if(order != null){
				if(txAmt > 0){
					order.VAT_Tax_Classification__c = 1;
				}else{
					order.VAT_Tax_Classification__c = 0;
				}
				if(vatNumber != null){
					order.VAT_Number__c = vatNumber;
				}

				update order;

			}
		}



		return txAmt;
	}
	*/

/*
	private static Decimal checkStateRulesandCalcTax( List<cc_3d_State_Tax_Rule__mdt> stateTaxRules, Decimal subtotal, String stateName, cc_3d_Valid_Shipping_Country__mdt countryDetail){
					Decimal txAmtVal = 0.0;

					if(stateTaxRules != null & stateTaxRules.size()>0){
						cc_3d_State_Tax_Rule__mdt applicableRule = getStateRuleFromList(stateName,stateTaxRules );
						if( applicableRule != null){
							txAmtVal = subtotal * (applicableRule.State_Tax_Percent__c/100);
						}else{
							txAmtVal = subtotal * (countryDetail.Tax_Percent__c/100);
						}
							
					}else{

						txAmtVal = subtotal * (countryDetail.Tax_Percent__c/100);
					}

					return txAmtVal;

	}

	private static cc_3d_State_Tax_Rule__mdt  getStateRuleFromList(String stateName, List<cc_3d_State_Tax_Rule__mdt> stateTaxRules){
		cc_3d_State_Tax_Rule__mdt stateRuleHolder = null;

		for(cc_3d_State_Tax_Rule__mdt stateRule :stateTaxRules){
			if(stateRule.State_Name__c.equalsIgnoreCase(stateName)){
				stateRuleHolder = stateRule;
				break;
			}
		}
		return stateRuleHolder;

	}
*/
}