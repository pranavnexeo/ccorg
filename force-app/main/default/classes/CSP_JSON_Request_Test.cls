@isTest
private class CSP_JSON_Request_Test {
public static testMethod void testmyCSPJSONRequest() {
     string test = 'test';
     CSP_JSON_Request_Item csp = new CSP_JSON_Request_Item('0000094713', '0000094713', test, test, '1', 'LB', 'a56c0000000JdJYAA0', test);
     List<CSP_JSON_Request_Item> items = new List<CSP_JSON_Request_Item>();
     items.add(csp);     
     //string url = 'https://nexeo--full.cs14.my.salesforce.com/07Mc0000000TKlK';    
     nexPrice_Settings__c settings = new nexPrice_Settings__c();
     settings.EasyPrice_EndPoint__c = 'https://fakeurl.com';
     settings.Mini_EndPoint__c = 'https://fakeurl.com';
     settings.History_EndPoint__c = 'https://fakeurl.com';
     settings.Contribution_Margin_Endpoint__c = 'https://fakeurl.com';
     insert settings;

     List<List<CSP_JSON_Request_Item>> listofitems=new List<List<CSP_JSON_Request_Item>>();
     listofitems.add(items);
     CSP_History_JSON_Request_Item chi= new CSP_History_JSON_Request_Item('Ship_to', 'Sold_to', 'Sales_Rep', 'material', 'base_code', 'Quantity', 'Sales_unit', 'date_from', 'date_to', 'SFDC_Account_Id', 'SFDC_Material_Id');
     List<CSP_History_JSON_Request_Item> item1=new List<CSP_History_JSON_Request_Item>();
      item1.add(chi);
                    try{
                    CSP_JSON_Request.Submit_Request(items);
                    }
                    catch(exception e) {}
                    try{
                    CSP_JSON_Request.Submit_Request_m(items);
                    }
                    catch (exception e){}
                    try{                    
                    CSP_JSON_Request.Submit_Request_m(listofitems);
                    }
                    catch (exception e){}
                    
                    try{
                    CSP_JSON_Request.Submit_History_Request(item1);
                    }
                    catch (exception e){}
                    
                    try{
                    CSP_JSON_Request.Submit_Request_String(new List<CSP_JSON_Request_Item>());
                    }
                    catch (exception e){}
                    try{
                    CSP_JSON_Request.Submit_History_Request_String(new List<CSP_History_JSON_Request_Item>());
                    }
                    catch (exception e){}
                    try{
                    List<CM_JSON_Request_Item> itemsList = new List<CM_JSON_Request_Item>();
                    CM_JSON_Request_Item item = new CM_JSON_Request_Item();
                    item.Ship_to = 'shipto';
    				itemsList.add(item);
                    CSP_JSON_Request.Submit_Request_CM(itemsList);
                    }
                    catch (exception e){}
}
}