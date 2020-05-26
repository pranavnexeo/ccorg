Public Class CM_JSON_Response{
Public String sfdc_account_id{get; set;}
Public String sfdc_material_id{get; set;}
Public String price{get; set;}
Public String curr{get; set;}
Public String price_support{get; set;}
Public String ic_charge{get; set;}
Public String add_charge{get; set;}
Public String mat_cost{get; set;}
Public String warehouse_charge{get; set;}
Public String freight_charge{get; set;}
Public String quantity{get; set;}
Public String message{get; set;}
Public String status{get; set;}
Public String revenue{get; set;}
Public String contrib_margin{get; set;}
Public String cm_percent{get; set;}
Public String unit_cm{get; set;}
Public String unit_mat_cost{get; set;}
Public String unit_warehouse_chg{get; set;}
Public String unit_freight_chg{get; set;}

Public CM_JSON_Response(String sfdc_account_id, String sfdc_material_id,String price, String curr, String price_support, String ic_charge, String add_charge, String mat_cost, String warehouse_charge, String freight_charge, String quantity, string status, String message, String revenue, String contrib_margin, String cm_percent, String unit_cm, String unit_mat_cost, String unit_warehouse_chg, String unit_freight_chg) 
{
this.sfdc_account_id = sfdc_account_id;
this.sfdc_material_id = sfdc_material_id;
this.price = price;
this.curr = curr;
this.price_support = price_support;
this.ic_charge = ic_charge;
this.add_charge = add_charge;
this.mat_cost = mat_cost;
this.warehouse_charge = warehouse_charge;
this.freight_charge = freight_charge;
this.quantity = quantity;
this.status = status;
this.message = message;
this.revenue = revenue;
this.contrib_margin = contrib_margin;
this.cm_percent = cm_percent;
this.unit_cm = unit_cm;
this.unit_mat_cost = unit_mat_cost;
this.unit_warehouse_chg = unit_warehouse_chg;
this.unit_freight_chg = unit_freight_chg;


}







}