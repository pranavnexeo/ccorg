public class AccountCalendar{

public Calendar Calendar{get; set;}
public List<CalEventItem> items{get; set;}

public AccountCalendar(ApexPages.standardcontroller sc){
items = new list<CalEventItem>();
Account a = (Account)sc.getrecord();
String uid = userinfo.getuserid();
Date startdate = system.today() - 90;
date enddate = system.today() + 90;

for(Opportunity o:[ select id, name, Account.Name, closedate from Opportunity where accountid = :a.id and closedate >= :startdate and closedate <= :enddate]){
  items.add(new CalEventItem(o, 'closedate', 'Name', 'Opportunity'));
}

for(Open_Orders__c oo:[ select id, name, Sales_Order_number__c, Expected_Ship_Date2__c  from Open_Orders__c where shipto__c = :a.id and Expected_Ship_Date2__c >= :startdate and Expected_Ship_Date2__c <= :enddate ]){
  items.add(new CalEventItem(oo, 'Expected_Ship_Date2__c', 'Sales_Order_Number__c', 'Sales Order'));
}

for(Sample_Material__c s:[ select id, name, Actual_Ship_Date__c, SAP_Material_MSD2__r.name  from sample_Material__c where Sample_Request__r.Account__c = :a.id and Actual_Ship_Date__c >= :startdate and Actual_Ship_Date__c <= :enddate]){
  items.add(new CalEventItem(s, 'Actual_Ship_Date__c', 'name', 'Sample Request'));
}


}
}