trigger SAP_Territory_After_Upsert on SAP_Territory__c (after update, after insert) {
   
   set<id> ids = new set<Id>();
   for(SAP_Territory__c t:trigger.new){
     if(t.update_Accounts__c == true)
     ids.add(t.id);
   }
   
   if( test.isrunningtest() == false && ids.size() > 0 ){
     Account_Team_Triggers.SAP_Territories(ids);
   }
}