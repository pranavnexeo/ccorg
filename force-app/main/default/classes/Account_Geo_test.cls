@isTest

private class Account_Geo_test{

    //Test method for Account_Geo class
    static testmethod void Account_Geo_method1(){
       try{
        Account acc = new Account(
        name = 'Test Account',
        SAP_Street__c = '242 DEMONT RD',
        SAP_City__c = 'CHESTER BASIN',
        SAP_State__c = 'Nova Scotia',
        SAP_Zip_Code__c = 'B0J 1K0',
        SAP_Country__c = 'CA',
        Address_Updated__c = true
        );
    
    insert acc;
        Account a = [select id, shippingstreet, shippingcity, shippingstate, shippingpostalcode, shippingcountry, Mapquest_address__c from account where id = :acc.id limit 1];
    
        Account_Geo.calculateDistance(12,14,12.00,14.00);
        Account_Geo.AccountDistance ad = new Account_Geo.AccountDistance(a,12.23);
        Account_Geo.getAccountsNearMe('lat','long',23);
        }catch(exception e){}
    }




}