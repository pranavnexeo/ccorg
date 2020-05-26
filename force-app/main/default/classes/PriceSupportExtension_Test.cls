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
private class PriceSupportExtension_Test {
    
    static Price_Support__c priceSupport1;
    static Price_Support__c priceSupport2;
    static Supplier_Profile__c supplierProfile;
    static Supplier_Profile__c supplierProfile2;
    static Supplier_Group__c supplierGroup;
    static Nexeo_Group__c nexeoGroup;
    static Bracketed_Pricing__c bracketedPricing;
    static Nexeo_Member__c nexeoMember;
    static Supplier_Member__c supplierMember;
    static PriceSupportExtension ext;
    static PriceSupportExtension ext2;
    static PriceSupportExtension ext3;
    static PriceSupportExtension ext4;
    static User nexeoMainApprover;
    static User supplierMainApprover;
    static Material_Sales_Data2__c material;
    static Account acct1;
    
    static void init(){
        
        
Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
        Map<String, Schema.RecordTypeInfo> rtmap = Price_Support__c.getSObjectType().getDescribe().getRecordTypeInfosByName();
        system.debug('rtmap: ' + rtmap);
        Account acct = new Account(name='TestAccount',SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Vendor',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA');
        insert acct;
        
        acct1= new Account(name='TestAccount1',SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Vendor',SAP_Accounting_Group__c='ZREG',W_Account_Status__c='ACTIVE');
        insert acct1;
        
        material = new Material_Sales_Data2__c(name='Test Material',Sales_Org_Code__c='1234',Record_key__c='Test',Dist_Channel_Code__c='30',Material_Number__c='12345');
        
        insert material;
        
        acct = [select id,name,SAP_Vendor_Purchase_Org__c,SAP_PartnerFunctionCodeText__c,SAP_PartnerFunctionText__c from Account where name= 'TestAccount'];
        
        supplierProfile = new Supplier_Profile__c(Required_Fields__c='Supplier Sales Contact,Competitor Manufacturer,Competitive Product,OEM,Potential Annual Volume,Application,Market Segment',Division_Name__c='Plastic',Purchasing_Organization__c='1000',Price_Changes_Automatically_Approved__c=False,of_rows_for_Bracketed_Pricing__c=2,Supplier_Name__c=acct.Id,X1st_Discount__c=0.7,X2nd_Discount__c=2.3,Comments__c='Testing');
        insert supplierProfile;
        
        supplierProfile2 = new Supplier_Profile__c(Division_Name__c='Plastic',Purchasing_Organization__c='1000',Price_Changes_Automatically_Approved__c=False,of_rows_for_Bracketed_Pricing__c=2,Supplier_Name__c=acct.Id,X1st_Discount__c=0.7,X2nd_Discount__c=2.3,Comments__c='Testing1');
        insert supplierProfile2;
        
        supplierProfile = [select Id,name,Required_Fields__c,Price_Changes_Automatically_Approved__c,Division_Name__c,Purchasing_Organization__c,of_rows_for_Bracketed_Pricing__c,Supplier_Name__c,X1st_Discount__c from Supplier_Profile__c where Comments__c='Testing'];
        
        Profile profile = [select id from profile where name='System Administrator'];

        supplierMainApprover = new User(alias = 'standt', email='standarduser@testorg.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = profile.Id, 
            timezonesidkey='America/Los_Angeles', username='supplierMain@testorg.com');
        
        insert supplierMainApprover;
        
        nexeoMainApprover = new User(alias = 'standt', email='standarduser@testorg.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = profile.Id, 
            timezonesidkey='America/Los_Angeles', username='nexeoMain@testorg.com');
        
        insert nexeoMainApprover;
        
        //nexeoMainApprover = [select name,email,Id from User where firstName='nexeoMainApprover'];
        
        supplierGroup = new Supplier_Group__c(Group_Name__c='Test Supplier Group',Supplier_Profile__c=supplierProfile.Id,Main_Approver__c=supplierMainApprover.Id,Send_Email__c = True);
        insert supplierGroup;
        
        supplierGroup = [select Id,Name,Main_Approver__c from Supplier_Group__c where Group_Name__c='Test Supplier Group'];
        
        nexeoGroup = new Nexeo_Group__c(Group_Name__c='Test Nexeo Group',Division_Name__c='Plastic',Main_Approver__c=nexeoMainApprover.Id,Send_E_Mail__c= True);
        
        insert nexeoGroup;
        
        nexeoGroup = [select Id,Name,Main_Approver__c,Division_Name__c from Nexeo_Group__c where Group_Name__c='Test Nexeo Group'];
        
        nexeoMember = new Nexeo_Member__c(Name__c=nexeoMainApprover.Id,Nexeo_Group__c=nexeoGroup.Id,Supplier_Group__c=supplierGroup.Id,Approver__c  = True);
        
        insert nexeoMember;
        
        supplierMember = new Supplier_Member__c(Name__c=supplierMainApprover.Id,Supplier_Group__c=supplierGroup.Id,Approver__c  = True);
        
        insert supplierMember;
        System.runAs(nexeoMainApprover){
            priceSupport1 = new Price_Support__c(recordtypeid = rtmap.get('Plastics').getrecordtypeid(), Supplier_Profile_ID__c = supplierProfile.Id,Purchasing_Organization__c='1000',Supplier_Group__c=supplierGroup.Id,Support_Type__c='Rebate',
            Nexeo_Group__c=nexeoGroup.Id,Status__c='Approved',Customer_Soldto__c = acct.Id,Flat_or_Purchased__c='Purchased',Division_Name__c='Plastic',Nexeo_Main_Approver__c=nexeoMainApprover.Id,Supplier_Main_Approver__c=supplierMainApprover.Id,
            Lotus_Notes_Document_Id__c='Test');
            
            insert priceSupport1;
            system.debug('recordtype id: ' + pricesupport1.recordtypeid);
        }
        System.runAs(nexeoMainApprover){
            priceSupport2 = new Price_Support__c(recordtypeid = rtmap.get('Plastics').getrecordtypeid(), Supplier_Profile_ID__c = supplierProfile.Id,Purchasing_Organization__c='1000',Supplier_Group__c=supplierGroup.Id,Support_Type__c='Upfront',
            Nexeo_Group__c=nexeoGroup.Id,Status__c='Approved',Division_Name__c='Plastic',Nexeo_Main_Approver__c=nexeoMainApprover.Id,Supplier_Main_Approver__c=supplierMainApprover.Id,
            Lotus_Notes_Document_Id__c='Test');
            
            insert priceSupport2;
        }
        
        //priceSupport = [select id,name from Price_Support__c where Lotus_Notes_Document_Id__c='Test'];
        
        bracketedPricing = new Bracketed_Pricing__c(X1st_Discount__c=0.9,X2nd_Discount__c=3.0,Price__c=10,Price_Support__c=priceSupport2.Id);
        
        insert bracketedPricing;
         
    }
    
  
    
    static testMethod void myUnitTest() {
        
        
       
        
        init();
        
        Test.setCurrentPage(Page.PriceSupportView);
        ApexPages.currentPage().getParameters().put('action','renew');
        
        ApexPages.currentPage().getParameters().put('materialId',material.Id);
        
        ApexPages.currentPage().getParameters().put('materialType','Selling');
        
        
        
        ApexPages.StandardController con = new ApexPages.StandardController(priceSupport1);
        system.debug('Price Support 1: ' + pricesupport1);
       
        ext = new PriceSupportExtension(con);
        
        ApexPages.StandardController con1 = new ApexPages.StandardController(priceSupport2);
        ext2 = new PriceSupportExtension(con1);
        
        ApexPages.StandardController con3 = new ApexPages.StandardController(new Price_Support__c(Flat_or_Purchased__c='Purchased'));
        ext3 = new PriceSupportExtension(con3);
        
        }
        
        //Price_Support__c priceSupportObj = [select id,name from Price_Support__c where Lotus_Notes_Document_Id__c='Test'];
        static testMethod void myUnitTest1(){
        myUnitTest();
        Test.startTest();
        ext2.customSupplierEdit();
        ext2.doSapretransfer();
        ext.acceptConditionalApproval();
        ext.awaitingSupplierApproval();
        ext.cancelPriceSupport();
        ext.comments=null;
        ApexPages.currentPage().getParameters().put('Supplier','true');
        ext.conditionalApproval();
        Test.stopTest();
        }
        
        static testMethod void myUnitTest2(){
        myUnitTest();
        Test.startTest();
        ext2.comments='Test';
        ext2.conditionalApproval();
        
        Test.stopTest();
        }
        
        static testMethod void myUnitTest3(){
        myUnitTest();
        Test.startTest();
        ext.customEdit();
        ext2.customEdit();
        ext.customSave();
        ext2.customSave();
        ext.decline();
        ext.doRebateCalculation();
        Test.stopTest();
        }
        static testMethod void myUnitTest4(){
        myUnitTest();
        Test.startTest();
        ext.doRenewal();
        ext.doUpfrontCalculation();
        ext.getAcceptConditionalApproval();
        ext.getAcceptReject();
        ext.getConditionallyApprove();
        
        Test.stopTest();
        }
        static testMethod void myUnitTest5(){
        myUnitTest();
        Test.startTest();
        ApexPages.currentPage().getParameters().put('customerId','');
        ApexPages.currentPage().getParameters().put('custType','Payer');
        ApexPages.currentPage().getParameters().put('soldToId','');
        ApexPages.currentPage().getParameters().put('payerNo','');
        
        ext.getCustomerDetails();
        
        ApexPages.currentPage().getParameters().put('customerId','123456');
        ApexPages.currentPage().getParameters().put('custType','Payer');
        ApexPages.currentPage().getParameters().put('soldToId','123456');
        ApexPages.currentPage().getParameters().put('payerNo','123456');
        
       // ext.getCustomerDetails();
        //ext.setSalesGroup('customerId','Payer');
        ext.getDecline();
        ext.getHub();
        ext.getNexeoApprove();
        Test.stopTest();
        
        }
        
        static testMethod void myUnitTest6(){
        myUnitTest();
        Test.startTest();
        ApexPages.currentPage().getParameters().put('nexeoGroup',nexeoGroup.name);
        ext.getNexeoApprovers();
        ApexPages.currentPage().getParameters().put('nexeoGroup','');
        ext.getNexeoApprovers();
        ext.getNexeoReject();
        ext.getPlantCode();
        ext.getPriceHistories();
        Test.stopTest();
        }
        
        static testMethod void myUnitTest7(){
        myUnitTest();
        Test.startTest();
        ApexPages.currentPage().getParameters().put('supplierProfile',supplierProfile.name);
        ext.getPricing();
        ApexPages.currentPage().getParameters().put('supplierProfile','');
        ext.getPricing();
        ext2.insertFlag= true;
        ext2.getPricing();
        ext2.insertFlag= false;
        ext2.getPricing();
        ext.getPricingList();
        ext.getResubmit();
        ext.getSubmitForApproval();
        Test.stopTest();
        }
        
        static testMethod void myUnitTest8(){
        myUnitTest();
        Test.startTest();
        ext.getSupplierApprove();
        ApexPages.currentPage().getParameters().put('supplierGroup',supplierGroup.name);
        ext.getSupplierApprovers();
        ApexPages.currentPage().getParameters().put('supplierGroup','');
        ext.getSupplierApprovers();
        ext.getSupplierDmContactNameList();
        ext.getSupplierReject();
        ext.getTerritoryList();
        ext.hidePopUp();
        ext.init();
        ext.nexeoApproval();
        ext.nexeoRejection();
        Test.stopTest();
        }
        
        static testMethod void myUnitTest9(){
        myUnitTest();
        Test.startTest();
        ext.populateMaterialData();
        
        ApexPages.currentPage().getParameters().put('materialType','Buying');
        
        ext.populateMaterialData();
        
        ext.resubmit();
        
        ext.PriceSupportHistory();
        
        ext.saveandresubmit();
        
        ext.saveandsubmitforapproval();
        
        ext3.saveandsubmitforapproval();
        Test.stopTest();
        }
        
        static testMethod void myUnitTest10(){
        myUnitTest();
        Test.startTest();
        ApexPages.StandardController con4 = new ApexPages.StandardController(new Price_Support__c(Support_Type__c='',New_or_Changed__c=null));
        ext3 = new PriceSupportExtension(con4);
        ext3.saveandsubmitforapproval();
        con4 = new ApexPages.StandardController(new Price_Support__c(Support_Type__c='',New_or_Changed__c='',Order_Type__c='Test'));
        ext3 = new PriceSupportExtension(con4);
        ext3.saveandsubmitforapproval();
        con4 = new ApexPages.StandardController(new Price_Support__c(Support_Type__c='',New_or_Changed__c='',Order_Type__c='',Mode__c=null));
        ext3 = new PriceSupportExtension(con4);
        ext3.saveandsubmitforapproval();
        con4 = new ApexPages.StandardController(new Price_Support__c(Support_Type__c='',New_or_Changed__c='',Order_Type__c='',Mode__c='',Nexeo_Group__c=null));
        ext3 = new PriceSupportExtension(con4);
        ext3.saveandsubmitforapproval();
        Test.stopTest();
        }
        
        static testMethod void myUnitTest11(){
        myUnitTest();
        Test.startTest();
        ApexPages.StandardController con4 = new ApexPages.StandardController(new Price_Support__c(Support_Type__c='',New_or_Changed__c=null));
        con4 = new ApexPages.StandardController(new Price_Support__c(Support_Type__c='',New_or_Changed__c='',Order_Type__c='',Mode__c='',Nexeo_Group__c=nexeoGroup.Id,Supplier_Profile_ID__c=null));
        ext3 = new PriceSupportExtension(con4);
        ext3.saveandsubmitforapproval();
        con4 = new ApexPages.StandardController(new Price_Support__c(Support_Type__c='',New_or_Changed__c='',Order_Type__c='',Mode__c='',Nexeo_Group__c=nexeoGroup.Id,Supplier_Profile_ID__c=supplierProfile.Id,Supplier_Group__c=null));
        ext3 = new PriceSupportExtension(con4);
        ext3.saveandsubmitforapproval();
        con4 = new ApexPages.StandardController(new Price_Support__c(Support_Type__c='',New_or_Changed__c='',Order_Type__c='',Mode__c='',Nexeo_Group__c=nexeoGroup.Id,Supplier_Profile_ID__c=supplierProfile.Id,Supplier_Group__c=supplierGroup.Id,Customer_Name__c=null));
        ext3 = new PriceSupportExtension(con4);
        ext3.saveandsubmitforapproval();
        con4 = new ApexPages.StandardController(new Price_Support__c(Support_Type__c='',New_or_Changed__c='',Order_Type__c='',Mode__c='',Nexeo_Group__c=nexeoGroup.Id,Supplier_Profile_ID__c=supplierProfile.Id,Supplier_Group__c=supplierGroup.Id,Customer_Name__c=acct1.Id,Material_Buying__c=null,Customer_soldto__c=acct1.Id));
        ext3 = new PriceSupportExtension(con4);
        ext3.saveandsubmitforapproval();
        con4 = new ApexPages.StandardController(new Price_Support__c(Support_Type__c='',New_or_Changed__c='',Order_Type__c='',Mode__c='',Nexeo_Group__c=nexeoGroup.Id,Supplier_Profile_ID__c=supplierProfile.Id,Supplier_Group__c=supplierGroup.Id,Customer_Name__c=acct1.Id,Material_Buying__c=material.Id,UOM__c=null,Customer_soldto__c=acct1.id));
        ext3 = new PriceSupportExtension(con4);
        
        Test.stopTest();
        }
        
        static testMethod void myUnitTest12(){
        myUnitTest();
        
        Test.startTest();
        ApexPages.StandardController con4 = new ApexPages.StandardController(new Price_Support__c(Support_Type__c='',New_or_Changed__c=null));
        ext3.saveandsubmitforapproval();
        con4 = new ApexPages.StandardController(new Price_Support__c(Support_Type__c='',New_or_Changed__c='',Order_Type__c='',Mode__c='',Nexeo_Group__c=nexeoGroup.Id,Supplier_Profile_ID__c=supplierProfile.Id,Supplier_Group__c=supplierGroup.Id,Customer_Name__c=acct1.Id,Material_Buying__c=material.Id,UOM__c='',Effective_Date__c=null,Customer_soldto__c=acct1.id));
        ext3 = new PriceSupportExtension(con4);
        ext3.saveandsubmitforapproval();
        con4 = new ApexPages.StandardController(new Price_Support__c(Support_Type__c='',New_or_Changed__c='',Order_Type__c='',Mode__c='',Nexeo_Group__c=nexeoGroup.Id,Supplier_Profile_ID__c=supplierProfile.Id,Supplier_Group__c=supplierGroup.Id,Customer_Name__c=acct1.Id,Material_Buying__c=material.Id,UOM__c='',Expiration_Date__c=System.today(),Flat_or_Purchased__c=null,Customer_soldto__c=acct1.id));
        ext3 = new PriceSupportExtension(con4);
        ext3.saveandsubmitforapproval();
        
        
        Test.stopTest();
        }
        
        static testMethod void myUnitTest13(){
        myUnitTest();
        Test.startTest();
        
        ext.showCancelPopUp();
        
        ext.showCommentsPopUp();
        
        ext.showDeclinePopUp();
        
        ext.showExiprationPopUp();
        
        ext.showReviewPopUp();
        
        ext.submitForApproval();
        
        Test.stopTest();
        }
        
        static testMethod void myUnitTest14(){
        myUnitTest();
        Test.startTest();
        
        ext.supplierApproval();
        ext.nullCheck(23.23);
        ext.supplierCheck();
        ext.nullCheck('test');
        ext.supplierRejection();
        ext.getRegionDetails();
        ext.updateExpiryDate();
        ext.recordtype = 'Test';
        ext.updateReviewDate();
        ext.editComments();
        ext.setSalesGroup('test','abc');
        ext.checkSupplierApprover();
        ext.checkNexeoApprover();
        ext.submitForApproval();
        
        Test.stopTest();
       
    }
}