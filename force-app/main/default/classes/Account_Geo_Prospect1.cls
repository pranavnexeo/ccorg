Global Class Account_Geo_Prospect1{


Public Id id;
Public Double lat{get;set;}
Public Double lng{get;set;}
Public Account_Directory__c Directory{get;set;}
Public List <Account_Directory__c> NearbyAcct{get;set;}
Public String s{get;set;}
Public Account_Directory__c mainAcct{get;set;}
Public String main{get;set;}
Public String AccountName{get;set;}
private final Account acct1;
public String GoogleAPIKey{get; set;}


public Account_Geo_Prospect1(ApexPages.StandardController stdController){
this.acct1 = (Account)stdController.getRecord();

  Integer distance=50;
  id = ApexPages.currentPage().getParameters().get('id');
  string latlng = 'SELECT Id,Account_Location__Latitude__s, Account_Location__Longitude__s FROM Account_Directory__c WHERE Account_Id__c = ' + id;
  system.debug('latlng:'+latlng);
  Directory = [SELECT Id, Account_Number__c, Owner_Name__c, Name, Type__c, Division__c, Account_Location__Latitude__s, Account_Location__Longitude__s, Account_Id__c FROM Account_Directory__c WHERE Account_Id__c =: id]; //database.query(latlng);
  system.debug('Directory:'+Directory.Id);
  AccountName = Directory.Account_Number__c + ' - ' + Directory.Name;
  
  lat = Directory.Account_Location__Latitude__s;
  lng = Directory.Account_Location__Longitude__s;
  //lat = stringtodouble(ApexPages.currentPage().getParameters().get('lat'));
  //lng = stringtodouble(ApexPages.currentPage().getParameters().get('lng'));
  system.debug('lat:'+lat);
  system.debug('lng:'+lng);
  if(lat != null && lng != null){ 
  string q = 'SELECT Id, Owner_Name__c, Name, Type__c, Division__c, Account_Location__Latitude__s, Account_Location__Longitude__s, Account_Id__c FROM Account_Directory__c WHERE (Owner_Name__c != \'Nexeo_Integration User\' AND Owner_Name__c != \'\') AND (NOT Division__c LIKE \'%Composites%\') AND DISTANCE(Account_Location__c, GEOLOCATION(' + lat + ',' + lng + '), \'mi\') < ' + distance;
         q +=   ' ORDER BY DISTANCE(Account_Location__c, GEOLOCATION(' + lat + ',' + lng + '), \'mi\') limit 1500'; 

  //String q = 'SELECT Id, Type, Name, AccountNumber, Location__Latitude__s, Location__Longitude__s FROM Account WHERE DISTANCE(Location__c, GEOLOCATION(' + lat + ',' + lng + '), \'mi\') < 50 ORDER BY DISTANCE(Location__c, GEOLOCATION(' + lat + ',' + lng + '), \'mi\') limit 50';
  NearbyAcct = database.query(q);
  system.debug('NearbyAcct size:'+NearbyAcct.size());
  s = String.escapesinglequotes(JSON.serialize(NearbyAcct));
  
  main = String.escapesinglequotes(JSON.serialize(Directory));
  }
  
  nexprice_settings__c ns = nexprice_settings__c.getOrgDefaults();
  GoogleAPIKey = ns.GoogleAPIKey__c;
}



public static Double stringtodouble(String sIn){
  string temp = '';
  if(sIn != '' && sIn != null)
  {
    if(sIn.contains('-'))
    {  temp = sIn.replaceall('-', '');
       temp = '-' + temp;
    }
    else{ temp = sIn; }
    if(temp.contains(','))
      temp = temp.replaceall(',','');
    return double.valueof(temp);
  }
  else{ return null; }
}


}