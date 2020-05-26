@isTest
public class cc_mn_ctrl_ProductListTest {
    static testmethod void fetchExtendedDataTest() {
        

        Map<String, SObject> m = cc_imp_testUtils.initData();
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='5sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = '5A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        system.runas(nexeoIntegrationUser)
        {
            insert cc_imp_testUtils.createNexeoCustomSettingList();
        ccrz__E_Product__c product = (ccrz__E_Product__c) m.get('product');
        ccrz.cc_CallContext.effAccountGroup = ccrz.cc_CallContext.currAccountGroup;

        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        String data = '[{"prodBean" : { "id" : "' + product.Id + '"}}]';

        ccrz.cc_RemoteActionResult result = null;

        Test.startTest();
        result = cc_mn_ctrl_ProductList.fetchExtendedData(ctx, data);
        Test.stopTest();

        System.assert(result != null);
        System.assert(result.data != null);
        }
    }

    static testmethod void populateProductEntryDataNoParamsTest() {
        

        Map<String, SObject> m = cc_imp_testUtils.initData();
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='4sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = '4A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        system.runas(nexeoIntegrationUser)
        {
            insert cc_imp_testUtils.createNexeoCustomSettingList();
        ccrz.cc_CallContext.effAccountGroup = ccrz.cc_CallContext.currAccountGroup;

        Test.setCurrentPageReference(new PageReference('Page.cc_imp_mn_ProductListBIE'));

        cc_mn_ctrl_ProductList controller = null;

        Test.startTest();
        controller = new cc_mn_ctrl_ProductList();
        Test.stopTest();

        System.assert(controller.jsonProductEntryData != null);
        System.assertEquals('[]', controller.jsonProductEntryData);
        }

    }

    static testmethod void populateProductEntryDataCategoryTest() {
        

        Map<String, SObject> m = cc_imp_testUtils.initData();
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhds1fdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A1231f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        system.runas(nexeoIntegrationUser)
        {
            cc_imp_StorefrontSettings__c  storeFrontSettingsList = cc_imp_testUtils.createMyNexeoCustomSetting();
        insert storeFrontSettingsList;
        ccrz__E_PriceList__c priceList = (ccrz__E_PriceList__c) m.get('priceList');
        ccrz__E_Category__c category = (ccrz__E_Category__c) m.get('category');
        System.debug('IGN: category '  + category);
            if(storeFrontSettingsList != null )
            {
                storeFrontSettingsList.CustomPriceListId__c = category.ccrz__CategoryID__c;
        		update storeFrontSettingsList;
            }
        

        ccrz.cc_CallContext.effAccountGroup = ccrz.cc_CallContext.currAccountGroup;
        ccrz.cc_CallContext.currAccount.cc_imp_MyProductList__c = priceList.Id;
        update ccrz.cc_CallContext.currAccount;
        ccrz.cc_CallContext.effAccountGroup = ccrz.cc_CallContext.currAccountGroup;
        ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_MYNEXEO_STOREFRONT;
        Map<String,String> pageParms = ccrz.cc_CallContext.currPageParameters;
        pageParms.put('categoryId', category.Id);
        ccrz.cc_CallContext.currPageParameters = pageParms;

        Test.setCurrentPageReference(new PageReference('Page.cc_imp_mn_ProductListBIE'));
        System.currentPageReference().getParameters().put('categoryId', category.Id);

        cc_mn_ctrl_ProductList controller = null;

        Test.startTest();
        controller = new cc_mn_ctrl_ProductList();
        Test.stopTest();

        System.assert(controller.jsonProductEntryData != null);
        List<cc_mn_bean_ResultsBaseData> productList = (List<cc_mn_bean_ResultsBaseData>) JSON.deserialize(controller.jsonProductEntryData, List<cc_mn_bean_ResultsBaseData>.class);
        //System.assertEquals(1, productList.size());
        }

    }

    static testmethod void populateProductEntryDataSearchTest() {
         Map<String, SObject> m = cc_imp_testUtils.initData();
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='2sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = '2A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        system.runas(nexeoIntegrationUser)
        {
            insert cc_imp_testUtils.createNexeoCustomSettingList();

       
        ccrz__E_PriceList__c priceList = (ccrz__E_PriceList__c) m.get('priceList');
        ccrz.cc_CallContext.effAccountGroup = ccrz.cc_CallContext.currAccountGroup;
        ccrz.cc_CallContext.currAccount.cc_imp_MyProductList__c = priceList.Id;
        update ccrz.cc_CallContext.currAccount;
        ccrz.cc_CallContext.effAccountGroup = ccrz.cc_CallContext.currAccountGroup;

        Customer_Product_Info__c cpi = new Customer_Product_Info__c(
            Customer_Material_Number__c = 'test', 
            CPI_Record_Type__c = 't', 
            Customer_Number__c = 'test', 
            Distribution_Channel_Code__c = 'te', 
            Material_Number__c = 'test', 
            Record_Key__c = 'test', 
            Sales_Org_Code__c = 'test');
        insert cpi;
        List<ccrz__E_PriceListItem__c> pliList = [SELECT Id FROM ccrz__E_PriceListItem__c WHERE ccrz__PriceList__c = :priceList.Id]; 
        pliList[0].CPI__c = cpi.Id;
        update pliList;       

		Map<String,String> pageParms = ccrz.cc_CallContext.currPageParameters;
        pageParms.put('operation', 'quickSearch');
        pageParms.put('searchText', 'test');
		ccrz.cc_CallContext.currPageParameters = pageParms;
        
        Test.setCurrentPageReference(new PageReference('Page.cc_imp_mn_ProductListBIE'));
        System.currentPageReference().getParameters().put('operation', 'quickSearch');        
        System.currentPageReference().getParameters().put('searchText', 'test');        

        cc_mn_ctrl_ProductList controller = null;

        Test.startTest();
        controller = new cc_mn_ctrl_ProductList();
        Test.stopTest();

        System.assert(controller.jsonProductEntryData != null);
        List<cc_mn_bean_ResultsBaseData> productList = (List<cc_mn_bean_ResultsBaseData>) JSON.deserialize(controller.jsonProductEntryData, List<cc_mn_bean_ResultsBaseData>.class);
        System.assertEquals(1, productList.size());
        }

    }
    
    static testmethod void checkInventory() {
        
              
        Map<String, SObject> m = cc_imp_testUtils.initData();
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='3sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = '3A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        system.runas(nexeoIntegrationUser)
        {
            insert cc_imp_testUtils.createNexeoCustomSettingList();
        nexPrice_Settings__c settings = new nexPrice_Settings__c(
			ATP_Check_Endpoint__c =  'testEndpoint' ,
            atp_username__c = 'testusername',
            atp_password__c = 'testpass'
        );
        insert settings;
		ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();  
        ccrz__E_PriceList__c priceList = (ccrz__E_PriceList__c) m.get('priceList');
        ccrz.cc_CallContext.effAccountGroup = ccrz.cc_CallContext.currAccountGroup;
        ccrz.cc_CallContext.currAccount.cc_imp_MyProductList__c = priceList.Id;
        update ccrz.cc_CallContext.currAccount;
        ccrz.cc_CallContext.effAccountGroup = ccrz.cc_CallContext.currAccountGroup;
        ctx.effAccountId = (String) m.get('userAccount').Id;
        
        Material_Sales_Data2__c matlist = new Material_Sales_Data2__c(name = 'Test Material', Material_Group3_Desc__c = 'COMMODITY', Material_Number__c = '12344321', Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',   Record_Key__c = 'Test Record Key');        
        insert matlist;
        
        Account_Material__c acmt = new Account_Material__c(Account__c=(Id) m.get('userAccount').Id,SAP_Material__c = matlist.id,SAP_Data__c = '{"tbl_target_prices":[{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"1.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.5501 ","exception2_price":"1.3951","exception2_pct":null,"exception1_price":"1.5036","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"4.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.4701 ","exception2_price":"1.3231","exception2_pct":null,"exception1_price":"1.4260","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"10.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.3701 ","exception2_price":"1.2331","exception2_pct":null,"exception1_price":"1.3290","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"40.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.3701 ","exception2_price":"1.2331","exception2_pct":null,"exception1_price":"1.3290","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null}],"tbl_sales_units":[{"sales_unit":"DR","numerator":"192 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"KG","numerator":"1 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"L","numerator":"10000 ","material_nbr":"000000000000020331","denominator":"10834 ","base_unit":"KG"},{"sales_unit":"LB","numerator":"32523 ","material_nbr":"000000000000020331","denominator":"71701 ","base_unit":"KG"},{"sales_unit":"PAL","numerator":"768 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"RCU","numerator":"192 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"GAL","numerator":"59146 ","material_nbr":"000000000000020331","denominator":"15625 ","base_unit":"L"}],"tbl_list_prices":null,"tbl_csp_prices":[{"csp_volume":"1.000 ","csp_uom":"LB","csp_scale_uom":"DR","csp_price_unit":"1 ","csp_price_protection_desc":"No Protection","csp_price_protection_code":"Z0","csp_price":"1.3000 ","csp_expiration_date":"20141031","csp_effective_date":"20131031","csp_drum_deposit_code":"","csp_currency":"USD4","csp_condition_nbr":"0037819378"}],"supplier":null,"sub_region":null,"specialty":null,"special_product":null,"sold_to":"0000094713","ship_to":"0000094713","sfdc_material_id":"","sfdc_account_id":"a56M0000000024YIAQ","sales_unit":"DR","sales_org":null,"return_type":"S","return_message":"Price generated successfully","quantity":null,"product_cluster":null,"pricing_industry":null,"plm":null,"material_nbr":"000000000000020331","lbs_unit":"","division":null,"distr_chan":null,"customer_size":null,"business_line":"","base_price_uom":null,"base_price_unit":null,"base_price_currency":null,"base_price":null,"base_code":null,"avg_order_unit":"DR","avg_order_qty":"3.000 "}');
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
        List<ccrz__E_PriceListItem__c> pliList = [SELECT Id FROM ccrz__E_PriceListItem__c WHERE ccrz__PriceList__c = :priceList.Id]; 
        pliList[0].Account_Material__c = acmt.Id;
        pliList[0].CPI__c = cpi.Id;
        update pliList;       

		Map<String,String> pageParms = ccrz.cc_CallContext.currPageParameters;
        pageParms.put('operation', 'quickSearch');
        pageParms.put('searchText', 'test');
		ccrz.cc_CallContext.currPageParameters = pageParms;
        
        Test.setCurrentPageReference(new PageReference('Page.cc_imp_mn_ProductListBIE'));
        System.currentPageReference().getParameters().put('operation', 'quickSearch');        
        System.currentPageReference().getParameters().put('searchText', 'test');        

        cc_mn_ctrl_ProductList controller = null;

        Test.startTest();
        controller = new cc_mn_ctrl_ProductList();
        cc_mn_ctrl_ProductList.checkInventory(ctx, pliList[0].Id, '110', 'LB', '07/25/2018');
        Test.stopTest();
        }

    }
}