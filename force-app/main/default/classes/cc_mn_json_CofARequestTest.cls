@IsTest
public with sharing class cc_mn_json_CofARequestTest {
    static testMethod void testParse() {
        String json = '{\"material\": \"16106053\",\"batch_number\": \"1234567890\"}';
        cc_mn_json_CofARequest obj = cc_mn_json_CofARequest.parse(json);
        System.assert(obj != null);
    }
}