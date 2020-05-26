@isTest 

public class Update_PriceSuppMaterialFields_test{
    
    public static testMethod void UnitTest(){
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
        
        Material_Sales_Data2__c material = new Material_Sales_Data2__c(name='Test Material',Update_Material__c = true ,Sales_Org_Code__c='1234',Record_key__c='Test',Dist_Channel_Code__c='30',Material_Number__c='12345',Material_Base_Code__c='123423');
        insert material;
        
       Price_Support__c priceSupport = new Price_Support__c(Supplier_Profile_ID__c = supplierProfile.Id,
                                                              Customer_soldto__c = acct.id,
                                                              Customer_Type__c = 'PY-Payer',
                                                              Material_Selling__c = material.id,
                                                              Purchasing_Organization__c='1000',
                                                              Status__c = 'Approved',
                                                              Supplier_Group__c = supplierGroup.Id,
                                                              Support_Type__c = 'Rebate',
                                                              Material_Buying__c = material.id,
                                                              Flat_or_Purchased__c='Purchased',
                                                              Nexeo_Group__c=nexeoGroup.Id,
                                                              Division_Name__c='Plastic',
                                                              Lotus_Notes_Document_Id__c='Test',
                                                              Expiration_Date__c=System.today(),
                                                              Effective_Date__c= System.today(),
                                                              X1st_Discount_Type_Buy__c='%',
            X2nd_Discount_Type_Buy__c='%',X1st_Discount_Type_Sell__c='%',X2nd_Discount_Type_Sell__c='%',Archieved__c=false,Agreement_Number__c='1234',SAP_Transfer__c='Open');
        insert priceSupport;
        
    
      Update_PriceSuppMaterialFields_Records con=new Update_PriceSuppMaterialFields_Records();
   con.update_Method();
       
    }
    
    public static testMethod void testMe(){
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
        
         Material_Sales_Data2__c material = new Material_Sales_Data2__c(name='Test Material',Update_Material__c = true ,Sales_Org_Code__c='1234',Record_key__c='Test',Dist_Channel_Code__c='30',Material_Number__c='12345',Material_Base_Code__c='123423');
        insert material;
        
         Price_Support__c priceSupport1 = new Price_Support__c(Supplier_Profile_ID__c = supplierProfile.Id,
                                                              
                                                              Customer_Type__c = 'PY-Payer',
                                                              Material_Selling__c = material.id,
                                                              Purchasing_Organization__c='1000',
                                                              Status__c = 'Approved',
                                                              Material_Buying__c = material.id,
                                                              Supplier_Group__c = supplierGroup.Id,
                                                              Support_Type__c = 'Upfront',
                                                              Flat_or_Purchased__c='Purchased',
                                                              Nexeo_Group__c=nexeoGroup.Id,
                                                              Division_Name__c='Plastic',
                                                              Lotus_Notes_Document_Id__c='Test',
                                                              Expiration_Date__c=System.today(),
                                                              Effective_Date__c= System.today(),
                                                              X1st_Discount_Type_Buy__c='%',
           Archieved__c=false,Agreement_Number__c='1234');
    insert priceSupport1;
  
    
     Update_PriceSuppMaterialFields_Records con1 = new Update_PriceSuppMaterialFields_Records();
   con1.update_Method();
   }
   public static testMethod void testMe1(){
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
        
         Material_Sales_Data2__c material = new Material_Sales_Data2__c(name='Test Material',Update_Material__c = true ,Sales_Org_Code__c='1234',Record_key__c='Test',Dist_Channel_Code__c='30',Material_Number__c='12345',Material_Base_Code__c='123423');
        insert material;
        
         Price_Support__c priceSupport1 = new Price_Support__c(Supplier_Profile_ID__c = supplierProfile.Id,
                                                              
                                                              Customer_Type__c = 'BP-Bill To',
                                                              Material_Selling__c = material.id,
                                                              Purchasing_Organization__c='1000',
                                                              Status__c = 'Approved',
                                                              Supplier_Group__c = supplierGroup.Id,
                                                              Material_Buying__c = material.id,
                                                              Support_Type__c = 'Rebate',
                                                              Flat_or_Purchased__c='Purchased',
                                                              Nexeo_Group__c=nexeoGroup.Id,
                                                              Division_Name__c='Plastic',
                                                              Lotus_Notes_Document_Id__c='Test',
                                                              Expiration_Date__c=System.today(),
                                                              Effective_Date__c= System.today(),
                                                              X1st_Discount_Type_Buy__c='%',
           Archieved__c=false,Agreement_Number__c='1234');
    insert priceSupport1;
  
    
     Update_PriceSuppMaterialFields_Records con1 = new Update_PriceSuppMaterialFields_Records();
   con1.update_Method();
   }
   public static testMethod void testMe2(){
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
        
         Material_Sales_Data2__c material = new Material_Sales_Data2__c(name='Test Material',Update_Material__c = true ,Sales_Org_Code__c='1234',Record_key__c='Test',Dist_Channel_Code__c='30',Material_Number__c='12345',Material_Base_Code__c='123423');
        insert material;
        
         Price_Support__c priceSupport1 = new Price_Support__c(Supplier_Profile_ID__c = supplierProfile.Id,
                                                              
                                                              Customer_Type__c = 'BP-Bill To',
                                                              Material_Selling__c = material.id,
                                                              Purchasing_Organization__c='1000',
                                                              Status__c = 'Open',
                                                              Supplier_Group__c = supplierGroup.Id,
                                                              Material_Buying__c = material.id,
                                                              Support_Type__c = 'Rebate',
                                                              Flat_or_Purchased__c='Purchased',
                                                              Nexeo_Group__c=nexeoGroup.Id,
                                                              Division_Name__c='Plastic',
                                                              Lotus_Notes_Document_Id__c='Test',
                                                              Expiration_Date__c=System.today(),
                                                              Effective_Date__c= System.today(),
                                                              X1st_Discount_Type_Buy__c='%',
           Archieved__c=false,Agreement_Number__c='1234');
    insert priceSupport1;
  
    
     Update_PriceSuppMaterialFields_Records con1 = new Update_PriceSuppMaterialFields_Records();
   con1.update_Method();
   }
}