trigger Log_SAP_Sales_Group_Change on SAP_Sales_Group__c (after update) {
  List<Integration_Table_Change__c> changes = new List<Integration_Table_Change__c>();
  for( Integration_Table_Change__c itc:[select id, new_description__c, old_description__c, code_value__c from Integration_table_Change__c
                                                where Config_Table__c = 'SAP_Sales_Group__c' and completed__c = false])
  { itc.completed__c = true; changes.add(itc); }
  integer size = changes.size();
 
  for(SAP_Sales_Group__c sg:trigger.new){
    if(sg.Sales_Group_Name__c != trigger.oldmap.get(sg.id).Sales_Group_Name__c)
    {
      Integration_Table_Change__c c = new Integration_Table_Change__c(
      Code_Field__c = 'SAP_SalesGroup__c',
      Description_Field__c = 'SAP_Sales_Group_Desc__c',
      Config_Code_Field__c = 'Sales_Group_Code__c',
      Config_Desc_Field__c = 'Sales_Group_Name__c',
      Config_Table__c = 'SAP_Sales_Group__c',
      New_Description__c = sg.Sales_Group_Name__c,
      Old_Description__c = trigger.oldmap.get(sg.id).Sales_Group_Name__c,
      Code_value__c = sg.Sales_Group_Code__c,
      Type__c = 'Account'
     );
     Integration_Table_Change__c c2 = new Integration_Table_Change__c(
      Code_Field__c = 'SAP_SalesGroup__c',
      Description_Field__c = 'Prospect_Sales_Group__c',
      Config_Code_Field__c = 'Sales_Group_Code__c',
      Config_Desc_Field__c = 'Sales_Group_Name__c',
      Config_Table__c = 'SAP_Sales_Group__c',
      New_Description__c = sg.Sales_Group_Name__c + ' (' + sg.sales_group_code__c + ')',
      Old_Description__c = trigger.oldmap.get(sg.id).Sales_Group_Name__c + ' (' + trigger.oldmap.get(sg.id).Sales_Group_Code__c + ')',
      Code_value__c = sg.Sales_Group_Code__c,
      Type__c = 'Account'
     );
     Integration_Table_Change__c c3 = new Integration_Table_Change__c(
      Code_Field__c = 'HQ_Sales_Office__c',
      Description_Field__c = 'HQ_Sales_Office_Desc__c',
      Config_Code_Field__c = 'Sales_Group_Code__c',
      Config_Desc_Field__c = 'Sales_Group_Name__c',
      Config_Table__c = 'SAP_Sales_Group__c',
      New_Description__c = sg.Sales_Group_Name__c,
      Old_Description__c = trigger.oldmap.get(sg.id).Sales_Group_Name__c,
      Code_value__c = sg.Sales_Group_Code__c,
      Type__c = 'Account'
      );
     changes.add(c);
     changes.add(c2);
     changes.add(c3);
   }
  }
  if(changes.size() > 0 && changes.size() > size)
    upsert changes;
}