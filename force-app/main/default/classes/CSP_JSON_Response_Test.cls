@isTest
private class CSP_JSON_Response_Test {
public static testMethod void testmyCSPJSONResponse() {
String test = 'test';

CSP_JSON_Response resp = new CSP_JSON_Response(test,test,test,test,test,test,test,test,test,test,test,
                                               test,test,test,test,test,test,test,test,test,test,test,
                                               test,test,test,test, 
                                               new List<CSP_JSON_Response.tbl_sales_units>{new CSP_JSON_Response.tbl_sales_units( test, test, test, test, test)}, 
                                               new List<CSP_JSON_Response.tbl_csp_prices>{new CSP_JSON_Response.tbl_csp_prices(test,test,test,test,test,test,test,test,test,test,test)}, 
                                               new List<CSP_JSON_Response.tbl_target_prices>{new CSP_JSON_Response.tbl_target_prices(test,test,test,test,test,test,test,test,test,test,test,test,test,test,test,test,test,test,test,test,test,test, test,test,test,test,test,test, test)},  
                                               new List<CSP_JSON_Response.tbl_list_prices>{new CSP_JSON_Response.tbl_list_prices(test,test,test,test,test,test,test,test,test,test,test, test)},
                                               test,test);
}
}