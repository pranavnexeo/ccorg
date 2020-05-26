Public Class CSP_JSON_Response{
Public String business_line{get; set;}
Public String avg_order_qty{get; set;}
Public String avg_order_unit{get; set;}
Public String sold_to{get; set;}//
Public String ship_to{get; set;}//
Public String material_nbr{get; set;}//
Public String sub_region{get; set;}//
Public String pricing_industry{get; set;}//
Public String customer_size{get; set;}//
Public String base_code{get; set;}//
Public String supplier{get; set;}//
Public String product_cluster{get; set;}//
Public String plm{get; set;}//
Public String specialty{get; set;}//
Public String special_product{get; set;}//
Public String lbs_unit{get; set;}//
Public String sales_unit{get; set;}//
Public String sales_org{get; set;}//
Public String distr_chan{get; set;}//
Public String division{get; set;}//
Public String quantity{get; set;}//
Public String base_price{get; set;}
Public String base_price_unit{get; set;}
Public String base_price_uom{get; set;}
Public String base_price_currency{get; set;}
Public String return_type{get; set;}//
Public String return_message{get; set;}//
Public String sfdc_account_id{get; set;}
Public String sfdc_material_id{get; set;}//
Public List<tbl_sales_units> tbl_sales_units{get; set;}//
Public List<tbl_csp_prices> tbl_csp_prices{get; set;}//
Public List<tbl_target_prices> tbl_target_prices{get; set;} //
Public List<tbl_list_prices> tbl_list_prices{get; set;}//

Public CSP_JSON_Response(String sold_to, String ship_to,String  material_nbr,String  sub_region,String  pricing_industry,String  customer_size,String  base_code,String  supplier,String  product_cluster,String  plm,String  specialty,String  special_product,String  lbs_unit,String  sales_unit,String  sales_org,String  distr_chan,String  division,String  quantity,String  base_price,String  base_price_unit,String  base_price_uom,String  base_price_currency,String  return_type,String  return_message,String  sfdc_account_id,String  sfdc_material_id, List<tbl_sales_units> tbl_sales_units, List<tbl_csp_prices> tbl_csp_prices, List<tbl_target_prices> tbl_target_prices,  List<tbl_list_prices> tbl_list_prices, String avg_order_qty, String avg_order_unit){

this.avg_order_qty = avg_order_qty;
this.avg_order_unit = avg_order_unit;
this.sold_to = sold_to;
this.ship_to =  ship_to;
this.material_nbr =  material_nbr;
this.sub_region =  sub_region;
this.pricing_industry =  pricing_industry;
this.customer_size =  customer_size;
this.base_code =  base_code;
this.supplier =  supplier;
this.product_cluster =  product_cluster;
this.plm =  plm;
this.specialty =  specialty;
this.special_product =  special_product;
this.lbs_unit =  lbs_unit;
this.sales_unit =  sales_unit;
this.sales_org =  sales_org;
this.distr_chan =  distr_chan;
this.division =  division;
this.quantity =  quantity;
this.base_price =  base_price;
this.base_price_unit =  base_price_unit;
this.base_price_uom =  base_price_uom;
this.base_price_currency =  base_price_currency;
this.return_type =  return_type;
this.return_message =  return_message;
this.sfdc_account_id =  sfdc_account_id;
this.sfdc_material_id =  sfdc_material_id;
this.tbl_sales_units = tbl_sales_units; 
this.tbl_csp_prices = tbl_csp_prices;
this.tbl_target_prices = tbl_target_prices;
this.tbl_list_prices = tbl_list_prices;
}

Public Class tbl_sales_units{
Public String material_nbr{get; set;}//
Public String sales_unit{get; set;}//
Public String numerator{get; set;}//
Public String denominator{get; set;}//
Public String base_unit{get; set;}//

Public tbl_sales_units(string material_nbr, string sales_unit, string numerator, string denominator, string base_unit){
this.material_nbr = material_nbr;
this.sales_unit = sales_unit;
this.numerator = numerator;
this.denominator = denominator;
this.base_unit = base_unit;

}
}
Public Class tbl_csp_prices{
Public String csp_price{get; set;}
Public String csp_scale_uom{get; set;}
Public String csp_volume{get; set;}
Public String csp_price_unit{get; set;}
Public String csp_uom{get; set;}
Public String csp_currency{get; set;}
Public String csp_effective_date{get; set;}
Public String csp_expiration_date{get; set;}
Public String csp_price_protection_code{get; set;}
Public String csp_price_protection_desc{get; set;}
Public String csp_drum_deposit_code{get; set;}
Public String csp_condition_nbr{get; set;}

public tbl_csp_prices( String csp_price, string csp_scale_uom, string csp_volume, string csp_price_unit, string csp_uom, string csp_currency, string csp_effective_date, string csp_price_protection_code, string csp_price_protection_desc, string csp_drum_deposit_code, string csp_condition_nbr){

this.csp_scale_uom = csp_scale_uom;
this.csp_price = csp_price;//
this.csp_volume =  csp_volume;//
this.csp_price_unit =  csp_price_unit;//
this.csp_uom =  csp_uom;//
this.csp_currency =  csp_currency;//
this.csp_effective_date =  csp_effective_date;//
this.csp_expiration_date =  csp_expiration_date;//
this.csp_price_protection_code =  csp_price_protection_code;//
this.csp_price_protection_desc =  csp_price_protection_desc;//
this.csp_drum_deposit_code =  csp_drum_deposit_code;//
this.csp_condition_nbr =  csp_condition_nbr;//
}
}

Public Class tbl_target_prices{

Public String tier_volume{get; set;}
Public String target_price{get; set;}
Public String target_price_unit{get; set;}
Public String target_price_uom{get; set;}
Public String target_price_currency{get; set;}
Public String cust_size_prem_pct{get; set;}
Public String cust_size_prem_amt{get; set;}
Public String cust_size_prem_price{get; set;}
Public String cust_industry_prem_pct{get; set;}
Public String cust_industry_prem_amt{get; set;}
Public String cust_industry_prem_price{get; set;}
Public String cust_geo_prem_price{get; set;}
Public String cust_geo_prem_pct{get; set;}
Public String cust_geo_prem_amt{get; set;}
Public String volume_prem_pct{get; set;}
Public String volume_prem_amt{get; set;}
Public String volume_prem_price{get; set;}
Public String total_prem_pct{get; set;}
Public String total_prem_amt{get; set;}
Public String total_target_price{get; set;}
Public String exception1_pct{get; set;}
Public String exception1_price{get; set;}
Public String exception2_pct{get; set;}
Public String exception2_price{get; set;}
Public String dpl_price{get; set;}
Public String dpl_price_unit{get; set;}
Public String dpl_price_uom{get; set;}
Public String dpl_price_currency{get; set;}
Public String target_scale_uom{get; set;}

Public tbl_target_prices( String tier_volume, String target_price, String target_price_unit, String target_price_uom, String target_price_currency, String cust_size_prem_pct, String cust_size_prem_amt, String cust_size_prem_price, String cust_industry_prem_pct, String cust_industry_prem_amt, String cust_industry_prem_price, String cust_geo_prem_price, String cust_geo_prem_pct, String cust_geo_prem_amt, String volume_prem_pct, String volume_prem_amt, String volume_prem_price, String total_prem_pct, String total_prem_amt, String total_target_price, String exception1_pct, String exception1_price, String exception2_pct, String exception2_price, String dpl_price, String dpl_price_unit, string dpl_price_uom, string dpl_price_currency, string target_scale_uom){

this.target_scale_uom = target_scale_uom;
this.dpl_price = dpl_price;
this.dpl_price_unit = dpl_price_unit;
this.dpl_price_uom = dpl_price_uom;
this.dpl_price_currency = dpl_price_currency;
this.tier_volume = tier_volume;
this.target_price =  target_price;
this.target_price_unit =  target_price_unit;
this.target_price_uom =  target_price_uom;
this.target_price_currency =  target_price_currency;
this.cust_size_prem_pct =  cust_size_prem_pct;
this.cust_size_prem_amt =  cust_size_prem_amt;
this.cust_size_prem_price =  cust_size_prem_price;
this.cust_industry_prem_pct =  cust_industry_prem_pct;
this.cust_industry_prem_amt =  cust_industry_prem_amt;
this.cust_industry_prem_price =  cust_industry_prem_price;
this.cust_geo_prem_price =  cust_geo_prem_price;
this.cust_geo_prem_pct =  cust_geo_prem_pct;
this.cust_geo_prem_amt =  cust_geo_prem_amt;
this.volume_prem_pct =  volume_prem_pct;
this.volume_prem_amt =  volume_prem_amt;
this.volume_prem_price =  volume_prem_price;
this.total_prem_pct =  total_prem_pct;
this.total_prem_amt =  total_prem_amt;
this.total_target_price =  total_target_price;
this.exception1_pct =  exception1_pct;
this.exception1_price =  exception1_price;
this.exception2_pct =  exception2_pct;
this.exception2_price =  exception2_price;
}
}

Public Class tbl_list_prices{

Public String list_price{get; set;}
Public String list_price_uom{get; set;}
Public String list_volume{get; set;}
Public String list_price_unit{get; set;}
Public String list_uom{get; set;}
Public String list_currency{get; set;}
Public String list_effective_date{get; set;}
Public String list_expiration_date{get; set;}
Public String list_price_protection_code{get; set;}
Public String list_price_protection_desc{get; set;}
Public String list_drum_deposit_code{get; set;}
Public String list_condition_nbr{get; set;}

Public tbl_list_prices(String list_price, String  list_price_uom, String  list_volume, String  list_price_unit, String  list_uom, String  list_currency, String  list_effective_date, String  list_expiration_date, String  list_price_protection_code, String  list_price_protection_desc, String  list_drum_deposit_code, String  list_condition_nbr){

this.list_price = list_price;
this.list_price_uom =  list_price_uom;
this.list_volume =  list_volume;
this.list_price_unit =  list_price_unit;
this.list_uom =  list_uom;
this.list_currency =  list_currency;
this.list_effective_date =  list_effective_date;
this.list_expiration_date =  list_expiration_date;
this.list_price_protection_code =  list_price_protection_code;
this.list_price_protection_desc =  list_price_protection_desc;
this.list_drum_deposit_code =  list_drum_deposit_code;
this.list_condition_nbr =  list_condition_nbr;
}
}
}