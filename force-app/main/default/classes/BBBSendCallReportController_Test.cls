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
private class BBBSendCallReportController_Test {

    static testMethod void myUnitTest() {
        Test.startTest();
        /*Account acc = new Account(Name = 'Test Account');
        insert acc; */
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution Customer').getRecordTypeId();
        Account acc = new Account(Name = 'Test',RecordtypeId=RecordTypeId,SAP_Sales_Org__c = 'Test', SAP_DivisionCode__c = 'Test', SAP_Industry_Key__c ='Test',HQ_Sales_Office__c = 'Test', SAP_SalesGroup__c = 'Test');
        insert acc;
 
        Call_Report__c cr = new Call_Report__c();
        cr.Account__c = acc.Id;
        cr.Title__c = 'Test Call Report';
        insert cr;
        Contact cntct = new Contact(FirstName='Chandra',LastName='ServiceDesk-DoNotReply',No_Email__c= true);
        insert cntct;
        EmailTemplate et = [select Id from EmailTemplate where DeveloperName = 'CallReport' limit 1];
        ApexPages.currentpage().getparameters().put('crid', cr.Id);
        ApexPages.currentpage().getparameters().put('tid', et.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(cr);
        BBBSendCallReportController c = new BBBSendCallReportController(sc);
        c.manualaddresses = '';
        //User u = [Select Id, LastName from User where lastname = 'Schramm' limit 1];
        c.searchuser = u.LastName;
        c.getmatched();
        c.selectedmatch = u.Id;
        c.getsendto();
        c.selectedsendto = u.Id;
        c.removeuser();
        c.sendemail();
        c.showPopup();
        c.closePopup();
        c.cancel();
        c.gettid();
        c.getcr();
        c.getcrid();
        c.refreshthis();
        
        boolean b = c.displayPopup;
        
    }
}