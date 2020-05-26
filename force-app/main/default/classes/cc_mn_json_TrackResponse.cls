public with sharing class cc_mn_json_TrackResponse {

    public String message {get; set;}
    public Boolean success {get; set;}
    public String responseCode {get; set;}

    public List<TrackItem> items {get; set;}

    public class TrackItem {
        public String error_indicator {get; set;}
        public String doc_number {get; set;}
        public String itm_number {get; set;}
        public String track_type {get; set;}
        public String planned_gi_date {get; set;}
        public String planned_delivery_date {get; set;}  
        public String requested_date {get; set;}          
        public String estimated_delivery_date {get; set;}    
        public String url {get; set;}
        public List<StatusResponse> status {get; set;}
        public FleetData pvt_fleet_data {get; set;}  
    }

    public class StatusResponse {
        public String message {get; set;}
        public String log_msg_no {get; set;}
        public String message_v1 {get; set;}
        public String type {get; set;}
    }

    public class FleetData {
        public VehicleLocation vehicle_location {get; set;}
        public List<StopData> stops_data {get; set;}
    }

    public class VehicleLocation {
        public String mandt {get; set;}
        public String uniqkey {get; set;}
        public String status {get; set;}
        public String vehicle_number {get; set;}
        public String datime {get; set;}
        public String speed {get; set;}
        public String latitude {get; set;}
        public String longitude {get; set;}
        public String location {get; set;}
        public String logindriver1 {get; set;}
    }

    public class StopData {
        public String mandt {get; set;}
        public String vehicle_number {get; set;}
        public String dispatch_number {get; set;}
        public String shipment_number {get; set;}
        public String dispatch_status {get; set;}
        public String driver {get; set;}
        public String stop_number {get; set;}
        public String name {get; set;}
        public String city {get; set;}
        public String state {get; set;}
        public String latitude {get; set;}
        public String longitude {get; set;}
        public String scheduled_arrival {get; set;}
        public String arrival_time {get; set;}
        public String departure_time {get; set;}
        public String location_status {get; set;}
        public String ship_to {get; set;}
    }
    
    public static cc_mn_json_TrackResponse parse(String json) {
        cc_mn_json_TrackResponse response = new cc_mn_json_TrackResponse();
        List<cc_mn_json_TrackResponse.TrackItem> items = (List<cc_mn_json_TrackResponse.TrackItem>) System.JSON.deserialize(json, List<cc_mn_json_TrackResponse.TrackItem>.class);
        List<cc_mn_json_TrackResponse.TrackItem> checkedForErrors = new List<cc_mn_json_TrackResponse.TrackItem>();
        for(cc_mn_json_TrackResponse.TrackItem item :items){
            List<StatusResponse> statusRspns = item.status;
            for(StatusResponse statusCheck :statusRspns){
                if(statusCheck.type.equalsIgnoreCase('e')){
                    item.error_indicator ='e';
                    break;
                }
            }
            checkedForErrors.add(item);
        }
        response.items = checkedForErrors;
        return response;
    }

    public String serialize() {
        return JSON.serialize(this);
    }

}