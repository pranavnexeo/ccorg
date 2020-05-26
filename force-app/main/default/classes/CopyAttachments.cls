@isTest
public class CopyAttachments{
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
    static User nexeoMainApprover;
    static User supplierMainApprover;
    static Material_Sales_Data2__c material;
    static Account acct1;
    
static testMethod void testAttachments()
    {
     Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;   
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
            priceSupport1 = new Price_Support__c(Supplier_Profile_ID__c = supplierProfile.Id,Purchasing_Organization__c='1000',Supplier_Group__c=supplierGroup.Id,Support_Type__c='Rebate',
            Nexeo_Group__c=nexeoGroup.Id,Status__c='Approved',Flat_or_Purchased__c='Purchased',Division_Name__c='Plastic',Nexeo_Main_Approver__c=nexeoMainApprover.Id,Supplier_Main_Approver__c=supplierMainApprover.Id,
            Lotus_Notes_Document_Id__c='Test');
            
            insert priceSupport1;
        }
        System.runAs(nexeoMainApprover){
            priceSupport2 = new Price_Support__c(Supplier_Profile_ID__c = supplierProfile.Id,Purchasing_Organization__c='1000',Supplier_Group__c=supplierGroup.Id,Support_Type__c='Upfront',
            Nexeo_Group__c=nexeoGroup.Id,Status__c='Approved',Division_Name__c='Plastic',Nexeo_Main_Approver__c=nexeoMainApprover.Id,Supplier_Main_Approver__c=supplierMainApprover.Id,
            Lotus_Notes_Document_Id__c='Test',Parent_Price_Support__c=priceSupport1.id);
            
            insert priceSupport2;
        }
        Set<Id> parentIdsSet = new Set<Id>();
        parentIdsSet.add(priceSupport1.id);
       // Price_Support__c cse=new Price_Support__c();
       // insert cse;
       // Price_Support__c cse1=new Price_Support__c();
       // insert cse1;
 
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=priceSupport2.id;
        insert attach;
        update priceSupport2;
        List<Attachment> attachments=[select id, name from Attachment where parent.id=:priceSupport2.id];
        System.assertEquals(1, attachments.size());
    }
    }