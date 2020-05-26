trigger User_Sales_Area_Before_Upsert on User_Sales_Area__c (before insert, before update) {

    System.debug('Record Count : '+Trigger.new.size());
    UserSalesAreaFunctions.processBeforeUpsert(Trigger.new);

}