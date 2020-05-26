@isTest
global class cc_imp_util_HttpUtilsTestMock implements HttpCalloutMock {

	global cc_imp_util_HttpUtilsTestMock (){
		throwException = false;
	}
	
	global HTTPResponse respond(HttpRequest request){
		if(throwException){
			throw new cc_imp_util_HttpUtilsException('Test Exception');
		}
		HttpResponse response = new HttpResponse();
		response.setStatusCode(200);
		response.setStatus('OK');
		response.setHeader('set-cookie','testkey=testvalue');
		return response;
	}
	
	global Boolean throwException {get; set;}

}