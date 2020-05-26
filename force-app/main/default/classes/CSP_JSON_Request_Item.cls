Public Class CSP_JSON_Request_Item{ 

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
Public String getNew_Product(){ return New_Product; }
String New_Product;
Public String getSales_Org(){ return Sales_Org; }
String Sales_Org;
Public String getDis_Channel(){ return Dis_Channel; }
String Dis_Channel;

Public CSP_JSON_Request_Item(String Ship_to, String Sold_to, String Sales_Rep, String material, String Quantity,String Sales_unit, String SFDC_Account_Id, String SFDC_Material_Id){
this.Ship_to = Ship_to;
this.Sold_to = Sold_to; 
this.Sales_Rep = Sales_rep;
this.material = material;
this.quantity = quantity;
this.Sales_unit = Sales_unit;
this.SFDC_Account_id = SFDC_Account_Id;
this.SFDC_Material_id = SFDC_Material_Id;
this.new_product = '';

}

Public CSP_JSON_Request_Item(String new_product, String Ship_to, String Sold_to, String Sales_Rep, String material, String Quantity,String Sales_unit, String SFDC_Account_Id, String SFDC_Material_Id){
this.new_product = new_product;
this.Ship_to = Ship_to;
this.Sold_to = Sold_to; 
this.Sales_Rep = Sales_rep;
this.material = material;
this.quantity = quantity;
this.Sales_unit = Sales_unit;
this.SFDC_Account_id = SFDC_Account_Id;
this.SFDC_Material_id = SFDC_Material_Id;

}

Public CSP_JSON_Request_Item(String new_product, String Ship_to, String Sold_to, String Sales_Rep, String material, String Quantity,String Sales_unit, String SFDC_Account_Id, String SFDC_Material_Id, String Sales_Org, String Dis_Channel){
this.new_product = new_product;
this.Ship_to = Ship_to;
this.Sold_to = Sold_to; 
this.Sales_Rep = Sales_rep;
this.material = material;
this.quantity = quantity;
this.Sales_unit = Sales_unit;
this.SFDC_Account_id = SFDC_Account_Id;
this.SFDC_Material_id = SFDC_Material_Id;
this.Sales_Org = Sales_Org;
this.Dis_Channel = Dis_Channel;
}

}