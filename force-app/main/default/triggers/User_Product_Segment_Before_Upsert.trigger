trigger User_Product_Segment_Before_Upsert on User_Product_Segment__c (before insert, before update) {

    System.debug('Record Count : '+Trigger.new.size());
    UserProductSegmentFunctions.processBeforeUpsert(Trigger.new);

}