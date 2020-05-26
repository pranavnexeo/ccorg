trigger SAP_Seller_After_Upsert on SAP_Seller__c (after delete, after insert, after update) {
    
    List<SAP_Seller__c> ssa;
    Map<Id, SAP_Seller__c> amap = new Map<Id, SAP_Seller__c>();
    
    if (Trigger.isDelete) {ssa = Trigger.old;} else {ssa = Trigger.new;}
    
    if(Trigger.isUpdate){
      amap = trigger.oldmap;
    }
    SAP_Seller_Functions.processAfterUpsert(ssa, amap);
}