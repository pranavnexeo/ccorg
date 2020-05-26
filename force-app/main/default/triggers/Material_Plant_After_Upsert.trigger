trigger Material_Plant_After_Upsert on Material_Plant__c (after insert, after update) {

    System.debug('Record Count : '+Trigger.new.size());
    Material_Plant_Functions.upsert_Material_Plant2(Trigger.new);
    
}