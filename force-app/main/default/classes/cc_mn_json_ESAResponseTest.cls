@isTest
public class cc_mn_json_ESAResponseTest {
    
    @isTest static void ValidateViewDoc()
    {
        cc_mn_json_ESAResponse obj = new cc_mn_json_ESAResponse();
        cc_mn_json_ESAResponse.StatusResponse obj1 = new cc_mn_json_ESAResponse.StatusResponse();
        cc_mn_json_ESAResponse.parse('{"Sales_order ":"345"}');
        obj.serialize();
    }
}