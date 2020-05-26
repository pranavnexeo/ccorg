@isTest(SeeAllData=false)
public class updateAlternateToRequested_Test {
    
	public static testMethod void updateAlternateToRequested(){
  		//Adding code to prevent have hardcoded IDs
  		Map<String, SObject> testData = NexeoTestUtils_Test.initData();
        User firstUser = (User) testData.get('firstUser');
       
        System.runAs(firstUser) {
         Double d;
        Integer i;
        List<formData> data = new List<formData>();
    
        Role_Reportee__c r = new Role_Reportee__c(role__c = 'AD Sales', user__c = userinfo.getuserid());
        insert r;
        
        List <String>AMId = new List <String>();
        List <String>aiDisplay= new List <String>();
        List <String>aid= new List <String>();
        List<string> ownerid = new List<string>();
        List<String> AccountId = new List<string>();
        List<String> ids = new List<String>();   
        Map<String, Map<String, String>> relmap = new Map<String, Map<String, String>>();
        Map<String, String> strmap = new Map<String, String>();
        strmap.put('Test','Test');
        relmap.put('SoldTos',strmap);
        relmap.put('CorpIds',strmap);
        
        Map<Id, Account> Accounts=new Map<Id, Account>();
        Map<Id, Material_Sales_Data2__c> materialmap=new Map<Id, Material_Sales_Data2__c>();
        Map<id, boolean> Access_Map =new Map<id, boolean>();
        
        string str;
        list<price_request_transaction__c> prt5 = new list<price_request_transaction__c>(); 
        boolean b = True;
        
        Account acc = new Account(Name = 'TestAccount',SAP_Sales_Org__c = '1000', SAP_Street__c = 'Blazer Parkway', SAP_StreetSuppl1__c = null, SAP_StreetSuppl2__c = null, SAP_StreetSuppl3__c = null, SAP_City__c = 'Dublin', SAP_State__c = 'OH',SAP_Zip_Code__c = '90210', SAP_Country__c = 'US',type= 'Customer', CurrencyIsoCode='USD',Full_Address__c= 'New Bazar Parkway,US');                 
        insert acc;    
                           
        contact c = new contact(Accountid = acc.id, firstname = 'abc', lastname = 'xyz', phone = '999-999-9999', No_Email__c = True);        
        insert c; 
        
        Profile profile = [select id from profile where name='System Administrator'];
        User U = new User(alias = 'standt', email='standarduser@testorg.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = profile.Id, 
            timezonesidkey='America/Los_Angeles', username='supplierMain@testorg.com',nexPrice_Disregard_Hierarchy__c=True);
        
        insert U;
        
        Role_Reportee__c rolerep=new Role_Reportee__c(User__c=U.id,role__c='AD Sales');
        insert rolerep;
        String test = 'test';

        Material_Sales_Data2__c m = new Material_Sales_Data2__c(name = 'Test Material', Material_Number__c = '12344321', Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',   Record_Key__c = 'Test Record Key');        
        insert m;
        
        
        List<formData> data5 = new List<formData>();
        formData fd=new formData('Account__c','SAP_Material__c');
        
        data5.add(fd);    
        Map<String, List<string>> wheres = new Map<String, List<String>>(); 
       
        Account_Material__c accmat = new account_material__c(Account__c = acc.id, SAP_Material__c = m.id);        
        insert accmat;
        
        Account acct = new Account(name='TestAccount',SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Vendor',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA',SAP_Partner_Functions__c='Sold To');
        insert acct; 
        
        Accounts.put(acct.id,acct); 
        Access_Map.put(acct.id,True);
        materialmap.put(acct.id,m); 
        
        Price_Request_Transaction__c PRT=new Price_Request_Transaction__c(Inner_Table__c='Test',Requested_Tiers__c='[{"attributes":{"type":"SAP_Price_Tier__c"},"CurrencyIsoCode":"USD","Exception_2_Price__c":3.9213,"Effective_Date__c":"2013-04-24","Expiration_Date__c":"2014-01-01","DPL_Price_UoM__c":null,"Target_Tier_Price__c":4.2165,"DPL_Price__c":null,"Price_UoM__c":"LB","Volume__c":1.0,"Target_Tier_Price_UoM__c":"LB","Target_Tier_Price_Unit__c":1.0,"Price__c":4.0,"TPI__c":94.87,"Volume_UoM__c":"DR","Exception_1_Price__c":4.0057},{"attributes":{"type":"SAP_Price_Tier__c"},"CurrencyIsoCode":"USD","Exception_2_Price__c":3.8283000000000005,"Effective_Date__c":"2013-04-24","Expiration_Date__c":"2014-01-01","DPL_Price_UoM__c":null,"Target_Tier_Price__c":4.1165,"DPL_Price__c":null,"Price_UoM__c":"LB","Volume__c":4.0,"Target_Tier_Price_UoM__c":"LB","Target_Tier_Price_Unit__c":1.0,"Price__c":5.0,"TPI__c":121.46,"Volume_UoM__c":"DR","Exception_1_Price__c":3.9107}]',SAP_Data__c='{"tbl_target_prices":[{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"1.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.2165 ","exception2_price":"3.9213","exception2_pct":null,"exception1_price":"4.0057","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"4.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.1165 ","exception2_price":"3.8283","exception2_pct":null,"exception1_price":"3.9107","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"10.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.0165 ","exception2_price":"3.7353","exception2_pct":null,"exception1_price":"3.8157","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"40.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"3.9165 ","exception2_price":"3.6423","exception2_pct":null,"exception1_price":"3.7207","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null}],"tbl_sales_units":[{"sales_unit":"DR","numerator":"22700 ","material_nbr":"000000000000753482","denominator":"100 ","base_unit":"KG"},{"sales_unit":"KG","numerator":"1 ","material_nbr":"000000000000753482","denominator":"1 ","base_unit":"KG"},{"sales_unit":"LB","numerator":"32523 ","material_nbr":"000000000000753482","denominator":"71701 ","base_unit":"KG"}],"tbl_list_prices":null,"tbl_csp_prices":[],"supplier":null,"sub_region":null,"specialty":null,"special_product":null,"sold_to":"0000094713","ship_to":"0000094713","sfdc_material_id":"","sfdc_account_id":"a56c0000000JdJYAA0","sales_unit":"DR","sales_org":null,"return_type":"S","return_message":"Price generated successfully","quantity":null,"product_cluster":null,"pricing_industry":null,"plm":null,"material_nbr":"000000000000753482","lbs_unit":"","division":null,"distr_chan":null,"customer_size":null,"business_line":"","base_price_uom":null,"base_price_unit":null,"base_price_currency":null,"base_price":null,"base_code":null,"avg_order_unit":"DR","avg_order_qty":"3.000 "}',Ship_To__c=acct.id,Sold_To__c=acct.id, Approval_Status__c='Pending Entry',Type__c='Quote');    
        insert PRT; 
        
        Price_Request_Transaction__c PRT1=new Price_Request_Transaction__c(Inner_Table__c='Test',Type__c='Requested',SAP_Data__c='{"tbl_target_prices":[{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"1.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.2165 ","exception2_price":"3.9213","exception2_pct":null,"exception1_price":"4.0057","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"4.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.1165 ","exception2_price":"3.8283","exception2_pct":null,"exception1_price":"3.9107","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"10.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.0165 ","exception2_price":"3.7353","exception2_pct":null,"exception1_price":"3.8157","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"40.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"3.9165 ","exception2_price":"3.6423","exception2_pct":null,"exception1_price":"3.7207","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null}],"tbl_sales_units":[{"sales_unit":"DR","numerator":"22700 ","material_nbr":"000000000000753482","denominator":"100 ","base_unit":"KG"},{"sales_unit":"KG","numerator":"1 ","material_nbr":"000000000000753482","denominator":"1 ","base_unit":"KG"},{"sales_unit":"LB","numerator":"32523 ","material_nbr":"000000000000753482","denominator":"71701 ","base_unit":"KG"}],"tbl_list_prices":null,"tbl_csp_prices":[],"supplier":null,"sub_region":null,"specialty":null,"special_product":null,"sold_to":"0000094713","ship_to":"0000094713","sfdc_material_id":"","sfdc_account_id":"a56c0000000JdJYAA0","sales_unit":"DR","sales_org":null,"return_type":"S","return_message":"Price generated successfully","quantity":null,"product_cluster":null,"pricing_industry":null,"plm":null,"material_nbr":"000000000000753482","lbs_unit":"","division":null,"distr_chan":null,"customer_size":null,"business_line":"","base_price_uom":null,"base_price_unit":null,"base_price_currency":null,"base_price":null,"base_code":null,"avg_order_unit":"DR","avg_order_qty":"3.000 "}',Ship_To__c=acct.id,Sold_To__c=acct.id, Approval_Status__c='Submitted');    
        PRT1.Approval_Status__c = 'Rejected-Alternate';
        insert PRT1; 
        
        SAP_Price__c SP1=new SAP_Price__c(Price_Request_Transaction__c=PRT1.id,type__c = 'Alternate');
        insert SP1; 
        
        PRT.RejectAlternateFlag__c = true;
        PRT.Approval_Status__c = 'Rejected-Alternate';
        PRT1.Approval_Status__c = 'Pending Entry';
        update PRT;
        update PRT1;
        }
      }
}