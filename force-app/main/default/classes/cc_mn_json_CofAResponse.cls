public with sharing class cc_mn_json_CofAResponse {

    public String material {get; set;}
    public String batch_number {get; set;}
    public String document {get; set;}
    public String message {get; set;}
    public List<StatusResponse> status {get; set;}

    public Boolean success {get; set;}
    public String responseCode {get; set;}

    public class StatusResponse {
        public String message {get; set;}
    }
    
    public static cc_mn_json_CofAResponse parse(String json) {
        return (cc_mn_json_CofAResponse) System.JSON.deserialize(json, cc_mn_json_CofAResponse.class);
    }

    public String serialize() {
        return JSON.serialize(this);
    }
}