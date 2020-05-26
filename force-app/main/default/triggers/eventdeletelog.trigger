trigger eventdeletelog on Event (before delete) {
   
   List<Audit_Log__C> logs = new LIst<Audit_Log__c>();
   
   for(event e:trigger.old){
     audit_log__c a = new Audit_Log__c(  
           object_id__c = e.id,
           object_name__C = 'Event',
           record_type__c = e.recordtypeid,
           audit_note1__c = 'Deleted'
      );
      logs.add(a);
   }
   if(logs.size() > 0)
     insert logs;
}