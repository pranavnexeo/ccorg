public class cc_mn_json_ESARequest
{
    public string Sales_order='';
    public string ARC_DOC_ID='';
    public string AR_OBJECT='';
    public cc_mn_json_ESARequest()
    {
       Sales_order='';
        ARC_DOC_ID='';
        AR_OBJECT ='';
    }
    public static cc_mn_json_ESARequest parse(String json) {
        return (cc_mn_json_ESARequest) System.JSON.deserialize(json, cc_mn_json_ESARequest.class);
    }

    public String serialize() {
        return JSON.serialize(this);
    }
}