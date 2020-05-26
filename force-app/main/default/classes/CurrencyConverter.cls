global with sharing class CurrencyConverter {

    public static final String DELIM = ':';
    
    global class ExchangeRate {
    	webservice String currencyFrom {get; set;}
        webservice Double valueFrom    {get; set;}
        webservice String currencyTo   {get; set;}
        webservice Double valueTo      {get; set;}
        webservice Double numerator    {get; set;} 
        webservice Double denominator  {get; set;}
        public ExchangeRate(String f,
                            String t,
                            Double n,
                            Double d) {
        	currencyFrom = f;
        	currencyTo = t;
        	numerator = n;
        	denominator = d;
        } 
    }
    
    public static Map<String, Double> getConversionRateMap() {
    	Map<String, Double> crmap = new Map<String, Double>();
    	List<CurrencyType> cts = [select IsoCode, IsCorporate,
    	                                 ConversionRate
    	                            from CurrencyType
    	                           where IsActive = true
    	                           order by IsoCode
    	                         ];
        for (CurrencyType ct : cts) {
        	crmap.put(ct.IsoCode, ct.ConversionRate);
        }
        return crmap;
    }
    
    webservice static List<String> getExchangeRateStrings() {
    	List<String> ers = new List<String>();
    	Map<String, Double> crmap = getConversionRateMap();
    	Set<String> currencyFrom = crmap.keySet();
        Set<String> currencyTo = crmap.keySet();
        for (String f : currencyFrom) {
        	Double d = crmap.get(f);
        	for (String t : currencyTo) {
        		Double n = crmap.get(t);
        		String er = f + DELIM + t + DELIM + n + DELIM + d;
        		ers.add(er);
        	}
        }
    	return ers;
    }
    
    webservice static List<ExchangeRate> getExchangeRates() {
        List<ExchangeRate> ers = new List<ExchangeRate>();
        Map<String, Double> crmap = getConversionRateMap();
        Set<String> currencyFrom = crmap.keySet();
        Set<String> currencyTo = crmap.keySet();
        for (String f : currencyFrom) {
            Double d = crmap.get(f);
            for (String t : currencyTo) {
                Double n = crmap.get(t);
                ExchangeRate er = new ExchangeRate(f, t, n, d);
                ers.add(er);
            }
        }
        return ers;
    }
    
    public static Map<String, ExchangeRate> getExchangeRateMap() {
    	Map<String, ExchangeRate> emap = new Map<String, ExchangeRate>();
    	List<ExchangeRate> ers = getExchangeRates();
    	for (ExchangeRate er : ers) {
    		String k = er.currencyFrom + DELIM + er.currencyTo;
    		emap.put(k, er);
    	}
    	return emap;
    }
    
    private static ExchangeRate getExchangeRate(Map<String, ExchangeRate> erMap,
                                                String currencyFrom,
                                                String currencyTo) {
        String k = currencyFrom + DELIM + currencyTo;
        if (erMap.containsKey(k)) {
        	return erMap.get(k);
        }
        return null;
    }
    
    webservice static ExchangeRate getExchangeRate(String currencyFrom,
                                                   String currencyTo) {
        Map<String, ExchangeRate> emap = getExchangeRateMap();
        return getExchangeRate(emap, currencyFrom, currencyTo);
    }
    
    webservice static ExchangeRate getConvertedCurrency(Double valueFrom,
                                                        String currencyFrom,
                                                        String currencyTo) {
    	ExchangeRate er = getExchangeRate(currencyFrom, currencyTo);
    	if (er != null && er.denominator != 0) {
            er.valueFrom = valueFrom;
    		er.valueTo = er.valueFrom * er.numerator / er.denominator;
    	}
    	return er;
    }
    
    public static Double getCurrencyConversionFactor(Map<String, Double> crmap,
                                                     String currencyFr,
                                                     String currencyTo) {
        Double denom = 1.0, numer = 1.0, ccf = 1.0;
        if (crmap.containsKey(currencyFr)) {denom = crmap.get(currencyFr);}
        if (crmap.containsKey(currencyTo)) {numer = crmap.get(currencyTo);}
        if (denom != 0) {
        	ccf = numer / denom;
        }
        return ccf;
    }
    
/*
************************************************
Test methods are in CurrencyConverter_Test class
************************************************
*/
    
}