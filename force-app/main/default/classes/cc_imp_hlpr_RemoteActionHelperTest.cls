@isTest
private class cc_imp_hlpr_RemoteActionHelperTest {
	
	@isTest static void test_remoteInit() {
		ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
		ccrz.cc_RemoteActionResult result = cc_imp_hlpr_RemoteActionHelper.remoteInit(ctx);	
		System.assertEquals(ctx, result.inputContext);
	}
	
	@isTest static void test_buildResponseData() {
		String testKey = 'key';
		Integer testInt = 7;
		Boolean success = false;

		ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
		ccrz.cc_RemoteActionResult result = cc_imp_hlpr_RemoteActionHelper.remoteInit(ctx);	
		cc_imp_hlpr_RemoteActionHelper.buildResponseData( 
			result,
			success, 
			new Map<String, Object> {
				testKey => testInt
			}
		);

		System.assertEquals(success, result.success);
		System.assertEquals(testInt, (Integer)((Map<String,Object>)result.data).get(testKey));
	}


	@isTest static void test_buildResponseData_NullSuccess() {
		String testKey = 'key';
		Integer testInt = 7;
		Boolean success = null;

		ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
		ccrz.cc_RemoteActionResult result = cc_imp_hlpr_RemoteActionHelper.remoteInit(ctx);	
		cc_imp_hlpr_RemoteActionHelper.buildResponseData( 
			result,
			success, 
			new Map<String, Object> {
				testKey => testInt
			}
		);

		System.assert(result.success);
	}


	@isTest static void test_createMessage(){
		ccrz.cc_bean_Message.MessageSeverity severity = ccrz.cc_bean_Message.MessageSeverity.ERROR; 
		String labelName = 'theName';
		Object data = 'testData';
		String className = 'theClass';

   		ccrz.cc_bean_Message msg = cc_imp_hlpr_RemoteActionHelper.createMessage(severity, labelName, data, className);
   		System.assertEquals(labelName, msg.labelId);
   		System.assertEquals(className, msg.classToAppend);
   		System.assertEquals((String)data, msg.message);
   		System.assertEquals(severity, msg.severity);

	}



}