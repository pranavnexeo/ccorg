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
private class Approval_Section_Controller_Test {

    static Account acc;
    static Opportunity opp;
    
    static testMethod void myUnitTest() {
        Test.startTest();
        Map<String, Schema.RecordTypeInfo> RTMap = Account.sObjectType.getDescribe().getRecordTypeInfosByName(); 
       // acc = new Account(Name='TestAcc*',Type='Prospect',SAP_Division_Desc__c='Nexeo Chem');
       // Acc.RecordTypeId = RTMap.get('Distribution Prospect').getrecordtypeid();
      //  Acc.SAP_Division_Desc__c = 'Nexeo Env Svcs';
       // insert acc;  
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution Prospect').getRecordTypeId();
       Account acc = new Account(Name = 'Test',RecordtypeId=RecordTypeId,SAP_Sales_Org__c = 'Test', SAP_DivisionCode__c = 'Test', SAP_Industry_Key__c ='Test',HQ_Sales_Office__c = 'Test', SAP_SalesGroup__c = 'Test');
       insert acc;         
        //Approval_Functions.submitrecord(acc.id, '');
         ApexPages.standardcontroller sc = new ApexPages.standardcontroller(acc);
         Approval_Section_Controller ASR = new Approval_Section_Controller(sc);
         
  
        
    }   

}