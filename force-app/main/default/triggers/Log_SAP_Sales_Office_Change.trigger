trigger Log_SAP_Sales_Office_Change on SAP_Sales_Office__c (after update) {
  List<Integration_Table_Change__c> changes = new List<Integration_Table_Change__c>();
  for( Integration_Table_Change__c itc:[select id, new_description__c, old_description__c, code_value__c from Integration_table_Change__c
                                                where Config_Table__c = 'SAP_Sales_Office__c' and completed__c = false])
  { itc.completed__c = true; changes.add(itc);   }
  integer size = changes.size();

  for(SAP_Sales_Office__c so:trigger.new){
    if(so.Sales_Office_Name__c != trigger.oldmap.get(so.id).Sales_Office_Name__c)
    {
      Integration_Table_Change__c c = new Integration_Table_Change__c(
      Code_Field__c = 'SAP_Sales_Office__c',
      Description_Field__c = 'SAP_Sales_Office_Desc__c',
      Config_Code_Field__c = 'Sales_Office_Code__c',
      Config_Desc_Field__c = 'Sales_Office_Name__c',
      Config_Table__c = 'SAP_Sales_Office__c',
      New_Description__c = so.Sales_Office_Name__c,
      Old_Description__c = trigger.oldmap.get(so.id).Sales_Office_Name__c,
      Code_value__c = so.Sales_Office_Code__c,
      Type__c = 'Account'
    );
    Integration_Table_Change__c c2 = new Integration_Table_Change__c(
      Code_Field__c = 'SAP_Sales_Office__c',
      Description_Field__c = 'Prospect_Sales_Office__c',
      Config_Code_Field__c = 'Sales_Office_Code__c',
      Config_Desc_Field__c = 'Sales_Office_Name__c',
      Config_Table__c = 'SAP_Sales_Office__c',
      New_Description__c = so.Sales_Office_Name__c + ' (' + so.sales_office_code__c + ')',
      Old_Description__c = trigger.oldmap.get(so.id).Sales_Office_Name__c + ' (' + trigger.oldmap.get(so.id).Sales_Office_code__c + ')',
      Code_value__c = so.Sales_Office_Code__c,
      Type__c = 'Account'
    );
      changes.add(c);
      changes.add(c2);
   }
  }
  if(changes.size() > 0 && changes.size() > size)
    upsert changes;
}