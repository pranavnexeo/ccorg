Global Class Account_Geo_Prospect{

public Account Account{Get; set;}
public boolean renderList{get; set;}
public List<Account_Directory__c> accountList{get; set;}
public Defaults defaults{Get; set;}
public String GoogleAPIKey{get; set;}

public Account_Geo_Prospect(){
  Account = new Account();
  renderList = true;
  defaults = new Defaults(userinfo.getuserroleid());
  Account.RecordTypeId = RecordType_Functions.getDefaultRecordTypeId(Account.getSobjectType());
  Account.Prospect_Sales_Org__c = defaults.prospect_Org;
  Account.Prospect_Dist_Channel__c = defaults.prospect_dist_channel;
  Account.Prospect_Division__c = defaults.prospect_div;
  Account.Prospect_Sales_District__c = defaults.prospect_District;
  Account.Prospect_Sales_Office__c = defaults.prospect_office;
  Account.Prospect_Sales_Group__c = defaults.prospect_group;
  Account.Nexprice_Market__c = defaults.End_Market;
  Account.Nexprice_Size__c = defaults.size;
  Account.Nexprice_Region__c = defaults.sales_region;
  Account.Salesforce1_Created__c = true;
  Account.Created_By_User_Agent__c = ApexPages.currentPage().getHeaders().get('USER-AGENT');
  system.debug(Account);
  
  nexprice_settings__c ns = nexprice_settings__c.getOrgDefaults();
  GoogleAPIKey = ns.GoogleAPIKey__c;
     
 // User User = [select id, name, nexPrice_Disregard_Hierarchy__c, userroleid from User where id = :userinfo.getuserid() limit 1];
 // List<Role_Data__c> roledata = new List<Role_Data__c>();

 // if(User.nexPrice_Disregard_Hierarchy__c == false)
 // roledata = [select id, data__c, type__c, API_Field_Name__c, role_id__c from Role_Data__c where role_id__c = :user.userroleid and type__c = 'Account'];
 // else
 // roledata = [select id, data__c, type__c, API_Field_Name__c, role_id__c from Role_Data__c where role_name__c = 'AD Sales' and type__c = 'Account'];
  
 // Set<String> fields = new Set<String>{'SAP_Sales_Org__c', 'SAP_DivisionCode__c', 'SAP_SalesDistrict__c', 'SAP_Sales_Office__c', 'SAP_SalesGroup__c' };
 // Map<String, List<String>> options = new Map<String, List<String>>();

 // for(string f:fields)
 //   options.put(f, new List<String>());
 // system.debug(roledata);
  
 // for(Role_Data__c rd:roledata)
 //   if(rd.data__c != null && rd.data__c != '' && fields.contains(rd.api_field_name__c))
 //     options.get(rd.api_field_name__c).addall(rd.data__c.split('; '));
    
 // for(string s:options.keyset()){
 //   if(options.get(s).size() == 1)
 //     Account.put(s, options.get(s).get(0));
 // }
  
 // system.debug('Account: ' + Account);
  
  

}

public void showForm(){
  renderList = false;
}

public void showList(){
  renderList = true;
}

public void resetForm(){
  Account = new Account();
}

public void cancel(){
  Account = new Account();
  renderList = true;
}

@RemoteAction
global static List<result> getResults(List<google_places_result> gpresults, string lat, string lon, string distance){
Map<double, result> results = new map<double, result>();
string q = 'SELECT Id, Name, Full_Address__c, Owner_Name__c, Owner_Email__c, type__c, Division__c, Account_Location__Latitude__s, Account_Location__Longitude__s, Account_Id__c FROM Account_Directory__c WHERE DISTANCE(Account_Location__c, GEOLOCATION(' + lat + ',' + lon + '), \'mi\') < ' + distance;
         q +=   ' ORDER BY DISTANCE(Account_Location__c, GEOLOCATION(' + lat + ',' + lon + '), \'mi\') limit 50'; 
for(Account_Directory__c ad:database.query(q)){
   double dist = calculateDistance(decimal.valueof(lat), decimal.valueof(lon), ad.Account_Location__Latitude__s, ad.Account_Location__Longitude__s);
   results.put(dist, new result(ad, dist));
}
for(google_places_result gpr:gpresults){
   system.debug('gpr: ' + gpr);
   double lat2 = gpr.geometry.location.A;
   double lon2 = gpr.geometry.location.B;
   
   if(lat2 == null)
     lat2 = gpr.geometry.location.K;
   
   if(lon2 == null)
     lon2 = gpr.geometry.location.D;
   
   if(lon2 == null)
     lon2 = gpr.geometry.location.G;
try{
   double dist = calculateDistance(decimal.valueof(lat), decimal.valueof(lon), lat2, lon2);
   results.put(dist, new result(gpr, dist));
   system.debug('I am inside try block');
   }Catch(Exception e){system.debug('error is :'+ e.getmessage());}   
}
List<Double> keys = new List<Double>();
keys.addall(results.keyset());
List<result> resultlist = new list<result>();
keys.sort();
for(Double k:keys)
  resultlist.add(results.get(k));

return resultlist;
}

@RemoteAction
global static Account createAccount(String Name, String Street, String City, String State, String Zip, String Country, String Org, String Dist, String Div, String District, String Office, String G){
  Account a = new Account(
    name = name,
    SAP_Street__c = street,
    SAP_City__c = city,
    SAP_State__c = state,
    SAP_Zip_Code__c = zip,
    SAP_Country__C = country,
    Prospect_Sales_Org__c = org,
    Prospect_Dist_Channel__c = dist,
    prospect_Division__c = div,
    prospect_Sales_District__c = district,
    prospect_Sales_Office__c = office,
    prospect_Sales_Group__c = g
  );
  insert a;
  return a;
}
public pagereference save(){
  insert Account;
  system.debug(account.id);
  return new pagereference('/' + Account.Id);
}

global class result{
  
  public Account_Directory__c ad{get; set;}
  public geometry geometry{get; set;}
  public google_places_result gpr{Get; set;}
  public double distance{Get; set;}
  public string type{get; set;}
  public string name{Get; set;}
  public string reference{Get; set;}
  public string vicinity{Get; set;}

  
  public result(Account_Directory__c ad, double distance){
    this.ad = ad;
    this.distance = distance;
    this.gpr = null;
    this.type = 'ad'; 
    this.geometry = new Geometry(new location(ad.Account_Location__latitude__s, ad.Account_Location__longitude__s));
    this.name = ad.name;
    this.vicinity = ad.Full_Address__c;
    this.reference = '';
  }
  public result(google_places_result gpr, double distance){
    this.ad = null;
    this.distance = distance;
    this.gpr = gpr;
    this.type = 'gpr';
    double lat2 = gpr.geometry.location.A;
   double lon2 = gpr.geometry.location.B;
   
   if(lat2 == null)
     lat2 = gpr.geometry.location.K;
   
   if(lon2 == null)
     lon2 = gpr.geometry.location.D;
     
    this.geometry = new Geometry(new location(lat2, lon2));
    this.name = gpr.name;
    this.vicinity = gpr.vicinity;
    this.reference = gpr.reference;
  }
}

global class geometry{
  public location location{Get; set;}
  public geometry(location location){
    this.location = location;
  }
}
global class location{
  public double lat{get; set;}
  public double lng{get; set;}
  public location(decimal lat, decimal lng){
    this.lat = lat;
    this.lng = lng;
  }

}

global class defaults{

  public SAP_Sales_Org__c Sales_Org{get; set;}
  public String Prospect_Org{Get; set;}
  public SAP_Distribution_Channel__c Dist_Channel{get; set;}
  public String Prospect_Dist_Channel{get; set;}
  public SAP_Sales_Division__c Division{Get; set;}
  public String Prospect_Div{get; set;}
  public SAP_Sales_District__c district{get; set;}
  public String Prospect_District{get; set;}
  public SAP_Sales_Office__c office{Get; set;}
  public String Prospect_Office{get; set;}
  public SAP_Sales_Group__c salesgroup{get; set;}
  public String Prospect_Group{get; set;}
  public String End_Market{Get; set;}
  public String Size{Get; set;}
  public String Sales_Region{get; set;}
  
  public defaults(string userRoleId){
    User_Defaults__c defaults = User_Defaults__c.getInstance(UserRoleId);
    system.debug(defaults);
    if(defaults != null){
      if(defaults.SAP_Sales_Org__c != null && defaults.SAP_Sales_Org__C != '')
      {  Sales_Org = [select Sales_Org_Code__c, Sales_Org_Description__c from SAP_Sales_Org__C where Sales_Org_Code__C = :defaults.SAP_Sales_Org__c limit 1];
         Prospect_Org = Sales_org.Sales_Org_Description__c + ' (' + Sales_org.Sales_Org_Code__c + ')';
      }else
      {
        Sales_Org = new SAP_Sales_Org__c();
        Prospect_Org = '';
      }
     
      if(defaults.SAP_Dist_Channel__c != null && defaults.SAP_Dist_Channel__c != '')
      {  Dist_Channel = [select Distribution_Channel_Code__c, Distribution_Channel_Description__c from SAP_Distribution_Channel__c where Distribution_Channel_Code__c = :defaults.SAP_Dist_Channel__c limit 1];
         Prospect_Dist_Channel = Dist_Channel.Distribution_Channel_Description__c + ' (' + dist_channel.Distribution_Channel_Code__c + ')';
      }else
      {  Dist_Channel = new SAP_Distribution_Channel__c();
         Prospect_Dist_Channel = '';
      }
      if(defaults.SAP_Division__c != null && defaults.SAP_Division__c != '')
      {  Division = [select Sales_Division_Code__c, Sales_Division_Description__c from SAP_Sales_Division__c where Sales_Division_Code__c = :defaults.SAP_Division__c limit 1];
         Prospect_div = division.Sales_Division_Description__c + ' (' + division.Sales_Division_Code__c + ')';
      }else
      { Division = new SAP_Sales_Division__c();
        prospect_div = '';
      }
        
      if(defaults.SAP_Sales_District__c != null && defaults.SAP_Sales_District__c != '')
      {  district = [select Sales_District_Code__c, Sales_District_Name__c from SAP_Sales_District__c where Sales_District_Code__c = :defaults.SAP_Sales_District__c limit 1];
         prospect_district = district.Sales_District_Name__c + ' (' + district.Sales_District_Code__C + ')';
      }else
      {  District = new SAP_Sales_District__c();
         prospect_district = '';
      }
      
      if(defaults.SAP_Sales_Office__c != null && defaults.SAP_Sales_Office__c != '')
      { Office = [select Sales_Office_Code__c, Sales_Office_Name__c from SAP_Sales_Office__c where Sales_Office_Code__c = :defaults.SAP_Sales_Office__c limit 1];
        prospect_office = office.Sales_Office_Name__C + ' (' + office.Sales_Office_Code__c + ')';
      }
      else
      { Office = new SAP_Sales_Office__c();
        prospect_office = '';
      }
        
      if(defaults.SAP_Sales_Group__c != null && defaults.SAP_Sales_Group__c != '')
      {  SalesGroup = [select Sales_Group_Code__c, Sales_Group_Name__c from SAP_Sales_Group__c where Sales_Group_Code__c = :defaults.SAP_Sales_Group__c limit 1];
         prospect_group = salesgroup.Sales_Group_Name__c + ' (' + salesgroup.Sales_Group_Code__c + ')';
      }
      else
      {  SalesGroup = new SAP_Sales_Group__c();
         prospect_group = '';
      }
      
      size = 'SMALL';
      End_Market = defaults.Nexprice_End_Market__c;
      Sales_Region = defaults.Nexprice_Region__c;
 
    }
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