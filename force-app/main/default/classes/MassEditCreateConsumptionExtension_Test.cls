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
private class MassEditCreateConsumptionExtension_Test {

static testMethod void myUnitTest() {
        Test.startTest();
        Map<String, Schema.RecordTypeInfo> RTMapCons = Consumption__c.sObjectType.getDescribe().getRecordTypeInfosByName();
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
        Account acc = new Account(Name = 'Test Account');
        acc.SAP_Zip_Code__c = '43081';
        insert acc;
        
        List<Consumption__c> cons = new list<consumption__c>();
        for(integer i=0; i<5; i++){
          Consumption__c c = new consumption__c(
               recordtypeid = RTMapCons.get('Distribution Chemicals').getrecordtypeid(),
               Account_name__c = acc.id
          );
          cons.add(c);
        }
        insert cons;     

        ApexPages.currentpage().getparameters().put('returl', '/apex/masseditcreateconsumption?returl=' + acc.id);
        ApexPages.StandardsetController stdsetcontroller = new ApexPages.StandardsetController(cons);
        stdsetcontroller.setselected(cons);
        MassEditCreateConsumptionExtension MECCE = new MassEditCreateConsumptionExtension(stdsetcontroller);
        MECCE.insertrow();
        MECCE.cindex = MECCE.wrapperlist.get(0).id;
        MECCE.clonecon();       
        MECCE.saveandcontinue();
        MECCE.cancel();
        MECCE.conslistsize = 4;
        MECCE.removeline();
        MECCE.save();

}



}