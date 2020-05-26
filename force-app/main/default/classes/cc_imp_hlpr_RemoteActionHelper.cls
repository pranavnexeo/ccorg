/**
 * cc_imp_hlpr_RemoteActionHelper
 *
 * Description:
 * This is a helper class that should be used by controllers that expose remote action methods
 * to initialize the Call Context, and to create response messages to add to the remote action response.
 *
 *
 */
public with sharing class cc_imp_hlpr_RemoteActionHelper {

	/**
	 * Initialize the call context from the remote action context.  Call this method at the beginning of each
	 * remote action method:
	 *
	 * ccrz.cc_RemoteActionResult res = cc_klg_hlpr_RemoteActionHelper.remoteInit(ctx);
	 *
	 */
	public static ccrz.cc_RemoteActionResult remoteInit(ccrz.cc_RemoteActionContext ctx) {
        ccrz.cc_RemoteActionResult result = new ccrz.cc_RemoteActionResult();
        result.success = false;
        result.inputContext = ctx;
        ccrz.cc_CallContext.initRemoteContext(ctx);
        return result;
    }

	/**
	 * Call this method to add messages to the remote action response.
	 *
	 *
	 * ccrz.cc_RemoteActionResult res = cc_klg_hlpr_RemoteActionHelper.remoteInit(ctx);
	 * res.messages.add(cc_gew_ctrl_OrderAttribs.createMessage(ccrz.cc_bean_Message.MessageSeverity.ERROR, null, e.getMessage() + ': ' + e.getStackTraceString(), 'messagingSection-Error'));
	 *
	 */
    public static ccrz.cc_bean_Message createMessage(ccrz.cc_bean_Message.MessageSeverity severity, String labelName, Object data, String className) {
        ccrz.cc_bean_Message msg = new ccrz.cc_bean_Message();
        msg.type = ccrz.cc_bean_Message.MessageType.CUSTOM;
        msg.classToAppend = className;
        msg.labelId = labelName;
        if (data != null)
            msg.message = String.valueOf(data);
        msg.severity = severity;
        return msg;
    }

    /**
     * Call this method to add custom data to the response.
     *
     * Parameters:
     *	response - the initialized cc_RemoteActionResult
     *  data - a Map<String, Object> of all the structures built in the remote action method.
	 *
	 * Example:
	 *	ccrz.cc_RemoteActionResult res = cc_klg_hlpr_RemoteActionHelper.remoteInit(ctx);
	 *  List<String> myStringList = new List<String>{ ... };
	 *  String endpoint = 'http:// ... ';
     *	cc_klg_hlpr_RemoteActionHelper.buildResponseData(response, true, 
     *		new Map<String,Object>{
     *			'endpoint' => endpoint,
     *			'myStringList' => myStringList
     *		}
     *  );
     *	
     *
     */
     public static void buildResponseData(ccrz.cc_RemoteActionResult response, Boolean success, Map<String, Object> data){
		response.data = data;
		if(success == null){
			response.success = true;
		}
		else {
			response.success = success;
		}
     }

}