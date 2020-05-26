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
private class RecordType_Functions_Test {

static testMethod void myUnitTest() {
        Test.startTest();
      
    String RecordTypeId = '';
    String RecordTypeName = '';
    String BusinessName = '';
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
    Account acct = new Account(name='TestAccount',SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Vendor',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA');
        insert acct; 
    
    RecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Customer','Account');
    RecordTypeName = RecordType_Functions.LookupRecordTypeName(RecordTypeId);
    BusinessName =  RecordType_Functions.getBusinessNameForAccountType(RecordTypeID);
    

    System.Debug('RecordTypeId = ' + RecordTypeId);
    System.Debug('RecordTypeName = ' + RecordTypeName);
    System.Debug('Business Name = ' + BusinessName);

    RecordTypeId = RecordType_Functions.LookupRecordTypeId('','');

    System.Debug('Bad RecordTypeId = ' + RecordTypeId);

    Map<String, Id> Map1 = RecordType_Functions.RetrieveRecordTypeNameMap('Account');
    Map<Id, String> Map2 = RecordType_Functions.RetrieveRecordTypeIdMap('Account');
    Map<Id, String> Map3 = RecordType_Functions.RetrieveAccRecordTypeMap();
    Map<String, Id> Map4 = RecordType_Functions.RetrieveRecordTypeNameMap();
    Map<String, Id> Map5 = RecordType_Functions.RetrieveRecordTypeNameMap();
    list<string> list1 = new list<string>();
    list1.add('Valvoline');
    list1.add('test');
  
    
    Map<String, Map<String, Id>> map7 = RecordType_Functions.getRecordTypeNameMap(list1);
    Map<String, Map<Id, String>> map8 = RecordType_Functions.getRecordTypeIdMap(list1);
    
    //Get Describe results for all objects
    Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
    //Get describe for Account
    Schema.SObjectType ot = gd.get('Account');
    //Pass the objectType
    List<String> recTypesAcc = RecordType_Functions.GetAvailableRecordTypeNamesForSObject(ot);
    String defaultId = RecordType_Functions.getDefaultRecordTypeId(ot);
    

}



}