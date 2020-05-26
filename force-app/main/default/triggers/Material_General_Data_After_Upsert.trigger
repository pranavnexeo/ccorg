trigger Material_General_Data_After_Upsert on Material_General_Data__c (after insert, after update) {

    System.debug('Record Count : '+Trigger.new.size());
    Material_General_Data_Functions.upsert_Material_General_Data2(Trigger.new);
    if (trigger.isUpdate) {
    	Material_General_Data_Functions.update_Material_Sales_Data2(trigger.oldMap, trigger.newMap);
    }
}