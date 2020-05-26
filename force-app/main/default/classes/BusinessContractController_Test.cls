@isTest()
public class BusinessContractController_Test {
    
    Public static testmethod void cntrlerTest(){

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
           SAP_Sales_Org__c = '1700',
           AccountNumber='123');
           insert acct;
            
       List<AccountTeamMember> atmlist = new List<AccountTeamMember>();
            AccountTeamMember atm = new AccountTeamMember(AccountId = acct.id, UserId = u.id,  TeamMemberRole = 'Seller(Info)');
            atmlist.add(atm);
            insert atmlist;
         
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
        
       Business_Contract__c bc = new Business_Contract__c();
       bc.Customer_Name__c = acct.Id;
       bc.Contract_Type__c = 'High Risk Inventory Agreement';
       bc.Agreement__c = 'Short Term Canada- 45 Days';
       insert bc;
        
        Contract cot = new Contract(StartDate = system.today().addDays(2), status = 'Draft', Buyer_Comments__c = 'New contract creation',OwnerExpirationNotice = '120',AccountId = acct.id, OwnerId = u.id,Forecasted_Quantity__c = 1234.123,Per__c = 'Month', Stocking_Unit__c = 'BAGS',Ashland_Supplier__c = 'Acidchem', Stocking_Warehouse__c = '0004 - Edmonton', SAP_Material__c = mm.id  );
        cotlist.add(cot);
        insert cotlist;

        test.startTest();
        PageReference pageRef = Page.BusinessContractPage;
        pageRef.getParameters().put('contractId',cot.id);
        Test.setCurrentPage(pageRef);
        
        ApexPages.standardcontroller sc = new ApexPages.standardcontroller(bc);
        BusinessContractController cc = new BusinessContractController(sc);
        cc.saveBusinessContract();
        cc.cancel();
        test.stopTest();
        
    }
    
    Public static testmethod void cntrlerTest_1(){

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
       Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution Customer').getRecordTypeId();       
           Account acct1s = new Account
           (name='TestAccount',
           SAP_Vendor_Purchase_Org__c='1700',
           SAP_Supplier_Number__c='123456',
           VendorUniqueId__c='1234561000',
           Type='Customer',
           SAP_Accounting_Group__c='ZVEN',
           SAP_PartnerFunctionCodeText__c='123456',
           SAP_PartnerFunctionText__c='ZA',
           YZ_Partner__c = ST.id , 
           SAP_Customer_Group_2_Desc__c = 'Primary Specialty',
           AccountNumber='123',
           SAP_Sales_Org__c ='1700',
           RecordTypeId = devRecordTypeId);
           insert acct1s;
            system.debug('a sales org'+acct1s.SAP_Sales_Org__c);
       List<AccountTeamMember> atmlist = new List<AccountTeamMember>();
            AccountTeamMember atm = new AccountTeamMember(AccountId = acct1s.id, UserId = u.id,  TeamMemberRole = 'Seller(Info)');
            atmlist.add(atm);
            insert atmlist;
         
      SAP_Plant__c sp = new SAP_Plant__c();
        sp.Plant_Code__c = plant;
        insert sp;     
       
        SAP_Purchasing_Group__c spg = new SAP_Purchasing_Group__c (Purchasing_Group_Code__c = '123', Name = 'test', User__c = u.id);
        insert spg;
        
        Material_Plant2__c mp2 = new Material_Plant2__c(Record_Key__c = matnum+plant, Material_Number__c = matnum, Plant_Code__c = plant, SalesOrg_Code__c = '1700', SAP_Purchasing_Analyst__c = spg.id);
        system.debug('mp2: ' + mp2);
        insert mp2;
        
        Material_Sales_Data2__c mm = new Material_Sales_Data2__c(Name = 'test material', Material_Number__c = matnum, Dist_Channel_Code__c = '30',Sales_Org_Code__c = '1700',Record_Key__c = '123456789012345');
        system.debug('mm:' +mm);
        insert mm;
        
       Business_Contract__c bc = new Business_Contract__c();
       bc.Customer_Name__c = acct1s.Id;
       bc.Contract_Type__c = 'High Risk Inventory Agreement';
       bc.Agreement__c = 'Short Term Canada- 45 Days';
       //insert bc;
        
        Contract cot = new Contract(StartDate = system.today().addDays(2), status = 'Draft', Buyer_Comments__c = 'New contract creation',OwnerExpirationNotice = '120',AccountId = acct1s.id, OwnerId = u.id,Forecasted_Quantity__c = 1234.123,Per__c = 'Month', Stocking_Unit__c = 'BAGS',Ashland_Supplier__c = 'Acidchem', Stocking_Warehouse__c = '0004 - Edmonton', SAP_Material__c = mm.id  );
        cotlist.add(cot);
        insert cotlist;

        test.startTest();
        
        PageReference pageRef = Page.BusinessContractPage;
        pageRef.getParameters().put('contractId',cot.id);
        Test.setCurrentPage(pageRef);

        ApexPages.standardcontroller sc = new ApexPages.standardcontroller(bc);
        BusinessContractController cc = new BusinessContractController(sc);
        cc.cancel();
        cc.saveBusinessContract();
        
        test.stopTest();
        
    }
    
    Public static testmethod void cntrlerTest_2(){

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
    Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution Customer').getRecordTypeId();          
           Account acct1 = new Account
           (name='TestAccount',
           SAP_Vendor_Purchase_Org__c='1700',
           SAP_Supplier_Number__c='123456',
           VendorUniqueId__c='1234561000',
           Type='Customer',
           SAP_Accounting_Group__c='ZVEN',
           SAP_PartnerFunctionCodeText__c='123456',
           SAP_PartnerFunctionText__c='ZA',
           YZ_Partner__c = ST.id , 
           SAP_Customer_Group_2_Desc__c = 'Primary Specialty',
           AccountNumber='123',
           SAP_Sales_Org__c ='1700',
           RecordTypeId = devRecordTypeId);
           insert acct1;
        system.debug(acct1);
            
       List<AccountTeamMember> atmlist = new List<AccountTeamMember>();
            AccountTeamMember atm = new AccountTeamMember(AccountId = acct1.id, UserId = u.id,  TeamMemberRole = 'Seller(Info)');
            atmlist.add(atm);
            insert atmlist;
         
      SAP_Plant__c sp = new SAP_Plant__c();
        sp.Plant_Code__c = plant;
        insert sp;     
       
        SAP_Purchasing_Group__c spg = new SAP_Purchasing_Group__c (Purchasing_Group_Code__c = '123', Name = 'test', User__c = u.id);
        insert spg;
        
        Material_Plant2__c mp2 = new Material_Plant2__c(Record_Key__c = matnum+plant, Material_Number__c = matnum, Plant_Code__c = plant, SalesOrg_Code__c = '1700', SAP_Purchasing_Analyst__c = spg.id);
        system.debug('mp2: ' + mp2);
        insert mp2;
        
        Material_Sales_Data2__c mm = new Material_Sales_Data2__c(Name = 'test material', Material_Number__c = matnum, Dist_Channel_Code__c = '30',Sales_Org_Code__c = '1700',Record_Key__c = '123456789012345');
        system.debug('mm:' +mm);
        insert mm;
        
       Business_Contract__c bc = new Business_Contract__c();
       bc.Customer_Name__c = acct1.Id;
       bc.Contract_Type__c = 'High Risk Inventory Agreement';
       bc.Agreement__c = 'Short Term Canada- 45 Days';
       insert bc;
        
        Contract cot = new Contract(StartDate = system.today().addDays(2), status = 'Draft', Buyer_Comments__c = 'New contract creation',OwnerExpirationNotice = '120',AccountId = acct1.id, OwnerId = u.id,Forecasted_Quantity__c = 1234.123,Per__c = 'Month', Stocking_Unit__c = 'BAGS',Ashland_Supplier__c = 'Acidchem', Stocking_Warehouse__c = '0004 - Edmonton', SAP_Material__c = mm.id  );
        system.debug(cot);
        cotlist.add(cot);
        insert cotlist;

        test.startTest();
        
        PageReference pageRef = Page.BusinessContractPage;
        pageRef.getParameters().put('clone','1');
        Test.setCurrentPage(pageRef);

        ApexPages.standardcontroller sc = new ApexPages.standardcontroller(bc);
        BusinessContractController cc = new BusinessContractController(sc);
        cc.cancel();
        cc.saveBusinessContract();
        
        test.stopTest();
        
    }

}