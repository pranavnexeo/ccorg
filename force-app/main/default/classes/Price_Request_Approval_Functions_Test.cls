@istest
public class Price_Request_Approval_Functions_Test{

static Account acct1 = new Account();
static Account_Material__c am1 = new Account_Material__c();
static Price_Request_Transaction__c PRT1 = new Price_Request_Transaction__c();

public static testMethod void testPriceReqAppFunc()
{
//List<Material_Sales_Data2__c> matlist = [select id,Material_Group2_Code__c,material_group4_code__c from Material_Sales_Data2__c limit 1];
Material_Sales_Data2__c matlist = new Material_Sales_Data2__c(name = 'Test Material', Material_Number__c = '12344321', Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',   Record_Key__c = 'Test Record Key');        
        insert matlist;
 try{       
Account a = new Account(name = 'Test Account',sap_salesgroup__c = '1000');
insert a;
string acct = a.Id;

Account_Material__c am = new account_material__c();
am.account__c = acct;
am.sap_material__c = matlist.id; 
insert am;
}
catch(exception e){}
    //Adding code to prevent have hardcoded IDs
Map<String, SObject> testData = NexeoTestUtils_Test.initData();  
User u = (User) testData.get('testUser1');    
Profile profile = [select id from profile where name='System Administrator'];
User user = new User(Out_Of_Office__c = system.today(),backup__c = u.Id,alias = 'standt', email='standarduser@testorg.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = profile.Id,Price_Coord_Region__c='US', 
            timezonesidkey='America/Los_Angeles', username='supplierMain@testorg.com',SAP_Cust_Num__c='0000011111');
            insert user;
            
List<User> usrlist = new List<User>();
usrlist.add(user);           
            
Map<Id,User> usermap = new Map<Id,User>(usrlist);


Price_Request_Transaction__c transrecord = new Price_Request_Transaction__c(Requested_Price_Protection__c = 'test');
insert transrecord;
SAP_Price__c sp=new SAP_Price__c(Price_Request_Transaction__c=transrecord.Id);
insert sp;
SAP_Price_Tier__c prt=new SAP_Price_Tier__c(Target_Tier_Price_Unit__c = 3,Price_Unit__c=18,SAP_Price__c=sp.Id, Price__c = 15);
insert prt;
 List<SAP_Price_Tier__c> sptList = new List<SAP_Price_Tier__c>();
    sptList.add(prt);
   Sap_Price sapPrice = new Sap_Price();
 
    sapPrice.SAP_Price = sp;
    sapPrice.SAP_Tiers = sptList;
    
Price_Protection_Codes__c ppc= new Price_Protection_Codes__c(Level__c = null,name = 'data');
insert ppc;
    
Price_Request_Transaction pTran = new Price_Request_Transaction(transrecord);
    
    pTran.List_Prices = sapPrice;
    pTran.CSP_Prices = sapPrice;
    pTran.Target_Prices = sapPrice;
    pTran.Requested_Tiers = sapPrice;
Price_Request_Approval_Functions con=new Price_Request_Approval_Functions();  
boolean ismatch =True;


try{
acct1 = new Account(name='TestAccount',SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Vendor',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA',owner = user);
insert acct1;
am1=new Account_Material__c(Account__c=acct1.id,PRT_Form__c='Test',Adjust_Form__c='Test',Avg_Order_Qty__c=10,Competitive_Price__c=24,CurrencyIsoCode='CAD',SAP_Data__c='{"tbl_target_prices":[{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"1.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.2165 ","exception2_price":"3.9213","exception2_pct":null,"exception1_price":"4.0057","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"4.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.1165 ","exception2_price":"3.8283","exception2_pct":null,"exception1_price":"3.9107","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"10.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.0165 ","exception2_price":"3.7353","exception2_pct":null,"exception1_price":"3.8157","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"40.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"3.9165 ","exception2_price":"3.6423","exception2_pct":null,"exception1_price":"3.7207","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null}],"tbl_sales_units":[{"sales_unit":"DR","numerator":"22700 ","material_nbr":"000000000000753482","denominator":"100 ","base_unit":"KG"},{"sales_unit":"KG","numerator":"1 ","material_nbr":"000000000000753482","denominator":"1 ","base_unit":"KG"},{"sales_unit":"LB","numerator":"32523 ","material_nbr":"000000000000753482","denominator":"71701 ","base_unit":"KG"}],"tbl_list_prices":null,"tbl_csp_prices":[],"supplier":null,"sub_region":null,"specialty":null,"special_product":null,"sold_to":"0000094713","ship_to":"0000094713","sfdc_material_id":"","sfdc_account_id":"a56c0000000JdJYAA0","sales_unit":"DR","sales_org":null,"return_type":"S","return_message":"Price generated successfully","quantity":null,"product_cluster":null,"pricing_industry":null,"plm":null,"material_nbr":"000000000000753482","lbs_unit":"","division":null,"distr_chan":null,"customer_size":null,"business_line":"","base_price_uom":null,"base_price_unit":null,"base_price_currency":null,"base_price":null,"base_code":null,"avg_order_unit":"DR","avg_order_qty":"3.000 "}');
insert am1;
//data.add(am1.Id);
}
catch(exception e){}
PRT1=new Price_Request_Transaction__c(Inner_Table__c='Test',Requested_Tiers__c='[{"attributes":{"type":"SAP_Price_Tier__c"},"CurrencyIsoCode":"USD","Exception_2_Price__c":3.9213,"Effective_Date__c":"2013-04-24","Expiration_Date__c":"2014-01-01","DPL_Price_UoM__c":null,"Target_Tier_Price__c":4.2165,"DPL_Price__c":null,"Price_UoM__c":"LB","Volume__c":1.0,"Target_Tier_Price_UoM__c":"LB","Target_Tier_Price_Unit__c":1.0,"Price__c":4.0,"TPI__c":94.87,"Volume_UoM__c":"DR","Exception_1_Price__c":4.0057},{"attributes":{"type":"SAP_Price_Tier__c"},"CurrencyIsoCode":"USD","Exception_2_Price__c":3.8283000000000005,"Effective_Date__c":"2013-04-24","Expiration_Date__c":"2014-01-01","DPL_Price_UoM__c":null,"Target_Tier_Price__c":4.1165,"DPL_Price__c":null,"Price_UoM__c":"LB","Volume__c":4.0,"Target_Tier_Price_UoM__c":"LB","Target_Tier_Price_Unit__c":1.0,"Price__c":5.0,"TPI__c":121.46,"Volume_UoM__c":"DR","Exception_1_Price__c":3.9107}]',SAP_Data__c='{"tbl_target_prices":[{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"1.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.2165 ","exception2_price":"3.9213","exception2_pct":null,"exception1_price":"4.0057","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"4.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.1165 ","exception2_price":"3.8283","exception2_pct":null,"exception1_price":"3.9107","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"10.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.0165 ","exception2_price":"3.7353","exception2_pct":null,"exception1_price":"3.8157","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"40.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"3.9165 ","exception2_price":"3.6423","exception2_pct":null,"exception1_price":"3.7207","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null}],"tbl_sales_units":[{"sales_unit":"DR","numerator":"22700 ","material_nbr":"000000000000753482","denominator":"100 ","base_unit":"KG"},{"sales_unit":"KG","numerator":"1 ","material_nbr":"000000000000753482","denominator":"1 ","base_unit":"KG"},{"sales_unit":"LB","numerator":"32523 ","material_nbr":"000000000000753482","denominator":"71701 ","base_unit":"KG"}],"tbl_list_prices":null,"tbl_csp_prices":[],"supplier":null,"sub_region":null,"specialty":null,"special_product":null,"sold_to":"0000094713","ship_to":"0000094713","sfdc_material_id":"","sfdc_account_id":"a56c0000000JdJYAA0","sales_unit":"DR","sales_org":null,"return_type":"S","return_message":"Price generated successfully","quantity":null,"product_cluster":null,"pricing_industry":null,"plm":null,"material_nbr":"000000000000753482","lbs_unit":"","division":null,"distr_chan":null,"customer_size":null,"business_line":"","base_price_uom":null,"base_price_unit":null,"base_price_currency":null,"base_price":null,"base_code":null,"avg_order_unit":"DR","avg_order_qty":"3.000 "}',Approval_Status__c='Pending Entry',Type__c='CSP');    
insert PRT1; 
List<Price_Request_Transaction> pTranReqList = new List<Price_Request_Transaction>();
pTranReqList.add(pTran);
try{
Price_Request_Approval_Functions.FetchApproverMap(pTranReqList);
}
catch(exception e){}
//Price_Request_Approval_Functions.FindInOfficeUser(user.id,usermap);
//Price_Request_Approval_Functions.checkuser(user.id,usermap,0); 

//List<Price_Request_Transaction__c> pTranReqList1 = new List<Price_Request_Transaction__c>();

//pTranReqList1.add(PRT1);
//Price_Request_Approval_Functions.FetchApproverMap(pTranReqList1);

}

public static testMethod void testPriceReqAppFunc1()
{
//List<Material_Sales_Data2__c> matlist = [select id,Material_Group2_Code__c,material_group4_code__c from Material_Sales_Data2__c limit 1];

Material_Sales_Data2__c matlist = new Material_Sales_Data2__c(name = 'Test Material', Material_Number__c = '12344321', Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',   Record_Key__c = 'Test Record Key');        
        insert matlist;
    try{    
Account a = new Account(name = 'Test Account',sap_salesgroup__c = '1000');
insert a;
string acct = a.Id;

Account_Material__c am = new account_material__c();
am.account__c = acct;
am.sap_material__c = matlist.id; 
insert am;
}
catch(exception e){}
        //Adding code to prevent have hardcoded IDs
Map<String, SObject> testData = NexeoTestUtils_Test.initData();  
User u = (User) testData.get('testUser1');  
Profile profile = [select id from profile where name='System Administrator'];
User user = new User(Out_Of_Office__c = null,backup__c = u.Id,alias = 'standt', email='standarduser@testorg.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = profile.Id,Price_Coord_Region__c='US', 
            timezonesidkey='America/Los_Angeles', username='supplierMain@testorg.com',SAP_Cust_Num__c='0000011111');
            insert user;
            
List<User> usrlist = new List<User>();
usrlist.add(user);           
            
Map<Id,User> usermap = new Map<Id,User>(usrlist);


Price_Request_Transaction__c transrecord = new Price_Request_Transaction__c(Requested_Price_Protection__c = 'test');
insert transrecord;
SAP_Price__c sp=new SAP_Price__c(Price_Request_Transaction__c=transrecord.Id);
insert sp;
SAP_Price_Tier__c prt=new SAP_Price_Tier__c(Target_Tier_Price_Unit__c = 0,Price_Unit__c=18,SAP_Price__c=sp.Id, Price__c = 15);
insert prt;
 List<SAP_Price_Tier__c> sptList = new List<SAP_Price_Tier__c>();
    sptList.add(prt);
   Sap_Price sapPrice = new Sap_Price();
 
    sapPrice.SAP_Price = sp;
    sapPrice.SAP_Tiers = sptList;
    
/*Price_Request_Transaction pTran = new Price_Request_Transaction(transrecord);
    
    pTran.List_Prices = sapPrice;
    pTran.CSP_Prices = sapPrice;
    pTran.Target_Prices = sapPrice;
    pTran.Requested_Tiers = sapPrice;
    */
Price_Request_Approval_Functions con=new Price_Request_Approval_Functions();  
boolean ismatch =True;


try{
acct1 = new Account(name='TestAccount',SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Vendor',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA',owner = user);
insert acct1;
am1=new Account_Material__c(Account__c=acct1.id,PRT_Form__c='Test',Adjust_Form__c='Test',Avg_Order_Qty__c=10,Competitive_Price__c=24,CurrencyIsoCode='CAD',SAP_Data__c='{"tbl_target_prices":[{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"1.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.2165 ","exception2_price":"3.9213","exception2_pct":null,"exception1_price":"4.0057","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"4.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.1165 ","exception2_price":"3.8283","exception2_pct":null,"exception1_price":"3.9107","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"10.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.0165 ","exception2_price":"3.7353","exception2_pct":null,"exception1_price":"3.8157","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"40.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"3.9165 ","exception2_price":"3.6423","exception2_pct":null,"exception1_price":"3.7207","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null}],"tbl_sales_units":[{"sales_unit":"DR","numerator":"22700 ","material_nbr":"000000000000753482","denominator":"100 ","base_unit":"KG"},{"sales_unit":"KG","numerator":"1 ","material_nbr":"000000000000753482","denominator":"1 ","base_unit":"KG"},{"sales_unit":"LB","numerator":"32523 ","material_nbr":"000000000000753482","denominator":"71701 ","base_unit":"KG"}],"tbl_list_prices":null,"tbl_csp_prices":[],"supplier":null,"sub_region":null,"specialty":null,"special_product":null,"sold_to":"0000094713","ship_to":"0000094713","sfdc_material_id":"","sfdc_account_id":"a56c0000000JdJYAA0","sales_unit":"DR","sales_org":null,"return_type":"S","return_message":"Price generated successfully","quantity":null,"product_cluster":null,"pricing_industry":null,"plm":null,"material_nbr":"000000000000753482","lbs_unit":"","division":null,"distr_chan":null,"customer_size":null,"business_line":"","base_price_uom":null,"base_price_unit":null,"base_price_currency":null,"base_price":null,"base_code":null,"avg_order_unit":"DR","avg_order_qty":"3.000 "}');
insert am1;
//data.add(am1.Id);
}
catch(exception e){}
PRT1=new Price_Request_Transaction__c(Inner_Table__c='Test',Requested_Tiers__c='[{"attributes":{"type":"SAP_Price_Tier__c"},"CurrencyIsoCode":"USD","Exception_2_Price__c":3.9213,"Effective_Date__c":"2013-04-24","Expiration_Date__c":"2014-01-01","DPL_Price_UoM__c":null,"Target_Tier_Price__c":4.2165,"DPL_Price__c":null,"Price_UoM__c":"LB","Volume__c":1.0,"Target_Tier_Price_UoM__c":"LB","Target_Tier_Price_Unit__c":1.0,"Price__c":4.0,"TPI__c":94.87,"Volume_UoM__c":"DR","Exception_1_Price__c":4.0057},{"attributes":{"type":"SAP_Price_Tier__c"},"CurrencyIsoCode":"USD","Exception_2_Price__c":3.8283000000000005,"Effective_Date__c":"2013-04-24","Expiration_Date__c":"2014-01-01","DPL_Price_UoM__c":null,"Target_Tier_Price__c":4.1165,"DPL_Price__c":null,"Price_UoM__c":"LB","Volume__c":4.0,"Target_Tier_Price_UoM__c":"LB","Target_Tier_Price_Unit__c":1.0,"Price__c":5.0,"TPI__c":121.46,"Volume_UoM__c":"DR","Exception_1_Price__c":3.9107}]',SAP_Data__c='{"tbl_target_prices":[{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"1.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.2165 ","exception2_price":"3.9213","exception2_pct":null,"exception1_price":"4.0057","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"4.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.1165 ","exception2_price":"3.8283","exception2_pct":null,"exception1_price":"3.9107","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"10.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.0165 ","exception2_price":"3.7353","exception2_pct":null,"exception1_price":"3.8157","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"40.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"3.9165 ","exception2_price":"3.6423","exception2_pct":null,"exception1_price":"3.7207","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null}],"tbl_sales_units":[{"sales_unit":"DR","numerator":"22700 ","material_nbr":"000000000000753482","denominator":"100 ","base_unit":"KG"},{"sales_unit":"KG","numerator":"1 ","material_nbr":"000000000000753482","denominator":"1 ","base_unit":"KG"},{"sales_unit":"LB","numerator":"32523 ","material_nbr":"000000000000753482","denominator":"71701 ","base_unit":"KG"}],"tbl_list_prices":null,"tbl_csp_prices":[],"supplier":null,"sub_region":null,"specialty":null,"special_product":null,"sold_to":"0000094713","ship_to":"0000094713","sfdc_material_id":"","sfdc_account_id":"a56c0000000JdJYAA0","sales_unit":"DR","sales_org":null,"return_type":"S","return_message":"Price generated successfully","quantity":null,"product_cluster":null,"pricing_industry":null,"plm":null,"material_nbr":"000000000000753482","lbs_unit":"","division":null,"distr_chan":null,"customer_size":null,"business_line":"","base_price_uom":null,"base_price_unit":null,"base_price_currency":null,"base_price":null,"base_code":null,"avg_order_unit":"DR","avg_order_qty":"3.000 "}',Approval_Status__c='Pending Entry',Type__c='CSP');    
insert PRT1; 
//List<Price_Request_Transaction> pTranReqList = new List<Price_Request_Transaction>();
//pTranReqList.add(pTran);

//Price_Request_Approval_Functions.FetchApproverMap(pTranReqList);
Price_Request_Approval_Functions.FindInOfficeUser(user.id,usermap);
Price_Request_Approval_Functions.checkuser(user.id,usermap,0); 

Price_Protection_Codes__c ppc= new Price_Protection_Codes__c(Level__c = 22.21,name = 'data');
insert ppc;

List<Price_Request_Transaction__c> pTranReqList1 = new List<Price_Request_Transaction__c>();

pTranReqList1.add(PRT1);
Price_Request_Approval_Functions.FetchApproverMap(pTranReqList1);
Price_Request_Approval_Functions.issame('test','StandardString');
Price_Request_Approval_Functions.sellercheck('OwnerSellerNum','SAPSellerNum');

}
        public static testMethod void testPriceReqAppFuncFGG(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      
          User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true,Ashland_Employee_Number__c = 'A123000');
          insert u;
         Map<Id, User> alluser= new Map<Id, User>();
            alluser.put(u.Id, u);
            Price_Request_Approval_Functions.FindInOfficeUser(u.Id, alluser);
            
                         SAP_Seller__c ss = new SAP_Seller__c(name = 'test',User__c = u.id);
          insert ss;
          
        List<Price_Request_approver__c> prl = new  List<Price_Request_approver__c>();
          Price_Request_Approver__c pra = new Price_Request_Approver__c(is_active__c = true,Division_Code__c = '31',SAP_Sales_Group_Code__c = '1700',Material_Group_4__c = 'test',PLM__c = 'testdata',SAP_Sales_Group__c = 'comdata',approval_level__c = 'Exception_Level',Approver__c = u.id);
          insert pra;
          prl.add(pra); 
         
        Material_Sales_Data2__c m = new Material_Sales_Data2__c(name = 'Test Material', Material_Number__c = '12344321',Material_Group3_Desc__c='SPECIALTY', Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',Record_Key__c = 'Test Record Key',Material_Group3_code__c='SPC');        
        insert m;            
          SAP_Territory__c ST = new SAP_Territory__c(Name = 'test', ZS_Partner__c = ss.id, YS_Partner__c = ss.id);
          insert ST; 
          try{ 
        Account acct = new Account(name='TestAccount',SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Customer',SAP_Accounting_Group__c='ZVEN',SAP_PartnerFunctionCodeText__c='123456',SAP_PartnerFunctionText__c='ZA',SAP_Partner_Functions__c='Sold To',YZ_Partner__c=ST.id);
        insert acct; 
          Account_Material__c accmat = new account_material__c(Account__c = acct.id, SAP_Material__c = m.id,CSP_Currency__c='USD');        
        insert accmat;
        }
        catch(exception e){}
        Price_Request_Transaction__c PRT=new Price_Request_Transaction__c(Inner_Table__c='Test',
                                                                              Requested_Tiers__c='[{"attributes":{"type":"SAP_Price_Tier__c"},"CurrencyIsoCode":"USD","Exception_2_Price__c":3.9213,"Effective_Date__c":"2013-04-24","Expiration_Date__c":"2014-01-01","DPL_Price_UoM__c":null,"Target_Tier_Price__c":4.2165,"DPL_Price__c":null,"Price_UoM__c":"LB","Volume__c":1.0,"Target_Tier_Price_UoM__c":"LB","Target_Tier_Price_Unit__c":1.0,"Price__c":4.0,"TPI__c":94.87,"Volume_UoM__c":"DR","Exception_1_Price__c":4.0057},{"attributes":{"type":"SAP_Price_Tier__c"},"CurrencyIsoCode":"USD","Exception_2_Price__c":3.8283000000000005,"Effective_Date__c":"2013-04-24","Expiration_Date__c":"2014-01-01","DPL_Price_UoM__c":null,"Target_Tier_Price__c":4.1165,"DPL_Price__c":null,"Price_UoM__c":"LB","Volume__c":4.0,"Target_Tier_Price_UoM__c":"LB","Target_Tier_Price_Unit__c":1.0,"Price__c":5.0,"TPI__c":121.46,"Volume_UoM__c":"DR","Exception_1_Price__c":3.9107}]',
                                                                              SAP_Data__c='{"tbl_target_prices":[{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"1.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.2165 ","exception2_price":"3.9213","exception2_pct":null,"exception1_price":"4.0057","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"4.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.1165 ","exception2_price":"3.8283","exception2_pct":null,"exception1_price":"3.9107","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"10.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"4.0165 ","exception2_price":"3.7353","exception2_pct":null,"exception1_price":"3.8157","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null},{"volume_prem_price":null,"volume_prem_pct":null,"volume_prem_amt":null,"total_target_price":"","total_prem_pct":null,"total_prem_amt":null,"tier_volume":"40.000 ","target_scale_uom":"DR","target_price_uom":"LB","target_price_unit":"1","target_price_currency":"USD4","target_price":"3.9165 ","exception2_price":"3.6423","exception2_pct":null,"exception1_price":"3.7207","exception1_pct":null,"dpl_price_uom":"","dpl_price_unit":"","dpl_price_currency":"","dpl_price":"","cust_size_prem_price":null,"cust_size_prem_pct":null,"cust_size_prem_amt":null,"cust_industry_prem_price":null,"cust_industry_prem_pct":null,"cust_industry_prem_amt":null,"cust_geo_prem_price":null,"cust_geo_prem_pct":null,"cust_geo_prem_amt":null}],"tbl_sales_units":[{"sales_unit":"DR","numerator":"22700 ","material_nbr":"000000000000753482","denominator":"100 ","base_unit":"KG"},{"sales_unit":"KG","numerator":"1 ","material_nbr":"000000000000753482","denominator":"1 ","base_unit":"KG"},{"sales_unit":"LB","numerator":"32523 ","material_nbr":"000000000000753482","denominator":"71701 ","base_unit":"KG"}],"tbl_list_prices":null,"tbl_csp_prices":[],"supplier":null,"sub_region":null,"specialty":null,"special_product":null,"sold_to":"0000094713","ship_to":"0000094713","sfdc_material_id":"","sfdc_account_id":"a56c0000000JdJYAA0","sales_unit":"DR","sales_org":null,"return_type":"S","return_message":"Price generated successfully","quantity":null,"product_cluster":null,"pricing_industry":null,"plm":null,"material_nbr":"000000000000753482","lbs_unit":"","division":null,"distr_chan":null,"customer_size":null,"business_line":"","base_price_uom":null,"base_price_unit":null,"base_price_currency":null,"base_price":null,"base_code":null,"avg_order_unit":"DR","avg_order_qty":"3.000 "}',
                                                                              Freight_Terms__c='ZD1-DDP Dest',Approval_Status__c='Pending Entry',Type__c='Quote',additional_dates__c = 'Yes');    
        insert PRT; 

    try{
        List<Price_Request_Transaction__c> pTranReqList2 = new List<Price_Request_Transaction__c>();
        pTranReqList2.add(PRT);
          Price_Request_Approval_Functions.FetchApproverMap(pTranReqList2);
          }catch(exception e){}
        List<Price_Request_Transaction> pTranReqList = new List<Price_Request_Transaction>();
        
 List<CSP_JSON_Response.tbl_sales_units> res = new List<CSP_JSON_Response.tbl_sales_units>();
 Price_Request_Transaction__c pReq = new Price_Request_Transaction__c();
 Price_Request_Transaction pRT2 = new Price_Request_Transaction(pReq);
 pRT2.setconversions(res);
 pRT2.getconversions();
 pRT2.getSalesUnitsList();
 pRT2.getTopCSP();
 pRT2.getTopCSPEffDate();
 pRT2.getTopCSPExpDate();
 pRT2.getTopDrumDeposit();
 pRT2.getTopPriceProtectionDesc();
 pRT2.getTopCSPVolume();
 pRT2.getTopCSPVolUom();
 pRT2.getTopCSPPriceUom();
 pRT2.getTopTarget();
 pRT2.getTopTargetVolume();
 pRT2.getTopTargetPriceUoM();
 pRT2.getTopTargetVolumeUoM();
 pRT2.getTopTargetEffDate();
 pRT2.getTopTargetExpDate();
 pRT2.getTopTPI();
 pRT2.ConvertUnitsTo(314159,'sUnitFrom','UnitT',true);

        pTranReqList.add(pRT2);
        try{
          Price_Request_Approval_Functions.FetchApproverMap(pTranReqList);
          }catch(exception e){}
          Price_Request_Approval_Functions.sellercheck('OwnerSellerNum','');

        
    }    

}