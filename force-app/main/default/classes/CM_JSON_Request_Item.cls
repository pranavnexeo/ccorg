Public Class CM_JSON_Request_Item{ 

Public String Ship_to{get;set; }
//String Ship_To;
Public String Sold_to{ get;set; }
//String Sold_to;
Public String Material{ get;set; }
//String material;
Public Double Quantity{ get;set; }
//String Quantity;
Public String Sales_Unit{ get;set; }
//String Sales_unit;
Public String SFDC_Account_Id{ get;set;}
//String SFDC_Account_Id;
Public String SFDC_Material_Id{ get;set; }
//String SFDC_Material_Id;
Public String Sales_Org{ get;set; }
//String Sales_Org;
public string freight_terms {get;set;}
//string freight_terms;
public string plant{get;set;}
//string plant;
public Double price{get;set;}
//string price;
public string price_unit{get;set;}
public string curr{get;set;}
//string curr;
public string distr_chan{get;set;}
//string distr_chan;
public string division{get;set;}
//string division;

public CM_JSON_Request_Item(){}

Public CM_JSON_Request_Item(String Ship_to, String Sold_to, String material, Double Quantity, String Sales_unit, Double price, String price_unit, String curr, String plant, String sfdc_account_Id, String sfdc_material_Id, String sales_org, String distr_chan, String division, String freight_terms){
this.Ship_to = Ship_to;
this.Sold_to = Sold_to; 
this.material = material;
this.quantity = quantity;
this.Sales_unit = Sales_unit;
this.price = price;
this.price_unit = price_unit;
this.curr = curr;
this.plant = plant;
this.sfdc_account_id = sfdc_account_Id;
this.sfdc_material_id = sfdc_material_Id;
this.sales_org = sales_org;
this.distr_chan = distr_chan;
this.division = division;
this.freight_terms = freight_terms;

}
}