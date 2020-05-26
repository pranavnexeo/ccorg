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
private class CheckRequestExtension_Test {
	
	static CheckRequestExtension chkExt;
	static Lease_Property__c leaseProperty;
	static Check_Request__c chkRqst;
	static PageReference pref;
	
	
	private static void init(){
		
		 leaseProperty = new Lease_Property__c(Additional_Comments__c='Test',Base_Rent__c=0.0);
		 insert leaseProperty;
		  
		 chkRqst = new Check_Request__c(Original_Expenses__c=0.0,Total_Amount__c=0.0,Old_Total__c=0.0,Original_Adjustments__c=0.0,Original_Vendor_Rent__c=0.0,Vendor_Expenses__c=0.0,Vendor_Rent__c=0.0,Adjustments__c=0.0,Comments__c='Test',Lease_Property__c=leaseProperty.Id);
		 insert chkRqst;
		 
		 leaseProperty = [select id,name from Lease_Property__c where Id = : leaseProperty.Id];
		 
		 pref = Page.LeasePropertyEditPage;
    	 pref.getParameters().put('leasePropertyId',leaseProperty.name);
    	 System.debug('leasePropertyId----'+leaseProperty.name);
   		 Test.setCurrentPage(pref);
   		 
   		 ApexPages.StandardController con = new ApexPages.StandardController(chkRqst);
   		 chkExt = new CheckRequestExtension(con);
   		 
		 
		 
	}
	
    static testMethod void myUnitTest() {
       
      
       init();
       chkExt.init();
       chkExt.doCalculation();
       
       
    }
}