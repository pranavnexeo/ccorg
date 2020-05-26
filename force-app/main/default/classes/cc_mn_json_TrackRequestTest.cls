@IsTest
public with sharing class cc_mn_json_TrackRequestTest {
    static testMethod void testParse() {
        String json = '{\"doc_number\": \"7391058\"}';
        cc_mn_json_TrackRequest obj = cc_mn_json_TrackRequest.parse(json);
        System.assert(obj != null);
    }
}