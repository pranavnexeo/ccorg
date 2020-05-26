global with sharing class cc_imp_mn_ctrl_MyAccount 
{

	 @RemoteAction
	  global static ccrz.cc_RemoteActionResult fetchCreditHistory(ccrz.cc_RemoteActionContext ctx)
	  {
	  	ccrz.cc_RemoteActionResult response = cc_imp_hlpr_RemoteActionHelper.remoteInit(ctx);

	  	cc_mn_json_ViewCreditResponse viewCreditResponse = cc_mn_api_ViewCredit.fetchViewCreditInfo();

	  	cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, viewCreditResponse.success, 
																 new Map<String,Object>
																 {'success' => viewCreditResponse.success,
																   'creditHistoryData' => viewCreditResponse,
																   'message' =>  viewCreditResponse.message
																});
        return response;
      }

}