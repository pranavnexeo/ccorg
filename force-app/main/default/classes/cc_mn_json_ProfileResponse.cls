public with sharing class cc_mn_json_ProfileResponse {

        public String customer {get; set;}
        public string profile {get; set;}
        public string appr_exp_date {get; set;}
        public String specification {get; set;}
        public string profile_desc{get;set;}
        public list<string> status{get;set;}
        public string disposer_name{get;set;}
        public cc_mn_json_ProfileResponse()
        {
          disposer_name ='';
          customer='';
          profile= '';  
          appr_exp_date='';
          specification='';
          profile_desc='';
          status = new list<string>();
          StatusResponse obj= new StatusResponse();
        }
        public class StatusResponse {
            public String message {get; set;}
        }
        
        public static list<cc_mn_json_ProfileResponse> parse(String json) {
            list<cc_mn_json_ProfileResponse> lst = new list<cc_mn_json_ProfileResponse>();
            lst = (list<cc_mn_json_ProfileResponse>)System.JSON.deserialize(json, list<cc_mn_json_ProfileResponse>.class);
            return lst;
        }
    
        public String serialize() {
            return JSON.serialize(this);
        }
 }