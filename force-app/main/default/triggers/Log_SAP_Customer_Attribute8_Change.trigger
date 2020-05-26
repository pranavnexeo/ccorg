trigger Log_SAP_Customer_Attribute8_Change on SAP_Customer_Attribute8__c (after update) {
List<Integration_Table_Change__c> changes = new List<Integration_Table_Change__c>();
for(Integration_Table_Change__c itc : [Select Id, new_description__c, old_description__c, code_value__c from Integration_table_Change__c
                                       where Config_Table__c = 'SAP_Customer_Attribute8__c' and completed__c = false]){
                                       itc.Completed__c = true;
                                       changes.add(itc);
                                       }
Integer size = changes.size();
for(SAP_Customer_Attribute8__c sca8:trigger.new){
    if(sca8.Customer_Attribute8_Name__c != trigger.oldmap.get(sca8.id).Customer_Attribute8_Name__c)
    {
Integration_Table_Change__c c = new Integration_Table_Change__c(
      Code_Field__c = 'SAP_Attribute8__c',
      Description_Field__c = 'SAP_Attribute8_Desc__c',
      Config_Code_Field__c = 'Customer_Attribute8_Code__c',
      Config_Desc_Field__c = 'Customer_Attribute8_Name__c',
      Config_Table__c = 'SAP_Customer_Attribute8__c',
      New_Description__c = sca8.Customer_Attribute8_Name__c,
      Old_Description__c = trigger.oldmap.get(sca8.id).Customer_Attribute8_Name__c,
      Code_value__c = sca8.Customer_Attribute8_Code__c,
      Type__c = 'Account'
     );
changes.add(c);    
}
}
if(changes.size() > 0 && changes.size() > size)
    upsert changes;
}