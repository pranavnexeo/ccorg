public with sharing class cc_mn_json_TrackRequest {
    public String doc_number {get; set;}

    public static cc_mn_json_TrackRequest parse(String json) {
        return (cc_mn_json_TrackRequest) System.JSON.deserialize(json, cc_mn_json_TrackRequest.class);
    }

    public String serialize() {
        return JSON.serialize(this);
    }
}