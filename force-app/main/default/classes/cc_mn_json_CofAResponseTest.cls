@IsTest
public with sharing class cc_mn_json_CofAResponseTest {

    static testMethod void testParse() {
        String json = '{"material":"16106053","batch_number":"1234567890","document":"XXXXX","status":[{"type":"S","message":"success"}]}';
        cc_mn_json_CofAResponse obj = cc_mn_json_CofAResponse.parse(json);
        System.assert(obj != null);
        System.assertEquals('16106053', obj.material);
        System.assertEquals('1234567890', obj.batch_number);
        System.assertEquals('success', obj.status[0].message);
        System.assertNotEquals(null, obj.serialize());
    }
}