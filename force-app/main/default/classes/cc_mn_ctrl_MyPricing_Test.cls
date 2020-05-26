@isTest
public class cc_mn_ctrl_MyPricing_Test {

        static Map<String, SObject> testData = new Map<String, SObject>();
        
    static {
        testData = cc_imp_testUtils.initData();
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        system.runas(nexeoIntegrationUser)
        {
        List<SAP_INCO_Term__c> incoTerms = new List<SAP_INCO_Term__c>();
        incoTerms.add(new SAP_INCO_Term__c(INCO_Term_Code__c = 'ZD1', INCO_Term_Name__c = 'DDP Dest, Frt Prepaid', Language_Code__c = 'EN'));
        incoTerms.add(new SAP_INCO_Term__c(INCO_Term_Code__c = 'ZD2', INCO_Term_Name__c = 'DDP Dest, Frt Prepaid 2', Language_Code__c = 'EN'));
        insert incoTerms;        
        
        cc_imp_StorefrontSettings__c customSettings = cc_imp_testUtils.createMyNexeoCustomSetting();
        insert customSettings;
                
        ccrz__E_PriceList__c priceList = (ccrz__E_PriceList__c) testData.get('priceList');
        System.debug('priceList ' + priceList);
        
        Material_Sales_Data2__c matlist = new Material_Sales_Data2__c(name = 'Test Material', Material_Group3_Desc__c = 'COMMODITY', Material_Number__c = '12344321', Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',   Record_Key__c = 'Test Record Key');        
        insert matlist;
        
        Account_Material__c acmt = new Account_Material__c(Account__c=(Id) testData.get('userAccount').Id,SAP_Material__c = matlist.id,SAP_Data__c = '{"tbl_target_prices":[{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"1.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.5501 ","exception2_price":"1.3951","exception2_pct":null,"exception1_price":"1.5036","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"4.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.4701 ","exception2_price":"1.3231","exception2_pct":null,"exception1_price":"1.4260","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"10.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.3701 ","exception2_price":"1.2331","exception2_pct":null,"exception1_price":"1.3290","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"40.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.3701 ","exception2_price":"1.2331","exception2_pct":null,"exception1_price":"1.3290","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null}],"tbl_sales_units":[{"sales_unit":"DR","numerator":"192 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"KG","numerator":"1 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"L","numerator":"10000 ","material_nbr":"000000000000020331","denominator":"10834 ","base_unit":"KG"},{"sales_unit":"LB","numerator":"32523 ","material_nbr":"000000000000020331","denominator":"71701 ","base_unit":"KG"},{"sales_unit":"PAL","numerator":"768 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"RCU","numerator":"192 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"GAL","numerator":"59146 ","material_nbr":"000000000000020331","denominator":"15625 ","base_unit":"L"}],"tbl_list_prices":null,"tbl_csp_prices":[{"csp_volume":"1.000 ","csp_uom":"LB","csp_scale_uom":"DR","csp_price_unit":"1 ","csp_price_protection_desc":"No Protection","csp_price_protection_code":"Z0","csp_price":"1.3000 ","csp_expiration_date":"20141031","csp_effective_date":"20131031","csp_drum_deposit_code":"","csp_currency":"USD4","csp_condition_nbr":"0037819378"}],"supplier":null,"sub_region":null,"specialty":null,"special_product":null,"sold_to":"0000094713","ship_to":"0000094713","sfdc_material_id":"","sfdc_account_id":"a56M0000000024YIAQ","sales_unit":"DR","sales_org":null,"return_type":"S","return_message":"Price generated successfully","quantity":null,"product_cluster":null,"pricing_industry":null,"plm":null,"material_nbr":"000000000000020331","lbs_unit":"","division":null,"distr_chan":null,"customer_size":null,"business_line":"","base_price_uom":null,"base_price_unit":null,"base_price_currency":null,"base_price":null,"base_code":null,"avg_order_unit":"DR","avg_order_qty":"3.000 "}');
        insert acmt;
        
        Customer_Product_Info__c cpi = new Customer_Product_Info__c(
            Customer_Material_Number__c = 'test', 
            CPI_Record_Type__c = 't', 
            Customer_Number__c = 'test', 
            Distribution_Channel_Code__c = 'te', 
            Material_Number__c = 'test', 
            Record_Key__c = 'test', 
            Sales_Org_Code__c = 'test');
        insert cpi;
        
        ccrz__E_Product__c product = (ccrz__E_Product__c) testData.get('product');
        product.SAP_Material__c = matlist.Id;
        update product;
        
        List<ccrz__E_PriceListItem__c> pliList = [SELECT Id FROM ccrz__E_PriceListItem__c WHERE ccrz__PriceList__c = :priceList.Id]; 
        
        pliList[0].Account_Material__c = acmt.Id;
        pliList[0].CPI__c = cpi.Id;
        update pliList;
        
        List<ccrz__E_PriceListItem__c> pliListItems = new List<ccrz__E_PriceListItem__c>();
        for(ccrz__E_PriceListItem__c priceListItem : [SELECT Id FROM ccrz__E_PriceListItem__c WHERE ccrz__PriceList__c = :priceList.Id]) {
            priceListItem.ccrz__StartDate__c = Date.Today();
            priceListItem.ccrz__EndDate__c =  Date.Today().addDays(54);
            pliListItems.add(priceListItem);
        }
        update pliListItems;
        ccrz__E_Rule__c rule = new ccrz__E_Rule__c(
            ccrz__Relation__c='Pricelist Item',
            ccrz__Name__c='PLI-tiered-pricing-rule',
            ccrz__RuleType__c='Tiered',
            ccrz__CurrencyISOCode__c='USD',
            ccrz__RuleSource__c='Pricing',
            ccrz__Enabled__c=true, 
            ccrz_pricelistitem__c = pliListItems.get(0).Id);
        insert rule;
        
        ccrz__E_PriceModifier__c modifier = new ccrz__E_PriceModifier__c(
            ccrz__DiscountType__c='Price', 
            ccrz__Amount__c=100.00, 
            ccrz__Quantity__c=100, 
            Base_Price__c=50.00);
        insert modifier;

        ccrz__E_RulePricingModifier__c rpm = new ccrz__E_RulePricingModifier__c(
            ccrz__Rule__c = rule.Id, 
            ccrz__PriceModifier__c = modifier.Id);
        insert rpm;
        
        ccrz__E_RuleTargetPLI__c pliRule = new ccrz__E_RuleTargetPLI__c(ccrz__E_Rule__c=rule.Id, ccrz__E_PriceListItem__c=pliList[0].Id);
        insert pliRule;
        
        Account userAccount = (Account) testData.get('userAccount');
        Automated_Price_Letter__c newAutomtedPriceLetter = new Automated_Price_Letter__c(Name = 'testPriceLetter' , Account__c = userAccount.Id);
        insert newAutomtedPriceLetter;
        
        Attachment attach=new Attachment();     
        attach.Name = 'Unit Test Attachment';
        Blob bodyBlob  =Blob.valueOf('Unit Test Attachment Body');
        attach.body  =bodyBlob;
        attach.parentId = newAutomtedPriceLetter.id;
        insert attach; 
        }
    }
   
    @isTest static void initializeClass() {
        cc_mn_ctrl_MyPricing controller = new cc_mn_ctrl_MyPricing();
        System.assert(String.isNotBlank(controller.archivedPriceLetters));
        System.assert(controller.totalRecordsPerPage != 0);       
    }
    
    @isTest static void getAllPricesPerAccount() {
        
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        ccrz.cc_RemoteActionResult result = null;
        
        cc_mn_ctrl_MyPricing controller = new cc_mn_ctrl_MyPricing();
        result = cc_mn_ctrl_MyPricing.getAllPricesPerAccount(ctx);
        
        System.assert(result != null);
        System.assert(result.data != null);
    }
        
    @isTest static void searchAllPricesPerAccountByParams() {
        
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        ccrz.cc_RemoteActionResult result = null;
        
        cc_mn_ctrl_MyPricing controller = new cc_mn_ctrl_MyPricing();
        result = cc_mn_ctrl_MyPricing.searchAllPricesPerAccountByParams(ctx, '{"sortCriteria"  : "", "sortDir" : "", "searchDataInput":"", "page" : ""}');
        
        System.assert(result != null);
        System.assert(result.data != null);
    }
    
    @isTest static void searchAllPricesPerAccountByParamsError() {
        
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        ccrz.cc_RemoteActionResult result = null;
        
        cc_mn_ctrl_MyPricing controller = new cc_mn_ctrl_MyPricing();
        result = cc_mn_ctrl_MyPricing.searchAllPricesPerAccountByParams(ctx, '');
        
        System.assert(result != null);
        System.assert(result.data != null);
    }

    @isTest static void sendMaterialEmail() {
        
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        ccrz.cc_RemoteActionResult result = null;
        
        cc_mn_ctrl_MyPricing controller = new cc_mn_ctrl_MyPricing();
        ccrz__E_PriceList__c priceList = (ccrz__E_PriceList__c) testData.get('priceList');
        result = cc_mn_ctrl_MyPricing.sendMaterialEmail(ctx, priceList.Id, 'bodyMessage', 'subject');
        
        System.assert(result != null);
        System.assert(result.data != null);
    }
    
    @isTest static void sendMaterialEmailError() {
        
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        ccrz.cc_RemoteActionResult result = null;
        
        cc_mn_ctrl_MyPricing controller = new cc_mn_ctrl_MyPricing();
        result = cc_mn_ctrl_MyPricing.sendMaterialEmail(ctx, '', 'bodyMessage', 'subject');
        
        System.assert(result != null);
        System.assert(result.data != null);
    }  
}