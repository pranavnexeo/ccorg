/*
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
private class MaterialSuppliersaleagroupsync_Test {

        static Material_Sales_Data2__c material;
        static Supplier_Profile__c supplierProfile;
        static Price_Support__c priceSupport1;
        static Supplier_Group__c supplierGroup;
        static User nexeoMainApprover;
        static User supplierMainApprover;
        static Nexeo_Member__c nexeoMember;
        static Supplier_Member__c supplierMember;
        static Nexeo_Group__c nexeoGroup;
        
        public static testMethod void  PriceSupportfieldsync_Test(){
            
        Map<String, SObject> testData = NexeoTestUtils_Test.initData();    
        id ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhssdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123sd002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        Account acct = new Account(name='TestAccount',SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Vendor',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA',SAP_SalesGroup__c='345');
        insert acct;
        
        Profile profile = [select id from profile where name='System Administrator'];
        
        material = new Material_Sales_Data2__c(name='Test Material',Sales_Org_Code__c='1234',Record_key__c='Test',Dist_Channel_Code__c='30',Material_Number__c='12345',Material_Base_Code__c='123423');
        insert material;
        
        supplierProfile = new Supplier_Profile__c(Required_Fields__c='Supplier Sales Contact,Competitor Manufacturer,Competitive Product,OEM,Potential Annual Volume,Application,Market Segment',Division_Name__c='Plastic',Purchasing_Organization__c='1000',Price_Changes_Automatically_Approved__c=False,of_rows_for_Bracketed_Pricing__c=2,Supplier_Name__c=acct.Id,X1st_Discount__c=0.7,X2nd_Discount__c=2.3,Comments__c='Testing',Vendor_PI__c='45321');
        insert supplierProfile;
        
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
        
        supplierGroup = new Supplier_Group__c(Group_Name__c='Test Supplier Group',Supplier_Profile__c=supplierProfile.Id,Main_Approver__c=supplierMainApprover.Id,Send_Email__c = True);
        insert supplierGroup;
        
        nexeoGroup = new Nexeo_Group__c(Group_Name__c='Test Nexeo Group',Division_Name__c='Plastic',Main_Approver__c=nexeoMainApprover.Id,Send_E_Mail__c= True);
        
        insert nexeoGroup;
        
        nexeoGroup = [select Id,Name,Main_Approver__c,Division_Name__c from Nexeo_Group__c where Group_Name__c='Test Nexeo Group'];
        
        nexeoMember = new Nexeo_Member__c(Name__c=nexeoMainApprover.Id,Nexeo_Group__c=nexeoGroup.Id,Supplier_Group__c=supplierGroup.Id,Approver__c  = True);
        
        insert nexeoMember;
        
        supplierMember = new Supplier_Member__c(Name__c=supplierMainApprover.Id,Supplier_Group__c=supplierGroup.Id,Approver__c  = True);
        
        insert supplierMember;
        
        supplierGroup = [select Id,Name,Main_Approver__c from Supplier_Group__c where Group_Name__c='Test Supplier Group'];
        priceSupport1 = new Price_Support__c(Supplier_Profile_ID__c = supplierProfile.Id,Purchasing_Organization__c='1000',Supplier_Group__c=supplierGroup.Id,Support_Type__c='Rebate',
            Nexeo_Group__c=nexeoGroup.Id,Status__c='Approved',Customer_Soldto__c = acct.Id,Flat_or_Purchased__c='Purchased',Division_Name__c='Plastic',Nexeo_Main_Approver__c=nexeoMainApprover.Id,Supplier_Main_Approver__c=supplierMainApprover.Id,
            Lotus_Notes_Document_Id__c='Test',Material_Buying__c=material.id,Material_Selling__c=material.id);
            
            insert priceSupport1;
            acct.SAP_SalesGroup__c='234';
            supplierProfile.Vendor_PI__c='12345';
            material.Material_Number__c='56437';   
   try
   {
    update acct;
    update supplierProfile;
    update material;
   }
  Catch(Exception e)
   {
  system.debug('Some Error Message:'+e);
   }
   Update_PriceSuppMaterialFields_Records con=new Update_PriceSuppMaterialFields_Records();
   con.update_Method();
   Update_PriceSuppforSuppProf_Records con1=new Update_PriceSuppforSuppProf_Records();
   con1.update_Method();
   Update_PriceSupport_Records con2=new  Update_PriceSupport_Records();
    con2.update_Method();    
 }
}