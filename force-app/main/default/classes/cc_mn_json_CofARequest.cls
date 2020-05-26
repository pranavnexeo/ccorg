public with sharing class cc_mn_json_CofARequest {

    public String material {get; set;}
    public String batch_number {get; set;}

    public static cc_mn_json_CofARequest parse(String json) {
        return (cc_mn_json_CofARequest) System.JSON.deserialize(json, cc_mn_json_CofARequest.class);
    }

    public String serialize() {
        return JSON.serialize(this);
    }
}