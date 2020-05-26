@isTest
public class cc_imp_util_HttpTest {
	// basic constructor test
	@isTest
	private static void testEmptyConstructor(){
		cc_imp_util_Http util = new cc_imp_util_Http();
		Integer statusCode = util.statusCode;
		String status = util.status;
		
		System.assertEquals(util.requestContentType, null);
		System.assertEquals(util.endpoint, null);
		System.assertEquals(util.body, null);
		System.assertEquals(util.method, cc_imp_util_Http.REQUEST_TYPE.GET);
		System.assertEquals(statusCode, null);
		System.assertEquals(status, null);
	} 

	@isTest
	private static void testException(){
		cc_imp_util_Http util = new cc_imp_util_Http();
		cc_imp_util_HttpUtilsTestMock testMock = new cc_imp_util_HttpUtilsTestMock();
		testMock.throwException = true;
		Test.setMock(HttpCalloutMock.class, testMock);
		Boolean threwException = false;
		Test.startTest();
		util.submitRequest();
		Test.stopTest();
		System.assert(util.requestErrors);
	}

	@isTest
	private static void testFullConstructor(){
		Test.setMock(HttpCalloutMock.class, new cc_imp_util_HttpUtilsTestMock());
		Test.startTest();
		cc_imp_util_Http util = new cc_imp_util_Http('http://avionos.com', cc_imp_util_Http.CONTENT_TYPE.JSON, '{ "userName":"test@avionos.com”, "password": "password", "firstName":"firstName","lastName":"lastName","email":"email@avionos.com"}');
		util.addCookie('AuthToken', 'MyAuth');
		util.addQueryParameter('isOrganization', 'true');
		util.setBody('test');
		util.addQueryParameter('param1', 'value1');
		util.addQueryParameter('param2', 'value2');
		util.submitRequest();
		Test.stopTest();
		System.assertEquals(200, util.statusCode);
		System.assertEquals('OK', util.status);
	}

	@isTest
	private static void testCookie(){
		PageReference pageRef = new PageReference('/');
		Cookie c = new Cookie('testkey', 'testvalue', null, -1, false);
		pageRef.setCookies(new LIST<Cookie>{c});

		Test.setCurrentPage(pageRef);
		Test.setMock(HttpCalloutMock.class, new cc_imp_util_HttpUtilsTestMock());
		Test.startTest();
		cc_imp_util_Http util = new cc_imp_util_Http('http://avionos.com', cc_imp_util_Http.CONTENT_TYPE.JSON, '{ "userName":"test@avionos.com”, "password": "password", "firstName":"firstName","lastName":"lastName","email":"email@avionos.com"}');
		util.addCookie('AuthToken', 'MyAuth');
		util.addQueryParameter('isOrganization', 'true');
		util.setBody('test');
		util.addQueryParameter('param1', 'value1');
		util.addQueryParameter('param2', 'value2');
		util.submitRequest();
		Test.stopTest();
		System.assertEquals(200, util.statusCode);
		System.assertEquals('OK', util.status);
		System.assertEquals('testvalue', util.getCookieValue('testkey'));
	}


	@isTest
	private static void testResetState(){
		Test.setMock(HttpCalloutMock.class, new cc_imp_util_HttpUtilsTestMock());
		Test.startTest();
		cc_imp_util_Http util = new cc_imp_util_Http('http://avionos.com', cc_imp_util_Http.CONTENT_TYPE.JSON, '{ "userName":"test@avionos.com”, "password": "password", "firstName":"firstName","lastName":"lastName","email":"email@avionos.com"}');
		util.addCookie('AuthToken', 'MyAuth');
		util.addQueryParameter('isOrganization', 'true');
		util.setBody('test');
		util.addQueryParameter('param1', 'value1');
		util.addQueryParameter('param2', 'value2');
		util.submitRequest();
		util.resetState();
		Test.stopTest();

		System.assertEquals(util.requestContentType, null);
		System.assertEquals(util.endpoint, null);
		System.assertEquals(util.body, null);
		System.assertEquals(util.method, null);
		System.assertEquals(util.statusCode, null);
		System.assertEquals(util.status, null);

	}
}