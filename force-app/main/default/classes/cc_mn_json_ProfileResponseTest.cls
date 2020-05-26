@isTest
public class cc_mn_json_ProfileResponseTest {
    
    @isTest static void ValidateViewDoc()
    {
        cc_mn_json_ProfileResponse obj34= new cc_mn_json_ProfileResponse();
        cc_mn_json_ProfileResponse.parse('[{"Sales_order ":"345"}]');
        obj34.serialize();
    }
}