Global class Target_Calculator_Controller{

Public String OrgOptions{get; set;} 
Public String DivOptions{get; set;}
Public String matTypeoptions{get; set;} 
public String MarketOptions{get; set;}
public String RegionOptions{get; set;}
public String SalesOrg{get; set;}
public String Division{get; set;}
public User_Defaults__c defaults{get; set;}
public List<String> searches{Get; set;}


Public Target_Calculator_Controller(Apexpages.standardcontroller sc){
  init();
  searches.add('<option val="consumption">Consumption Materials</option>');
  system.debug(searches.size());
}
public Target_Calculator_Controller(){

  init();

}
public void init(){

defaults = User_Defaults__c.getInstance(userinfo.getuserroleid());
SalesOrg = '';
Division = '';
matTypeoptions = '';
marketoptions = '<option class="market" value="">Select End Market...</option>';
regionoptions = '<option class="region" value="">Select Region...</option>';
matTypeoptions = '<option class="matType" value="">Select COM/SPC...</option>';
matTypeoptions += '<option value="COMMODITY">COMMODITY</option><option value="SPECIALTY">SPECIALTY</option>';

searches = new List<String>{ '<option selected="selected" value="material">Material Code / Desc</option>', '<option value="base">Base Code / Desc</option>'}; 

User User = [select id, name, nexPrice_Disregard_Hierarchy__c, userroleid from User where id = :userinfo.getuserid() limit 1];
List<Role_Data__c> roledata = new List<Role_Data__c>();
if(User.nexPrice_Disregard_Hierarchy__c == false)
roledata = [select id, data__c, type__c, API_Field_Name__c, role_id__c from Role_Data__c where role_id__c = :user.userroleid and type__c = 'Account'];
else
roledata = [select id, data__c, type__c, API_Field_Name__c, role_id__c from Role_Data__c where role_name__c = 'AD Sales' and type__c = 'Account'];

Set<String> fields = new Set<String>{'SAP_Sales_Org__c', 'SAP_DivisionCode__c'};
Map<String, List<String>> options = new Map<String, List<String>>();
Set<String> divSet= new Set<String>{'31','32'};

for(string f:fields)
  options.put(f, new List<String>());

for(Role_Data__c rd:roledata)
  if(rd.data__c != null && rd.data__c != '' && fields.contains(rd.api_field_name__c))
    options.get(rd.api_field_name__c).addall(rd.data__c.split('; '));

orgoptions = '<option class="salesorg" value="">Select Sales Org...</option>';
for(SAP_Sales_Org__c org:[select Sales_Org_Code__c, Sales_Org_Description__C,  Sales_Org_Code_w_o_G2__c  from SAP_Sales_Org__c where Sales_Org_Code_w_o_G2__c IN :options.get('SAP_Sales_Org__c') order by Sales_org_Code__c limit 500])
{   
    OrgOptions += '<option class="salesorg" value="' + org.Sales_Org_Code_w_o_G2__c + '">' + org.Sales_Org_Code_w_o_G2__c + ' - ' + org.Sales_Org_Description__c.escapeEcmaScript() + '</option>';
}
DivOptions = '<option class="salesdiv" value="">Select Division...</option>';


for(SAP_Sales_Division__c div:[select id, Sales_Division_Code__c, Sales_Division_Description__C from SAP_Sales_Division__c where Sales_Division_Description__c LIKE '%Nexeo%' and Sales_Division_code__c IN :divSet order by Sales_Division_Description__c limit 10])
{   
  DivOptions += '<option class="salesdiv" value="' + div.sales_division_Code__c + '">' + div.sales_division_Code__c + ' - ' + Div.Sales_Division_Description__c.escapeEcmaScript() + '</option>';
}

}
@RemoteAction
Global static List<sObject> getMaterials(string q, string type, string org, string AccountId, boolean flip, string division, string matType){
  q = q.replace('%', '');
 
  string q1 = '%' + q + '%';
  if(type == 'material')  
  if(flip == false){
      if(division == '31')
          return [select id, name, material_number__c, Material_General_Data__r.Material_Container_Desc__c from Material_Sales_data2__c where name LIKE :q1 and Sales_Org_Code__c = :org and (NOT NAME LIKE '%do not%') and (NOT Material_Desc__c LIKE '%do not%') and Marked_for_Deletion__c != 'TRUE' and Division_Code__c != '34' and customer_repack__c = 'FALSE' and Material_General_Data__r.Ext_Material_group_code__c = '101' and Division_Code__c = :division and Material_Group3_Desc__c = :matType limit 50];
      else 
          return [select id, name, material_number__c, Material_General_Data__r.Material_Container_Desc__c from Material_Sales_data2__c where name LIKE :q1 and Sales_Org_Code__c = :org and (NOT NAME LIKE '%do not%') and (NOT Material_Desc__c LIKE '%do not%') and Marked_for_Deletion__c != 'TRUE' and Division_Code__c != '34' and customer_repack__c = 'FALSE' and Material_General_Data__r.Ext_Material_group_code__c = '101' and Division_Code__c = :division limit 50];
  }
  else{
      if(division == '31')
          return [select id, name, material_number__c, Material_General_Data__r.Material_Container_Desc__c from Material_Sales_data2__c where name LIKE :q1 and Sales_Org_Code__c = :org and (NOT NAME LIKE '%do not%') and (NOT Material_Desc__c LIKE '%do not%') and Marked_for_Deletion__c != 'TRUE' and Division_Code__c != '34' and customer_repack__c = 'FALSE' and Division_Code__c = :division and Material_Group3_Desc__c = :matType limit 50];
      else
          return [select id, name, material_number__c, Material_General_Data__r.Material_Container_Desc__c from Material_Sales_data2__c where name LIKE :q1 and Sales_Org_Code__c = :org and (NOT NAME LIKE '%do not%') and (NOT Material_Desc__c LIKE '%do not%') and Marked_for_Deletion__c != 'TRUE' and Division_Code__c != '34' and customer_repack__c = 'FALSE' and Division_Code__c = :division limit 50];
  }
  else if(type == 'base')
  return [select id, name, Material_Base_Code_Description__c, Material_Base_Code__c from Material_Base_Code__c 
          where (Material_Base_Code__c LIKE :q1 or Material_Base_Code_Description__c LIKE :q1)];
  else if(type == 'basematerial')
  return [select id, name, material_number__c, Material_General_Data__r.Material_Container_Desc__c from Material_Sales_data2__c where (material_base_code__c LIKE :q1 or material_base_code_desc__c LIKE :q1) and (NOT NAME LIKE '%do not%')  and Sales_Org_Code__c = :org  and Division_Code__c != '34' and customer_repack__c = 'FALSE' limit 50];
  else if(type == 'consumption')
  {
    set<String> mids = new set<String>();
    for(Consumption__c c:[select id, SAP_Material__c from Consumption__c where Account_Name__c = :AccountId and SAP_Material__c != null])
       mids.add(c.SAP_Material__c);
    return [select id, name, material_number__c, Material_General_Data__r.Material_Container_Desc__c from Material_Sales_data2__c where (material_base_code__c LIKE :q1 or material_base_code_desc__c LIKE :q1 or  name LIKE :q1) and Sales_Org_Code__c = :org and (NOT NAME LIKE '%do not%')  and Division_Code__c != '34' and id IN :mids and customer_repack__c = 'FALSE' order by Name limit 50];
  }
  else if(type == 'Opportunity')
  {
    set<String> mids = new set<String>();
    for(Opportunity c:[select id, SAP_Material__c from Opportunity where AccountId = :AccountId and SAP_Material__c != null])
       mids.add(c.SAP_Material__c);
    return [select id, name, material_number__c, Material_General_Data__r.Material_Container_Desc__c from Material_Sales_data2__c where (material_base_code__c LIKE :q1 or material_base_code_desc__c LIKE :q1 or  name LIKE :q1) and Sales_Org_Code__c = :org and (NOT NAME LIKE '%do not%')  and Division_Code__c != '34' and customer_repack__c = 'FALSE' and id IN :mids order by Name limit 50 ];
  }
  else
  return [select id, name, material_number__c, Material_General_Data__r.Material_Container_Desc__c from Material_Sales_data2__c where material_base_code__c = :q1 and Sales_Org_Code__c = :org and (NOT NAME LIKE '%do not%')  and Division_Code__c != '34' and customer_repack__c = 'FALSE' limit 50];
}




@RemoteAction
Global static string getMarkets(String org, string div){
  string toreturn = '<option class="market" value="';
  if(div == '32')
    toreturn += 'PLASTICS';
  toreturn += '">Select End Market...</option>';
  for(Target_End_Market__c em:[select id, name, code__c from Target_End_Market__c where Sales_org__c = :org and division__c = :div])
    toreturn += '<option class="market" value="' + em.name + '">' + em.name + '</option>';
  return toreturn;
}

@RemoteAction
Global static string getRegions(String org, string div){
  string toreturn = '<option class="region" value="';
  if(div == '32')
    toreturn += 'PLASTICS';
  toreturn += '">Select Region...</option>';
  for(Pricing_Region__c r:[select id, name, code__c from Pricing_Region__c where Sales_org__c = :org and division__c = :div])
    toreturn += '<option class="region" value="' + r.name + '">' + r.name + '</option>';
  return toreturn;
}

@RemoteAction
Global static Account getAccount(id accountid){
  return [select id, SAP_Sales_Org__c, SAP_DivisionCode__c, Account_Number__c, Nexprice_Market__c, Nexprice_Region__c, Nexprice_Size__c from Account where id = :accountid];

}
@RemoteAction
Global static List<sObject> getContainers(String basecode, boolean flip, string division, string matType){
system.debug('Division is:'+division);
  if(flip == false)
      return [select id, 
                 name,
                 Material_General_Data__r.Material_Container_Code__r.Material_Container_Code_Description__c
                 from Material_Sales_Data2__c where 
                 Material_Base_Code__c = :basecode and Material_General_Data__r.Ext_Material_group_code__c = '101' and Division_Code__c = :division and Material_Group3_Desc__c = :matType limit 50];
  else
      return [select id, 
                 name,
                 Material_General_Data__r.Material_Container_Code__r.Material_Container_Code_Description__c
                 from Material_Sales_Data2__c where 
                 Material_Base_Code__c = :basecode and Material_Group3_Desc__c = :matType limit 50];
}
@TestVisible Private static string getTable(List<CSP_JSON_Response> responses, String unitType){
  system.debug('response : ' + responses);
  Map<String, Double> conversionmap = new Map<String, Double>();
  // Adding logic to skip seller Floor for division '32'
  string table;
  if(responses[0].division <> '32')
      table = '<table data-mode="reflow" class="price-list ui-responsive thetable" data-role="table" ><thead><tr><th>Tier</th><th>Price</th><th>Seller Floor</th></tr></thead><tbody>';    
  else
      table = '<table data-mode="reflow" class="price-list ui-responsive thetable" data-role="table" ><thead><tr><th>Tier</th><th>Price</th></tr></thead><tbody>';
  
  boolean isEmpty = true;
  
  for(CSP_JSON_Response response:responses)
  {   isEmpty = (response.tbl_target_prices.size() == 0);
      conversionmap = getConversionMap(response.tbl_sales_units);
      
      for(CSP_JSON_Response.tbl_target_prices row:response.tbl_target_prices){
         //table += '<tr><td>' + row.tier_volume + ' ' + row.target_scale_uom + '</td><td>';
         //table += row.target_price_currency + ' ' + row.target_price + ' per ' +  row.target_price_unit  + ' ' + row.target_price_uom + '</td>';
         
         if(unitType=='KG' && row.target_price_uom != 'KG')
         {
           Double vol = stringtodouble(row.tier_volume);
           Decimal tvol  = convertunits(conversionmap, vol, row.target_scale_uom, unitType, false);
           Double price = stringtodouble(row.target_price);
           Decimal tprice = convertUnits(conversionmap, price, row.target_price_uom, unitType, true);  
           table += '<tr><td>' + Math.Round(tvol) + ' ' + unitType + '</td><td>';
           table += row.target_price_currency + ' ' + tprice.setscale(4) + ' per ' +  row.target_price_unit  + ' ' + unitType + '</td>';
         }else{
          table += '<tr><td>' + row.tier_volume + ' ' + row.target_scale_uom + '</td><td>';
          table += row.target_price_currency + ' ' + row.target_price + ' per ' +  row.target_price_unit  + ' ' + row.target_price_uom + '</td>';
         
         }
         
         if(response.division <> '32')
         table += '<td>' + row.exception1_price + '</td>';
      }
  }
  
  /*string table = '<table data-mode="reflow" class="price-list ui-responsive thetable" data-role="table" ><thead><tr><th>Tier</th><th>Price</th><th>Seller Floor</th></tr></thead><tbody>';
  boolean isEmpty = true;
  for(CSP_JSON_Response response:responses)
  {   isEmpty = (response.tbl_target_prices.size() == 0);
    for(CSP_JSON_Response.tbl_target_prices row:response.tbl_target_prices){
         table += '<tr><td>' + row.tier_volume + ' ' + row.target_scale_uom + '</td><td>';
         table += row.target_price_currency + ' ' + row.target_price + ' per ' +  row.target_price_unit  + ' ' + row.target_price_uom + '</td>';
         table += '<td>' + row.exception1_price + '</td></tr>';
      }
   }
   */
   
  table += '</tr></tbody></table>';
  
  if(isEmpty)
    table = '<br/>Call for Pricing<br/>';
  system.debug(table);
  return table;
}

@TestVisible private static string getTestString(){
  string toreturn = ' [{"business_line": "", "sold_to": "0000721031", "ship_to": "0000721031", "material_nbr": "000000000000020512", "sub_region": "", "pricing_industry": "", ';
  toreturn += '"pricing_endmkt": "", "customer_size": "", "customer_size_sp": "", "customer_size_co": "", "base_code": "01_3010000", "supplier": "", "product_cluster": "ACETONE", ';
  toreturn += '"plm": "103", "specialty": "STANDARD", "special_product": "", "prod_type": "COMMODITY", "pack_type": "DRR", "lbs_unit": "", "sales_unit": "DR", "sales_org": "1000", ';
  toreturn += '"distr_chan": "30", "division": "", "quantity": "1.000 ", "base_price": "0.6800", "base_price_unit": "1 ", "base_price_uom": "LB", "base_price_currency": "USD4", ';
  toreturn += '"base_price_condition_nbr": "0037810153", "base_price_next": "", "base_price_next_cond_nbr": "", "base_price_next_date": "", "price_date": "01/22/2014", "return_type": "S", ';
  toreturn += '"return_message": "Price generated successfully", "sfdc_account_id": "", "sfdc_material_id": "", "last_changed": "00000000", "last_changed_tim": "", "avg_order_qty": "0.000 ", ';
  toreturn += '"avg_order_unit": "", "tbl_sales_units": [{"material_nbr": "000000000000020512", "sales_unit": "DR", "numerator": "162 ", "denominator": "1 ", "base_unit": "KG"}, ';
  toreturn += '{"material_nbr": "000000000000020512", "sales_unit": "KG", "numerator": "1 ", "denominator": "1 ", "base_unit": "KG"}, {"material_nbr": "000000000000020512", "sales_unit": "L", ';
  toreturn += '"numerator": "10000 ", "denominator": "12563 ", "base_unit": "KG"}, {"material_nbr": "000000000000020512", "sales_unit": "LB", "numerator": "32523 ", "denominator": "71701 ", ';
  toreturn += '"base_unit": "KG"}, {"material_nbr": "000000000000020512", "sales_unit": "RCU", "numerator": "162 ", "denominator": "1 ", "base_unit": "KG"}, {"material_nbr": "000000000000020512",';
  toreturn += '"sales_unit": "GAL", "numerator": "59146 ", "denominator": "15625 ", "base_unit": "L"}], "tbl_csp_prices": [], "tbl_target_prices": [{"target_tier": "1 ", "tier_volume": "1.000 ", ';
  toreturn += '"target_price": "0.9000 ", "target_price_unit": "1", "target_price_uom": "LB", "target_price_currency": "USD4", "target_price_next": "", "cust_size_prem_pct": "", ';
  toreturn += '"cust_size_prem_amt": "", "cust_size_prem_price": "", "cust_industry_prem_pct": "", "cust_industry_prem_amt": "", "cust_industry_prem_price": "", "cust_geo_prem_pct": "", ';
  toreturn += '"cust_geo_prem_amt": "", "cust_geo_prem_price": "", "end_market_prem_pct": "", "end_market_prem_amt": "0.0200 ", "end_market_prem_price": "0.8800", "prod_pack_type_prem_pct": "", ';
  toreturn += '"prod_pack_type_prem_amt": "0.0700 ", "prod_pack_type_prem_price": "0.8300", "cust_tail_prem_pct": "", "cust_tail_prem_amt": "0.0000 ", "cust_tail_prem_price": "0.9000", ';
  toreturn += '"volume_prem_pct": "", "volume_prem_amt": "0.1300 ", "volume_prem_price": "0.7700", "cust_rgn_adj_pct": "", "cust_rgn_adj_amt": "", "cust_rgn_adj_price": "", "total_prem_pct": "", ';
  toreturn += '"total_prem_amt": "", "total_target_price": "", "exception1_pct": "4.00-", "exception1_amt": "", "exception1_price": "0.8640", "exception2_pct": "10.00-", "exception2_amt": "", ';
  toreturn += '"exception2_price": "0.8100", "dpl_price": "", "dpl_price_unit": "", "dpl_price_uom": "", "dpl_price_currency": "", "target_scale_uom": "DR", "target_price_lb": "0.9000 "}, ';
  toreturn += '{"target_tier": "2 ", "tier_volume": "4.000 ", "target_price": "0.8800 ", "target_price_unit": "1", "target_price_uom": "LB", "target_price_currency": "USD4", "target_price_next": "", ';
  toreturn += '"cust_size_prem_pct": "", "cust_size_prem_amt": "", "cust_size_prem_price": "", "cust_industry_prem_pct": "", "cust_industry_prem_amt": "", "cust_industry_prem_price": "", ';
  toreturn += '"cust_geo_prem_pct": "", "cust_geo_prem_amt": "", "cust_geo_prem_price": "", "end_market_prem_pct": "", "end_market_prem_amt": "0.0200 ", "end_market_prem_price": "0.8600", ';
  toreturn += '"prod_pack_type_prem_pct": "", "prod_pack_type_prem_amt": "0.0700 ", "prod_pack_type_prem_price": "0.8100", "cust_tail_prem_pct": "", "cust_tail_prem_amt": "0.0000 ", ';
  toreturn += '"cust_tail_prem_price": "0.8800", "volume_prem_pct": "", "volume_prem_amt": "0.1100 ", "volume_prem_price": "0.7700", "cust_rgn_adj_pct": "", "cust_rgn_adj_amt": "", ';
  toreturn += '"cust_rgn_adj_price": "", "total_prem_pct": "", "total_prem_amt": "", "total_target_price": "", "exception1_pct": "4.00-", "exception1_amt": "", "exception1_price": "0.8448", ';
  toreturn += '"exception2_pct": "10.00-", "exception2_amt": "", "exception2_price": "0.7920", "dpl_price": "", "dpl_price_unit": "", "dpl_price_uom": "", "dpl_price_currency": "", "target_scale_uom": ';
  toreturn += '"DR", "target_price_lb": "0.8800 "}, {"target_tier": "3 ", "tier_volume": "10.000 ", "target_price": "0.8300 ", "target_price_unit": "1", "target_price_uom": "LB", ';
  toreturn += '"target_price_currency": "USD4", "target_price_next": "", "cust_size_prem_pct": "", "cust_size_prem_amt": "", "cust_size_prem_price": "", "cust_industry_prem_pct": "", ';
  toreturn += '"cust_industry_prem_amt": "", "cust_industry_prem_price": "", "cust_geo_prem_pct": "", "cust_geo_prem_amt": "", "cust_geo_prem_price": "", "end_market_prem_pct": "", ';
  toreturn += '"end_market_prem_amt": "0.0200 ", "end_market_prem_price": "0.8100", "prod_pack_type_prem_pct": "", "prod_pack_type_prem_amt": "0.0700 ", "prod_pack_type_prem_price": "0.7600", ';
  toreturn += '"cust_tail_prem_pct": "", "cust_tail_prem_amt": "0.0000 ", "cust_tail_prem_price": "0.8300", "volume_prem_pct": "", "volume_prem_amt": "0.0600 ", "volume_prem_price": "0.7700", ';
  toreturn += '"cust_rgn_adj_pct": "", "cust_rgn_adj_amt": "", "cust_rgn_adj_price": "", "total_prem_pct": "", "total_prem_amt": "", "total_target_price": "", "exception1_pct": "4.00-", ';
  toreturn += '"exception1_amt": "", "exception1_price": "0.7968", "exception2_pct": "10.00-", "exception2_amt": "", "exception2_price": "0.7470", "dpl_price": "", "dpl_price_unit": "", "dpl_price_uom":';
  toreturn += ' "", "dpl_price_currency": "", "target_scale_uom": "DR", "target_price_lb": "0.8300 "}, {"target_tier": "4 ", "tier_volume": "40.000 ", "target_price": "0.7700 ", "target_price_unit": "1", ';
  toreturn += '"target_price_uom": "LB", "target_price_currency": "USD4", "target_price_next": "", "cust_size_prem_pct": "", "cust_size_prem_amt": "", "cust_size_prem_price": "", "cust_industry_prem_pct": "", ';
  toreturn += '"cust_industry_prem_amt": "", "cust_industry_prem_price": "", "cust_geo_prem_pct": "", "cust_geo_prem_amt": "", "cust_geo_prem_price": "", "end_market_prem_pct": "", "end_market_prem_amt": "0.0200 ",';
  toreturn += ' "end_market_prem_price": "0.7500", "prod_pack_type_prem_pct": "", "prod_pack_type_prem_amt": "0.0700 ", "prod_pack_type_prem_price": "0.7000", "cust_tail_prem_pct": "", "cust_tail_prem_amt": "0.0000 ",';
  toreturn += ' "cust_tail_prem_price": "0.7700", "volume_prem_pct": "", "volume_prem_amt": "0.0000 ", "volume_prem_price": "0.7700", "cust_rgn_adj_pct": "", "cust_rgn_adj_amt": "", "cust_rgn_adj_price": "", ';
  toreturn += '"total_prem_pct": "", "total_prem_amt": "", "total_target_price": "", "exception1_pct": "4.00-", "exception1_amt": "", "exception1_price": "0.7392", "exception2_pct": "10.00-", "exception2_amt": "",';
  toreturn += ' "exception2_price": "0.6930", "dpl_price": "", "dpl_price_unit": "", "dpl_price_uom": "", "dpl_price_currency": "", "target_scale_uom": "DR", "target_price_lb": "0.7700 "}], "tbl_list_prices": []}]';
  return toreturn;
}

@RemoteAction
Global static string SendEmail(String id, String notes){
 system.debug('sendemailbox');
  string returnstring = '';
  try{
  system.debug('line145');
    Target_Price_Request__c tpr = [select id, Email_Owner__c, Owner.Email from Target_Price_Request__c where id = :id limit 1];
    system.debug('tpr'+tpr);
    tpr.Email_Owner__c = true;
    system.debug('tpr.Email_Owner__c'+tpr.Email_Owner__c);
    tpr.Notes__c = notes;
    update tpr;
    System.debug('!! after update:'+tpr);
    returnstring = 'Email Sent to ' + tpr.owner.Email;
  } catch(exception e){ system.debug(e.getmessage()); returnstring = e.getMessage(); }
  return returnstring;
} 

@RemoteAction
Global static List<Target_Price_Request__c> getRecent(String AccountId){

if(AccountId == '')
  return [select id, Material__r.Name, notes__c, CreatedDate, Material__c, Target_Table__c,
          Sales_Org__c, Division__c, Region__c, End_Market__c, Customer_Size__c
         from Target_Price_Request__c where createdby.id = :userinfo.getuserid() and Account__c = null order by createdDate DESC limit 10];
         
else if(AccountId == 'Default')
  return [select id, Material__r.Name, notes__c, CreatedDate, Material__c, Target_Table__c,
          Sales_Org__c, Division__c, Region__c, End_Market__c, Customer_Size__c, Account__r.Name
         from Target_Price_Request__c where createdby.id = :userinfo.getuserid() order by createdDate DESC limit 10];
         
else
  return [select id, Material__r.Name, notes__c, CreatedDate, Material__c, Target_Table__c,
          Sales_Org__c, Division__c, Region__c, End_Market__c, Customer_Size__c, Account__r.Name
         from Target_Price_Request__c where  Account__c = :AccountId order by createdDate DESC limit 10];

}

@RemoteACtion
Global Static Target_Price_Request__c getCustomerTiers(Target_Calc_Request c, String AccountId, String unitType){
       Account a = [select name, id, type,  SAP_DistChannel__c, Nexprice_Size__c, Nexprice_Market__c, Nexprice_Region__c, AccountNumber, SAP_Sold_To_Account__c, SAP_DivisionCode__c, SAP_Sales_Org__c from Account where id = :AccountId limit 1];
       a.Nexprice_Size__c = c.CUSTOMER_SIZE;
       a.Nexprice_Market__c = c.PRICING_ENDMKT;
       a.Nexprice_Region__c = c.SUB_REGION;
        
       
       
       List<CSP_JSON_Request_Item> SAP_Requests = new List<CSP_JSON_Request_Item>();
       Material_Sales_Data2__c m = [select id, Name,  material_number__c, Sales_UOM__r.Alternative_UOM__c, Material_Group2_Desc__c from Material_Sales_Data2__c where id = :c.MATERIAL limit 1];
       
       String SoldToNumber = '';
       
       if(a.SAP_Sold_To_Account__c != null && a.SAP_Sold_To_Account__c != '')
          SoldToNumber = a.SAP_Sold_To_Account__c.substringBefore(' - ');

       CSP_JSON_Request_Item csp = new CSP_JSON_Request_Item(
                                                   'X',
                                                   a.accountnumber, 
                                                   SoldToNumber,
                                                   '',
                                                   m.material_number__c,
                                                   '1',
                                                   m.Sales_UOM__r.Alternative_UOM__c,
                                                   m.id, 
                                                   '',
                                                   a.SAP_Sales_Org__c,
                                                   a.SAP_DistChannel__c);
    
       SAP_Requests.add(csp);
       List<CSP_JSON_Response> response = CSP_JSON_Request.submit_Request_m(SAP_Requests);
       system.debug('request: ' + SAP_requests);
       system.debug('response: ' + response);
       Target_Price_Request__c tpr = new Target_Price_Request__c(  Division__c = a.SAP_DivisionCode__c,
                                                                   Email_Owner__C = false,
                                                                   Material__c = m.Id,
                                                                   Material__r = m,
                                                                   Sales_Org__c = a.SAP_Sales_Org__c,
                                                                   Account__c = a.id,
                                                                   Target_Table__c = getTable(response,unitType),
                                                                   Account__r = a,
                                                                   Region__c = c.SUB_REGION,
                                                                   End_Market__c = c.PRICING_ENDMKT);
       update a;
       insert tpr;
       return tpr;
            
}

@RemoteAction
Global static Target_Price_Request__c getProspectTiers(Target_Calc_Request c, string AccountId, String unitType){
        
        system.debug('AccountId: ' + AccountId);
        Account a = [select name, AccountNumber, id, type, Nexprice_Size__c, Nexprice_Market__c, Nexprice_Region__c from Account where id = :AccountId limit 1];
        a.Nexprice_Size__c = c.CUSTOMER_SIZE;
        a.Nexprice_Market__c = c.PRICING_ENDMKT;
        a.Nexprice_Region__c = c.SUB_REGION;
        
        if(a.type == 'Prospect'){
            SAP_Sales_Org__c org = [select id, Sales_Org_Code__c, Sales_Org_Description__c from SAP_Sales_Org__c where Sales_Org_Code__c = :c.SALES_ORG limit 1];      
            a.Prospect_Sales_Org__c = org.Sales_Org_Description__c + ' (' + org.Sales_Org_Code__c + ')';
            SAP_Sales_Division__c div = [select id, Sales_Division_Code__c, Sales_Division_Description__c from SAP_Sales_Division__c where Sales_Division_Code__c = :c.DIVISION limit 1];
            a.Prospect_Division__c = div.Sales_Division_Description__C + ' (' + div.Sales_Division_Code__c + ')';
        }
        
        
        Target_Price_Request__c tpr = new Target_Price_Request__c( Customer_Size__c = c.CUSTOMER_SIZE,
                                                                   Division__c = c.DIVISION,
                                                                   Email_Owner__C = false,
                                                                   End_Market__C = c.PRICING_ENDMKT,
                                                                   Material__c = c.MATERIAL,
                                                                   Region__c = c.SUB_REGION,
                                                                   Sales_Org__c = c.SALES_ORG,
                                                                   Account__c = AccountId,
                                                                   Account__r = a);
        
        List<Material_Sales_Data2__c> materiallist = [select id, name, material_number__c, Material_Group2_Desc__c from Material_Sales_Data2__c where id = :c.MATERIAL limit 1];
        if(materiallist.size() > 0)
        {  c.MATERIAL = materiallist.get(0).material_number__c;
           tpr.material__r = materiallist.get(0);
        }
        nexPrice_Settings__c settings = nexPrice_Settings__c.getOrgDefaults();
        String endpoint = settings.Target_Calculator_Endpoint__c;

        httprequest req = new httprequest();       
        req.setHeader('Content-Type', 'application/xml');  
        req.settimeout(60000); 
        req.setEndpoint(endpoint);
        req.setMethod('POST');     
        List<Target_Calc_Request> requests = new List<Target_Calc_Request>{c};
        req.setBody(JSON.serialize(requests)); 
        system.debug(JSON.serialize(requests));   
        http h = new http();
        List<CSP_JSON_Response> response = new List<CSP_JSON_Response>();
        String r = getTestString();
        try{
          if(test.isrunningtest() == false){
            httpresponse res = h.send(req);
            r = res.getBody();
          }
          system.debug('response string: ' + r);
          response = (List<CSP_JSON_Response>)JSON.deserialize(r, List<CSP_JSON_Response>.class);
          
        }catch(exception e){ system.debug('***ERROR****: ' + e.getmessage()); }
        tpr.Target_Table__c = getTable(response, unitType);
        
        update a;
        insert tpr;     
        return tpr;
}


@RemoteAction
Global static Target_Price_Request__c getTiers(Target_Calc_Request c, string matType, String unitType){
        
        Target_Price_Request__c tpr = new Target_Price_Request__c( Customer_Size__c = c.CUSTOMER_SIZE,
                                                                   Division__c = c.DIVISION,
                                                                   Email_Owner__C = false,
                                                                   End_Market__C = c.PRICING_ENDMKT,
                                                                   Material__c = c.MATERIAL,
                                                                   Region__c = c.SUB_REGION,
                                                                   Sales_Org__c = c.SALES_ORG);
        
        List<Material_Sales_Data2__c> materiallist = [select id, name, material_number__c, Material_Group2_Desc__c from Material_Sales_Data2__c where id = :c.MATERIAL limit 1];
        if(materiallist.size() > 0)
        {  c.MATERIAL = materiallist.get(0).material_number__c;
           tpr.material__r = materiallist.get(0);
        }
        nexPrice_Settings__c settings = nexPrice_Settings__c.getOrgDefaults();
        String endpoint = settings.Target_Calculator_Endpoint__c;

        httprequest req = new httprequest();       
        req.setHeader('Content-Type', 'application/xml');  
        req.settimeout(60000); 
        req.setEndpoint(endpoint);
        req.setMethod('POST');     
        List<Target_Calc_Request> requests = new List<Target_Calc_Request>{c};
        req.setBody(JSON.serialize(requests)); 
        system.debug(JSON.serialize(requests));   
        http h = new http();
        List<CSP_JSON_Response> response = new List<CSP_JSON_Response>();
        String r = getTestString();
        try{
          if(test.isrunningtest() == false){
            httpresponse res = h.send(req);
            r = res.getBody();
          }
          system.debug('response string: ' + r);
          response = (List<CSP_JSON_Response>)JSON.deserialize(r, List<CSP_JSON_Response>.class);
          
        }catch(exception e){ system.debug('***ERROR****: ' + e.getmessage()); }
        tpr.Target_Table__c = getTable(response, unitType);
        insert tpr;     
        return tpr;
}

public static Double stringtodouble(String sIn){
  string temp = '';
  if(sIn != '' && sIn != null)
  {
    if(sIn.contains('-'))
    {  temp = sIn.replaceall('-', '');
       temp = '-' + temp;
    }
    else{ temp = sIn; }
    if(temp.contains(','))
      temp = temp.replaceall(',','');
    return double.valueof(temp);
  }
  else{ return null; }
}

Public static Map<String, Double> getConversionMap(List<CSP_JSON_Response.tbl_sales_units> units)
{
   Map<String, Double> conversionmap = new Map<String, Double>();
   for(CSP_JSON_Response.tbl_sales_units u:units)
   {
     if(u.numerator != '' && u.denominator != '')
     {  if(Double.valueof(u.denominator) != 0)
        {  
           conversionmap.put(u.sales_unit, (Double.valueof(u.numerator) / Double.valueof(u.denominator)));
        }
     }
   }
   return conversionmap;
}

Public static Double ConvertUnits(Map<String, Double> conversionmap, Double iValue, String sUnitFrom, String sUnitTo, boolean invert){

  if(conversionmap.containskey(sUnitFrom) && conversionmap.containskey(sUnitTo))
  {
    if(conversionmap.get(sUnitTo) > 0)
    {
     if(invert == true)
     {
     Double baseunit = iValue / conversionmap.get(sUnitFrom);
     return (baseunit * conversionmap.get(sUnitTo));
     }
     else
     {
     Double baseunit = iValue * conversionmap.get(sUnitFrom);
     return (baseunit / conversionmap.get(sUnitTo));
     }
    }
    else return iValue;
  }
  else
  { return iValue; }
}


}