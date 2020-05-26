trigger Customer_Group_Before_Upsert on Customer_Group__c (before insert, before update) {

    System.debug('Record Count : '+Trigger.new.size());
    CustomerGroupFunctions.processBeforeUpsert(Trigger.new);

}