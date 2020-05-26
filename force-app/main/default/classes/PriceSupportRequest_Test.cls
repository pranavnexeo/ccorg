@isTest
private class PriceSupportRequest_Test{
    
    static testMethod void myUnitTest() {
    Price_Support_Request__c psr = new Price_Support_Request__c(CurrencyIsoCode = 'USD');
    insert psr;
    //public string a
    PriceSupportRequest psre = new PriceSupportRequest();
    PriceSupportRequest.getAllRecords();
    PriceSupportRequest.getDateFormat();
    PriceSupportRequest.saveRecord(psr.id+'&abc','test');
    }
}