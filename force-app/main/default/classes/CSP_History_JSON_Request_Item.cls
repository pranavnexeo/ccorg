Public Class CSP_History_JSON_Request_Item{ 

Public String getShip_to(){ return Ship_To; }
String Ship_To;
Public String getSold_to(){ return Sold_to; }
String Sold_to;
Public String getSales_Rep(){ return Sales_Rep; }
String Sales_Rep;
Public String getMaterial(){ return material; }
String material;
Public String getQuantity(){ return Quantity; }
String Quantity;
Public String getSales_Unit(){ return Sales_Unit; }
String Sales_unit;
Public String getSFDC_Account_Id(){ return SFDC_Account_Id; }
String SFDC_Account_Id;
Public String getSFDC_Material_Id(){ return SFDC_Material_Id; }
String SFDC_Material_Id;
Public String getDate_From(){ return date_from; }
String date_from;
Public String getDate_To(){ return date_to; }
String date_to;
Public String getBase_Code(){ return base_code; }
String base_code;
public String SALES_ORG{get; set;}
public string DISTR_CHAN{get ;set;}


Public CSP_History_JSON_Request_Item(String Ship_to, String Sold_to, String Sales_Rep, String material, String base_code, String Quantity,String Sales_unit, String date_from, String date_to, String SFDC_Account_Id, String SFDC_Material_Id){
this.Ship_to = Ship_to;
this.Sold_to = Sold_to; 
this.base_code = base_code;
this.Sales_Rep = Sales_rep;
this.material = material;
this.quantity = quantity;
this.Sales_unit = Sales_unit;
this.SFDC_Account_id = SFDC_Account_Id;
this.SFDC_Material_id = SFDC_Material_Id;
this.Date_From = date_from;
this.Date_to = date_to;
}
Public CSP_History_JSON_Request_Item(String Ship_to, String Sold_to, String Sales_Rep, String material, String Quantity,String Sales_unit, String date_from, String date_to, String SFDC_Account_Id, String SFDC_Material_Id){
this.Ship_to = Ship_to;
this.Sold_to = Sold_to; 
this.base_code = '';
this.Sales_Rep = Sales_rep;
this.material = material;
this.quantity = quantity;
this.Sales_unit = Sales_unit;
this.SFDC_Account_id = SFDC_Account_Id;
this.SFDC_Material_id = SFDC_Material_Id;
this.Date_From = date_from;
this.Date_to = date_to;
}

}