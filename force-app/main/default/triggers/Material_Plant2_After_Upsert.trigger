trigger Material_Plant2_After_Upsert on Material_Plant2__c (after insert, after update) {

    System.debug('Record Count : '+Trigger.new.size());
    Material_Plant_Functions.createSharingRecords(Trigger.new);
    
}