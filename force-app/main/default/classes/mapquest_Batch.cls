//Batch Class to get Latitude and longitude
//Author - Matt
global class mapquest_Batch //implements Database.Batchable<SObject>,Database.AllowsCallouts
{
/*global string q;
global mapquest_Batch(string addtoquery){
        q = 'select id, Mapquest_Address__c from Account where (((shippinglatitude = 0 and shippinglongitude = 0) or (shippinglatitude = null and shippinglongitude = null)) or Address_Updated__c = true) and (type = \'Customer\' or type = \'Prospect\') and Mapquest_Address__c != \'\'';
        if(test.isrunningtest() == true)
          q += addtoquery;        
}
//Start method
global Database.QueryLocator start(Database.BatchableContext bcMain){
         return Database.getQueryLocator(q);
} 
 
//Execute Method
global void execute(Database.BatchableContext bcMain, List<Account> alist){
      
      Map<Id, Mapquest_Functions.LatLng> amap = Mapquest_Functions.getLatLngs(alist);
      for(account a:alist)
        if(amap.containskey(a.id))
        {  a.shippinglatitude = amap.get(a.id).lat;
           a.shippinglongitude = amap.get(a.id).lng;
           a.billinglatitude = amap.get(a.id).lat;
           a.billinglongitude = amap.get(a.id).lng;
           a.address_updated__c = false;
           a.mapquest_quality__c = amap.get(a.id).quality;

        }
        if(alist.size() > 0) {
        ProcessorControl.RunTrigger = true;        
          update alist;    
       }               
   }
//Finish Method
global void finish(Database.BatchableContext bc){
        
    }*/
}