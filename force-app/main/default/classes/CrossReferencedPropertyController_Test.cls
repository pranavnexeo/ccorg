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
private class CrossReferencedPropertyController_Test { 
	
	static Lease_Property__c leaseObj;
	static Fee_Property__c feeObj;
	static PageReference pref;
	static CrossReferencedPropertyController crss;
	
	private static void init(){
		
		leaseObj = new Lease_Property__c(file__c='123',Additional_Comments__c='Test',Base_Rent__c=0.0);
		feeObj = new Fee_Property__c(file__c='1234',Commitmet__c='Test');
		insert leaseObj;
		insert feeObj;
		
		leaseObj = [select id,name,file__c from Lease_Property__c where Id = : leaseObj.Id];
		feeObj = [select id,name,file__c from Fee_Property__c where Id = : feeObj.Id];
		
		pref = Page.CrossReferencedPropertyView;
    	pref.getParameters().put('propertyId',leaseObj.file__c);
    	//pref.getParameters().put('feePropertyId',feeObj.name);
    	
   		Test.setCurrentPage(pref);
   		 
	}
	
    static testMethod void myUnitTest() {
       
       init();
       crss = new CrossReferencedPropertyController();
       crss.getPropertyList();
       crss.init();
       pref.getParameters().put('propertyId',feeObj.file__c);
   	   Test.setCurrentPage(pref);
       crss.init();
      
       
    }
}