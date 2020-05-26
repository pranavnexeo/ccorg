trigger Reorder_Before_Upsert on Reorder__c (before insert, before update) {

    Open_Orders_Functions.processReordersBeforeUpsert(Trigger.new);

}