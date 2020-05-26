@IsTest
public with sharing class cc_mn_json_TrackResponseTest {

    public static final String JSON_RESPONSE = '[{'+
        '"doc_number": "0007391058",'+
        '"itm_number": "000010",'+
        '"track_type": "P",'+
        '"url": "http://www2.rlcarriers.com/freight/shipping/shipment-tracing?pro=10280288-7&docType=PRO",'+
        '"status": [{'+
            '"type": "S",'+
            '"id": "000",'+
            '"number": "000",'+
            '"message": "",'+
            '"log_no": "",'+
            '"log_msg_no": "000000",'+
            '"message_v1": "Success",'+
            '"message_v2": "",'+
            '"message_v3": "",'+
            '"message_v4": "",'+
            '"parameter": "",'+
            '"row": "0 ",'+
            '"field": "",'+
            '"system": ""'+
        '}],'+
        '"pvt_fleet_data": {'+
            '"vehicle_location": {'+
                '"mandt": "",'+
                '"uniqkey": "",'+
                '"status": "0 ",'+
                '"vehicle_number": "",'+
                '"datime": "",'+
                '"speed": "0",'+
                '"latitude": "0.0000000000000000E+00",'+
                '"longitude": "0.0000000000000000E+00",'+
                '"location": "",'+
                '"logindriver1": ""'+
            '},'+
            '"stops_data": [{'+
                '"mandt": "020",'+
                '"vehicle_number": "",'+
                '"dispatch_number": "00777267991",'+
                '"shipment_number": "0007267991",'+
                '"dispatch_status": "0",'+
                '"driver": "",'+
                '"stop_number": "1 ",'+
                '"name": "NEXEO 0077 WILLOW SPRINGS",'+
                '"city": "WILLOW SPRINGS",'+
                '"state": "IL",'+
                '"latitude": "4.1740220000000001E+01",'+
                '"longitude": "-8.7886075000000005E+01",'+
                '"scheduled_arrival": "10/16/2016 4:01 AM",'+
                '"arrival_time": "",'+
                '"departure_time": "",'+
                '"location_status": "",'+
                '"ship_to": "P0077"'+
            '},'+
            '{'+
                '"mandt": "020",'+
                '"vehicle_number": "",'+
                '"dispatch_number": "00777267991",'+
                '"shipment_number": "0007267991",'+
                '"dispatch_status": "0",'+
                '"driver": "",'+
                '"stop_number": "2 ",'+
                '"name": "BASF CORPORATION",'+
                '"city": "MALCOM",'+
                '"state": "IA",'+
                '"latitude": "4.1705477999999999E+01",'+
                '"longitude": "-9.2556078999999997E+01",'+
                '"scheduled_arrival": "10/16/2016 4:02 AM",'+
                '"arrival_time": "",'+
                '"departure_time": "",'+
                '"location_status": "",'+
                '"ship_to": "0000507322"'+
            '}]'+
        '}'+
    '}]';

    public static final String JSON_RESPONSE_ERROR = '[{'+
        '"doc_number": "0007391058",'+
        '"itm_number": "000010",'+
        '"track_type": "P",'+
        '"url": "http://www2.rlcarriers.com/freight/shipping/shipment-tracing?pro=10280288-7&docType=PRO",'+
        '"status": [{'+
            '"type": "E",'+
            '"id": "000",'+
            '"number": "000",'+
            '"message": "",'+
            '"log_no": "",'+
            '"log_msg_no": "000000",'+
            '"message_v1": "Success",'+
            '"message_v2": "",'+
            '"message_v3": "",'+
            '"message_v4": "",'+
            '"parameter": "",'+
            '"row": "0 ",'+
            '"field": "",'+
            '"system": ""'+
        '}],'+
        '"pvt_fleet_data": {'+
            '"vehicle_location": {'+
                '"mandt": "",'+
                '"uniqkey": "",'+
                '"status": "0 ",'+
                '"vehicle_number": "",'+
                '"datime": "",'+
                '"speed": "0",'+
                '"latitude": "0.0000000000000000E+00",'+
                '"longitude": "0.0000000000000000E+00",'+
                '"location": "",'+
                '"logindriver1": ""'+
            '},'+
            '"stops_data": [{'+
                '"mandt": "020",'+
                '"vehicle_number": "",'+
                '"dispatch_number": "00777267991",'+
                '"shipment_number": "0007267991",'+
                '"dispatch_status": "0",'+
                '"driver": "",'+
                '"stop_number": "1 ",'+
                '"name": "NEXEO 0077 WILLOW SPRINGS",'+
                '"city": "WILLOW SPRINGS",'+
                '"state": "IL",'+
                '"latitude": "4.1740220000000001E+01",'+
                '"longitude": "-8.7886075000000005E+01",'+
                '"scheduled_arrival": "10/16/2016 4:01 AM",'+
                '"arrival_time": "",'+
                '"departure_time": "",'+
                '"location_status": "",'+
                '"ship_to": "P0077"'+
            '},'+
            '{'+
                '"mandt": "020",'+
                '"vehicle_number": "",'+
                '"dispatch_number": "00777267991",'+
                '"shipment_number": "0007267991",'+
                '"dispatch_status": "0",'+
                '"driver": "",'+
                '"stop_number": "2 ",'+
                '"name": "BASF CORPORATION",'+
                '"city": "MALCOM",'+
                '"state": "IA",'+
                '"latitude": "4.1705477999999999E+01",'+
                '"longitude": "-9.2556078999999997E+01",'+
                '"scheduled_arrival": "10/16/2016 4:02 AM",'+
                '"arrival_time": "",'+
                '"departure_time": "",'+
                '"location_status": "",'+
                '"ship_to": "0000507322"'+
            '}]'+
        '}'+
    '}]';


    static testMethod void testParse() {
        cc_mn_json_TrackResponse obj = cc_mn_json_TrackResponse.parse(JSON_RESPONSE);
        System.assert(obj != null);
        System.assertEquals('0007391058', obj.items[0].doc_number);
        System.assertEquals('000010', obj.items[0].itm_number);
        System.assertEquals('P', obj.items[0].track_type);
        System.assertEquals('http://www2.rlcarriers.com/freight/shipping/shipment-tracing?pro=10280288-7&docType=PRO', obj.items[0].url);
        System.assertEquals('', obj.items[0].status[0].message);
        System.assertEquals('Success', obj.items[0].status[0].message_v1);
        System.assertEquals('000000', obj.items[0].status[0].log_msg_no);
        System.assertEquals('0', obj.items[0].pvt_fleet_data.vehicle_location.speed);
        System.assertEquals(2, obj.items[0].pvt_fleet_data.stops_data.size());
        System.assert(
            obj.items[0].pvt_fleet_data.vehicle_location.mandt != null &&
            obj.items[0].pvt_fleet_data.vehicle_location.uniqkey != null &&
            obj.items[0].pvt_fleet_data.vehicle_location.status != null &&
            obj.items[0].pvt_fleet_data.vehicle_location.vehicle_number != null &&
            obj.items[0].pvt_fleet_data.vehicle_location.datime != null &&
            obj.items[0].pvt_fleet_data.vehicle_location.speed != null &&
            obj.items[0].pvt_fleet_data.vehicle_location.latitude != null &&
            obj.items[0].pvt_fleet_data.vehicle_location.longitude != null &&
            obj.items[0].pvt_fleet_data.vehicle_location.location != null &&
            obj.items[0].pvt_fleet_data.vehicle_location.logindriver1 != null
        );

        System.assert(
            obj.items[0].pvt_fleet_data.stops_data[0].mandt != null &&
            obj.items[0].pvt_fleet_data.stops_data[0].vehicle_number != null &&
            obj.items[0].pvt_fleet_data.stops_data[0].dispatch_number != null &&
            obj.items[0].pvt_fleet_data.stops_data[0].shipment_number != null &&
            obj.items[0].pvt_fleet_data.stops_data[0].dispatch_status != null &&
            obj.items[0].pvt_fleet_data.stops_data[0].driver != null &&
            obj.items[0].pvt_fleet_data.stops_data[0].stop_number != null &&
            obj.items[0].pvt_fleet_data.stops_data[0].name != null &&
            obj.items[0].pvt_fleet_data.stops_data[0].city != null &&
            obj.items[0].pvt_fleet_data.stops_data[0].state != null &&
            obj.items[0].pvt_fleet_data.stops_data[0].latitude != null &&
            obj.items[0].pvt_fleet_data.stops_data[0].longitude != null &&
            obj.items[0].pvt_fleet_data.stops_data[0].scheduled_arrival != null &&
            obj.items[0].pvt_fleet_data.stops_data[0].arrival_time != null &&
            obj.items[0].pvt_fleet_data.stops_data[0].departure_time != null &&
            obj.items[0].pvt_fleet_data.stops_data[0].location_status != null &&
            obj.items[0].pvt_fleet_data.stops_data[0].ship_to != null
        );
        
        System.assertNotEquals(null, obj.serialize());
    }
}