@isTest
private class CSP_JSON_Request_Item_Test {
public static testMethod void testmyCSPJSONRequestItem() {
String test = 'test';

CSP_JSON_Request_Item i = new CSP_JSON_Request_Item('test','test', 'test', 'test', 'test', 'test', 'test', 'test');
i = new CSP_JSON_Request_Item('test', 'test','test', 'test', 'test', 'test', 'test', 'test', 'test');
 CSP_JSON_Request_Item  i1 = new CSP_JSON_Request_Item('test', 'test','test', 'test', 'test', 'test', 'test', 'test', 'test','test', 'test');
i.getship_to();
i.getsold_to();
i.getmaterial();
i.getSales_rep();
i.getquantity();
i.getsales_unit();
i.getSFDC_Account_Id();
i.getSFDC_Material_Id();
i.getNew_Product();
i.getSales_Org();
i.getDis_Channel();
}
}