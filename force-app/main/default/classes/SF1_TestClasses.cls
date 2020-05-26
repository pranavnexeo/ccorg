@isTest
private class SF1_TestClasses{

//Testmethod for "AccountMaterial_Information" class.
static testmethod void SF1_TestClasses_Method1(){
	Map<String, SObject> testData = NexeoTestUtils_Test.initData();  
Account acct;
Account_Material__c am;
Price_Request_Transaction__c PRT;
SAP_Seller__c saps;
Price_Request_Approver__c pra;
Price_Request_Approver__c pra1;

acct = new Account(name='TestAccount',SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Vendor',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA');
        insert acct; 
        am=new Account_Material__c(Account__c=acct.id,PRT_Form__c='Test',Adjust_Form__c='Test',Avg_Order_Qty__c=10,Competitive_Price__c=24,CurrencyIsoCode='CAD');
        PRT=new Price_Request_Transaction__c(Inner_Table__c='Test',Ship_To__c=acct.id,Sold_To__c=acct.id, Approval_Status__c='Pending Entry',Type__c='Quote');    
        insert PRT;
        saps = new SAP_Seller__c(Name='0000012345');
        insert saps;
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(FirstName = 'Rajeev',LastName = 'Shekhar',Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='saxs2bh7d3447gfdhddc@gorg.com', IsActive = true);
        insert u;
        User u1 = new User(FirstName = 'Rajeev',LastName = 'Shekhar',Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='saxsbbb2bh7d3447gfdhddc@gorg.com', IsActive = true);
        insert u1; 
        pra = new Price_Request_Approver__c(Approver__c = u.id,SAP_Seller__c = saps.id,Approval_Level__c='Exception 1',Process_Order__c=2);
        insert pra;
        pra1 = new Price_Request_Approver__c(Approver__c = u1.id,SAP_Seller__c = saps.id,Approval_Level__c='Exception 1',Process_Order__c=2);
        insert pra1;
        ApexPages.standardcontroller sc = new ApexPages.standardcontroller(am);
        AccountMaterial_Information AMi = new AccountMaterial_Information(sc);
        string s = AMi.prtName;
        string s1 = AMi.prtType;
        string s2 = AMi.prtAppComments;
        try{
        AMi.getAccountMaterial();
        }catch(exception e){}
        
        AccountMaterial_Information.getApproversList();
}

//Test class for AM_CSPTier class
static testmethod void SF1_TestClasses_Method2(){
        Map<String, SObject> testData = NexeoTestUtils_Test.initData();  
        Account acct;
        String test = 'test';

        CSP_JSON_Response resp = new CSP_JSON_Response(test,test,test,test,test,test,test,test,test,test,test,
                                               test,test,test,test,test,test,test,test,test,test,test,
                                               test,test,test,test, 
                                               new List<CSP_JSON_Response.tbl_sales_units>{new CSP_JSON_Response.tbl_sales_units( test, test, test, test, test)}, 
                                               new List<CSP_JSON_Response.tbl_csp_prices>{new CSP_JSON_Response.tbl_csp_prices(test,test,test,test,test,test,test,test,test,test,test)}, 
                                               new List<CSP_JSON_Response.tbl_target_prices>{new CSP_JSON_Response.tbl_target_prices(test,test,test,test,test,test,test,test,test,test,test,test,test,test,test,test,test,test,test,test,test,test, test,test,test,test,test,test, test)},  
                                               new List<CSP_JSON_Response.tbl_list_prices>{new CSP_JSON_Response.tbl_list_prices(test,test,test,test,test,test,test,test,test,test,test, test)},
                                               test,test);
        Account_Material__c am;
        Id recordid;
        Material_Sales_Data2__c matlist = new Material_Sales_Data2__c(name = 'Test Material', Material_Number__c = '12344321', Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',   Record_Key__c = 'Test Record Key');        
        insert matlist;
        acct = new Account(name='TestAccount',SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Vendor',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA',SAP_DivisionCode__c='31');
        insert acct; 
        am=new Account_Material__c(SAP_Material__c = matlist.Id,Account__c=acct.id,PRT_Form__c='Test',Adjust_Form__c='Test',Avg_Order_Qty__c=10,Competitive_Price__c=24,SAP_Data__c='{"tbl_target_prices":[{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"1.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.2165 ","exception2_price":"3.9213","exception2_pct":null,"exception1_price":"4.0057","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"4.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.1165 ","exception2_price":"3.8283","exception2_pct":null,"exception1_price":"3.9107","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"10.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.0165 ","exception2_price":"3.7353","exception2_pct":null,"exception1_price":"3.8157","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"40.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"3.9165 ","exception2_price":"3.6423","exception2_pct":null,"exception1_price":"3.7207","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null}],"tbl_sales_units":[{"sales_unit":"DR","numerator":"22700 ","material_nbr":"000000000000753482","denominator":"100 ","base_unit":"KG"},{"sales_unit":"KG","numerator":"1 ","material_nbr":"000000000000753482","denominator":"1 ","base_unit":"KG"},{"sales_unit":"LB","numerator":"32523 ","material_nbr":"000000000000753482","denominator":"71701 ","base_unit":"KG"}],"tbl_list_prices":null,"tbl_csp_prices":[],"supplier":null,"sub_region":null,"specialty":null,"special_product":null,"sold_to":"0000094713","ship_to":"0000094713","sfdc_material_id":"","sfdc_account_id":"a56c0000000JdJYAA0","sales_unit":"DR","sales_org":null,"return_type":"S","return_message":"Price generated successfully","quantity":null,"product_cluster":null,"pricing_industry":null,"plm":null,"material_nbr":"000000000000753482","lbs_unit":"","division":null,"distr_chan":null,"customer_size":null,"business_line":"","base_price_uom":null,"base_price_unit":null,"base_price_currency":null,"base_price":null,"base_code":null,"avg_order_unit":"DR","avg_order_qty":"3.000 "}');
        insert am;
        AM_CSPTier amcsp = new AM_CSPTier();
        amcsp.recordid = am.Id;
        amcsp.gettarget();
        Map<String, Double> CurrencyMap = new Map<String, Double>();
        for(CurrencyType c:[select id, IsoCode, ConversionRate from CurrencyType])
        {
             if(c.isocode != '' && c.isocode != null)
               CurrencyMap.put(c.IsoCode, C.ConversionRate);
        } 
        
        AM_CSPTier.ConvertCurrency(20,'test','test',CurrencyMap);
        AM_CSPTier.formatDate(system.today());
        AM_CSPTier.stringtodate('101112');
        AM_CSPTier.stringtodouble('101112');
        amcsp.getcsptier();

}

//Test class for nexprice_mobileSetPrice class
static testmethod void SF1_TestClasses_Method3(){
       	Map<String, SObject> testData = NexeoTestUtils_Test.initData();  
       Account a = new Account(name = 'Test Account',sap_salesgroup__c = '1000',sap_city__c = 'Newyork',SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Vendor',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA',AccountNumber='123');
        insert a;
        
        string acct = a.Id;
        
        Material_Sales_Data2__c matlist = new Material_Sales_Data2__c(name = 'Test Material', Material_Number__c = '12344321', Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',   Record_Key__c = 'Test Record Key');        
        insert matlist;
        
        Account_Material__c acmt = new Account_Material__c(Account__c=acct,SAP_Material__c = matlist.id,SAP_Data__c = '{"tbl_target_prices":[{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"1.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.5501 ","exception2_price":"1.3951","exception2_pct":null,"exception1_price":"1.5036","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"4.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.4701 ","exception2_price":"1.3231","exception2_pct":null,"exception1_price":"1.4260","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"10.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.3701 ","exception2_price":"1.2331","exception2_pct":null,"exception1_price":"1.3290","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"40.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"1.3701 ","exception2_price":"1.2331","exception2_pct":null,"exception1_price":"1.3290","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null}],"tbl_sales_units":[{"sales_unit":"DR","numerator":"192 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"KG","numerator":"1 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"L","numerator":"10000 ","material_nbr":"000000000000020331","denominator":"10834 ","base_unit":"KG"},{"sales_unit":"LB","numerator":"32523 ","material_nbr":"000000000000020331","denominator":"71701 ","base_unit":"KG"},{"sales_unit":"PAL","numerator":"768 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"RCU","numerator":"192 ","material_nbr":"000000000000020331","denominator":"1 ","base_unit":"KG"},{"sales_unit":"GAL","numerator":"59146 ","material_nbr":"000000000000020331","denominator":"15625 ","base_unit":"L"}],"tbl_list_prices":null,"tbl_csp_prices":[{"csp_volume":"1.000 ","csp_uom":"LB","csp_scale_uom":"DR","csp_price_unit":"1 ","csp_price_protection_desc":"No Protection","csp_price_protection_code":"Z0","csp_price":"1.3000 ","csp_expiration_date":"20141031","csp_effective_date":"20131031","csp_drum_deposit_code":"","csp_currency":"USD4","csp_condition_nbr":"0037819378"}],"supplier":null,"sub_region":null,"specialty":null,"special_product":null,"sold_to":"0000094713","ship_to":"0000094713","sfdc_material_id":"","sfdc_account_id":"a56M0000000024YIAQ","sales_unit":"DR","sales_org":null,"return_type":"S","return_message":"Price generated successfully","quantity":null,"product_cluster":null,"pricing_industry":null,"plm":null,"material_nbr":"000000000000020331","lbs_unit":"","division":null,"distr_chan":null,"customer_size":null,"business_line":"","base_price_uom":null,"base_price_unit":null,"base_price_currency":null,"base_price":null,"base_code":null,"avg_order_unit":"DR","avg_order_qty":"3.000 "}');
        insert acmt;
        
        List<String> amids = new List<String>();
        amids.add(acmt.id); 
        
        Formdata formdataobj = new Formdata('name', 'value');
        List<Formdata> formdataList = new List<Formdata>();
        formdataList.add(formdataobj);
        try{
        nexprice_mobileSetPrice.SubmitForm12(true,'test',amids, formdataList,'simulate');
        }
        catch(exception e){}
        nexprice_mobileSetPrice nexmobileset = new nexprice_mobileSetPrice();
        nexprice_mobileSetPrice.getDateFormat();
        ApexPages.StandardController sc = new ApexPages.standardController(acmt);
        //Price_Request_Form ctrl = new Price_Request_Form();
        //nexprice_mobileSetPrice nexmobileset1 = new nexprice_mobileSetPrice(ctrl);
        nexprice_mobileSetPrice nexmobileset2 = new nexprice_mobileSetPrice(sc); 
        
}

//Test class for Account_Material_Information class
static testmethod void SF1_TestClasses_Method4(){
        Map<String, SObject> testData = NexeoTestUtils_Test.initData();  
        Id recordid;
        Account a = new Account(name = 'Test Account',sap_salesgroup__c = '1000',sap_city__c = 'Newyork',SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Vendor',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA',AccountNumber='123');
        insert a;
        
        string acct = a.Id;
        
        Material_Sales_Data2__c matlist = new Material_Sales_Data2__c(name = 'Test Material', Material_Number__c = '12344321', Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',   Record_Key__c = 'Test Record Key');        
        insert matlist;
        
        Account_Material__c amInfo  = new Account_Material__c(Account__c=acct,SAP_Material__c = matlist.id);
        insert amInfo;
        Account_Material_Information ami = new  Account_Material_Information();
        ami.recordid = amInfo.id;
        ami.getamInfo();
       
}

//Test method for Account_Material_Search
static testmethod void SF1_TestClasses_Method5(){
        Account_Material__c acc = new Account_Material__c();
        acc.Prospect_Material__c=false;
        acc.ownerid=userinfo.getuserid();
        insert acc;
        ApexPages.standardcontroller sc = new ApexPages.standardcontroller(acc);

        Account_Material_Search accmat = new Account_Material_Search(sc);
        accmat.getrow();
        accmat.getrowclose();
        Account_Material_Search.getPricing('test');
        Account_Material_Search.amsearch('test',acc.id);
}

static testmethod void SF1_TestClasses_Method6(){
        Map<String, SObject> testData = NexeoTestUtils_Test.initData();  
        Account acct = new Account();
        acct = new Account(name='TestAccount',SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Vendor',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA');
        insert acct;
        ApexPages.standardcontroller sc = new ApexPages.standardcontroller(acct);
        Account_Hierarchy_Mobile_Card accmat = new Account_Hierarchy_Mobile_Card(sc);
        try{
        Account_Hierarchy_mobile_card ac = new Account_Hierarchy_mobile_card();
        }catch(exception e){}
}
}