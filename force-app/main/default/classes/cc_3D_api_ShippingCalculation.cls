global with sharing class cc_3D_api_ShippingCalculation extends ccrz.cc_api_ShippingAndHandling {
	global cc_3D_api_ShippingCalculation() {
		System.assert(false, 'Implement constructor if needed');
		
	}

	global override List<ccrz.cc_ctrl_hlpr_ShippingOption> getShippingOptions(String zipCode, String stateCode, String countryCode, Id cartId, String storeName){
		System.assert(false, 'Implement the getShippingOptions method');
		return null;	
	}
}