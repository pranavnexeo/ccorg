public with sharing class cc_mn_json_ESAResponse {

        public String Sales_order {get; set;}
        public String ARC_DOC_ID {get; set;}
        public string AR_OBJECT{get;set;}
        public String document {get; set;}
        public String message {get; set;}
        public List<StatusResponse> status {get; set;}
    
        public Boolean success {get; set;}
        public String responseCode {get; set;}
        public cc_mn_json_ESAResponse()
        {
            Sales_order=''; 
            ARC_DOC_ID='';  
            AR_OBJECT='';  
            document='';  
            message='';  
            success=false; 
            responseCode ='';  
            status   = new List<StatusResponse> ();
        }
        public class StatusResponse {
            public String message {get; set;}
        }
        
        public static cc_mn_json_ESAResponse parse(String json) {
            return (cc_mn_json_ESAResponse) System.JSON.deserialize(json, cc_mn_json_ESAResponse.class);
        }
    
        public String serialize() {
            return JSON.serialize(this);
        }
    }