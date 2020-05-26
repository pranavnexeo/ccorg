@isTest
public class cc_mn_json_ESARequestTest {
    
    @isTest static void ValidateViewDoc()
    {
        cc_mn_json_ESARequest obj = new cc_mn_json_ESARequest();
        
        cc_mn_json_ESARequest.parse('{"Sales_order ":"345"}');
        obj.serialize();
    }
}