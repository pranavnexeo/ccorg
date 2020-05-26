public class Country_Code_Functions {
	
	private static Map<String, String> cmap = null;
	
	public static Map<String, String> getCountryCodeMap() {
		if (cmap != null) {return cmap;}
		cmap = new Map<String, String>();
        List<Country_Code__c> cs = [select Country__c, Code__c From Country_Code__c];
        for(Country_Code__c c : cs) {cmap.put(c.Country__c, c.Code__c);}
        return cmap;
	}
	
	static testMethod void test01() {
		Test.startTest();
		System.debug(getCountryCodeMap());
        System.debug(getCountryCodeMap());
		Test.stopTest();
	}

}