@isTest
public class AtpInvSearchController_Test {
    
   private static testmethod void testMethod1() {  
    String matnum = '010000000123456789';
    String salesOrg = '1234';
    String distChan = '30';
    
    
    Nexprice_settings__c nxs = new Nexprice_settings__c();
    nxs.ATP_Check_Endpoint__c = 'wwww.endpoint.com/test2';
    nxs.atp_username__c = 'myusername';
    nxs.atp_password__c = 'mypassword';
    insert nxs;
       
    Material_General_Data2__c mgd2 = new Material_General_Data2__c();
    mgd2.Material_Number__c = matnum;
    insert mgd2;
    
    List<Material_Sales_Data__c> msda = testGet_Material_Sales_Data(matnum);
    insert msda;
       
       Material_Sales_Data2__c msd2 = new Material_Sales_Data2__c();
       msd2.Material_Number__c = matnum;
       msd2.Sales_Org_Code__c = salesOrg;
       msd2.Dist_Channel_Code__c = distChan;
       msd2.Record_Key__c = matnum + salesOrg + distChan;
       msd2.Material_General_Data__c = mgd2.Id;
       insert msd2;
       
        Account acct = new Account(name='TestAccount',SAP_Sales_Org__c='1000',SAP_Supplier_Number__c='123456',AccountNumber='1234561000',Type='Customer',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA',SAP_DivisionCode__c='31');
        insert acct; 
        Account_Material__c am=new Account_Material__c(Quantity__c=1500,SAP_Material__c = msd2.id,Account__c=acct.id,PRT_Form__c='Test',Adjust_Form__c='Test',Avg_Order_Qty__c=10,Competitive_Price__c=24,CurrencyIsoCode='CAD',SAP_Data__c='{"tbl_target_prices":[{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"1.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.2165 ","exception2_price":"3.9213","exception2_pct":null,"exception1_price":"4.0057","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"4.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.1165 ","exception2_price":"3.8283","exception2_pct":null,"exception1_price":"3.9107","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"10.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.0165 ","exception2_price":"3.7353","exception2_pct":null,"exception1_price":"3.8157","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"40.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"3.9165 ","exception2_price":"3.6423","exception2_pct":null,"exception1_price":"3.7207","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null}],"tbl_sales_units":[{"sales_unit":"DR","numerator":"22700 ","material_nbr":"000000000000753482","denominator":"100 ","base_unit":"KG"},{"sales_unit":"KG","numerator":"1 ","material_nbr":"000000000000753482","denominator":"1 ","base_unit":"KG"},{"sales_unit":"LB","numerator":"32523 ","material_nbr":"000000000000753482","denominator":"71701 ","base_unit":"KG"}],"tbl_list_prices":null,"tbl_csp_prices":[],"supplier":null,"sub_region":null,"specialty":null,"special_product":null,"sold_to":"0000094713","ship_to":"0000094713","sfdc_material_id":"","sfdc_account_id":"a56c0000000JdJYAA0","sales_unit":"DR","sales_org":null,"return_type":"S","return_message":"Price generated successfully","quantity":null,"product_cluster":null,"pricing_industry":null,"plm":null,"material_nbr":"000000000000753482","lbs_unit":"","division":null,"distr_chan":null,"customer_size":null,"business_line":"","base_price_uom":null,"base_price_unit":null,"base_price_currency":null,"base_price":null,"base_code":null,"avg_order_unit":"DR","avg_order_qty":"3.000 "}');
        insert am;
       test.starttest();
       ApexPages.standardcontroller sc = new ApexPages.standardcontroller(am);
       AtpInvSearchController aisc = new AtpInvSearchController(sc);
       aisc.checkinv();
       aisc.getStockingUnitCodes();
       test.stoptest();
   }  
    
    private static List<Material_Sales_Data__c> testGet_Material_Sales_Data(String matnum) {
        String PIPE = '\\|';
        String[] salesData = new String[]{'1000|30|D10054305251276741|DR|WC',
                                          '1700|30|D10054305251276741|DR|WC',
                                          '1000|10|I27000000000276741'
                                         };
        List<Material_Sales_Data__c> msda = new List<Material_Sales_Data__c>();
        for (Integer i = 0; i < 1; i++) {
            for (Integer j = 0; j < salesData.size(); j++) {
                Material_Sales_Data__c msd = new Material_Sales_Data__c();
                msd.Material_Number__c = matnum;
                String[] sa = salesData[j].split(PIPE);
                msd.Sales_Org__c = sa[0];
                msd.Distribution_Channel__c = sa[1];
                msd.Record_Key__c = matnum + sa[0] + sa[1];
                msd.Product_Hierarchy__c = sa[2];
                if (sa.size() > 3) {
                    msd.Sales_Unit__c = sa[3];
                    if (sa.size() > 4) {
                        msd.Material_Pricing_Group__c = sa[4];
                    }
                }
                msda.add(msd);
            } 
        }
        return msda;
    }
        
}