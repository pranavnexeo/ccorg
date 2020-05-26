trigger Log_SAP_Customer_Attribute2_Change on SAP_Customer_Attribute2__c (after update) {
List<Integration_Table_Change__c> changes = new List<Integration_Table_Change__c>();

for(Integration_Table_Change__c itc : [Select Id, new_description__c, old_description__c, code_value__c from Integration_table_Change__c
                                       where Config_table__c = 'SAP_Customer_Attribute2__c' and completed__c = false]){
                                       itc.completed__c = true; 
                                       changes.add(itc);
                                      }
System.debug('--------changes------' +changes);
integer size = changes.size();
System.debug('-----size----' +size);
for(SAP_Customer_Attribute2__c sca2 : trigger.new){
    if(sca2.Customer_Attribute2_Name__c != trigger.oldmap.get(sca2.id).Customer_Attribute2_Name__c)                                       
    {
      Integration_Table_Change__c c = new Integration_Table_Change__c(
      Code_Field__c = 'SAP_Attribute2__c',
      Description_Field__c = 'SAP_Attribute2_Desc__c',
      Config_Code_Field__c = 'Customer_Attribute2_Code__c',
      Config_Desc_Field__c = 'Customer_Attribute2_Name__c',
      Config_Table__c = 'SAP_Customer_Attribute2__c',
      New_Description__c = sca2.Customer_Attribute2_Name__c,
      Old_Description__c = trigger.oldmap.get(sca2.id).Customer_Attribute2_Name__c,
      Code_value__c = sca2.Customer_Attribute2_Code__c,
      Type__c = 'Account'
     );
     System.debug('---------c---------' +c);
     changes.add(c);
     System.debug('--------changes-----' +changes);
    }
}
if(changes.size() > 0 && changes.size() > size)
   upsert changes;
}