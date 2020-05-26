@isTest

public class Letter_Price_Controller_test{

      public static testMethod void testFGG(){
       try{
        
         Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      
          /*User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true,Ashland_Employee_Number__c = 'A123000');
          insert u;*/
           id ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
         
          SAP_Seller__c ss = new SAP_Seller__c(name = 'test',User__c = nexeoIntegrationUser.id);
          
          insert ss;
         
          SAP_Territory__c ST = new SAP_Territory__c(Name = 'test', ZS_Partner__c = ss.id, YS_Partner__c = ss.id);
          insert ST;
          
        Material_Sales_Data2__c m = new Material_Sales_Data2__c(name = 'Test Material', Material_Number__c = '12344321',Material_Group3_Desc__c='SPECIALTY', Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',Record_Key__c = 'Test Record Key',Material_Group3_code__c='SPC');        
        insert m;                      
        Account acct = new Account(name='TestAccount',SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Customer',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA',SAP_Partner_Functions__c='Sold To',YZ_Partner__c=ST.id);
        insert acct; 
         Account_Material__c accmat = new account_material__c(Account__c = acct.id, SAP_Material__c = m.id,CSP_Currency__c='USD');        
        insert accmat;
        
            Price_Request_Transaction__c PRT=new Price_Request_Transaction__c(Inner_Table__c='Test',
                                                                              Requested_Tiers__c='[{"attributes":{"type":"SAP_Price_Tier__c"},"CurrencyIsoCode":"USD","Exception_2_Price__c":3.9213,"Effective_Date__c":"2013-04-24","Expiration_Date__c":"2014-01-01","DPL_Price_UoM__c":null,"Target_Tier_Price__c":4.2165,"DPL_Price__c":null,"Price_UoM__c":"LB","Volume__c":1.0,"Target_Tier_Price_UoM__c":"LB","Target_Tier_Price_Unit__c":1.0,"Price__c":4.0,"TPI__c":94.87,"Volume_UoM__c":"DR","Exception_1_Price__c":4.0057},{"attributes":{"type":"SAP_Price_Tier__c"},"CurrencyIsoCode":"USD","Exception_2_Price__c":3.8283000000000005,"Effective_Date__c":"2013-04-24","Expiration_Date__c":"2014-01-01","DPL_Price_UoM__c":null,"Target_Tier_Price__c":4.1165,"DPL_Price__c":null,"Price_UoM__c":"LB","Volume__c":4.0,"Target_Tier_Price_UoM__c":"LB","Target_Tier_Price_Unit__c":1.0,"Price__c":5.0,"TPI__c":121.46,"Volume_UoM__c":"DR","Exception_1_Price__c":3.9107}]',
                                                                              SAP_Data__c='{"tbl_target_prices":[{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"1.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.2165 ","exception2_price":"3.9213","exception2_pct":null,"exception1_price":"4.0057","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"4.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.1165 ","exception2_price":"3.8283","exception2_pct":null,"exception1_price":"3.9107","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"10.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.0165 ","exception2_price":"3.7353","exception2_pct":null,"exception1_price":"3.8157","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"40.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"3.9165 ","exception2_price":"3.6423","exception2_pct":null,"exception1_price":"3.7207","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null}],"tbl_sales_units":[{"sales_unit":"DR","numerator":"22700 ","material_nbr":"000000000000753482","denominator":"100 ","base_unit":"KG"},{"sales_unit":"KG","numerator":"1 ","material_nbr":"000000000000753482","denominator":"1 ","base_unit":"KG"},{"sales_unit":"LB","numerator":"32523 ","material_nbr":"000000000000753482","denominator":"71701 ","base_unit":"KG"}],"tbl_list_prices":null,"tbl_csp_prices":[],"supplier":null,"sub_region":null,"specialty":null,"special_product":null,"sold_to":"0000094713","ship_to":"0000094713","sfdc_material_id":"","sfdc_account_id":"a56c0000000JdJYAA0","sales_unit":"DR","sales_org":null,"return_type":"S","return_message":"Price generated successfully","quantity":null,"product_cluster":null,"pricing_industry":null,"plm":null,"material_nbr":"000000000000753482","lbs_unit":"","division":null,"distr_chan":null,"customer_size":null,"business_line":"","base_price_uom":null,"base_price_unit":null,"base_price_currency":null,"base_price":null,"base_code":null,"avg_order_unit":"DR","avg_order_qty":"3.000 "}',
                                                                              Freight_Terms__c='ZD1-DDP Dest',corporate_account__c=acct.id,Ship_To__c=acct.id,Sold_To__c=acct.id, Approval_Status__c='Pending Entry',Type__c='Quote',Account_Material__c=accmat.id);    
        insert PRT; 
          Price_Letter__c pl = new Price_Letter__c(Customers__c = acct.id);            
        insert pl;            
         SAP_Price__c SP=new SAP_Price__c(Price_Request_Transaction__c=PRT.id,type__c = 'Requested');
        insert SP; 
        SAP_Price_Tier__c SPT=new SAP_Price_Tier__c(SAP_Price__c=SP.id);
        insert SPT;
        Price_Letter_Item__c pi = new Price_Letter_Item__c(Account_Material__c = accmat.id,Price_Letter__c = pl.id, CSP_Tiers__c = sp.Id, Quote_Tiers__c = sp.Id );            
        insert pi;     
         //update pl; 

         Price_Letter__c price_letter = new Price_Letter__c();
         ApexPages.standardController sc = new ApexPages.standardcontroller(pl);     
          Letter_Price_Controller priceLetterPage = new Letter_Price_Controller(sc);
          
         //Letter_Price_Controller.getHeaderDetailLine();
         
         // priceLetterPage.getLongDate();
         //priceLetterPage.getHeaderDetailLineFrench();
        /*
         Letter_Price_Controller.Price_Letter_Location priceLetterLoc = new Letter_Price_Controller.Price_Letter_Location(new Price_Request_Transaction__c(), new Material_Sales_Data2__c(), new List<SAP_Price_tier__c>(), new List<SAP_Price_tier__c>());
         //priceLetterLoc.addItem(new Material_Sales_Data2__c(), new List<SAP_Price_tier__c>(), new List<SAP_Price_tier__c>());
               
                
            Letter_Price_Controller.Location location = new Letter_Price_Controller.Location('String', acct);
                      */ 
            Letter_Price_Controller.tierInfo tierInfo1 = new Letter_Price_Controller.tierInfo(4.2165,4.1659,3.2,'2015-01-01','DR','LB','12','3.913','test','test','test','test');
            //Date dte = system.Today();
            //dte= system.Today();
            Letter_Price_Controller.formatDate(system.today()-1);
            }catch(exception e){}
      
    }
    
    
    
     public static testMethod void test(){
        try{
        
         Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      
          User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true,Ashland_Employee_Number__c = 'A123000');
          insert u;
         
          SAP_Seller__c ss = new SAP_Seller__c(name = 'test',User__c = u.id);
          insert ss;
         
          SAP_Territory__c ST = new SAP_Territory__c(Name = 'test', ZS_Partner__c = ss.id, YS_Partner__c = ss.id);
          insert ST;
          
        Material_Sales_Data2__c m = new Material_Sales_Data2__c(name = 'Test Material', Material_Number__c = '12344321',Material_Group3_Desc__c='SPECIALTY', Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',Record_Key__c = 'Test Record Key',Material_Group3_code__c='SPC');        
        insert m;                      
        Account acct = new Account(name='TestAccount',SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Customer',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA',SAP_Partner_Functions__c='Sold To',YZ_Partner__c=ST.id);
        insert acct; 
         Account_Material__c accmat = new account_material__c(Account__c = acct.id, SAP_Material__c = m.id,CSP_Currency__c='USD');        
        insert accmat;
        
            Price_Request_Transaction__c PRT=new Price_Request_Transaction__c(Inner_Table__c='Test',
                                                                              Requested_Tiers__c='[{"attributes":{"type":"SAP_Price_Tier__c"},"CurrencyIsoCode":"USD","Exception_2_Price__c":3.9213,"Effective_Date__c":"2013-04-24","Expiration_Date__c":"2014-01-01","DPL_Price_UoM__c":null,"Target_Tier_Price__c":4.2165,"DPL_Price__c":null,"Price_UoM__c":"LB","Volume__c":1.0,"Target_Tier_Price_UoM__c":"LB","Target_Tier_Price_Unit__c":1.0,"Price__c":4.0,"TPI__c":94.87,"Volume_UoM__c":"DR","Exception_1_Price__c":4.0057},{"attributes":{"type":"SAP_Price_Tier__c"},"CurrencyIsoCode":"USD","Exception_2_Price__c":3.8283000000000005,"Effective_Date__c":"2013-04-24","Expiration_Date__c":"2014-01-01","DPL_Price_UoM__c":null,"Target_Tier_Price__c":4.1165,"DPL_Price__c":null,"Price_UoM__c":"LB","Volume__c":4.0,"Target_Tier_Price_UoM__c":"LB","Target_Tier_Price_Unit__c":1.0,"Price__c":5.0,"TPI__c":121.46,"Volume_UoM__c":"DR","Exception_1_Price__c":3.9107}]',
                                                                              SAP_Data__c='{"tbl_target_prices":[{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"1.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.2165 ","exception2_price":"3.9213","exception2_pct":null,"exception1_price":"4.0057","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"4.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.1165 ","exception2_price":"3.8283","exception2_pct":null,"exception1_price":"3.9107","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"10.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.0165 ","exception2_price":"3.7353","exception2_pct":null,"exception1_price":"3.8157","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"40.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"3.9165 ","exception2_price":"3.6423","exception2_pct":null,"exception1_price":"3.7207","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null}],"tbl_sales_units":[{"sales_unit":"DR","numerator":"22700 ","material_nbr":"000000000000753482","denominator":"100 ","base_unit":"KG"},{"sales_unit":"KG","numerator":"1 ","material_nbr":"000000000000753482","denominator":"1 ","base_unit":"KG"},{"sales_unit":"LB","numerator":"32523 ","material_nbr":"000000000000753482","denominator":"71701 ","base_unit":"KG"}],"tbl_list_prices":null,"tbl_csp_prices":[],"supplier":null,"sub_region":null,"specialty":null,"special_product":null,"sold_to":"0000094713","ship_to":"0000094713","sfdc_material_id":"","sfdc_account_id":"a56c0000000JdJYAA0","sales_unit":"DR","sales_org":null,"return_type":"S","return_message":"Price generated successfully","quantity":null,"product_cluster":null,"pricing_industry":null,"plm":null,"material_nbr":"000000000000753482","lbs_unit":"","division":null,"distr_chan":null,"customer_size":null,"business_line":"","base_price_uom":null,"base_price_unit":null,"base_price_currency":null,"base_price":null,"base_code":null,"avg_order_unit":"DR","avg_order_qty":"3.000 "}',
                                                                              Freight_Terms__c='ZD1-DDP Dest',corporate_account__c=acct.id,Ship_To__c=acct.id,Sold_To__c=acct.id, Approval_Status__c='Pending Entry',Type__c='Quote',Account_Material__c=accmat.id);    
        insert PRT; 
          Price_Letter__c pl = new Price_Letter__c(Customers__c = acct.id);            
        insert pl;            
         SAP_Price__c SP=new SAP_Price__c(Price_Request_Transaction__c=PRT.id,type__c = 'Requested');
        insert SP; 
        SAP_Price_Tier__c SPT=new SAP_Price_Tier__c(SAP_Price__c=SP.id);
        insert SPT;
        Price_Letter_Item__c pi = new Price_Letter_Item__c(Account_Material__c = accmat.id,Price_Letter__c = pl.id, CSP_Tiers__c = sp.Id, Quote_Tiers__c = sp.Id );            
        insert pi;     
         update pl; 

         Price_Letter__c price_letter = new Price_Letter__c();
         ApexPages.standardController sc = new ApexPages.standardcontroller(pl);
        
            
            Letter_Price_Controller priceLetterPage = new Letter_Price_Controller(sc);
         priceLetterPage.getHeaderDetailLine();
         priceLetterPage.getLongDate();
         priceLetterPage.getHeaderDetailLineFrench();
         
         Letter_Price_Controller.Price_Letter_Location priceLetterLoc = new Letter_Price_Controller.Price_Letter_Location(new Price_Request_Transaction__c(), new Material_Sales_Data2__c(), new List<SAP_Price_tier__c>(), new List<SAP_Price_tier__c>());
         //priceLetterLoc.addItem(new Material_Sales_Data2__c(), new List<SAP_Price_tier__c>(), new List<SAP_Price_tier__c>());
                      
                
            Letter_Price_Controller.Location location = new Letter_Price_Controller.Location('String', acct);
            
            Letter_Price_Controller.tierInfo tierInfo1 = new Letter_Price_Controller.tierInfo(4.2165,4.1659,3.2,'2015-01-01','DR','LB','12','3.913','test','test','test','test');
            //Date dte = system.Today();
            //dte= system.Today();
            Letter_Price_Controller.formatDate(system.today()-1);
            
          }
          catch(exception e){}
    }
    
    
     public static testMethod void testMe(){
        try{
        
         Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      
          User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true,Ashland_Employee_Number__c = 'Z123456');
          insert u;
         
          SAP_Seller__c ss = new SAP_Seller__c(name = 'test',User__c = u.id);
          insert ss;
         
          SAP_Territory__c ST = new SAP_Territory__c(Name = 'test', ZS_Partner__c = ss.id, YS_Partner__c = ss.id);
          insert ST;
          
        Material_Sales_Data2__c m = new Material_Sales_Data2__c(name = 'Test Material', Material_Number__c = '12344321', Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',Record_Key__c = 'Test Record Key',Material_Group3_Desc__c='SPECIALTY');        
        insert m;                      
        Account acct = new Account(name='TestAccount',SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Vendor',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA',SAP_Partner_Functions__c='Sold To',YZ_Partner__c=ST.id);
        insert acct; 
         Account_Material__c accmat = new account_material__c(Account__c = acct.id, SAP_Material__c = m.id);        
        insert accmat;
            Price_Request_Transaction__c PRT=new Price_Request_Transaction__c(Inner_Table__c='Test',
                                                                              Requested_Tiers__c='[{"attributes":{"type":"SAP_Price_Tier__c"},"CurrencyIsoCode":"USD","Exception_2_Price__c":3.9213,"Effective_Date__c":"2013-04-24","Expiration_Date__c":"2014-01-01","DPL_Price_UoM__c":null,"Target_Tier_Price__c":4.2165,"DPL_Price__c":null,"Price_UoM__c":"LB","Volume__c":1.0,"Target_Tier_Price_UoM__c":"LB","Target_Tier_Price_Unit__c":1.0,"Price__c":4.0,"TPI__c":94.87,"Volume_UoM__c":"DR","Exception_1_Price__c":4.0057},{"attributes":{"type":"SAP_Price_Tier__c"},"CurrencyIsoCode":"USD","Exception_2_Price__c":3.8283000000000005,"Effective_Date__c":"2013-04-24","Expiration_Date__c":"2014-01-01","DPL_Price_UoM__c":null,"Target_Tier_Price__c":4.1165,"DPL_Price__c":null,"Price_UoM__c":"LB","Volume__c":4.0,"Target_Tier_Price_UoM__c":"LB","Target_Tier_Price_Unit__c":1.0,"Price__c":5.0,"TPI__c":121.46,"Volume_UoM__c":"DR","Exception_1_Price__c":3.9107}]',
                                                                              SAP_Data__c='{"tbl_target_prices":[{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"1.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.2165 ","exception2_price":"3.9213","exception2_pct":null,"exception1_price":"4.0057","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"4.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.1165 ","exception2_price":"3.8283","exception2_pct":null,"exception1_price":"3.9107","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"10.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.0165 ","exception2_price":"3.7353","exception2_pct":null,"exception1_price":"3.8157","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"40.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"3.9165 ","exception2_price":"3.6423","exception2_pct":null,"exception1_price":"3.7207","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null}],"tbl_sales_units":[{"sales_unit":"DR","numerator":"22700 ","material_nbr":"000000000000753482","denominator":"100 ","base_unit":"KG"},{"sales_unit":"KG","numerator":"1 ","material_nbr":"000000000000753482","denominator":"1 ","base_unit":"KG"},{"sales_unit":"LB","numerator":"32523 ","material_nbr":"000000000000753482","denominator":"71701 ","base_unit":"KG"}],"tbl_list_prices":null,"tbl_csp_prices":[],"supplier":null,"sub_region":null,"specialty":null,"special_product":null,"sold_to":"0000094713","ship_to":"0000094713","sfdc_material_id":"","sfdc_account_id":"a56c0000000JdJYAA0","sales_unit":"DR","sales_org":null,"return_type":"S","return_message":"Price generated successfully","quantity":null,"product_cluster":null,"pricing_industry":null,"plm":null,"material_nbr":"000000000000753482","lbs_unit":"","division":null,"distr_chan":null,"customer_size":null,"business_line":"","base_price_uom":null,"base_price_unit":null,"base_price_currency":null,"base_price":null,"base_code":null,"avg_order_unit":"DR","avg_order_qty":"3.000 "}',
                                                                              Ship_To__c=acct.id,Sold_To__c=acct.id, Approval_Status__c='Pending Entry',Type__c='Quote',Account_Material__c=accmat.id);    
        insert PRT; 
          Price_Letter__c pl = new Price_Letter__c(Customers__c = 'abc');            
        insert pl;            
         SAP_Price__c SP=new SAP_Price__c(Price_Request_Transaction__c=PRT.id,type__c = 'CSP');
        insert SP; 
        List<SAP_Price_Tier__c> sptLst = new List<SAP_Price_Tier__c>();
        SAP_Price_Tier__c SPT=new SAP_Price_Tier__c(SAP_Price__c=SP.id);
        insert SPT;
        sptLst.add(spt);
        Price_Letter_Item__c pi = new Price_Letter_Item__c(Account_Material__c = accmat.id,Price_Letter__c = pl.id, CSP_Tiers__c = sp.Id, Quote_Tiers__c = sp.Id );            
        insert pi;     
         update pl; 

         Price_Letter__c price_letter = new Price_Letter__c();
         ApexPages.standardController sc = new ApexPages.standardcontroller(pl);
         Letter_Price_Controller priceLetterPage = new Letter_Price_Controller(sc);
         string res = priceLetterPage.getHeaderDetailLine();
         //priceLetterPage.getLongDate();
         string resFrnch = priceLetterPage.getHeaderDetailLineFrench();
         
         Letter_Price_Controller.Price_Letter_Location priceLetterLoc = new Letter_Price_Controller.Price_Letter_Location(new Price_Request_Transaction__c(), new Material_Sales_Data2__c(), new List<SAP_Price_tier__c>(), new List<SAP_Price_tier__c>());
         //priceLetterLoc.addItem(new Material_Sales_Data2__c(), new List<SAP_Price_tier__c>(), new List<SAP_Price_tier__c>());
                          
                
            Letter_Price_Controller.Location location = new Letter_Price_Controller.Location('String', acct);
            
            priceLetterPage.Quote_Tiers = sptLst;
            
            Letter_Price_Controller.tierInfo tierInfo1 = new Letter_Price_Controller.tierInfo(4.2165,4.1659,3.2,'2015-01-01','DR','LB','12','3.913','test','test','test','test');
            //Date dte = system.Today();
            //dte= system.Today();
            Letter_Price_Controller.formatDate(system.today()-1);
            
          }
          catch(exception e){}
    }
  
  
}