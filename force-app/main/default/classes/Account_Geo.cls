global class Account_Geo{

@RemoteAction
global static List<AccountDistance> getAccountsNearMe(string lat, string lon, integer distance){
  
  List<AccountDistance> toreturn = new List<AccountDistance>();
  
  string q = 'SELECT Id, Name, Full_Address__c, ShippingLatitude, ShippingLongitude FROM Account WHERE DISTANCE(BillingAddress, GEOLOCATION(' + lat + ',' + lon + '), \'mi\') < ' + distance;
         q +=   ' ORDER BY DISTANCE(BillingAddress, GEOLOCATION(' + lat + ',' + lon + '), \'mi\') limit 50';
         system.debug(q);
  
  for(Account a:database.query(q))
    toreturn.add(new AccountDistance(a, calculateDistance(a.shippinglatitude, a.shippinglongitude, Decimal.valueof(lat), Decimal.valueof(lon))));
      
  return toreturn;
}

global class AccountDistance{
  public Account Account{get; set;}
  public decimal Distance{Get; set;}
  public AccountDistance(Account a, decimal d){
    this.Account = a;
    this.Distance = d;
  }

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
}