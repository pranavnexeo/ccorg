/*
* @Name CopyAttachments 
* @Purpose Used for Update Checkbox in Supplier Profile .
* @Author  Chandrakant
* @Version 1.0 
*/
trigger UpdateSupplierProfileCheckbox on Supplier_Profile__c (before update) {
List<Supplier_Profile__c> ListofSupplierProfiles = new List<Supplier_Profile__c>();
 for (Integer i = 0; i < Trigger.new.size(); i++) {
     if (Trigger.old[i].Vendor_PI__c !=Trigger.new[i].Vendor_PI__c ||Trigger.old[i].Supplier_Street_Address__c !=Trigger.new[i].Supplier_Street_Address__c ||Trigger.old[i].Supplier_Number__c !=Trigger.new[i].Supplier_Number__c ||Trigger.old[i].Supplier_City__c !=Trigger.new[i].Supplier_City__c||Trigger.old[i].State__c !=Trigger.new[i].State__c){
     Trigger.new[i].Update_Checkbox__c =True;
     ListofSupplierProfiles.add(Trigger.new[i]);
     }
}

}