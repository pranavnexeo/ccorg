@isTest
private class CM_JSON_Request_Item_Test {
public static testMethod void testmyCMJSONRequestItem()
{
String test = 'test';

CM_JSON_Request_Item cj1 = new CM_JSON_Request_Item();
double d = 0.133;
CM_JSON_Request_Item cj = new CM_JSON_Request_Item('test','test', 'test',d, 'test',d, 'test', 'test', 'test', 'test','test', 'test', 'test', 'test','test');
cj.Sold_to = 'test';
cj.Ship_to= 'test';
cj.Material= 'test';
cj.Sales_Unit= 'test';
cj.SFDC_Account_Id= 'test';
cj.SFDC_Material_Id= 'test';
cj.Sales_Org= 'test';
cj.freight_terms= 'test';
cj.plant= 'test';
cj.curr= 'test';
cj.distr_chan= 'test';
cj.price_unit= 'test';
cj.division= 'test';
cj.Quantity = 0.133;
cj.price= 0.134;


}

}