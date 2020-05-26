/*
* @Name UpdateMaterialSalesData2Checkbox 
* @Purpose Used for Update Checkbox in Material Sales Data2 .
* @Author  Chandrakant
* @Version 1.0 
*/
trigger UpdateMaterialSalesData2Checkbox on Material_Sales_Data2__c (before update) {
List<Material_Sales_Data2__c> ListofMaterial = new List<Material_Sales_Data2__c>();
 for (Integer i = 0; i < Trigger.new.size(); i++) {
     if (Trigger.old[i].Material_Number__c !=Trigger.new[i].Material_Number__c ||Trigger.old[i].Material_Base_Code__c !=Trigger.new[i].Material_Base_Code__c ||Trigger.old[i].Material_General_Data__r.Material_Container_Desc__c !=Trigger.new[i].Material_General_Data__r.Material_Container_Desc__c ||Trigger.old[i].Material_General_Data__r.Material_Description__c !=Trigger.new[i].Material_General_Data__r.Material_Description__c||Trigger.old[i].Material_Group2_Code__c !=Trigger.new[i].Material_Group2_Code__c){
     Trigger.new[i].Update_Material__c =True;
     ListofMaterial .add(Trigger.new[i]);
     }
}

}