@isTest
private class CurrencyConverter_Test {

    static void debug(String s) {
    	System.debug(LoggingLevel.INFO, '>>>>>>>>>> ' + s);
    }
    
    static testMethod void test01() {
    	CurrencyConverter.getExchangeRateStrings();
    }
    
    static testMethod void test02() {
        CurrencyConverter.getExchangeRates();
    }
    
    static testMethod void test03() {
        CurrencyConverter.getExchangeRate('USD', 'CAD');
        CurrencyConverter.getConvertedCurrency(100, 'USD', 'CAD');
        CurrencyConverter.getConvertedCurrency(100, '000', '999');
    }
    
    static testMethod void test04() {
        Map<String, Double> crmap = CurrencyConverter.getConversionRateMap();
        debug('EUR to GBP : '+CurrencyConverter.getCurrencyConversionFactor(crmap, 'EUR', 'GBP'));
        debug('USD to INR : '+CurrencyConverter.getCurrencyConversionFactor(crmap, 'USD', 'INR'));
    }
    
}