global with sharing class cc_mn_ctrl_FleetTrack {
    @RemoteAction   
    global static ccrz.cc_RemoteActionResult fetch(ccrz.cc_RemoteActionContext ctx, String docNumber) {
        ccrz.cc_RemoteActionResult response = cc_imp_hlpr_RemoteActionHelper.remoteInit(ctx);

        cc_mn_json_TrackResponse calloutResponse = cc_mn_api_FleetTrack.fetchFleetTrack(ccrz.cc_CallContext.storefront, docNumber);
        Map<String,Object> data = new Map<String,Object>{'success' => callOutResponse.success, 'data' => callOutResponse, 'message' => callOutResponse.message};

        cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, calloutResponse.success, data);
        
        return response;
    }
}