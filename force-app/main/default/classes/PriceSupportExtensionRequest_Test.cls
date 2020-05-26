/** Test class for PriceSupportExtensionRequest **/

@isTest
private class PriceSupportExtensionRequest_Test{

static Price_Support_Request__c priceSupport1;
static Price_Support_Request__c priceSupport2;
static Supplier_Profile__c supplierProfile;
static Supplier_Profile__c supplierProfile2;
static PriceSupportExtensionRequest ext;
static PriceSupportExtensionRequest ext2;
static PriceSupportExtensionRequest ext3;
static PriceSupportExtensionRequest ext4;
static Material_Sales_Data2__c material;
static Account acct1;


static void init(){

Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
    
    User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='saxs2bh77gfdhddc@gorg.com', IsActive = true);
    insert u; 
Map<String, Schema.RecordTypeInfo> rtmap = Price_Support_Request__c.getSObjectType().getDescribe().getRecordTypeInfosByName();
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
priceSupport1 = new Price_Support_Request__c(recordtypeid = rtmap.get('Rebate').getrecordtypeid(), Supplier_Profile_ID__c = supplierProfile.Id,Sales_Organization__c ='1000',Support_Type__c='Rebate',
            Status__c='Open',Flat_or_Purchased__c='Purchased',Division_Name__c='Chemicals',Division_Number__c = '31',Customer_Type__c = 'PY-Payer');

SAP_Plant__c sp = new SAP_Plant__c(Next_Day_Orders_Sat__c = 'test',Plant_Name__c = '');
insert sp;
List<SAP_Plant__c> plantList = new List<SAP_Plant__c>();
 plantList.add(sp);
}

static testMethod void myUnitTest() {
init();
List<Bracketed_Pricing__c> bplist = new List<Bracketed_Pricing__c>();
Test.setCurrentPage(Page.PriceSupportRequestRebateView);
Test.setCurrentPage(Page.PriceSupportRequestUpfrontView);

//ApexPages.currentPage().getParameters().put('rid',rtmap.get('Rebate').getrecordtypeid());
ApexPages.StandardController con = new ApexPages.StandardController(priceSupport1);
ext = new PriceSupportExtensionRequest(con);
ext.recordtype = 'test';
ext.region = 'test1';
ext.subtitle = 'test2';
ext.displayPopUp = true;
ext.exiprationFlag = true;
ext.conditionalPopUp = false;
ext.insertFlag = true;
ext.isDisplay = true;
ext.reviewFlag = false;
ext.Supplier_Sales_Contact_Req = true;
ext.Competitor_Manufacturer_Req = true;
ext.Competitive_Product_Req = false;
ext.OEM_Req= true;
ext.Potential_Annual_Volume_Req = true;
ext.Application_Req = false;
ext.Market_Segment_Req = true;
ext.cancelFlag= true;
ext.declineFlag = false;

ext.getSupplierDmContactNameList();
ext.getTerritoryList();
ext.getPricingList();
ext.supplierCheck();
ext.setPricingList(bplist);

}
static testMethod void myUnitTest1(){
myUnitTest();
        Test.startTest();
        ext.comments=null;
        ApexPages.currentPage().getParameters().put('Supplier','true');
        ext.customsave();
        ext.customedit();
        ApexPages.currentPage().getParameters().put('materialId',material.Id);
        ApexPages.currentPage().getParameters().put('materialType','Selling');
        ApexPages.currentPage().getParameters().put('materialType','Buying');
        ext.populateMaterialData();
        ApexPages.currentPage().getParameters().put('supplierProfile',supplierProfile.name);
        ext.getPricing();
        ApexPages.currentPage().getParameters().put('supplierProfile','');
        ext.getPricing();
        Test.stopTest();
}
static testMethod void myUnitTest2(){
        myUnitTest();
        Test.startTest();
        ApexPages.currentPage().getParameters().put('customerId','');
        ApexPages.currentPage().getParameters().put('custType','Payer');
        ApexPages.currentPage().getParameters().put('soldToId','');
        ApexPages.currentPage().getParameters().put('payerNo','');
        
        ext.getCustomerDetails();
        ext.setSalesGroup('customerId','Payer');
        ApexPages.currentPage().getParameters().put('customerId','123456');
        ApexPages.currentPage().getParameters().put('custType','Payer');
        ApexPages.currentPage().getParameters().put('soldToId','123456');
        ApexPages.currentPage().getParameters().put('payerNo','123456');
        ApexPages.currentPage().getParameters().put('region','ECA');
        ApexPages.currentPage().getParameters().put('allRegionVal','true');
        ext.getHub();
        ext.getPlantCode();
        ext.getPlants();
        ext.nullCheck(12.23);
        ext.nullCheck('test');
        ext.getRegionDetails();
        ext.validate();
        Test.stopTest();
        
        }
}