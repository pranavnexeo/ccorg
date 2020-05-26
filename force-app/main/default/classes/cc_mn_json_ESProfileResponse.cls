public with sharing class cc_mn_json_ESProfileResponse {

        public String document {get; set;}
        public Boolean success {get; set;}
        public String responseCode {get; set;}
        public String message {get; set;}
        public cc_mn_json_ESProfileResponse()
        {
          document='';
          success= false;  
          responseCode ='';
          message='';
          StatusResponse obj= new StatusResponse();
        }
        public class StatusResponse {
            public String message {get; set;}
        }
        
        public static cc_mn_json_ESProfileResponse parse(String json) {
            return (cc_mn_json_ESProfileResponse) System.JSON.deserialize(json, cc_mn_json_ESProfileResponse.class);
        }
    
        public String serialize() {
            return JSON.serialize(this);
        }
 }