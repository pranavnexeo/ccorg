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
private class resetPriceSupportNullValues_Test {

    static testMethod void myUnitTest() {
        
        Map<String, SObject> testData = NexeoTestUtils_Test.initData();
        Profile profile = [select id from profile where name='System Administrator'];
        User MainApprover = new User(alias = 'standt', email='standarduser@testorg.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = profile.Id, 
            timezonesidkey='America/Los_Angeles', username='supplierMain@testorg.com');
        insert MainApprover;
        
        Account cust1 = new Account(name='TestAccount1',Type='Customer',OwnerId=MainApprover.Id);
        insert cust1;
        
        Account cust2 = new Account(name='TestAccount2',Type='Customer');
        insert cust2;
        
        Price_Support__c priceSupport1 = new Price_Support__c(Customer_Name__c=cust1.Id,Supplier_Profile_ID__c = null,Purchasing_Organization__c='1000',Supplier_Group__c=null,Support_Type__c='Rebate',
            Nexeo_Group__c=null,New_or_Changed__c='Changed',Status__c='Open',Division_Name__c='Plastic',Nexeo_Main_Approver__c=null,Supplier_Main_Approver__c=null,Expiration_Date__c=System.today(),Effective_Date__c= System.today(),
            Lotus_Notes_Document_Id__c='Test',Purchase_Cost__c=null,Customer_Soldto__c = cust1.Id,X1st_Discount_Buy__c=null,X2nd_Discount_Buy__c=null,Supplier_Supported_Price__c=null,
            X1st_Discount_Sell__c=null,X2nd_Discount_Sell__c=null,Other_Allowances__c=null,Net_Purchase_Cost__c=null,Net_Support_Cost__c=null,Requested_Rebate_Amount__c=null);
        insert priceSupport1;
        
        Price_Support__c priceSupport2 = new Price_Support__c(Supplier_Profile_ID__c = null,Purchasing_Organization__c='1000',Supplier_Group__c=null,Support_Type__c='Rebate',
            Nexeo_Group__c=null,New_or_Changed__c='Changed',Status__c='Approved',Customer_Soldto__c = cust1.Id,Division_Name__c='Plastic',Nexeo_Main_Approver__c=null,Supplier_Main_Approver__c=null,Expiration_Date__c=System.today(),Effective_Date__c= System.today(),
            Lotus_Notes_Document_Id__c='Test',Purchase_Cost__c=null,X1st_Discount_Buy__c=null,X2nd_Discount_Buy__c=null,Supplier_Supported_Price__c=null,
            X1st_Discount_Sell__c=null,X2nd_Discount_Sell__c=null,Parent_Price_Support__c=priceSupport1.Id,Other_Allowances__c=null,Net_Purchase_Cost__c=null,Net_Support_Cost__c=null,Requested_Rebate_Amount__c=null);
        insert priceSupport2;
        
        priceSupport1.Status__c='Approved';
        priceSupport1.Parent_Price_Support__c=priceSupport2.Id;
        priceSupport1.Customer_Name__c = cust2.Id;
        update priceSupport1;
        
        priceSupport1.Status__c='Awaiting Nexeo Approval';
        update priceSupport1;
        
        priceSupport1.Status__c='Awaiting Supplier Approval';
        update priceSupport1;
        
        priceSupport1.Status__c='Rejected by Supplier';
        update priceSupport1;
        
        priceSupport1.Status__c='Conditionally Approved';
        update priceSupport1;
        
        priceSupport1.Status__c='Rejected';
        update priceSupport1;
        
        priceSupport1.Status__c='Approved';
        update priceSupport1;
        
    }
}