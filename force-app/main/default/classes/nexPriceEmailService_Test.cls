@isTest
private class nexPriceEmailService_Test{
    static testMethod void testemailservice(){
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env    = new Messaging.InboundEnvelope();
        
    /*    Account a = new Account(name = 'Test Account',sap_salesgroup__c = '1000',sap_city__c = 'Newyork');
        insert a;
        string acct = a.Id;
        List<Material_Sales_Data2__c> matlist = [select id,Name,Material_Group2_Desc__c,PH1_Division__c,PH2_Line__c,PH3_group__c,PH4_supplier__c,PH5_family__c,PH6_segment__c,PH7_subsegment__c,Material_Base_Code__c,material_Base_Code_Desc__c,Material_Group2_Code__c,material_group4_code__c from Material_Sales_Data2__c limit 1];
        Account_Material__c acmt = new account_material__c();
        acmt.account__c = acct;
        acmt.sap_material__c = matlist[0].id; 
        acmt.sap_data__c = '{"tbl_target_prices":[{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"1.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.9271 ","exception2_price":"0.0000","exception2_pct":null,"exception1_price":"4.6807","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"4.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.8271 ","exception2_price":"0.0000","exception2_pct":null,"exception1_price":"4.5857","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"10.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.7271 ","exception2_price":"0.0000","exception2_pct":null,"exception1_price":"4.4907","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"40.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.6271 ","exception2_price":"0.0000","exception2_pct":null,"exception1_price":"4.3957","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null}],"tbl_sales_units":[{"sales_unit":"DR","numerator":"202 ","material_nbr":"000000000000725073","denominator":"1 ","base_unit":"KG"},{"sales_unit":"GAL","numerator":"3878 ","material_nbr":"000000000000725073","denominator":"1000 ","base_unit":"KG"},{"sales_unit":"KG","numerator":"1 ","material_nbr":"000000000000725073","denominator":"1 ","base_unit":"KG"},{"sales_unit":"LB","numerator":"32523 ","material_nbr":"000000000000725073","denominator":"71701 ","base_unit":"KG"}],"tbl_list_prices":null,"tbl_csp_prices":[{"csp_volume":"1.000 ","csp_uom":"LB","csp_scale_uom":"DR","csp_price_unit":"1 ","csp_price_protection_desc":"No Protection","csp_price_protection_code":"Z0","csp_price":"3.4000 ","csp_expiration_date":"20140321","csp_effective_date":"20130321","csp_drum_deposit_code":"","csp_currency":"USD4","csp_condition_nbr":"0036659213"}],"supplier":null,"sub_region":null,"specialty":null,"special_product":null,"sold_to":"0000097093","ship_to":"0000097093","sfdc_material_id":"","sfdc_account_id":"a56E0000000ZPW3IAO","sales_unit":"DR","sales_org":null,"return_type":"S","return_message":"Price generated successfully","quantity":null,"product_cluster":null,"pricing_industry":null,"plm":null,"material_nbr":"000000000000725073","lbs_unit":"","division":null,"distr_chan":null,"customer_size":null,"business_line":"","base_price_uom":null,"base_price_unit":null,"base_price_currency":null,"base_price":null,"base_code":null,"avg_order_unit":"DR","avg_order_qty":"5.000 "}';
        acmt.ownerid = '005E0000000Yxil';
        insert acmt;
        List<String> accList = new List<String>();
        String mat1 = matlist[0].id;
        Account_Material__c accmat = new account_material__c(Account__c = acct , SAP_Material__c = mat1);
        insert accmat;
        List<Id> accMat1 = new List<Id>();
        accMat1.add(accmat.Id);
        
        Price_Request_Transaction__c p = new Price_Request_Transaction__c(Approval_Rejection_Comments__c = 'Comments',Account_Material__c = accmat.id);
        insert p;
        
        string prt = p.id;*/
        
       
        email.subject = '087339123';
        env.fromAddress = 'user@abcxyz.com';
        email.plainTextBody = 'APPROVE \n APPROVE \n Rest of the message.. ';
        
        nexPriceEmailService nexemail = new nexPriceEmailService();
        nexemail.handleInboundEmail(email,env);
        
       
    }
}