@IsTest(seealldata = true)
public class easyOrderStatusUpdate_Test {
    
     @IsTest
    static void testEasyOrderStatusUpdateSuccess() {
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = 'http://';
        req.requestBody = Blob.valueOf('Test Blob');
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.setMock(HttpCalloutMock.class, new MockHttpGenerator(200, '200', '', new Map<String, String>()));
        //easyOrderStatusUpdate.doPost();
        Test.stopTest();

    }
    
    @IsTest
    static void testEasyOrderStatusUpdateFails() {
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = 'http://';
        
        req.requestBody = Blob.valueOf('Test Blob');
        
        RestContext.request = req;
        RestContext.response = res;

        
        Test.setMock(HttpCalloutMock.class, new MockHttpGenerator(503, '503', '<html>', new Map<String, String>()));
        //easyOrderStatusUpdate.doPost();
        Test.stopTest();

    }
    
    @IsTest
    static void testDelete() {
        Test.startTest();
        easyOrderStatusUpdate.doDelete();
        Test.stopTest();
    }

}