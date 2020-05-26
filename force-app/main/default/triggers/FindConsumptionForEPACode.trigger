trigger FindConsumptionForEPACode on EPA_Code__c (before insert) {

set<string>codes = new set<string>();
String s = '';
for(EPA_Code__c e:trigger.new){
  s = e.epa_id__c + e.reporting_year__c + e.page_number__c;
  codes.add(s);
}
List<Consumption__c> cons = [select id, RTKKey__c from Consumption__c where RTKKey__c in :codes];
Map<string, ID> cmap = new map<string, id>();

for(Consumption__c c:cons){
  cmap.put(c.RTKKey__c, c.id);
}

for(EPA_Code__c e:trigger.new){
  s = e.epa_id__c + e.reporting_year__c + e.page_number__c;
  if(cmap.containskey(s)){
    e.consumption__c = cmap.get(s);
  }
}

}