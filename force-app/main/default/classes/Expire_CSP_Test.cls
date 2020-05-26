@isTest
//(SeeAllData=true)
public class Expire_CSP_Test{    
    
    public static testMethod void testController() {   
      	PRT_Movement_Settings__c PRTMSetting = new PRT_Movement_Settings__c(Name = '32', Switch__c = true, CG5__c = true);
        insert PRTMSetting;
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution Customer').getRecordTypeId();
        Account acct = new Account(SAP_DivisionCode__c = '32',name='TestAccount',SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Vendor',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA',AccountNumber='123');
        insert acct;
        
        Material_Sales_Data2__c m = new Material_Sales_Data2__c(name = 'Test Material', Material_Number__c = '12344321', Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',   Record_Key__c = 'Test Record Key');        
        insert m;
        
        Account_Material__c am = new Account_Material__c(Account__c=acct.id,SAP_Material__c = m.id,SAP_Data__c = '{"tbl_target_prices":[{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"1.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.5501 ","exception2_price":"1.3951","exception2_pct":null,"exception1_price":"1.5036","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"4.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.4701 ","exception2_price":"1.3231","exception2_pct":null,"exception1_price":"1.4260","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"10.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.3701 ","exception2_price":"1.2331","exception2_pct":null,"exception1_price":"1.3290","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"40.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.3701 ","exception2_price":"1.2331","exception2_pct":null,"exception1_price":"1.3290","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null}],"tbl_sales_units":[{"sales_unit":"DR","numerator":"192 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"KG","numerator":"1 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"L","numerator":"10000 ","material_nbr":"000000000000020331","denominator":"10834 ","base_unit":"KG"},{"sales_unit":"LB","numerator":"32523 ","material_nbr":"000000000000020331","denominator":"71701 ","base_unit":"KG"},{"sales_unit":"PAL","numerator":"768 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"RCU","numerator":"192 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"GAL","numerator":"59146 ","material_nbr":"000000000000020331","denominator":"15625 ","base_unit":"L"}],"tbl_list_prices":null,"tbl_csp_prices":[{"csp_volume":"1.000 ","csp_uom":"LB","csp_scale_uom":"DR","csp_price_unit":"1 ","csp_price_protection_desc":"No Protection","csp_price_protection_code":"Z0","csp_price":"1.3000 ","csp_expiration_date":"20141031","csp_effective_date":"20131031","csp_drum_deposit_code":"","csp_currency":"USD4","csp_condition_nbr":"0037819378"}],"supplier":null,"sub_region":null,"specialty":null,"special_product":null,"sold_to":"0000094713","ship_to":"0000094713","sfdc_material_id":"","sfdc_account_id":"a56M0000000024YIAQ","sales_unit":"DR","sales_org":null,"return_type":"S","return_message":"Price generated successfully","quantity":null,"product_cluster":null,"pricing_industry":null,"plm":null,"material_nbr":"000000000000020331","lbs_unit":"","division":null,"distr_chan":null,"customer_size":null,"business_line":"","base_price_uom":null,"base_price_unit":null,"base_price_currency":null,"base_price":null,"base_code":null,"avg_order_unit":"DR","avg_order_qty":"3.000 "}');
        insert am;
        
        
        Account_Material__c am1 = new Account_Material__c(Account__c=acct.id,SAP_Material__c = m.id,SAP_Data__c = '{"tbl_target_prices":[{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"1.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.5501 ","exception2_price":"1.3951","exception2_pct":null,"exception1_price":"1.5036","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"4.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.4701 ","exception2_price":"1.3231","exception2_pct":null,"exception1_price":"1.4260","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"10.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.3701 ","exception2_price":"1.2331","exception2_pct":null,"exception1_price":"1.3290","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"40.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.3701 ","exception2_price":"1.2331","exception2_pct":null,"exception1_price":"1.3290","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null}],"tbl_sales_units":[{"sales_unit":"DR","numerator":"192 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"KG","numerator":"1 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"L","numerator":"10000 ","material_nbr":"000000000000020331","denominator":"10834 ","base_unit":"KG"},{"sales_unit":"LB","numerator":"32523 ","material_nbr":"000000000000020331","denominator":"71701 ","base_unit":"KG"},{"sales_unit":"PAL","numerator":"768 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"RCU","numerator":"192 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"GAL","numerator":"59146 ","material_nbr":"000000000000020331","denominator":"15625 ","base_unit":"L"}],"tbl_list_prices":null,"tbl_csp_prices":[{"csp_volume":"1.000 ","csp_uom":"LB","csp_scale_uom":"DR","csp_price_unit":"1 ","csp_price_protection_desc":"No Protection","csp_price_protection_code":"Z0","csp_price":"1.3000 ","csp_expiration_date":"20141031","csp_effective_date":"20131031","csp_drum_deposit_code":"","csp_currency":"USD4","csp_condition_nbr":"0037819378"}],"supplier":null,"sub_region":null,"specialty":null,"special_product":null,"sold_to":"0000094713","ship_to":"0000094713","sfdc_material_id":"","sfdc_account_id":"a56M0000000024YIAQ","sales_unit":"DR","sales_org":null,"return_type":"S","return_message":"Price generated successfully","quantity":null,"product_cluster":null,"pricing_industry":null,"plm":null,"material_nbr":"000000000000020331","lbs_unit":"","division":null,"distr_chan":null,"customer_size":null,"business_line":"","base_price_uom":null,"base_price_unit":null,"base_price_currency":null,"base_price":null,"base_code":null,"avg_order_unit":"DR","avg_order_qty":"3.000 "}');
        insert am1;  
        
        String paramID = am.Id + '-' + am1.Id;
        
        Price_Support_Ids__c psID = new Price_Support_Ids__c(
        Ids__c = paramID
        );
        insert psID;
        
        String dateVal = '1393785000000';
        Double d = 1.00;
        Decimal dec = 1.11;
        Price_Request_Transaction__c PRT=new Price_Request_Transaction__c(Account_Material__c=am1.id,Inner_Table__c='Test',CurrencyIsoCode='USD');
        insert PRT; 
        
        Expire_CSP.mockResponse1 = '["' + PRT.Id + '"]';
        
        Map<String,String> map1 = new Map<String,String>();
        map1.put(am.Id,dateVal);
        map1.put(am1.Id,dateVal);
        
        Expire_CSP con = new  Expire_CSP();
        Expire_CSP.ExpiryRequest req = new Expire_CSP.ExpiryRequest();
        req.soldtonumber = 'test';
        req.shiptonumber = 'test1';
        req.salesorg = 'test2';
        req.materialnumber = 'test3';
        req.expiry_date = system.today();
        req.priceprot = 'test4';
        req.distchannel = 'test5';
        req.prtid = 'test15';
        req.drumdep = 'test51';
        
        Expire_CSP.ExpiryResponse res = new  Expire_CSP.ExpiryResponse();
        res.prtid = 'test123';
        res.status = 'test12';
        res.errormessage = 'test13';
        
        Expire_CSP.getRecordsToDisplay(psID.Id);
        Expire_CSP.expirePRT(map1);
        Expire_CSP.validateDate(map1);
        Expire_CSP.stringtodate('19880101');
        Expire_CSP.formatDate(system.today());
        Expire_CSP.Stringtodouble(d);
        Expire_CSP.Stringtodouble(dec);
        Expire_CSP.stringtodouble('1,1-2,2');
        Expire_CSP.getDateFormat();
     }
    
     public static testMethod void testController2() {   
      	PRT_Movement_Settings__c PRTMSetting = new PRT_Movement_Settings__c(Name = '32', Switch__c = true, CG5__c = true);
        insert PRTMSetting;
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution Customer').getRecordTypeId();
        Account acct = new Account(SAP_DivisionCode__c = '32',name='TestAccount',SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Vendor',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA',AccountNumber='123');
        insert acct;
        
        Material_Sales_Data2__c m = new Material_Sales_Data2__c(name = 'Test Material', Material_Number__c = '12344321', Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',   Record_Key__c = 'Test Record Key');        
        insert m;
        
        Account_Material__c am = new Account_Material__c(Account__c=acct.id,SAP_Material__c = m.id,SAP_Data__c = '{"tbl_target_prices":[{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"1.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.5501 ","exception2_price":"1.3951","exception2_pct":null,"exception1_price":"1.5036","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"4.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.4701 ","exception2_price":"1.3231","exception2_pct":null,"exception1_price":"1.4260","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"10.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.3701 ","exception2_price":"1.2331","exception2_pct":null,"exception1_price":"1.3290","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"40.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.3701 ","exception2_price":"1.2331","exception2_pct":null,"exception1_price":"1.3290","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null}],"tbl_sales_units":[{"sales_unit":"DR","numerator":"192 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"KG","numerator":"1 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"L","numerator":"10000 ","material_nbr":"000000000000020331","denominator":"10834 ","base_unit":"KG"},{"sales_unit":"LB","numerator":"32523 ","material_nbr":"000000000000020331","denominator":"71701 ","base_unit":"KG"},{"sales_unit":"PAL","numerator":"768 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"RCU","numerator":"192 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"GAL","numerator":"59146 ","material_nbr":"000000000000020331","denominator":"15625 ","base_unit":"L"}],"tbl_list_prices":null,"tbl_csp_prices":[{"csp_volume":"1.000 ","csp_uom":"LB","csp_scale_uom":"DR","csp_price_unit":"1 ","csp_price_protection_desc":"No Protection","csp_price_protection_code":"Z0","csp_price":"1.3000 ","csp_expiration_date":"20141031","csp_effective_date":"20131031","csp_drum_deposit_code":"","csp_currency":"USD4","csp_condition_nbr":"0037819378"}],"supplier":null,"sub_region":null,"specialty":null,"special_product":null,"sold_to":"0000094713","ship_to":"0000094713","sfdc_material_id":"","sfdc_account_id":"a56M0000000024YIAQ","sales_unit":"DR","sales_org":null,"return_type":"S","return_message":"Price generated successfully","quantity":null,"product_cluster":null,"pricing_industry":null,"plm":null,"material_nbr":"000000000000020331","lbs_unit":"","division":null,"distr_chan":null,"customer_size":null,"business_line":"","base_price_uom":null,"base_price_unit":null,"base_price_currency":null,"base_price":null,"base_code":null,"avg_order_unit":"DR","avg_order_qty":"3.000 "}');
        insert am;
        
        
        Account_Material__c am1 = new Account_Material__c(Account__c=acct.id,SAP_Material__c = m.id,SAP_Data__c = '{"tbl_target_prices":[{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"1.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.5501 ","exception2_price":"1.3951","exception2_pct":null,"exception1_price":"1.5036","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"4.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.4701 ","exception2_price":"1.3231","exception2_pct":null,"exception1_price":"1.4260","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"10.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.3701 ","exception2_price":"1.2331","exception2_pct":null,"exception1_price":"1.3290","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"40.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.3701 ","exception2_price":"1.2331","exception2_pct":null,"exception1_price":"1.3290","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null}],"tbl_sales_units":[{"sales_unit":"DR","numerator":"192 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"KG","numerator":"1 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"L","numerator":"10000 ","material_nbr":"000000000000020331","denominator":"10834 ","base_unit":"KG"},{"sales_unit":"LB","numerator":"32523 ","material_nbr":"000000000000020331","denominator":"71701 ","base_unit":"KG"},{"sales_unit":"PAL","numerator":"768 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"RCU","numerator":"192 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"GAL","numerator":"59146 ","material_nbr":"000000000000020331","denominator":"15625 ","base_unit":"L"}],"tbl_list_prices":null,"tbl_csp_prices":[{"csp_volume":"1.000 ","csp_uom":"LB","csp_scale_uom":"DR","csp_price_unit":"1 ","csp_price_protection_desc":"No Protection","csp_price_protection_code":"Z0","csp_price":"1.3000 ","csp_expiration_date":"20141031","csp_effective_date":"20131031","csp_drum_deposit_code":"","csp_currency":"USD4","csp_condition_nbr":"0037819378"}],"supplier":null,"sub_region":null,"specialty":null,"special_product":null,"sold_to":"0000094713","ship_to":"0000094713","sfdc_material_id":"","sfdc_account_id":"a56M0000000024YIAQ","sales_unit":"DR","sales_org":null,"return_type":"S","return_message":"Price generated successfully","quantity":null,"product_cluster":null,"pricing_industry":null,"plm":null,"material_nbr":"000000000000020331","lbs_unit":"","division":null,"distr_chan":null,"customer_size":null,"business_line":"","base_price_uom":null,"base_price_unit":null,"base_price_currency":null,"base_price":null,"base_code":null,"avg_order_unit":"DR","avg_order_qty":"3.000 "}');
        insert am1;  
        
        String paramID = am.Id + '-' + am1.Id;
        
        Price_Support_Ids__c psID = new Price_Support_Ids__c(
        Ids__c = paramID
        );
        insert psID;
        
        String dateVal = '1393785000000';
        Double d = 1.00;
        Decimal dec = 1.11;
        Price_Request_Transaction__c PRT=new Price_Request_Transaction__c(Account_Material__c=am1.id,Inner_Table__c='Test',CurrencyIsoCode='USD');
        insert PRT; 
        
        Map<String,String> map1 = new Map<String,String>();
        map1.put(am.Id,dateVal);
        map1.put(am1.Id,dateVal);
        
        Expire_CSP con = new  Expire_CSP();
        Expire_CSP.ExpiryRequest req = new Expire_CSP.ExpiryRequest();
        req.soldtonumber = 'test';
        req.shiptonumber = 'test1';
        req.salesorg = 'test2';
        req.materialnumber = 'test3';
        req.expiry_date = null;
        req.priceprot = 'test4';
        req.distchannel = 'test5';
        req.prtid = 'test15';
        req.drumdep = 'test51';
        
        Expire_CSP.ExpiryResponse res = new  Expire_CSP.ExpiryResponse();
        res.prtid = 'test123';
        res.status = 'test12';
        res.errormessage = 'test13';
        
        Expire_CSP.getRecordsToDisplay(psID.Id);
        Expire_CSP.expirePRT(map1);
        Expire_CSP.validateDate(map1);
        Expire_CSP.stringtodate('19880101');
        Expire_CSP.formatDate(system.today());
        Expire_CSP.Stringtodouble(d);
        Expire_CSP.Stringtodouble(dec);
        Expire_CSP.stringtodouble('1,1-2,2');
        Expire_CSP.getDateFormat();
     }
}