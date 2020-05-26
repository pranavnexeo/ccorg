@IsTest(seealldata = true)
public class easyOrderList_Test {
    
    @IsTest
    static void testEasyOrderListSuccess() {
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestBody = Blob.valueOf('Test Blob');
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.setMock(HttpCalloutMock.class, new MockHttpGenerator(200, '200', '', new Map<String, String>()));

        Test.stopTest();

    }
    
    @IsTest
    static void testEasyOrderListFails() {
        
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestBody = Blob.valueOf('Test Blob');
        
        RestContext.request = req;
        RestContext.response = res;

        
        Test.setMock(HttpCalloutMock.class, new MockHttpGenerator(503, '503', '<html>', new Map<String, String>()));
        //easyOrderList.doPost();
        Test.stopTest();

    }
    
    @IsTest
    static void testDelete() {
        Test.startTest();
        easyOrderList.doDelete();
        Test.stopTest();
    }

}