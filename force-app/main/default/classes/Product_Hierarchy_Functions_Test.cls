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
private class Product_Hierarchy_Functions_Test {

    static String ph = '!abcdefghijklmnopq';
    static String lc = 'E';
    
    static testMethod void test01() {
        Test.startTest();
        Product_Hierarchy__c ph1, ph2, ph3, ph4, ph5, ph6, ph7;
        ph1 = new Product_Hierarchy__c();
        ph1.Product_Hierarchy_Code__c = ph.substring(0,1);
        ph1.Language_Code__c = lc;
        ph2 = new Product_Hierarchy__c();
        ph2.Product_Hierarchy_Code__c = ph.substring(0,3);
        ph2.Language_Code__c = lc;
        ph3 = new Product_Hierarchy__c();
        ph3.Product_Hierarchy_Code__c = ph.substring(0,6);
        ph3.Language_Code__c = lc;
        ph4 = new Product_Hierarchy__c();
        ph4.Product_Hierarchy_Code__c = ph.substring(0,9);
        ph4.Language_Code__c = lc;
        ph5 = new Product_Hierarchy__c();
        ph5.Product_Hierarchy_Code__c = ph.substring(0,12);
        ph5.Language_Code__c = lc;
        ph6 = new Product_Hierarchy__c();
        ph6.Product_Hierarchy_Code__c = ph.substring(0,15);
        ph6.Language_Code__c = lc;
        ph7 = new Product_Hierarchy__c();
        ph7.Product_Hierarchy_Code__c = ph;
        ph7.Language_Code__c = lc;
        insert ph1;
        insert ph2;
        insert ph3;
        insert ph4;
        insert ph5;
        insert ph6;
        insert ph7;
        Set<String> aset = new Set<String> {ph};
        Product_Hierarchy_Functions.upsert_Product_Hierarchy2(aset);
        Product_Hierarchy_Functions.getProdHerkyMap(aset);
        List<Product_Hierarchy__c> plist;
        plist = Product_Hierarchy_Functions.getProductSegments('99');
        System.debug(plist);
        Set<String> ph5s = new Set<String> {ph.substring(0,12)};
        Map<String, String> ph5map = Product_Hierarchy_Functions.getProductFamilyMap(ph5s);
        Set<String> ph6s = new Set<String> {ph.substring(0,15)};
        Map<String, String> ph6map = Product_Hierarchy_Functions.getProductSegmentMap(ph6s);
        Test.stopTest();
    }
    
    static testMethod void test02() {
        Test.startTest();
        Product_Hierarchy_Functions.getProductFamilies('10', '000');
        Test.stopTest();
    }

}