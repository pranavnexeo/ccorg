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
private class CallUpEditExtension_Test {
	
	static CallUpEditExtension callExt;
	static Lease_Property__c leaseProperty;
	static Fee_Property__c feeProperty;
	static Call_Up__c callUpOne;
	static Call_Up__c callUpTwo;
	static PageReference pref;
	
	
	private static void init(){
		
		 leaseProperty = new Lease_Property__c(Additional_Comments__c='Test',Base_Rent__c=0.0);
		 insert leaseProperty;
		  
		 feeProperty = new Fee_Property__c(Additional_Comments__c='Test',File_Type__c='Fee Property - 0');
		 insert feeProperty;
		 
		 callUpOne = new Call_Up__c(Fee_Property__c=feeProperty.Id,Reason__c='Testing',Entity_Name__c='Test');
		 insert callUpOne;
		 
		 callUpTwo = new Call_Up__c(Lease_Property__c=leaseProperty.Id,Reason__c='Testing',Entity_Name__c='Test');
		 insert callUpTwo;
		 
		 pref = Page.CallUpEditPage;
    	 pref.getParameters().put('feePropertyId',feeProperty.Id);
    	 pref.getParameters().put('leasePropertyId',leaseProperty.Id);
    	 pref.getParameters().put('entityName','Test');
    	 
    	 
   		 Test.setCurrentPage(pref);
   		 
   		 ApexPages.StandardController con = new ApexPages.StandardController(callUpOne);
   		 callExt = new CallUpEditExtension(con);
   		 
		 
		 
	}
	
	
    static testMethod void myUnitTest() {
       
       init();
       callExt.init();
       callExt.closeCallUp();
       callExt.getEditFlag();
       ApexPages.StandardController con = new ApexPages.StandardController(callUpTwo);
   	   callExt = new CallUpEditExtension(con);
   	   callExt.init();
       callExt.closeCallUp();
       callExt.getEditFlag();
       
    }
}