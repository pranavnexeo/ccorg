public with sharing class NumberController {

    public Decimal value {get; set;}
    public Integer decimals {get; set;}
    public String locale {get; set;}
    
    public String numberString {
        get {
            return getFormattedValue();
        }
    }
    
    public String getFormattedValue() {
        if (locale == null) {locale = 'en_US';}
        Decimal d = getRoundedValue();
        String s = CurrencyFunctions.getFormattedDecimal(locale, d);
        return s;
    }
    
    public Decimal getRoundedValue() {
        if (decimals == null) {decimals = 2;}
        if (value == null) {value = 0;}
        Decimal d1 = 10;
        Decimal d2 = d1.pow(decimals);
        Decimal d3 = (value * d2).round();
        Decimal d4 = d3.divide(d2, decimals);
        return d4;
    }

}