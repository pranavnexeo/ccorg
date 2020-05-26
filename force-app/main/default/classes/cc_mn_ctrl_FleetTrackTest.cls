@isTest
public class cc_mn_ctrl_FleetTrackTest {
    static testmethod void fetchCofATest() {
        cc_imp_StorefrontSettings__c myNexeoCustomSetting = cc_imp_testUtils.createMyNexeoCustomSetting();
        insert myNexeoCustomSetting ;

        Map <String, String> headerMap = new Map<String, String> ();
        headerMap.put('Content-Type','application/json');

        Test.setMock(HttpCalloutMock.class, new cc_imp_mn_FetchMSDSMock_HttpResponse(200, 'success', cc_mn_json_TrackResponseTest.JSON_RESPONSE, headerMap));

        cc_imp_testUtils.clearContext();
       
        ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_MYNEXEO_STOREFRONT;

        String docNumber = '7391058';

        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();

        ccrz.cc_RemoteActionResult res = null;

        Test.startTest();
        res  = cc_mn_ctrl_FleetTrack.fetch(ctx, docNumber);
        Test.stopTest();

        System.assert(res != null);
        System.assert(res.data != null);
        Map<String,Object> data = (Map<String,Object>) res.data;
        System.assert((Boolean) data.get('success'));

    }

    static testmethod void fetchCofAFailTest() {
        cc_imp_StorefrontSettings__c myNexeoCustomSetting = cc_imp_testUtils.createMyNexeoCustomSetting();
        insert myNexeoCustomSetting ;

        Map <String, String> headerMap = new Map<String, String> ();
        headerMap.put('Content-Type','application/json');

        Test.setMock(HttpCalloutMock.class, new cc_imp_mn_FetchMSDSMock_HttpResponse(200, 'success', cc_mn_json_TrackResponseTest.JSON_RESPONSE_ERROR, headerMap));

        cc_imp_testUtils.clearContext();
       
        ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_MYNEXEO_STOREFRONT;

        String docNumber = '7391058';

        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();

        ccrz.cc_RemoteActionResult res = null;

        Test.startTest();
        res  = cc_mn_ctrl_FleetTrack.fetch(ctx, docNumber);
        Test.stopTest();

        System.assert(res != null);
        System.assert(res.data != null);
        Map<String,Object> data = (Map<String,Object>) res.data;
        cc_mn_json_TrackResponse calloutResponse = (cc_mn_json_TrackResponse)data.get('data');
        List<cc_mn_json_TrackResponse.TrackItem> items = calloutResponse.items;
        String errorIndicator = '';
        if(items.size()>0){
            errorIndicator = items[0].error_indicator;
        }
        System.assertEquals(errorIndicator,'e');
    }
}