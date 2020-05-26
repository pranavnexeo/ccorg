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
private class PriceSupportSearchController_Test {

    static testMethod void myUnitTest() {
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
        Account acct = new Account(name='TestAccount',SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Vendor',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA');
        insert acct;
        
        
        Supplier_Profile__c supplierProfile = new Supplier_Profile__c(Division_Name__c='Plastic',Purchasing_Organization__c='1000',Price_Changes_Automatically_Approved__c=False,of_rows_for_Bracketed_Pricing__c=2,Supplier_Name__c=acct.Id,X1st_Discount__c=0.7,X2nd_Discount__c=2.3,Comments__c='Testing1');
        insert supplierProfile;
        Supplier_Group__c supplierGroup = new Supplier_Group__c(Group_Name__c='Test Supplier Group',Supplier_Profile__c=supplierProfile.Id,Send_Email__c = True);
        insert supplierGroup;
        Nexeo_Group__c nexeoGroup = new Nexeo_Group__c(Group_Name__c='Test Nexeo Group',Division_Name__c='Plastic',Send_E_Mail__c= True);
        insert nexeoGroup;
        
        
        
        Price_Support__c priceSupport1 = new Price_Support__c(Supplier_Profile_ID__c = supplierProfile.Id,Purchasing_Organization__c='1000',Supplier_Group__c=supplierGroup.Id,Support_Type__c='Rebate',Flat_or_Purchased__c='Purchased',
            Nexeo_Group__c=nexeoGroup.Id,Status__c='Awaiting Nexeo Approval',Division_Name__c='Plastic',Lotus_Notes_Document_Id__c='Test',Expiration_Date__c=System.today(),Effective_Date__c= System.today(),X1st_Discount_Type_Buy__c='%',
            X2nd_Discount_Type_Buy__c='%',X1st_Discount_Type_Sell__c='%',X2nd_Discount_Type_Sell__c='%',Archieved__c=false,Agreement_Number__c='1234',SAP_Transfer__c='Open');
        insert priceSupport1;
        
        Apexpages.currentPage().getParameters().put('agreementId','1234');
        Apexpages.currentPage().getParameters().put('divisionName','Plastic');
        Apexpages.currentPage().getParameters().put('status','Awaiting Nexeo Approval');
        Apexpages.currentPage().getParameters().put('sapTransfer','Open');
        Apexpages.currentPage().getParameters().put('salesOrg','1000');
        Apexpages.currentPage().getParameters().put('supportType','Rebate');
        Apexpages.currentPage().getParameters().put('nexeoGroupName','Test');
        Apexpages.currentPage().getParameters().put('supplierGroupName','Test');
        Apexpages.currentPage().getParameters().put('customerName','Test');
        Apexpages.currentPage().getParameters().put('customerNumber','1234');
        Apexpages.currentPage().getParameters().put('nexeoMainApprover','test');
        Apexpages.currentPage().getParameters().put('seller','trest');
        Apexpages.currentPage().getParameters().put('supplierName','test');
        Apexpages.currentPage().getParameters().put('supplierNumber','1234');
        Apexpages.currentPage().getParameters().put('materialName','test');
        Apexpages.currentPage().getParameters().put('materialCode','1234');
        Apexpages.currentPage().getParameters().put('expDate','12/01/2012');
        Apexpages.currentPage().getParameters().put('mg2','test');
        Apexpages.currentPage().getParameters().put('mg4','test');
        Apexpages.currentPage().getParameters().put('newChanged','new');
        Apexpages.currentPage().getParameters().put('materialNameBuy','test');
        Apexpages.currentPage().getParameters().put('created','Today');
        Apexpages.currentPage().getParameters().put('region','test');
        
        PriceSupportSearchController con = new PriceSupportSearchController();
        con.getExpDt();
        con.getLimitList();
        con.getPriceSupports();
        con.runQuery();
        con.runSearch();
        con.toggleSort();
        con.newNexeoGroup = nexeoGroup.id;
        con.agreementId = 'test1';
        con.status = 'test1';
        con.sapTransfer = 'test1';
        con.salesOrg = 'test1';
        con.supportType = 'test1';
         con.nexeoGroupName = 'test1';
         con.supplierGroupName = 'test1';
         con.customerName = 'test1';
         con.customerNumber = 'test1';
         con.region = 'test1';
         con.seller = 'test1';
         con.supplierNumber = 'test1';
         con.materialName = 'test1';
         con.materialCode = 'test1';
         //con.expDate = system.now();
         con.nexeoMainApprover = 'test1';
         con.mg2 = 'test1'; 
         con.mg4 = 'test1';
         con.newChanged = 'test1';
         con.materialNameBuy = 'test1';
         con.created = 'test1';
        ApexPages.currentPage().getParameters().put('selectedRecords', priceSupport1.id);
        ApexPages.currentPage().getParameters().put('supplierName', acct.name);
        ApexPages.currentPage().getParameters().put('salesorg', supplierProfile.Purchasing_Organization__c);
        con.updateNexeoGroup();
        con.updateDebitMemo();
        //con.DebitMemoList();
        
        //con.
        List<SelectOption> temp8 = con.DebitMemoList;
        List<SelectOption> temp7 = con.materialGroup4List;
        List<SelectOption> temp = con.salesOrgList;
        List<SelectOption> temp1 = con.newChangedList;
        List<SelectOption> temp2 = con.divisionList;
        List<SelectOption> temp3 = con.nexeoGroupList;
        List<SelectOption> temp4 = con.sapStatusList;
        List<SelectOption> temp5 = con.materialGroup2List;
        List<SelectOption> temp6 = con.supportTypeList;
        List<SelectOption> temp9 = con.statusList;
        
        
        
    }
}