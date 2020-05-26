@isTest
public class inventory_request_test {
	static testMethod void testParse() {
        string json = '[{"HEADER": [{"SALES_ORG": "1000","DISTR_CHAN": "30","DIVISION": "32"}],"PARTNERS": [{"PARTN_ROLE": "AG","PARTN_NUMB": "0000176745"}],"ITEMS": [{"MATERIAL": "000000000000027765","PLANT": "0084","REQ_QTY": 1000,"SALES_UNIT": "LB","REQ_DATE": "2018-04-07"}],"SWITCHES": [{"ATP":[ {"swtchOn": "X","LOCALE": "enUS"}] }]}]}}';
		List<inventory_request> inv = inventory_Request.parse(json);
	}
}