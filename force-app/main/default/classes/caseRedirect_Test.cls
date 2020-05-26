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
private class caseRedirect_Test {

    static Account acc;
    static Case cas;
    static Case cas2;
    
    static testMethod void myUnitTest() {
    Profile p1 = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p1.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;

        Test.startTest();

        acc = new Account(Name='TestAcc');
        insert acc;
        
        cas = new Case();
        cas.AccountId = acc.Id;
        cas.DZ_Number__c = '123456';
        cas.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution DZ', 'Case');
        cas.Subject = '';
        insert cas;
        System.debug(cas);
        
        cas2 = new Case();
        cas2.AccountId = acc.id;
        cas2.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Nexeo Standard Incident', 'Case');
        cas2.subject = '';
        insert cas2;
        update cas2;
        
        ApexPages.standardController sc = new ApexPages.standardcontroller(cas);
        ApexPages.standardcontroller sc2 = new ApexPages.standardcontroller(cas2);
        caseRedirect CR = new caseRedirect(sc);
        caseRedirect CR2 = new caseRedirect(sc2);
        
        pagereference p = cr.redirect();
        p = cr2.redirect();
        p = cr.redirectedit();
        p = cr2.redirectedit();
        p = cr.redirectview();
        p = cr2.redirectview();
    }   
     
   
}