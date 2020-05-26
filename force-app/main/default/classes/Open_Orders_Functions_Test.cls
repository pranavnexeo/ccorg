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
private class Open_Orders_Functions_Test {

    static testMethod void myUnitTest() {
    	Test.startTest();
        test02();
    }
    
    static void test01() {
        String s = '2010-04-12';
        if (s.length() > 9) {
            Integer y = Integer.valueOf(s.substring(0,4));
            Integer m = Integer.valueOf(s.substring(5, 7));
            Integer d = Integer.valueOf(s.substring(8, 10));
        }
    }
    
    static void test02() {
    	Reorder__c r = new Reorder__c();
    	r.Customer_PO_Number__c = 'Test';
    	r.Expected_Ship_Date__c = Date.today();
    	r.Requested_Delivery_Date__c = Date.today();
    	insert r;
    	r = [select Expected_Ship_Date__c, Expected_Ship_Date2__c, 
    	            Requested_Delivery_Date__c, Requested_Delivery_Date2__c
    	       from Reorder__c where Id = :r.Id
    	    ];
    	System.debug(r.Expected_Ship_Date__c + ' --> ' + r.Expected_Ship_Date2__c);
        System.debug(r.Requested_Delivery_Date__c + ' --> ' + r.Requested_Delivery_Date2__c);
    }
}