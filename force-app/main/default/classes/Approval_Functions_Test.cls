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
private class Approval_Functions_Test {

static testMethod void myUnitTest() {

Profile pr = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = pr.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
      
        Map<String, Schema.RecordTypeInfo> RTMap = ES_Profile__c.sObjectType.getDescribe().getRecordTypeInfosByName();
        Account a = new Account(Name = 'Test Acc');
        Insert a;
        Opportunity Opp = new Opportunity(Name = 'Test Opp', Accountid = a.id, stagename = 'open', closedate = system.today());
        Insert Opp;
        ES_Profile__c p = new ES_Profile__c(Opportunity__C = opp.id, Stage__c = 'Profile Approved', recordtypeid = RTMap.get('Profile Approved').getrecordtypeid());
        insert p;
        Approval_Functions.submitrecord(p.id, '');
    
        Approval_Functions.isapprover(userinfo.getuserid(),p.id);
        Approval_Functions.ApproveReject(p.id, 'Reject', '');
        p = [select id, stage__c from ES_Profile__c where id = :p.id];
        if(p.stage__c == 'Pricing Rejected'){
        Approval_Functions.submitrecord(p.id, '');
        Approval_Functions.ApproveReject(p.id, 'Approve', '');
        }
        Map<ID, String> comments = Approval_Functions.getcomments(new set<ID>{p.id});
        Map<ID, String> firstcomments = Approval_Functions.getlastapproverscomments(new set<ID>{p.id});
   Approval_Functions.issubmitted('test'); 
}



}