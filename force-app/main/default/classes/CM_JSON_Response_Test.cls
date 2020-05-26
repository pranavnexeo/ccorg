@isTest
private class CM_JSON_Response_Test {
public static testMethod void testmyCMJSONResponse() {
String test = 'test';

CM_JSON_Response cj = new CM_JSON_Response('test', 'test', 'test','test', 'test','test', 'test', 'test', 'test','test', 'test', 'test', 'test', 'test', 'test', 'test','test', 'test','test', 'test');

cj.curr= 'test';
cj.sfdc_account_id= 'test';
cj.sfdc_material_id= 'test';
cj.price= 'test';
cj.price_support= 'test';
cj.ic_charge= 'test';
cj.add_charge= 'test';
cj.mat_cost= 'test';
cj.warehouse_charge= 'test';
cj.freight_charge= 'test';
cj.quantity= 'test';
cj.message= 'test';
cj.status= 'test';
cj.revenue = 'test';
cj.contrib_margin = 'test';
cj.cm_percent = 'test';
cj.unit_cm = 'test';
cj.unit_mat_cost = 'test';
cj.unit_warehouse_chg = 'test';
cj.unit_freight_chg = 'test';
  
  }   
}