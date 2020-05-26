@isTest

public class Updateworkflowuser_Test {

Public static testmethod void Commodity_ZSPartner(){

               
       Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      
       User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true);
             insert u;
             
             SAP_Seller__c s = new SAP_Seller__c(Name = 'test', user__c = u.id);
              insert s; 
             
             SAP_Territory__c ST = new SAP_Territory__c(Name = 'test', ZS_Partner__c = s.id);
             insert ST;
              
           Account acct = new Account
           (name='TestAccount',
           SAP_Vendor_Purchase_Org__c='1000',
           SAP_Supplier_Number__c='123456',
           VendorUniqueId__c='1234561000',
           Type='Customer',
           SAP_Accounting_Group__c='ZVEN',
           SAP_PartnerFunctionCodeText__c='123456',
           SAP_PartnerFunctionText__c='ZA',
           YY_Partner__c = ST.id , 
           SAP_Customer_Group_2_Desc__c = 'Primary Commodity',
            SAP_Customer_Group_2__c = 'COM',
           AccountNumber='123');
           insert acct;
            
       List<AccountTeamMember> atmlist = new List<AccountTeamMember>();
            AccountTeamMember atm = new AccountTeamMember(AccountId = acct.id, UserId = u.id,  TeamMemberRole = 'Seller(Info)');
            atmlist.add(atm);
            insert atmlist;
   
       Business_Contract__c bc = new Business_Contract__c();
       bc.Customer_Name__c = acct.id;
       insert bc;     
          
       }
       
       Public static testmethod void Commodity_YSPartner(){

               
       Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      
       User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true);
             insert u;
             
             SAP_Seller__c s = new SAP_Seller__c(Name = 'test', user__c = u.id);
              insert s; 
             
             SAP_Territory__c ST = new SAP_Territory__c(Name = 'test', YS_Partner__c = s.id);
             insert ST;
              
           Account acct = new Account
           (name='TestAccount',
           SAP_Vendor_Purchase_Org__c='1000',
           SAP_Supplier_Number__c='123456',
           VendorUniqueId__c='1234561000',
           Type='Customer',
           SAP_Accounting_Group__c='ZVEN',
           SAP_PartnerFunctionCodeText__c='123456',
           SAP_PartnerFunctionText__c='ZA',
           YY_Partner__c = ST.id , 
           SAP_Customer_Group_2_Desc__c = 'Primary Commodity',
            SAP_Customer_Group_2__c = 'COM',
           AccountNumber='123');
           insert acct;
            
       List<AccountTeamMember> atmlist = new List<AccountTeamMember>();
            AccountTeamMember atm = new AccountTeamMember(AccountId = acct.id, UserId = u.id,  TeamMemberRole = 'Seller(Info)');
            atmlist.add(atm);
            insert atmlist;
   
       Business_Contract__c bc = new Business_Contract__c();
       bc.Customer_Name__c = acct.id;
       insert bc;     
          
       }
       
       
  Public static testmethod void Speciality_ZSPartner(){

               
       Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      
       User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true);
             insert u;
             
             SAP_Seller__c s = new SAP_Seller__c(Name = 'test', user__c = u.id);
              insert s; 
             
             SAP_Territory__c ST = new SAP_Territory__c(Name = 'test', ZS_Partner__c = s.id);
             insert ST;
              
           Account acct = new Account
           (name='TestAccount',
           SAP_Vendor_Purchase_Org__c='1000',
           SAP_Supplier_Number__c='123456',
           VendorUniqueId__c='1234561000',
           Type='Customer',
           SAP_Accounting_Group__c='ZVEN',
           SAP_PartnerFunctionCodeText__c='123456',
           SAP_PartnerFunctionText__c='ZA',
           YZ_Partner__c = ST.id , 
           SAP_Customer_Group_2_Desc__c = 'Primary Specialty',
            SAP_Customer_Group_2__c = 'SPC',
           AccountNumber='123');
           insert acct;
            
       List<AccountTeamMember> atmlist = new List<AccountTeamMember>();
            AccountTeamMember atm = new AccountTeamMember(AccountId = acct.id, UserId = u.id,  TeamMemberRole = 'Seller(Info)');
            atmlist.add(atm);
            insert atmlist;
   
       Business_Contract__c bc = new Business_Contract__c();
       bc.Customer_Name__c = acct.Id;
       insert bc;
       
          
          
      
     
  }
  
  Public static testmethod void Speciality_YSPartner(){

       List<Contract> cotlist = new List<Contract>();
       String plant = '0004';
       String matnum = '000000000123456789';
       Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      
       User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true);
             insert u;
             
             SAP_Seller__c s = new SAP_Seller__c(Name = 'test', user__c = u.id);
              insert s; 
             
             SAP_Territory__c ST = new SAP_Territory__c(Name = 'test', YS_Partner__c = s.id);
             insert ST;
              
           Account acct = new Account
           (name='TestAccount',
           SAP_Vendor_Purchase_Org__c='1000',
           SAP_Supplier_Number__c='123456',
           VendorUniqueId__c='1234561000',
           Type='Customer',
           SAP_Accounting_Group__c='ZVEN',
           SAP_PartnerFunctionCodeText__c='123456',
           SAP_PartnerFunctionText__c='ZA',
           YZ_Partner__c = ST.id , 
           SAP_Customer_Group_2_Desc__c = 'Primary Specialty',
            SAP_Customer_Group_2__c = 'SPC',
           AccountNumber='123');
           insert acct;
            
       List<AccountTeamMember> atmlist = new List<AccountTeamMember>();
            AccountTeamMember atm = new AccountTeamMember(AccountId = acct.id, UserId = u.id,  TeamMemberRole = 'Seller(Info)');
            atmlist.add(atm);
            insert atmlist;
   
       Business_Contract__c bc = new Business_Contract__c();
       bc.Customer_Name__c = acct.Id;
       insert bc;
      
      SAP_Plant__c sp = new SAP_Plant__c();
        sp.Plant_Code__c = plant;
        insert sp;     
       
        SAP_Purchasing_Group__c spg = new SAP_Purchasing_Group__c (Purchasing_Group_Code__c = '123', Name = 'test', User__c = u.id);
        insert spg;
        
        Material_Plant2__c mp2 = new Material_Plant2__c(Record_Key__c = matnum+plant, Material_Number__c = matnum, Plant_Code__c = plant, SalesOrg_Code__c = '1000', SAP_Purchasing_Analyst__c = spg.id);
        system.debug('mp2: ' + mp2);
        insert mp2;
        
        Material_Sales_Data2__c mm = new Material_Sales_Data2__c(Name = 'test material', Material_Number__c = matnum, Dist_Channel_Code__c = '30',Sales_Org_Code__c = '1000',Record_Key__c = '123456789012345');
        system.debug('mm:' +mm);
        insert mm;
        
        Contract cot = new Contract(StartDate = system.today(), status = 'Draft', Buyer_Comments__c = 'New contract creation',OwnerExpirationNotice = '120',AccountId = acct.id, OwnerId = u.id,Forecasted_Quantity__c = 1234.123,Per__c = 'Month', Stocking_Unit__c = 'BAGS',Ashland_Supplier__c = 'Acidchem', Stocking_Warehouse__c = '0004 - Edmonton', SAP_Material__c = mm.id ,
                                   Business_Contract__c = bc.id);
        cotlist.add(cot);
        insert cotlist;
      
       bc.Status__c = 'Activated';
      update bc;
      
      
          
       
     
  }
  
}