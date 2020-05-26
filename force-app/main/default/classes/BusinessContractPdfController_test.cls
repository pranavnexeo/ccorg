@isTest()
public class BusinessContractPdfController_test {
    
    Public static testmethod void pdfCntrl(){

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
        
        Business_Contract_Agreement_Data__c bca = new Business_Contract_Agreement_Data__c();
        bca.Name = 'Short Term Canada- 45 Days';
        //bca.First_Block__c = 'Test';
        bca.Second_Block__c = 'Test';
        bca.Terms_1__c = 'Test';
        bca.Terms_2__c = 'Test';
        bca.Terms_3__c = 'Test';
        bca.Terms_4__c = 'Test';
        insert bca;

        test.startTest();
        
        ApexPages.standardcontroller sc = new ApexPages.standardcontroller(bc);
        BusinessContractPdfController cc = new BusinessContractPdfController(sc);
        test.stopTest();
        
          
       
     
  }


}