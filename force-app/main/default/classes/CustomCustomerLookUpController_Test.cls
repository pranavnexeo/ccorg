/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class CustomCustomerLookUpController_Test {

    static testMethod void myUnitTest() {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
        Account cust = new Account(name='TestAccount',SAP_Vendor_Purchase_Org__c='1000',Active_Account__c='Yes',Type='Customer',SAP_Customer_Number__c='123456',SAP_DivisionCode__c='32',SAP_DistChannel__c='30',SAP_Sales_Org__c='1000',SAP_Partner_Functions__c='Payer');
        insert cust;
        
        CISRelationships__c cis = new CISRelationships__c(Source_Customer__c=cust.Id,Customer_Number__c='123456',Customer_Type__c='Payer');
        insert cis;
        
         System.currentPageReference().getParameters().put('custNo','123456');
         System.currentPageReference().getParameters().put('lksrch',cust.Id);
         System.currentPageReference().getParameters().put('salesOrg','1000-US');
         System.currentPageReference().getParameters().put('customerType','PY-Payer');
         System.currentPageReference().getParameters().put('divisionNo','32');
         System.currentPageReference().getParameters().put('distChannel','30');
         
        
         CustomCustomerLookUpController con = new CustomCustomerLookUpController();
         con.getFormTag();
         con.getSoldTos();
         con.getTextBox();
         con.search();
         
         
        
    }
}