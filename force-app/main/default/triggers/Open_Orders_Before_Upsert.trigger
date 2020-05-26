trigger Open_Orders_Before_Upsert on Open_Orders__c (before insert, before update) {

    Open_Orders_Functions.processBeforeUpsert(Trigger.new);
    
}