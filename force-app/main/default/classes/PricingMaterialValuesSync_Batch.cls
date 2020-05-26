global class PricingMaterialValuesSync_Batch implements Database.Batchable<SObject> {

List<PH6_PH7__c> hierarchies;
global String q;

// Class Constructor - set query string
global PricingMaterialValuesSync_Batch() {
q = 'SELECT id, name,  PH6_Segment__c, PH6_Segment_Code__c, PH7_SubSegment__c, PH7_SubSegment_Code__c FROM Material_Sales_Data2__c WHERE Dist_Channel_Code__c = \'30\'';

}
// "Start" runs when the class in instanciated
global Database.QueryLocator start(Database.BatchableContext bcMain) {
hierarchies = PH6_PH7__c.getall().values();
delete hierarchies;


return Database.getQueryLocator(q);
}

// "Execute" is what is being run as a separate process per batch
global void execute(Database.BatchableContext bcMain, List<Material_Sales_Data2__c> lstBatchRecords) {

hierarchies = PH6_PH7__c.getall().values();
set<String> hstrings = new set<String>();
List<PH6_PH7__c> toinsert = new list<PH6_PH7__c>();


for(PH6_PH7__c p:hierarchies)
  hstrings.add(p.name);
  
for(Material_Sales_Data2__c m:lstBatchRecords) 
  if(!hstrings.contains(m.PH6_Segment__c + ' - ' + m.PH7_SubSegment__c) &&
      m.ph6_segment__c != '' && m.ph7_subsegment__c != '' &&
      m.ph6_segment__c != null && m.ph7_subsegment__c != null && 
      m.PH6_Segment_Code__c != null && m.PH7_SubSegment_Code__c != null)
  {
    hstrings.add(m.PH6_Segment__c + ' - ' + m.PH7_SubSegment__c);
    PH6_PH7__c p = new PH6_PH7__c();
    p.name = m.PH6_Segment_Code__c + ':' + m.PH7_SubSegment_Code__c;
    p.PH6__c = m.PH6_Segment__c;
    p.PH7__c = m.PH7_SubSegment__c;
    toinsert.add(p);
  }
  
if(toinsert.size() > 0)
  upsert toinsert;  
    

}

// Finish the Batch Job
global void finish(Database.BatchableContext bcMain) {
// Optional - you can send an email to an admin with results
}
}