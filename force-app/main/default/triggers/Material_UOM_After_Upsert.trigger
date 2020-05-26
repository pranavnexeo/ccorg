trigger Material_UOM_After_Upsert on Material_UOM__c (after insert, after update) {

    System.debug('Record Count : '+Trigger.new.size());
    Material_UOM_Functions.upsert_Material_UOM2(Trigger.new);
    
}