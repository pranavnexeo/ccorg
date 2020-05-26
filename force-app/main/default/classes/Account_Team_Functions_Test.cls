@isTest

public class Account_Team_Functions_Test {

Public static testmethod void accteamfunc(){

            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      
       User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true);
             insert u;

           List<Account> acclist = new List<Account>();
            Account a = new Account(Name = 'test',type = 'Customer');
            acclist.add(a);
            insert acclist;
            
            
       List<AccountTeamMember> atmlist = new List<AccountTeamMember>();
            AccountTeamMember atm = new AccountTeamMember(AccountId = a.id, UserId = u.id,  TeamMemberRole = 'Seller(Info)');
            atmlist.add(atm);
            insert atmlist;
            
          Material_Sales_Data2__c matlist = new Material_Sales_Data2__c(name = 'Test Material', Material_Number__c = '12344321', Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',   Record_Key__c = 'Test Record Key');        
        insert matlist;
        
        Account_Material__c acmt = new Account_Material__c(Account__c=acclist[0].id,SAP_Material__c = matlist.id,SAP_Data__c = '{"tbl_target_prices":[{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"1.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.5501 ","exception2_price":"1.3951","exception2_pct":null,"exception1_price":"1.5036","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"4.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.4701 ","exception2_price":"1.3231","exception2_pct":null,"exception1_price":"1.4260","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"10.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.3701 ","exception2_price":"1.2331","exception2_pct":null,"exception1_price":"1.3290","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"40.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.3701 ","exception2_price":"1.2331","exception2_pct":null,"exception1_price":"1.3290","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null}],"tbl_sales_units":[{"sales_unit":"DR","numerator":"192 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"KG","numerator":"1 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"L","numerator":"10000 ","material_nbr":"000000000000020331","denominator":"10834 ","base_unit":"KG"},{"sales_unit":"LB","numerator":"32523 ","material_nbr":"000000000000020331","denominator":"71701 ","base_unit":"KG"},{"sales_unit":"PAL","numerator":"768 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"RCU","numerator":"192 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"GAL","numerator":"59146 ","material_nbr":"000000000000020331","denominator":"15625 ","base_unit":"L"}],"tbl_list_prices":null,"tbl_csp_prices":[{"csp_volume":"1.000 ","csp_uom":"LB","csp_scale_uom":"DR","csp_price_unit":"1 ","csp_price_protection_desc":"No Protection","csp_price_protection_code":"Z0","csp_price":"1.3000 ","csp_expiration_date":"20141031","csp_effective_date":"20131031","csp_drum_deposit_code":"","csp_currency":"USD4","csp_condition_nbr":"0037819378"}],"supplier":null,"sub_region":null,"specialty":null,"special_product":null,"sold_to":"0000094713","ship_to":"0000094713","sfdc_material_id":"","sfdc_account_id":"a56M0000000024YIAQ","sales_unit":"DR","sales_org":null,"return_type":"S","return_message":"Price generated successfully","quantity":null,"product_cluster":null,"pricing_industry":null,"plm":null,"material_nbr":"000000000000020331","lbs_unit":"","division":null,"distr_chan":null,"customer_size":null,"business_line":"","base_price_uom":null,"base_price_unit":null,"base_price_currency":null,"base_price":null,"base_code":null,"avg_order_unit":"DR","avg_order_qty":"3.000 "}');
        insert acmt;
        
        Account_Team_Functions.createSharingRecordsNeXpriceCPI(atmlist,true);
        Account_Team_Functions.createSharingRecordsNeXpriceCPI(atmlist,false);
 }
 
   Public static testmethod void BusinessContract(){
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      
       User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true);
             insert u;
    List<Account> acclist = new List<Account>();
            Account a = new Account(Name = 'test',type = 'Customer');
            acclist.add(a);
            insert acclist;
            
              
            
       List<AccountTeamMember> atmlist = new List<AccountTeamMember>();
            AccountTeamMember atm = new AccountTeamMember(AccountId = acclist[0].id, UserId = u.id,  TeamMemberRole = 'Seller(Info)');
            atmlist.add(atm);
            insert atmlist;
   
   Business_Contract__c bc = new Business_Contract__c();
      bc.Customer_Name__c = acclist[0].Id;
      insert bc;
      
      Account_Team_Functions.createSharingRecordsBusinessContract(atmlist,true);
        Account_Team_Functions.createSharingRecordsBusinessContract(atmlist,false);
      
 }  
 
 Public static testmethod void RDRequest(){
 Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      
       User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true);
             insert u;
    List<Account> acclist = new List<Account>();
    Map<String,Schema.RecordTypeInfo> rtMap = Schema.SObjectType.R_D_Requests__c.getRecordTypeInfosByName();
            Account a = new Account(Name = 'test',type = 'Customer');
            acclist.add(a);
            insert acclist;
            
               
            
       List<AccountTeamMember> atmlist = new List<AccountTeamMember>();
            AccountTeamMember atm = new AccountTeamMember(AccountId = acclist[0].id, UserId = u.id,  TeamMemberRole = 'Seller(Info)');
            atmlist.add(atm);
            insert atmlist;
   
    R_D_Requests__c rdr = new R_D_Requests__c(Customer__c = acclist[0].id, Requestor__c = u.id, Stage__c = 'Stage 0 - Initiate',RecordtypeId = rtMap.get('Customer – Stage 0 Concept').getrecordtypeid());
            insert rdr;
      
      Account_Team_Functions.createSharingRecordsRDRequest(atmlist,true);
        Account_Team_Functions.createSharingRecordsRDRequest(atmlist,false);
      
 }
 Public static testmethod void SampleAnalysisReq(){
  Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      
       User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true);
             insert u;
    List<Account> acclist = new List<Account>();
    Map<String,Schema.RecordTypeInfo> rtMap = Schema.SObjectType.R_D_Requests__c.getRecordTypeInfosByName();
            Account a = new Account(Name = 'test',type = 'Customer');
            acclist.add(a);
            insert acclist;
            
              
            
       List<AccountTeamMember> atmlist = new List<AccountTeamMember>();
            AccountTeamMember atm = new AccountTeamMember(AccountId = acclist[0].id, UserId = u.id,  TeamMemberRole = 'Seller(Info)');
            atmlist.add(atm);
            insert atmlist;
   
    Sample_Analysis_Request__c  SAR = new Sample_Analysis_Request__c (Customer__c = acclist[0].id,Requested_by__c = u.id, Sample_Name__c = 'test');
    insert SAR;
      
      Account_Team_Functions.createSharingRecordsSampleAnalysisReq(atmlist,true);
        Account_Team_Functions.createSharingRecordsSampleAnalysisReq(atmlist,false);
      
 }
 Public static testmethod void SalesChurn(){
 Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      
       User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true);
             insert u;

           List<Account> acclist = new List<Account>();
            Account a = new Account(Name = 'test',type = 'Customer');
            acclist.add(a);
            insert acclist;
            
       List<AccountTeamMember> atmlist = new List<AccountTeamMember>();
            AccountTeamMember atm = new AccountTeamMember(AccountId = a.id, UserId = u.id,  TeamMemberRole = 'Seller(Info)');
            atmlist.add(atm);
            insert atmlist;
            
            Material_Sales_Data2__c matlist = new Material_Sales_Data2__c(name = 'Test Material', Material_Number__c = '12344321', Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',   Record_Key__c = 'Test Record Key');        
        insert matlist;
        
         SalesChurn__c SC = new SalesChurn__c (Account_Number__c = acclist[0].id,Material_Code__c = matlist.id, Reason__c = 'Demand');
        
        Account_Team_Functions.createSharingRecordsSalesChurn(atmlist,true);
        Account_Team_Functions.createSharingRecordsSalesChurn(atmlist,false);
 }
 
   Public static testmethod void ChemLabReport(){
   
               Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      
       User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true);
             insert u;
    List<Account> acclist = new List<Account>();
            Account a = new Account(Name = 'test',type = 'Customer');
            acclist.add(a);
            insert acclist;
            
              
            
            Set<Id> id = new Set<Id>();
       List<AccountTeamMember> atmlist = new List<AccountTeamMember>();
            AccountTeamMember atm = new AccountTeamMember(AccountId = acclist[0].id, UserId = u.id,  TeamMemberRole = 'Seller(Info)');
            atmlist.add(atm);
            insert atmlist;
            
            Sample_Analysis_Request__c  SAR = new Sample_Analysis_Request__c (Customer__c = acclist[0].id,Requested_by__c = u.id, Sample_Name__c = 'test');
    insert SAR;
   
   Competitive_Analysis_Report__c CAR = new Competitive_Analysis_Report__c(Lab_Number__c = SAR.id);
      
      Account_Team_Functions.createSharingRecordsChemLabReport(atmlist,true);
        Account_Team_Functions.createSharingRecordsChemLabReport(atmlist,false);
        Account_Team_Functions.createSharingRecordsBusinessContractFuture(id,true,'test');
      
 }  
}