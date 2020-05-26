public with sharing class CurrencyController {

    public Decimal value {get; set;}
    public Integer decimals {get; set;}
    public String code {get; set;}
    public String locale {get; set;}
    
    public Currency__c c {
        get {
            Currency__c cc = new Currency__c();
            cc.CurrencyIsoCode = code;
            cc.Code__c = code;
            cc.Value__c = getRoundedValue();
            return cc;
        }
    }

    public String currencyString {
        get {
            return getFormattedValue();
        }
    }
    
    private Decimal getRoundedValue() {
        if (code == null) {code = 'USD';}
        if (decimals == null) {decimals = 2;}
        if (value == null) {value = 0;}
        Decimal d1 = 10;
        Decimal d2 = d1.pow(decimals);
        Decimal d3 = (value * d2).round();
        Decimal d4 = d3.divide(d2, decimals);
        return d4;
    }

    private String getFormattedValue() {
        if (locale == null) {locale = 'en_US';}
        Decimal d = getRoundedValue();
        String s = CurrencyFunctions.getFormattedDecimal(locale, d);
        return code + ' ' + s;
    }
    
}