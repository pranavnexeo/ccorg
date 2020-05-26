@isTest
public class caseRedirect_New_Test {

    static Account acc;
    static NCAR_Cases__c cas2;
//    static Case cas;
//    static Case cas2;
    
    static testMethod void myUnitTest() {
    Profile pr = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = pr.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
Id devRecordTypeId = Schema.SObjectType.NCAR_Cases__c.getRecordTypeInfosByName().get('Nexeo Return').getRecordTypeId();
        Id rtID = Schema.SObjectType.NCAR_Cases__c.getRecordTypeInfosByName().get('Nexeo Standard Incident').getRecordTypeId();
        
        Test.startTest();

        acc = new Account(Name='TestAcc');
        insert acc;
        
        NCAR_Cases__c cas = new NCAR_Cases__c(recordtypeid=devRecordTypeId);
        /* cas.AccountId = acc.Id;
        cas.DZ_Number__c = '123456';
        cas.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution DZ', 'Case');
        cas.Subject = ''; */
        insert cas;
        System.debug(cas);
        
        
        
        ApexPages.standardController sc = new ApexPages.standardcontroller(cas);
        ApexPages.currentPage().getParameters().put('retURL',('a'+acc.id));
        ApexPages.currentPage().getParameters().put('id',cas.id);
        caseRedirect_New CR = new caseRedirect_New(sc);
        CR.contactID = 'test';
        CR.a = acc;
        
        pagereference p = cr.redirect();
        
        p = cr.redirectedit();
        
        p = cr.redirectview();
        test.stoptest();
        
    }   
    static testMethod void myUnitTest1() {
    Profile p1 = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p1.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
Id rtID = Schema.SObjectType.NCAR_Cases__c.getRecordTypeInfosByName().get('Nexeo Standard Incident').getRecordTypeId();
        
        //Test.startTest();

        acc = new Account(Name='TestAcc');
        insert acc;
        cas2 = new NCAR_Cases__c(recordtypeid=rtID);
        /* cas2.AccountId = acc.id;
        cas2.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Nexeo Standard Incident', 'Case');
        cas2.subject = ''; */
        insert cas2;
        //update cas2;
        
        ApexPages.standardcontroller sc2 = new ApexPages.standardcontroller(cas2);
        ApexPages.currentPage().getParameters().put('retURL',('a'+acc.id));
        ApexPages.currentPage().getParameters().put('id',cas2.id);
        Test.startTest();
       /* caseRedirect_New CR2 = new caseRedirect_New(sc2);
        pagereference p = cr2.redirect();
        p = cr2.redirect();
        p = cr2.redirectedit();
        p = cr2.redirectview();*/
        test.stoptest();
        
    
    }
   
}