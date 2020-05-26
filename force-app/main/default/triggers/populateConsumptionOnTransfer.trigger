trigger populateConsumptionOnTransfer on RTK_Transfer__c (before insert) {

Set<String> conset = new set<string>();
string s = '';
for(RTK_Transfer__c t:trigger.new){
  s = t.Hidden_EPA_ID_Source_Facility__c + t.reporting_year__c + t.page_number__c;
  conset.add(s);
}

list<Consumption__c> Conlist = [select id, RTKKey__c from Consumption__c where RTKKey__c in :conset];
Map<String, id> cmap = new map<string, id>();

for(Consumption__c c:conlist){
  cmap.put(c.RTKKey__c, c.id);
}

for(RTK_Transfer__c t:trigger.new){
  s = t.Hidden_EPA_ID_Source_Facility__c + t.reporting_year__c + t.page_number__c;
  if(cmap.containskey(s)){
  t.consumption__c = cmap.get(s);}
}


}