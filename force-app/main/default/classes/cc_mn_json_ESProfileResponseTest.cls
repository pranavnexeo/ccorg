@isTest
public class cc_mn_json_ESProfileResponseTest {
    
    @isTest static void ValidateViewDoc()
    {
        cc_mn_json_ESProfileResponse  obj34= new cc_mn_json_ESProfileResponse();
        cc_mn_json_ESProfileResponse.parse('{"Sales_order ":"345"}');
        obj34.serialize();
    }
}