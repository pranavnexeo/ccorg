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
private class UOM_Conversion_Functions_Test {

    static String testUom = 'Test UOM';
    static String accountRecordType = 'Test AccountRecordType';
    
    static testMethod void myUnitTest() {
        UOM_Conversion__c uomc = new UOM_Conversion__c();
        uomc.UOM__c = testUom;
        uomc.Qty_Greater_Than_or_Equal_to_5_Gallons__c = 1;
        insert uomc;
        
        UOM_Account_Record_Type__c uart = new UOM_Account_Record_Type__c();
        uart.UOM_Conversion__c = uomc.Id;
        uart.Account_Record_Type__c = accountRecordType;
        uart.Record_Key__c = accountRecordType + '-' + uomc.Id;
        uart.Sample_Quantity_1__c = 1;
        insert uart;
         
        UOM_Conversion_Functions.UOMQty_Greater_Than_5_Gallons(testUom, 10);
        
        UOM_Conversion_Functions.getUomSelectOptions('xxxxxxxxx');  
        List<SelectOption> sol = UOM_Conversion_Functions.getUomSelectOptions(accountRecordType);  
        System.debug(sol);
        
        UOM_Conversion_Functions.getSampleQuantities('xxxxxxxxx');
        Map<String, Map<String, Double>> qmap = UOM_Conversion_Functions.getSampleQuantities(accountRecordType);
        System.debug(qmap);
        
        // public static void setRouteForApprovalFlags(String accountRecordType, Sample_Request__c sampleRequest, List<Sample_Material__c> sampleMaterials) 
        Sample_Request__c sampleRequest = new Sample_Request__c();
        Sample_Material__c sampleMaterial = new Sample_Material__c();
        List<Sample_Material__c> listSampleMaterial = new List<Sample_Material__c>();
        listSampleMaterial.add(sampleMaterial);
        UOM_Conversion_Functions.setRouteForApprovalFlags(accountRecordType,sampleRequest,listSampleMaterial);
    }
}