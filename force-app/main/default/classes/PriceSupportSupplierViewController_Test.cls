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
private class PriceSupportSupplierViewController_Test {

    static testMethod void myUnitTest() {
        
        Profile profile = [select id from profile where name='System Administrator'];
        User MainApprover = new User(alias = 'standt', email='standarduser@testorg.com', 
            emailencodingkey='UTF-8', lastname='Nexeo_Integration User', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = profile.Id, 
            timezonesidkey='America/Los_Angeles', username='supplierMain@testorg.com');
        insert MainApprover;
        
        Account acct = new Account(name='TestAccount',SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Vendor',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA');
        insert acct;
        
        
        Supplier_Profile__c supplierProfile = new Supplier_Profile__c(Division_Name__c='Plastic',Purchasing_Organization__c='1000',Price_Changes_Automatically_Approved__c=False,of_rows_for_Bracketed_Pricing__c=2,Supplier_Name__c=acct.Id,X1st_Discount__c=0.7,X2nd_Discount__c=2.3,Comments__c='Testing1');
        insert supplierProfile;
        Supplier_Group__c supplierGroup = new Supplier_Group__c(Group_Name__c='Test Supplier Group',Supplier_Profile__c=supplierProfile.Id,Main_Approver__c=MainApprover.Id,Send_Email__c = True);
        insert supplierGroup;
        Nexeo_Group__c nexeoGroup = new Nexeo_Group__c(Group_Name__c='Test Nexeo Group',Division_Name__c='Plastic',Main_Approver__c=MainApprover.Id,Send_E_Mail__c= True);
        insert nexeoGroup;
        
        Nexeo_Member__c nexeoMember = new Nexeo_Member__c(Name__c=MainApprover.Id,Nexeo_Group__c=nexeoGroup.Id,Supplier_Group__c=supplierGroup.Id,Approver__c  = True);
        insert nexeoMember;
        Supplier_Member__c supplierMember = new Supplier_Member__c(Name__c=MainApprover.Id,Supplier_Group__c=supplierGroup.Id,Approver__c  = True);
        insert supplierMember;
        
        Price_Support__c priceSupport1 = new Price_Support__c(Supplier_Profile_ID__c = supplierProfile.Id,Purchasing_Organization__c='1000',Supplier_Group__c=supplierGroup.Id,Support_Type__c='Upfront',
            Nexeo_Group__c=nexeoGroup.Id,Status__c='Awaiting Nexeo Approval',Division_Name__c='Plastic',Nexeo_Main_Approver__c=MainApprover.Id,Supplier_Main_Approver__c=MainApprover.Id,
            Lotus_Notes_Document_Id__c='Test');
        insert priceSupport1;
        
        Price_Support__c priceSupport2 = new Price_Support__c(Supplier_Profile_ID__c = supplierProfile.Id,Purchasing_Organization__c='1000',Supplier_Group__c=supplierGroup.Id,Support_Type__c='Upfront',
            Nexeo_Group__c=nexeoGroup.Id,Status__c='Awaiting Supplier Approval',Division_Name__c='Plastic',Nexeo_Main_Approver__c=MainApprover.Id,Supplier_Main_Approver__c=MainApprover.Id,
            Lotus_Notes_Document_Id__c='Test');
        insert priceSupport2;
        
        System.runAs(MainApprover){
            
            Apexpages.currentPage().getParameters().put('agreementId','123');
            Apexpages.currentPage().getParameters().put('supportType','Rebate');
            Apexpages.currentPage().getParameters().put('status','Awaiting Supplier Approval');
            Apexpages.currentPage().getParameters().put('customerName','Test');
            Apexpages.currentPage().getParameters().put('materialName','Test');
            Apexpages.currentPage().getParameters().put('nexeoApprover','Test');
            Apexpages.currentPage().getParameters().put('supplierApprover','Test');
            Apexpages.currentPage().getParameters().put('supplierReference','123');
            Apexpages.currentPage().getParameters().put('plant','test');
            Apexpages.currentPage().getParameters().put('region','test');
            PriceSupportSupplierViewController con = new PriceSupportSupplierViewController();
            con.toggleSort();
            con.getLimitList();
            con.runQuery();
            con.runSearch();
            con.agreementId='test';
            con.supportType='test31';
            con.status='test3';
            con.customerName='test32';
            con.materialName='test23';
            con.nexeoApprover='test21';
            con.supplierApprover='test11';
            con.supplierReference='test12';
            con.plant='test2';
            con.region='test1';
            con.getPriceSupports();
            List<SelectOption> temp1= con.statusList;
            List<SelectOption> temp2= con.supportTypeList;
            List<SelectOption> temp3= con.nexeoGroupList;
            List<SelectOption> temp4= con.supplierGroupList;
            String temp5 = con.debugSoql;
            String temp6 = con.sortField;
        
        
        }
        
        
    }
}