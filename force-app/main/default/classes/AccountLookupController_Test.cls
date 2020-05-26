/**
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class AccountLookupController_Test {

    static Account acc;
    static Opportunity opp;
    
    static testMethod void myUnitTest() {
    
        Profile pr = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = pr.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
        Test.startTest();
        Map<String, Schema.RecordTypeInfo> RTMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName(); 
        acc = new Account(Name='TestAcc*',Type='Prospect',SAP_Division_Desc__c='Nexeo Chem');
        insert acc;   
        
        
        apexpages.currentpage().getparameters().put('lksrch',acc.Name);
        
         ApexPages.standardcontroller sc = new ApexPages.standardcontroller(acc);
         AccountLookupController CR = new AccountLookupController();
         cr.searchString =acc.Name;    
         pagereference p = cr.search();
         p = cr.sortResults();
        //p = cr.saveAccount();
        cr.getFormTag();
        cr.getTextBox();
        
    }   

}