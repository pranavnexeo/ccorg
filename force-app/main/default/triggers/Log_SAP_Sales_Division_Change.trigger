trigger Log_SAP_Sales_Division_Change on SAP_Sales_Division__c (after update) {

  List<Integration_Table_Change__c> changes = new List<Integration_Table_Change__c>(); 
  for( Integration_Table_Change__c itc:[select id, new_description__c, old_description__c, code_value__c from Integration_table_Change__c
                                                where Config_Table__c = 'SAP_Sales_Division__c' and completed__c = false])
  { itc.completed__c = true; changes.add(itc); }
  integer size = changes.size();
 
  for(SAP_Sales_Division__c sg:trigger.new){
    if(sg.Sales_Division_Description__c != trigger.oldmap.get(sg.id).Sales_Division_Description__c)
    {
      Integration_Table_Change__c c = new Integration_Table_Change__c(
      Code_Field__c = 'SAP_DivisionCode__c',
      Description_Field__c = 'SAP_Division_Desc__c',
      Config_Code_Field__c = 'Sales_Division_Code__c',
      Config_Desc_Field__c = 'Sales_Division_Description__c',
      Config_Table__c = 'SAP_Sales_Division__c',
      New_Description__c = sg.Sales_Division_Description__c,
      Old_Description__c = trigger.oldmap.get(sg.id).Sales_Division_Description__c,
      Code_value__c = sg.Sales_Division_Code__c,
      Type__c = 'Account'
     );
     Integration_Table_Change__c c2 = new Integration_Table_Change__c(
      Code_Field__c = 'SAP_DivisionCode__c',
      Description_Field__c = 'Prospect_Division__c',
      Config_Code_Field__c = 'Sales_Division_Code__c',
      Config_Desc_Field__c = 'Sales_Division_Description__c',
      Config_Table__c = 'SAP_Sales_Division__c',
      New_Description__c = sg.Sales_Division_Description__c + ' (' + sg.Sales_Division_Code__c + ')',
      Old_Description__c = trigger.oldmap.get(sg.id).Sales_Division_Description__c + ' (' + trigger.oldmap.get(sg.id).Sales_Division_code__c + ')',
      Code_value__c = sg.Sales_Division_Code__c,
      Type__c = 'Account'
     );
     changes.add(c);
     changes.add(c2);
   }
  }
  if(changes.size() > 0 && changes.size() > size)
    upsert changes;

}