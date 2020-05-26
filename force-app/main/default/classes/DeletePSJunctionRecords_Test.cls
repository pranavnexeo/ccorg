@isTest
private class DeletePSJunctionRecords_Test{
    
    static testMethod void myUnitTest() {
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
    Account acc = new Account(Name = 'Test Account');
        acc.SAP_Zip_Code__c = '43081';
        insert acc;
    Account_Material__c ncpi = new Account_Material__c(CurrencyIsoCode = 'USD',Account__c = acc.id);
    insert ncpi;
    SAP_Price_Support__c sps = new SAP_Price_Support__c(CurrencyIsoCode = 'USD');
    insert sps;
    Price_Support_Junction__c psj = new Price_Support_Junction__c(Nexprice_CPI__c = ncpi.id,SAP_Price_Support__c = sps.id);
    insert psj;
    sps.Deletion_Indicator__c = 'X';
    update sps;
    
    }
}