public class mapquest_Functions{
/*
@future
public static void SetLatLngs(set<Id> acctids, boolean BillingEqualsShipping){

  List<Account> accounts = [select id, mapquest_address__c from Account where id IN :acctids];
  Map<Id, LatLng> amap = getLatLngs(accounts);
  for(account a:accounts){
    if(amap.containskey(a.id))
    {
      a.shippinglatitude = amap.get(a.id).Lat;
      a.shippinglongitude = amap.get(a.id).Lng;
      if(billingequalsshipping){
        a.billinglatitude = amap.get(a.id).Lat;
        a.billinglongitude = amap.get(a.id).lng;
      }
    }
  }
  update accounts;
}
*/
/*
public static string getTestResponse(){
   string response = '{"info":{"statuscode":0,"copyright":{"text":"\u00A9 2014 MapQuest, Inc.","imageUrl":"http://api.mqcdn.com/res/mqlogo.gif",';
   response += '"imageAltText":"\u00A9 2014 MapQuest, Inc."},"messages":[]},"options":{"maxResults":-1,"thumbMaps":true,"ignoreLatLngInput":false},';
   response += '"results":[{"providedLocation":{"street":"242 DEMONT RD CHESTER BASIN Nova Scotia B0J 1K0 CA"},"locations":[{"street":"","adminArea6":"",';
   response += '"adminArea6Type":"Neighborhood","adminArea5":"","adminArea5Type":"City","adminArea4":"","adminArea4Type":"County","adminArea3":"NS",';
   response += '"adminArea3Type":"State","adminArea1":"CA","adminArea1Type":"Country","postalCode":"","geocodeQualityCode":"A3XAX","geocodeQuality":"STATE",';
   response += '"dragPoint":false,"sideOfStreet":"N","linkId":"282093645","unknownInput":"","type":"s","latLng":{"lat":45.0,"lng":-63.0},"displayLatLng":';
   response += '{"lat":45.0,"lng":-63.0},"mapUrl":"http://www.mapquestapi.com/staticmap/v4/getmap?key=Fmjtd&#124;luub2d6an1,bn=o5-9u7guf&type=map&size=225,160';
   response += '&pois=purple-1,45.0000002,-62.9999999,0,0,&#124;&center=45.0000002,-62.9999999&zoom=5&rand=1904704651"}]}]}';
   return response;
}
public static Map<Id, LatLng> getLatLngs(List<Account> accts){
  Map<Id, LatLng> amap = new Map<Id, LatLng>();
  Map<String, Id> addressmap = new map<String, Id>();
  List<Mapquest_Request.Location> locations = new List<Mapquest_Request.Location>();
  for(account a:accts){
    system.debug('My Account: ' + a);
    if(a.mapquest_address__c != null && a.mapquest_address__c != ''){
    locations.add(new Mapquest_Request.Location(a.Mapquest_Address__c.replaceall(' ', '%20')));
    addressmap.put(a.mapquest_address__c, a.id);
    }
  }
  system.debug('Address Map: ' + addressmap);
  Mapquest_request mqreq = new Mapquest_request(locations);
   
        String endpoint = 'http://www.mapquestapi.com/geocoding/v1/batch?';
        string key = 'Fmjtd%7Cluub2d6an1%2Cbn%3Do5-9u7guf';
        endpoint += 'key=' + key + '&json=' + JSON.serialize(mqreq);
        
        Http http = new Http();
        HttpRequest hreq = new HttpRequest();
        hreq.setHeader('Content-Type', 'application/xml');  
        hreq.settimeout(60000);
        //hreq.setBody(JSON.serialize(mqreq));    
        hreq.setEndpoint(endpoint);
        system.debug('endpoint: ' + endpoint);
        hreq.setMethod('GET');
        string resstring = getTestResponse();
        if(test.isrunningtest() == false){
          httpResponse res = http.send(hreq); 
          resstring = res.getbody();
        }
        system.debug('response: ' + resstring);

        Mapquest_response response = (Mapquest_Response)JSON.deserialize(resstring, Mapquest_Response.class);  
        system.debug(response);
        for(Mapquest_response.result mqr:response.results)
        {
           system.debug('Provided Location: ' + mqr.providedLocation.Street);
           if(addressmap.containskey(mqr.providedLocation.Street) && mqr.locations.size() > 0)
             amap.put(addressmap.get(mqr.providedLocation.Street), new LatLng(mqr.locations[0].geocodeQuality, mqr.locations[0].latLng.lat, mqr.locations[0].latLng.lng));
        }
        return amap;
}

public static Decimal calculateDistance(Decimal lat1, Decimal lon1, Decimal lat2, Decimal lon2){
      
      system.debug(lat1 + ', ' + lon1);
      system.debug(lat2 + ', ' + lon2);
      Double dDepartLat = lat1 * 3.14159 / 180;
      Double dDepartLong = lon1 * 3.14159 / 180;
      Double dArrivalLat = lat2 * 3.14159 / 180;
      Double dArrivalLong = lon2 * 3.14159 / 180;

      Double dDeltaLong = dArrivalLong - dDepartLong;
      Double dDeltaLat = dArrivalLat - dDepartLat;

// calculate angle using the haversine formula
      Double dHaversineResult = Math.Sin( dDeltaLat / 2 ) * Math.Sin( dDeltaLat / 2 ) 
                          + Math.Cos( dDepartLat ) * Math.Cos( dArrivalLat ) 
                            * Math.Sin( dDeltaLong / 2 ) * Math.Sin( dDeltaLong / 2 );

// calculate distance by multiplying arc-tangent by the planet radius in miles
      Double dDistance = 3958.76 * 2 * Math.Atan2( Math.Sqrt( dHaversineResult ), Math.Sqrt( 1 - dHaversineResult ) );

// return estimate
      system.debug('Distance: ' + dDistance);
      return dDistance;
    }

public class LatLng{
  public string quality{get; set;}
  public double lat{get; set;}
  public double lng{get; set;}
  public LatLng(string quality, double lat, double lng){
    this.quality = quality;
    this.lat = lat;
    this.lng = lng;
  }
}
*/
}