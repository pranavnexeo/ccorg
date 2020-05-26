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
private class SupplierProfileExtension_Test {

    static testMethod void myUnitTest() {
        
        
        Map<String, SObject> testData = NexeoTestUtils_Test.initData();
        Account acct = new Account(name='TestAccount',SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Vendor',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456,333333',SAP_PartnerFunctionText__c='ZA,RS');
        insert acct;
        
        Supplier_Profile__c supplierProfile = new Supplier_Profile__c(Required_Fields__c='Supplier Sales Contact,Competitor Manufacturer,Competitive Product,OEM,Potential Annual Volume,Application,Market Segment',Division_Name__c='Plastic',Purchasing_Organization__c='1000',Price_Changes_Automatically_Approved__c=False,of_rows_for_Bracketed_Pricing__c=2,Supplier_Name__c=acct.Id,X1st_Discount__c=0.7,X2nd_Discount__c=2.3,Comments__c='Testing');
        insert supplierProfile;
        
        ApexPages.StandardController con = new ApexPages.StandardController(supplierProfile);
        SupplierProfileExtension ext = new SupplierProfileExtension(con);
        ext.customSave();
        ext.getSupplierDetails();
        ext.getSupplierPiNumberList();
        
       
        
    }
}