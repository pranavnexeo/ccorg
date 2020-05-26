@isTest
public class Integration_Table_Change_Test{
public static testMethod void  Integration_Table_Change_Test() {
  SAP_Sales_Org__c so = new SAP_Sales_Org__c(Sales_Org_Code__c = '123', Sales_Org_Description__c = 'test', Language_code__c = 'E');
  insert so;
  so.Sales_Org_Description__c = 'test1';
  update so;
  SAP_Distribution_Channel__c sd = new SAP_Distribution_Channel__c(Distribution_Channel_Code__c = '12', Distribution_Channel_Description__c = 'test', Language_code__c = 'E');
  insert sd;
  sd.distribution_channel_description__c = 'test1';
  update sd;
  SAP_Sales_Division__c div = new SAP_Sales_Division__c(Sales_Division_Code__c = '30', Sales_Division_Description__c = 'test', Language_code__c = 'E');
  insert div;
  div.sales_division_Description__c = 'test1';
  update div;
  
  SAP_Sales_District__c ssd = new SAP_Sales_District__c(sales_district_code__c = '11', sales_district_name__c  = 'test', Language_code__c = 'E');
  insert ssd;
  ssd.sales_district_name__c = 'test1';
  update ssd;
  SAP_Sales_Office__c soff = new SAP_Sales_Office__c(Sales_Office_Code__c = '111', Sales_Office_name__c = 'test', Language_code__c = 'E');
  insert soff;
  soff.sales_office_name__c = 'test1';
  update soff;
  SAP_Sales_Group__c sg = new SAP_Sales_Group__c(Sales_Group_Code__c = '111', Sales_Group_Name__c = 'test', Language_code__c = 'E');
  insert sg;
  sg.sales_group_name__c = 'test1';
  update sg;
  
  Material_Pricing_Group1__c mpg1 = new Material_Pricing_Group1__c(Material_Pricing_Group1_Code__c = '111', Material_Pricing_Group1_Description__c = 'test', Language_code__c = 'E');
  insert mpg1;
  mpg1.Material_Pricing_Group1_Description__c = 'test1';
  update mpg1;
  
  Material_Pricing_Group2__c mpg2 = new Material_Pricing_Group2__c(Material_Pricing_Group2_Code__c = '222', Material_Pricing_Group2_Description__c = 'test', Language_code__c = 'E');
  insert mpg2;
  mpg2.Material_Pricing_Group2_Description__c = 'test2';
  update mpg2;
  
  Material_Pricing_Group3__c mpg3 = new Material_Pricing_Group3__c(Material_Pricing_Group3_Code__c = '333', Material_Pricing_Group3_Description__c = 'test', Language_code__c = 'E');
  insert mpg3;
  mpg3.Material_Pricing_Group3_Description__c = 'test3';
  update mpg3;
  
  Material_Pricing_Group4__c mpg4 = new Material_Pricing_Group4__c(Material_Pricing_Group4_Code__c = '444', Material_Pricing_Group4_Description__c = 'test', Language_code__c = 'E');
  insert mpg4;
  mpg4.Material_Pricing_Group4_Description__c = 'test4';
  update mpg4;
 
  Material_Pricing_Group5__c mpg5 = new Material_Pricing_Group5__c(Material_Pricing_Group5_Code__c = '555', Material_Pricing_Group5_Description__c = 'test', Language_code__c = 'E');
  insert mpg5;
  mpg5.Material_Pricing_Group5_Description__c = 'test5';
  update mpg5;
  
  Material_Pricing_Group__c mpg = new Material_Pricing_Group__c(Material_Pricing_Group_Code__c = '111', Material_Pricing_Group_Description__c = 'test', Language_code__c = 'E');
  insert mpg;
  mpg.Material_Pricing_Group_Description__c = 'test1';
  update mpg;
  
  Product_Hierarchy__c ph = new Product_Hierarchy__c(Product_Hierarchy_Code__c = 'TG2', Product_Hierarchy_Description__c = 'Test', Language_code__c = 'E');
  insert ph;
  ph.Product_Hierarchy_Description__c = 'Test1';
  update ph;
  
  Material_base_Code__c mbc = new Material_base_Code__c(Material_Base_Code__c = '01_00000000', Material_Base_Code_Description__c = 'Test');
  insert mbc;
  mbc.Material_Base_Code_Description__c = 'Test1';
  update mbc;
  
  SAP_Customer_Group4__c cg4 = new SAP_Customer_Group4__c(Customer_Group4_Code__c = '000', Customer_Group4_name__c = 'Test', Language_Code__c = 'E');
  insert cg4;
  cg4.customer_group4_name__c = 'test1';
  update cg4;
  
  SAP_Billing_Block_Code__c sbbc = new SAP_Billing_Block_Code__c(Billing_Block_Code__c = '01',Billing_Block_Name__c = 'Test', Language_Code__c = 'E');
  insert sbbc;
  sbbc.Billing_Block_Name__c = 'Test1';
  update sbbc;
  
  SAP_Customer_Attribute2__c sca2 = new SAP_Customer_Attribute2__c(Customer_Attribute2_Code__c = '01',Customer_Attribute2_Name__c = 'Test',Language_Code__c = 'E');
  insert sca2;
  sca2.Customer_Attribute2_Name__c = 'Test1';
  update sca2;
  
  SAP_Customer_Attribute5__c sca5 = new SAP_Customer_Attribute5__c(Customer_Attribute5_Code__c = 'ZK',Customer_Attribute5_Name__c = 'TRADE KEY', Language_Code__c = 'E');
  insert sca5;
  sca5.Customer_Attribute5_Name__c = 'test';
  update sca5;
  
  SAP_Customer_Attribute8__c sca8 = new SAP_Customer_Attribute8__c(Customer_Attribute8_Code__c = 'Z2',Customer_Attribute8_Name__c = 'test',Language_Code__c = 'E');
  insert sca8;
  sca8.Customer_Attribute8_Name__c = 'test1';
  update sca8;
  
  SAP_Customer_Classification__c scc = new SAP_Customer_Classification__c(Customer_Classification_Code__c = '01',Customer_Classification_Name__c = 'test',Language_Code__c = 'E');
  insert scc;
  scc.Customer_Classification_Name__c = 'test1';
  update scc;
  
  SAP_Customer_Group1__c scg1 = new SAP_Customer_Group1__c(Customer_Group1_Code__c = '101',Customer_Group1_Name__c = 'test',Language_Code__c = 'E');
  insert scg1;
  scg1.Customer_Group1_Name__c = 'test1';
  update scg1;
  
  SAP_Customer_Group2__c scg2 = new SAP_Customer_Group2__c(Customer_Group2_Code__c = '12C',Customer_Group2_Name__c = 'test',Language_Code__c = 'E');
  insert scg2;
  scg2.Customer_Group2_Name__c = 'test1';
  update scg2;
  
  SAP_Customer_Group3__c scg3 = new SAP_Customer_Group3__c(Customer_Group3_Code__c = '100',Customer_Group3_Name__c = 'test',Language_Code__c = 'E');
  insert scg3;
  scg3.Customer_Group3_Name__c = 'test1';
  update scg3;
  
  SAP_Customer_Group4__c scg4 = new SAP_Customer_Group4__c(Customer_Group4_Code__c = '10A',Customer_Group4_Name__c = 'test',Language_Code__c = 'E');
  insert scg4;
  scg4.Customer_Group4_Name__c = 'test1';
  update scg4;
  
  SAP_Customer_Group5__c scg5 = new SAP_Customer_Group5__c(Customer_Group5_Code__c = '23A',Customer_Group5_Name__c = 'test',Language_Code__c = 'E');
  insert scg5;
  scg5.Customer_Group5_Name__c = 'test1';
  update scg5;
  
  SAP_Customer_Group__c scg = new SAP_Customer_Group__c(Customer_Group_Code__c = '60',Customer_Group_Name__c = 'test',Language_Code__c = 'E');
  insert scg;
  scg.Customer_Group_Name__c = 'test1';
  update scg;
  
  SAP_Delivery_Block_Code__c sdbc = new SAP_Delivery_Block_Code__c(Delivery_Block_Code__c = '01',Delivery_Block_Name__c = '',Language_Code__c = 'E');
  insert sdbc;
  sdbc.Delivery_Block_Name__c = 'test1';
  update sdbc;
  
  SAP_INCO_Term__c sit = new SAP_INCO_Term__c(INCO_Term_Code__c = 'ZD1',INCO_Term_Name__c = 'test',Language_Code__c = 'E');
  insert sit;
  sit.INCO_Term_Name__c = 'test1';
  update sit;
  
  SAP_Industry_Code__c sic = new SAP_Industry_Code__c(Industry_Code__c = '01110000',Industry_Name__c = 'test',Language_Code__c = 'E');
  insert sic;
  sic.Industry_Name__c = 'test1';
  update sic;
  
  SAP_Order_Block_Code__c sobc = new SAP_Order_Block_Code__c(Order_Block_Code__c = '01',Order_Block_Name__c = 'test',Language_Code__c = 'E');
  insert sobc;
  sobc.Order_Block_Name__c = 'test1';
  update sobc;
  
  SAP_Payment_Term_Explanation__c spte = new SAP_Payment_Term_Explanation__c(Payment_Term_Code__c = 'P225',Payment_Term_Explanation__c = 'test',Language_Code__c = 'E', Day_limit__c = '00',Record_Key__c = 'P22500');
  insert spte;
  spte.Payment_Term_Explanation__c = 'test1';
  update spte;
  
  SAP_Price_List_Type__c splt = new SAP_Price_List_Type__c(Price_List_Type_Code__c = '01',Price_List_Type_Name__c = 'test',Language_Code__c = 'E');
  insert splt;
  splt.Price_List_Type_Name__c = 'test1';
  update splt;
  
  
}
}