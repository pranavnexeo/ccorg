@isTest
public class PricingQueryWrapper_Test {
    
   @isTest static void test_parseAndSerialize() {
		PricingQueryWrapper wrap = new PricingQueryWrapper();
	
		wrap.searchDataInput = '1'; 
		wrap.sortCriteria = '2';
		wrap.sortDir = '3';
        wrap.page = '4';

		String msg = wrap.serialize();

		PricingQueryWrapper wrap2 = PricingQueryWrapper.parse(msg);



	}

}