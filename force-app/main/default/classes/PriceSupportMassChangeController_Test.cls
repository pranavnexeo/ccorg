/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a  particular piece
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
private class PriceSupportMassChangeController_Test {

    static testMethod void myUnitTest() {
    
Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
       
       Account acct = new Account(name='TestAccount',SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Vendor',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA');
        insert acct;
        
       Material_Sales_Data2__c matlist = new Material_Sales_Data2__c(name = 'Test Material', Material_Number__c = '12344321', Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',   Record_Key__c = 'Test Record Key');        
      insert matlist;
       
        Supplier_Profile__c supplierProfile = new Supplier_Profile__c(Division_Name__c='Plastic',Purchasing_Organization__c='1000',Price_Changes_Automatically_Approved__c=False,of_rows_for_Bracketed_Pricing__c=2,Supplier_Name__c=acct.Id,X1st_Discount__c=0.7,X2nd_Discount__c=2.3,Comments__c='Testing1');
        insert supplierProfile;
        Supplier_Group__c supplierGroup = new Supplier_Group__c(Group_Name__c='Test Supplier Group',Supplier_Profile__c=supplierProfile.Id,Send_Email__c = True);
        insert supplierGroup;
        Nexeo_Group__c nexeoGroup = new Nexeo_Group__c(Group_Name__c='Test Nexeo Group',Division_Name__c='Plastic',Send_E_Mail__c= True);
        insert nexeoGroup;        
        
        List<Price_Support__c> psl = new List<Price_Support__c>();
        Price_Support__c priceSupport1 = new Price_Support__c( Customer_Type__c = 'PY-Payer',Requested_Rebate_Amount__c = 12,Customer_Soldto__c = acct.id,Order_Type__c = 'Plant',Sales_Organisation__c = '1000-US',Sales_Group_Desc__c = '1000',Customer_Name__c = acct.id,Material_Buying__c = matlist.id,Material_Selling__c = matlist.id,Supplier_Profile_ID__c = supplierProfile.Id,Purchasing_Organization__c='1000',Supplier_Group__c=supplierGroup.Id,Support_Type__c='Rebate',Flat_or_Purchased__c='Purchased',
            Nexeo_Group__c=nexeoGroup.Id,Status__c='Awaiting Nexeo Approval',Division_Name__c='Plastic',Lotus_Notes_Document_Id__c='Test',Expiration_Date__c=System.today(),Effective_Date__c= System.today(),X1st_Discount_Type_Buy__c='%',X2nd_Discount_Type_Buy__c='%',X1st_Discount_Type_Sell__c='%',X2nd_Discount_Type_Sell__c='%');
        insert priceSupport1;
        psl.add(priceSupport1);
        
        Price_Support__c priceSupport2 = new Price_Support__c(Customer_Type__c = 'PY-Payer',Requested_Rebate_Amount__c = 32,Customer_Soldto__c = acct.id,Parent_Price_Support__c = priceSupport1.id,Order_Type__c = 'Plant',Sales_Organisation__c = '1000-US',Sales_Group_Desc__c = '1000',Customer_Name__c = acct.id,Material_Buying__c = matlist.id,Material_Selling__c = matlist.id,Supplier_Profile_ID__c = supplierProfile.Id,Purchasing_Organization__c='1000',Supplier_Group__c=supplierGroup.Id,Support_Type__c='Upfront',
            Nexeo_Group__c=nexeoGroup.Id,Status__c='Awaiting Nexeo Approval',Division_Name__c='Plastic',Lotus_Notes_Document_Id__c='Test',Expiration_Date__c=System.today(),Effective_Date__c= System.today());
        insert priceSupport2;
        
        Price_Support__c priceSupport3 = new Price_Support__c(Requested_Rebate_Amount__c = 64,Customer_Soldto__c = acct.id,Parent_Price_Support__c = priceSupport2.id,Order_Type__c = 'Both',Sales_Organisation__c = '1000-US',Sales_Group_Desc__c = '1000',Customer_Name__c = acct.id,Material_Buying__c = matlist.id,Material_Selling__c = matlist.id,Supplier_Profile_ID__c = supplierProfile.Id,Purchasing_Organization__c='1000',Supplier_Group__c=supplierGroup.Id,Support_Type__c='Upfront',Flat_or_Purchased__c='Flat',
            Rebate_Editable__c = true,Nexeo_Group__c=nexeoGroup.Id,Status__c='Approved',Division_Name__c='Plastic',Lotus_Notes_Document_Id__c='Test',Expiration_Date__c=System.today(),Effective_Date__c= System.today());
        insert priceSupport3;
        
        Price_Support__c priceSupport4 = new Price_Support__c(Requested_Rebate_Amount__c = 45,Parent_Price_Support__c = priceSupport3.id,Order_Type__c = 'Both',Sales_Organisation__c = '1000-US',Sales_Group_Desc__c = '1000',Customer_Name__c = acct.id,Material_Buying__c = matlist.id,Material_Selling__c = matlist.id,Supplier_Profile_ID__c = supplierProfile.Id,Purchasing_Organization__c='1000',Supplier_Group__c=supplierGroup.Id,Support_Type__c='Rebate',Flat_or_Purchased__c='Purchased',
            Nexeo_Group__c=nexeoGroup.Id,Status__c='Approved',Division_Name__c='Plastic',Lotus_Notes_Document_Id__c='Test',Expiration_Date__c=System.today(),Effective_Date__c= System.today(),X1st_Discount_Type_Buy__c='%',X2nd_Discount_Type_Buy__c='%',X1st_Discount_Type_Sell__c='%',X2nd_Discount_Type_Sell__c='%');
        insert priceSupport4;
        Price_Support__c priceSupport5 = new Price_Support__c(Requested_Rebate_Amount__c = 43,Order_Type__c = 'Plant',Sales_Organisation__c = '1700-Canada',Sales_Group_Desc__c = '1000',Customer_Name__c = acct.id,Material_Buying__c = matlist.id,Material_Selling__c = matlist.id,Supplier_Profile_ID__c = supplierProfile.Id,Purchasing_Organization__c='1000',Supplier_Group__c=supplierGroup.Id,Support_Type__c='Rebate',Flat_or_Purchased__c='Purchased',
            Nexeo_Group__c=nexeoGroup.Id, Net_Support_Cost__c=10,Status__c='Awaiting Nexeo Approval',Division_Name__c='Plastic',Lotus_Notes_Document_Id__c='Test',Expiration_Date__c=System.today(),Effective_Date__c= System.today(),X1st_Discount_Type_Buy__c='%',X2nd_Discount_Type_Buy__c='%',X1st_Discount_Type_Sell__c='%',X2nd_Discount_Type_Sell__c='%');
        insert priceSupport5; 
       
        
        Price_Support_Ids__c Pid=new Price_Support_Ids__c(Ids__c=priceSupport3.id);
        insert Pid;
        
        Price_Support_Ids__c Pid1=new Price_Support_Ids__c(Ids__c=priceSupport4.id);
        insert Pid1;
        
        Apexpages.currentPage().getParameters().put('selectedRecords',Pid.id);
        Apexpages.currentPage().getParameters().put('renew','true');
        
        Apexpages.currentPage().getParameters().put('selectedRecords',Pid1.id);
        Apexpages.currentPage().getParameters().put('renew','true');
        
        PriceSupportMassChangeController con1 = new PriceSupportMassChangeController();
        con1.comments='Test';
        con1.supportedPriceType='$';
        con1.customSave();
        con1.nullCheck(12.34);
        con1.nullCheck('test');
        con1.nullChecknew('test');
        con1.validate(priceSupport1);
        con1.validate(priceSupport5);
        
        Price_Support__c priceSupport6 = new Price_Support__c(Supplier_Profile_ID__c = supplierProfile.Id,Purchasing_Organization__c='1000',Supplier_Group__c=supplierGroup.Id,Support_Type__c='Rebate',Flat_or_Purchased__c='Flat',
            Nexeo_Group__c=nexeoGroup.Id, Net_Support_Cost__c=10,Status__c='Awaiting Nexeo Approval',Division_Name__c='Plastic',Lotus_Notes_Document_Id__c='Test',Expiration_Date__c=System.today(),Effective_Date__c= System.today(),X1st_Discount_Type_Buy__c='%',X2nd_Discount_Type_Buy__c='%',X1st_Discount_Type_Sell__c='%',X2nd_Discount_Type_Sell__c='%');
        insert priceSupport6; 
        con1.validate(priceSupport6);
         List<Price_Support__c> listPriceSupport=new List<Price_Support__c>();
        listPriceSupport.add(priceSupport1);
        listPriceSupport.add(priceSupport2);
        listPriceSupport.add(priceSupport3);
        listPriceSupport.add(priceSupport4);
        listPriceSupport.add(priceSupport5);
        PriceSupportMassChangeController.validate1(listPriceSupport);
        
        Apexpages.currentPage().getParameters().put('selectedRecords',Pid.id);
        Apexpages.currentPage().getParameters().put('renew','false');
        
        Apexpages.currentPage().getParameters().put('selectedRecords',Pid1.id);
        Apexpages.currentPage().getParameters().put('renew','false');
        
        PriceSupportMassChangeController con2 = new PriceSupportMassChangeController();
        con2.purchaseCostType='$';
        con2.customSave();
        con2.effectiveDate = system.today();
       
       
    }
}