@isTest

Private class Updateuser_Test{

    Private static testMethod void UpdateUser_isCommodity(){
     Map<String, SObject> testData = NexeoTestUtils_Test.initData();
       Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      
       User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true);
             insert u;
             
             SAP_Seller__c s = new SAP_Seller__c(Name = 'test', user__c = u.id);
              insert s; 
             
             SAP_Territory__c ST = new SAP_Territory__c(Name = 'test', ZS_Partner__c = s.id, YS_Partner__c = s.id);
             insert ST;

        Account acct = new Account
           (name='TestAccount',
           SAP_Vendor_Purchase_Org__c='1000',
           SAP_Supplier_Number__c='123456',
           VendorUniqueId__c='1234561000',
           Type='Vendor',
           SAP_Accounting_Group__c='ZVEN',
           SAP_PartnerFunctionCodeText__c='123456',
           SAP_PartnerFunctionText__c='ZA',
           YY_Partner__c = ST.id , 
           SAP_Customer_Group_2_Desc__c = 'COMMODITY',
           AccountNumber='123');
           insert acct;
    
           
        Material_Sales_Data2__c matlist = new Material_Sales_Data2__c(name = 'Test Material', Material_Group3_Desc__c = 'COMMODITY', Material_Number__c = '12344321', Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',   Record_Key__c = 'Test Record Key');        
        insert matlist;
        
        Account_Material__c acmt = new Account_Material__c(Account__c=acct.id,SAP_Material__c = matlist.id,SAP_Data__c = '{"tbl_target_prices":[{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"1.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.5501 ","exception2_price":"1.3951","exception2_pct":null,"exception1_price":"1.5036","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"4.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.4701 ","exception2_price":"1.3231","exception2_pct":null,"exception1_price":"1.4260","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"10.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.3701 ","exception2_price":"1.2331","exception2_pct":null,"exception1_price":"1.3290","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"40.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.3701 ","exception2_price":"1.2331","exception2_pct":null,"exception1_price":"1.3290","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null}],"tbl_sales_units":[{"sales_unit":"DR","numerator":"192 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"KG","numerator":"1 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"L","numerator":"10000 ","material_nbr":"000000000000020331","denominator":"10834 ","base_unit":"KG"},{"sales_unit":"LB","numerator":"32523 ","material_nbr":"000000000000020331","denominator":"71701 ","base_unit":"KG"},{"sales_unit":"PAL","numerator":"768 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"RCU","numerator":"192 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"GAL","numerator":"59146 ","material_nbr":"000000000000020331","denominator":"15625 ","base_unit":"L"}],"tbl_list_prices":null,"tbl_csp_prices":[{"csp_volume":"1.000 ","csp_uom":"LB","csp_scale_uom":"DR","csp_price_unit":"1 ","csp_price_protection_desc":"No Protection","csp_price_protection_code":"Z0","csp_price":"1.3000 ","csp_expiration_date":"20141031","csp_effective_date":"20131031","csp_drum_deposit_code":"","csp_currency":"USD4","csp_condition_nbr":"0037819378"}],"supplier":null,"sub_region":null,"specialty":null,"special_product":null,"sold_to":"0000094713","ship_to":"0000094713","sfdc_material_id":"","sfdc_account_id":"a56M0000000024YIAQ","sales_unit":"DR","sales_org":null,"return_type":"S","return_message":"Price generated successfully","quantity":null,"product_cluster":null,"pricing_industry":null,"plm":null,"material_nbr":"000000000000020331","lbs_unit":"","division":null,"distr_chan":null,"customer_size":null,"business_line":"","base_price_uom":null,"base_price_unit":null,"base_price_currency":null,"base_price":null,"base_code":null,"avg_order_unit":"DR","avg_order_qty":"3.000 "}');
        insert acmt;
    
                             
           Price_Request_Transaction__c PRT = new Price_Request_Transaction__c
                (Inner_Table__c='Test',Account_Material__c=acmt.id,SAP_Material__c = matlist.id,Ship_To__c=acct.id,Sold_To__c=acct.id, Approval_Status__c='Rejected with Alternate',Type__c='CSP');    
            insert PRT;
        }
        
        Private static testMethod void UpdateUser_isSpeciality(){
    Map<String, SObject> testData = NexeoTestUtils_Test.initData();
       Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      
       User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true);
             insert u;
             
             SAP_Seller__c s = new SAP_Seller__c(Name = 'test', user__c = u.id);
              insert s; 
             
             SAP_Territory__c ST = new SAP_Territory__c(Name = 'test', ZS_Partner__c = s.id, YS_Partner__c = s.id);
             insert ST;

        Account acct = new Account
           (name='TestAccount',
           SAP_Vendor_Purchase_Org__c='1000',
           SAP_Supplier_Number__c='123456',
           VendorUniqueId__c='1234561000',
           Type='Vendor',
           SAP_Accounting_Group__c='ZVEN',
           SAP_PartnerFunctionCodeText__c='123456',
           SAP_PartnerFunctionText__c='ZA',
           YZ_Partner__c = ST.id , 
           SAP_Customer_Group_2_Desc__c = 'SPECIALTY',
           AccountNumber='123');
           insert acct;
    
           
        Material_Sales_Data2__c matlist = new Material_Sales_Data2__c(name = 'Test Material', Material_Number__c = '12344321', Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000', Material_Group3_Desc__c = 'SPECIALTY',  Record_Key__c = 'Test Record Key');        
        insert matlist;
        
        Account_Material__c acmt = new Account_Material__c(Account__c=acct.id,SAP_Material__c = matlist.id,SAP_Data__c = '{"tbl_target_prices":[{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"1.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.5501 ","exception2_price":"1.3951","exception2_pct":null,"exception1_price":"1.5036","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"4.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.4701 ","exception2_price":"1.3231","exception2_pct":null,"exception1_price":"1.4260","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"10.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.3701 ","exception2_price":"1.2331","exception2_pct":null,"exception1_price":"1.3290","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"40.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.3701 ","exception2_price":"1.2331","exception2_pct":null,"exception1_price":"1.3290","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null}],"tbl_sales_units":[{"sales_unit":"DR","numerator":"192 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"KG","numerator":"1 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"L","numerator":"10000 ","material_nbr":"000000000000020331","denominator":"10834 ","base_unit":"KG"},{"sales_unit":"LB","numerator":"32523 ","material_nbr":"000000000000020331","denominator":"71701 ","base_unit":"KG"},{"sales_unit":"PAL","numerator":"768 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"RCU","numerator":"192 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"GAL","numerator":"59146 ","material_nbr":"000000000000020331","denominator":"15625 ","base_unit":"L"}],"tbl_list_prices":null,"tbl_csp_prices":[{"csp_volume":"1.000 ","csp_uom":"LB","csp_scale_uom":"DR","csp_price_unit":"1 ","csp_price_protection_desc":"No Protection","csp_price_protection_code":"Z0","csp_price":"1.3000 ","csp_expiration_date":"20141031","csp_effective_date":"20131031","csp_drum_deposit_code":"","csp_currency":"USD4","csp_condition_nbr":"0037819378"}],"supplier":null,"sub_region":null,"specialty":null,"special_product":null,"sold_to":"0000094713","ship_to":"0000094713","sfdc_material_id":"","sfdc_account_id":"a56M0000000024YIAQ","sales_unit":"DR","sales_org":null,"return_type":"S","return_message":"Price generated successfully","quantity":null,"product_cluster":null,"pricing_industry":null,"plm":null,"material_nbr":"000000000000020331","lbs_unit":"","division":null,"distr_chan":null,"customer_size":null,"business_line":"","base_price_uom":null,"base_price_unit":null,"base_price_currency":null,"base_price":null,"base_code":null,"avg_order_unit":"DR","avg_order_qty":"3.000 "}');
        insert acmt;
    
                             
           Price_Request_Transaction__c PRT = new Price_Request_Transaction__c
                (Inner_Table__c='Test',Account_Material__c=acmt.id,Ship_To__c=acct.id,SAP_Material__c = matlist.id,Sold_To__c=acct.id, Approval_Status__c='Rejected with Alternate',Type__c='CSP');    
            insert PRT;
        }
}