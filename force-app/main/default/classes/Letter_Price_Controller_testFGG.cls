@isTest
public class Letter_Price_Controller_testFGG {
    public static testMethod void testFGG(){
        
        Test.startTest();
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];      
        User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true,Ashland_Employee_Number__c = 'A123000');
        insert u;
        SAP_Seller__c ss = new SAP_Seller__c(name = 'test',User__c = u.id);          
        insert ss;         
        SAP_Territory__c ST = new SAP_Territory__c(Name = 'test', ZS_Partner__c = ss.id, YS_Partner__c = ss.id);
        insert ST;
        Account acct = new Account(name='TestAccount',SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Customer',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA',SAP_Partner_Functions__c='Sold To',YZ_Partner__c=ST.id);
        insert acct; 
        acct.Account_Number__c='^0+';
        update acct;
        
        Price_Letter__c pl = new Price_Letter__c(Customers__c = acct.id);            
        
        
        pl.Language__c='ENG';
        insert pl; 
  
   
        List<Account_Material__c> am = new List<Account_Material__c>();
        Material_Sales_Data2__c m = new Material_Sales_Data2__c(name = 'Test Material', Material_Number__c = '12344321',Material_Group3_Desc__c='SPECIALTY', Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',Record_Key__c = 'Test Record Key',Material_Group3_code__c='SPC');        
        insert m;    
        Account_Material__c accmat = new account_material__c(Account__c = acct.id, SAP_Material__c = m.id,CSP_Currency__c='USD');
        insert accmat;
        Price_Request_Transaction__c PRT=new Price_Request_Transaction__c(Inner_Table__c='Test',
                                                                              Requested_Tiers__c='[{"attributes":{"type":"SAP_Price_Tier__c"},"CurrencyIsoCode":"USD","Exception_2_Price__c":3.9213,"Effective_Date__c":"2013-04-24","Expiration_Date__c":"2014-01-01","DPL_Price_UoM__c":null,"Target_Tier_Price__c":4.2165,"DPL_Price__c":null,"Price_UoM__c":"LB","Volume__c":1.0,"Target_Tier_Price_UoM__c":"LB","Target_Tier_Price_Unit__c":1.0,"Price__c":4.0,"TPI__c":94.87,"Volume_UoM__c":"DR","Exception_1_Price__c":4.0057},{"attributes":{"type":"SAP_Price_Tier__c"},"CurrencyIsoCode":"USD","Exception_2_Price__c":3.8283000000000005,"Effective_Date__c":"2013-04-24","Expiration_Date__c":"2014-01-01","DPL_Price_UoM__c":null,"Target_Tier_Price__c":4.1165,"DPL_Price__c":null,"Price_UoM__c":"LB","Volume__c":4.0,"Target_Tier_Price_UoM__c":"LB","Target_Tier_Price_Unit__c":1.0,"Price__c":5.0,"TPI__c":121.46,"Volume_UoM__c":"DR","Exception_1_Price__c":3.9107}]',
                                                                              SAP_Data__c='{"tbl_target_prices":[{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"1.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.2165 ","exception2_price":"3.9213","exception2_pct":null,"exception1_price":"4.0057","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"4.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.1165 ","exception2_price":"3.8283","exception2_pct":null,"exception1_price":"3.9107","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"10.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.0165 ","exception2_price":"3.7353","exception2_pct":null,"exception1_price":"3.8157","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"40.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"3.9165 ","exception2_price":"3.6423","exception2_pct":null,"exception1_price":"3.7207","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null}],"tbl_sales_units":[{"sales_unit":"DR","numerator":"22700 ","material_nbr":"000000000000753482","denominator":"100 ","base_unit":"KG"},{"sales_unit":"KG","numerator":"1 ","material_nbr":"000000000000753482","denominator":"1 ","base_unit":"KG"},{"sales_unit":"LB","numerator":"32523 ","material_nbr":"000000000000753482","denominator":"71701 ","base_unit":"KG"}],"tbl_list_prices":null,"tbl_csp_prices":[],"supplier":null,"sub_region":null,"specialty":null,"special_product":null,"sold_to":"0000094713","ship_to":"0000094713","sfdc_material_id":"","sfdc_account_id":"a56c0000000JdJYAA0","sales_unit":"DR","sales_org":null,"return_type":"S","return_message":"Price generated successfully","quantity":null,"product_cluster":null,"pricing_industry":null,"plm":null,"material_nbr":"000000000000753482","lbs_unit":"","division":null,"distr_chan":null,"customer_size":null,"business_line":"","base_price_uom":null,"base_price_unit":null,"base_price_currency":null,"base_price":null,"base_code":null,"avg_order_unit":"DR","avg_order_qty":"3.000 "}',
                                                                         corporate_account__c=acct.id,Ship_To__c=acct.id,Sold_To__c=acct.id, Approval_Status__c='Pending Entry',Type__c='Quote',Account_Material__c=accmat.id);              
        insert PRT;    
        List<SAP_Price_Tier__c> SPT = new List<SAP_Price_Tier__c>();
        
        SAP_Price__c SP=new SAP_Price__c(Price_Request_Transaction__c=PRT.id,type__c = 'Requested');
        insert SP; 
        
        update SP;
           SAP_Price_Tier__c SAPPT=new SAP_Price_Tier__c(SAP_Price__c=SP.id);
        insert SAPPT;
        SPT.add(SAPPT);
     
     
        SAP_Price_tier__C sptier=new SAP_Price_tier__C();   
        sptier.SAP_Price__c=SP.Id;
        insert sptier;
        
        SPT.add(sptier);
        
        
        Price_Letter_item__c itemPL= new Price_Letter_item__c();
        itemPL.Account_Material__c=accmat.Id;
        itemPL.Price_Letter__c=pl.Id;
        //itemPL.Quote_Tiers__c=PRT.Id;
        //itemPl.CSP_Tiers__c=PRT.Id;
        System.debug('TEST FGG Price_letter_item '+pl.id);
        insert itemPL;
        Price_Letter_item__c itemPL2= new Price_Letter_item__c();
        itemPL2.Account_Material__c=accmat.Id;
        itemPL2.Price_Letter__c=pl.Id;
        insert itemPL2;
        
        Account_Material__c accmatQuery = new account_material__c();
        accmatQuery=[Select Account__c from Account_Material__c where Account__c=:acct.id];                
        update accmatQuery;
        am.add(accmatQuery);
        
        
        List<Price_Request_Transaction__c> transactions= new List<Price_Request_Transaction__c>();
        //PRT.SAP_Material__c=SAPM
        transactions.add(PRT);               

        Price_Letter__c price_letter = new Price_Letter__c();
        price_letter.Customers__c='test,test,test,test,test';
        price_letter.Sent__c=true;
        insert price_letter;
       
        ApexPages.standardController sc = new ApexPages.standardcontroller(pl);    
        Letter_Price_Controller letterController= new Letter_Price_Controller(sc);
        
        letterController.getHeaderDetailLine();
        letterController.getHeaderDetailLineCanadian(); 
        letterController.getLongDate();
        letterController.getHeaderDetailLineFrench();
        letterController.Quote_Tiers = SPT;
        letterController.CSP_Tiers= SPT;
        letterController.ams= am;
        
    ///////----Price Letter Location Class Testing------///////
    
    
            Letter_Price_Controller.tierInfo tierInfo1 = new Letter_Price_Controller.tierInfo(4.2165,4.2165,3.2,'2015-01-01','DR','LB','12','3.913','test','test','test','test');        
            //Date dte = system.Today();
            //dte= system.Today();
            Letter_Price_Controller.formatDate(system.today()-1);
            Letter_Price_Controller.formatDate(null);
            
    //////////////////////////////////////////////////////////
    //
    //
        
    //
    //Price_Request_Transaction__c t, Material_Sales_Data2__c m, List<SAP_Price_tier__c> Req, List<SAP_Price_tier__c> CSP 
        
        try{ 
            Letter_Price_Controller.Price_letter_Location pll= new Letter_Price_Controller.Price_letter_Location(PRT,m,SPT,SPT);
            
 
           }catch(Exception ex){}
        
        try{
            Letter_Price_Controller.Location locationTest= new Letter_Price_Controller.Location('type',acct);   
        }catch(Exception ex){}
    //Letter_Price_Controller.Price_letter_Location pll= new Letter_Price_Controller.Price_letter_Location(null,null,null,null);
    Test.stopTest();
   
 }  
}