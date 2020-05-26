global with sharing class cc_3d_ctrl_CheckoutUserInfoController {

    public Map<String, List<String>> countryMap {get; set;}
    public String countryMapJSON {get; set;}
    public Map<String, String> currencyMap {get; set;}
    public String currencyMapJSON {get; set;}
    public Map<String, String> defaultCurrencyMap {get; set;}
    public String defaultCurrencyMapJSON {get; set;}
    public Map<String, List<String>> countyMap {get; set;}
    public String countyMapJSON {get; set;}

	public cc_3d_ctrl_CheckoutUserInfoController() {
        initializeCountryMap();
        initializeCountyMap();
        initializeCurrencyMap();
	}

    private void initializeCountryMap() {
        this.countryMap = new Map<String, List<String>>();
        this.defaultCurrencyMap = new Map<String, String>();
        List<cc_3d_Valid_Shipping_Country__mdt> codes = [SELECT DeveloperName, Country_Code__c, Shipping_Countries__c, Default_Currency__c FROM cc_3d_Valid_Shipping_Country__mdt];
        for (cc_3d_Valid_Shipping_Country__mdt c : codes) {
            if (c.Shipping_Countries__c != null) {
                List<String> countries = c.Shipping_Countries__c.split(',');
                this.countryMap.put(c.Country_Code__c, countries);
                this.defaultCurrencyMap.put(c.Country_Code__c, c.Default_Currency__c);
            }
        }
        this.countryMapJSON = JSON.serialize(this.countryMap);
        this.defaultCurrencyMapJSON = JSON.serialize(this.defaultCurrencyMap);
    }

    private void initializeCountyMap() {
        this.countyMap = new Map<String, List<String>>();
        List<cc_imp_State_County__c> counties = [SELECT County__c, State__c FROM cc_imp_State_County__c];
        for (cc_imp_State_County__c c : counties) {
            List<String> countyList = countyMap.get(c.State__c);
            if (countyList == null) {
                countyList = new List<String>();
                this.countyMap.put(c.State__c, countyList);
            }
            countyList.add(c.County__c);
        }
        this.countyMapJSON = JSON.serialize(this.countyMap);
    }

    private void initializeCurrencyMap() {
        this.currencyMap = new Map<String, String>();
        Map<String, ccrz__E_LocaleMap__c> localeMap = ccrz__E_LocaleMap__c.getAll();
        for (String key : localeMap.keySet()) {
            ccrz__E_LocaleMap__c setting = localeMap.get(key);
            this.currencyMap.put(setting.ccrz__CountryCode__c, setting.ccrz__Currency__c);
        }
        this.currencyMapJSON = JSON.serialize(this.currencyMap);
    }

    @RemoteAction
    global static void saveCounty(String storeName, String portalUserId, String county, String cartSfId) {
        ccrz__E_Cart__c cart = [SELECT Id, ccrz__ShipTo__c FROM ccrz__E_Cart__c WHERE Id = :cartSfId];
        if (cart.ccrz__ShipTo__c != null) {
            ccrz__E_ContactAddr__c address = new ccrz__E_ContactAddr__c(Id = cart.ccrz__ShipTo__c, County__c = county);
            update address;
        }
    }

}