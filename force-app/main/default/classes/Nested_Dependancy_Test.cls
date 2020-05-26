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
private class Nested_Dependancy_Test {
    
    static testMethod void myUnitTest() {
        Test.startTest();
        Map<String, ID> RTMap = RecordType_Functions.RetrieveRecordTypeNameMap('Nested_Dependancy__c');
        Nested_Dependancy__c n1 = new nested_dependancy__c();
        n1.object__c = 'Case';
        n1.field_1__c = 'field1'; 
        n1.Field_1_value__c = 'f1';
        n1.field_2__c = 'field2';
        n1.field_2_value__c = 'f2';
        n1.field_3__c = 'field3';
        n1.field_3_value__c = 'f3';
        n1.field_4__c = 'field4';
        n1.field_4_value__c = 'f4';
        n1.field_5__c = 'field5';
        n1.field_5_value__c = 'f5';
        n1.record_type_name__c = 'rectype';
        n1.recordtypeid = RTMap.get('5 Level');
        insert n1;
        
        Nested_Dependancy__c n2 = n1.clone(false);
        n2.field_3_value__c = 'f3-2';      
        insert n2;
        
        Nested_Dependancy ND = new nested_dependancy('field1', 'field2', 'field3', 'field4', 'field5', 'rectype', 'Case');
        ND.field1changed('f1');
        nd.field2changed('f1', 'f2');
        nd.field3changed('f1', 'f2','f3');
        nd.field4changed('f1', 'f2', 'f3', 'f4');
        nd.field5changed('f5');

     
   }
}