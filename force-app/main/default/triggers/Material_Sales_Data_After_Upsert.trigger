trigger Material_Sales_Data_After_Upsert on Material_Sales_Data__c (after insert, after update) {

    System.debug('Record Count : '+Trigger.new.size());
    Material_Sales_Data_Functions.upsert_Material_Sales_Data2(Trigger.new);
    
}