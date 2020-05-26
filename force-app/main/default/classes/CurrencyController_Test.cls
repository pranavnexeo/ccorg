@isTest
    private class CurrencyController_Test {
        public static testMethod void testCurrencyController() {
        //Currency__c cur = new Currency__c(name = 'test');
        //Currency__c cu = new Currency__c();
        CurrencyController cc = new CurrencyController();
        cc.value= 1.2;
        cc.decimals  = 1;
        cc.code =  '';
        cc.locale = '';
        string st = cc.currencyString;
        Currency__c cur = cc.c;
        //cc.c('1');
        //cc.currencyString('12');
        //CurrencyController.currencyString cs = new CurrencyController.currencyString ('12');
    }
  }