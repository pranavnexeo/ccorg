trigger Log_SAP_Disribution_Channel_Change on SAP_Distribution_Channel__c (after update) {
  List<Integration_Table_Change__c> changes = new List<Integration_Table_Change__c>();
  for( Integration_Table_Change__c itc:[select id, new_description__c, old_description__c, code_value__c from Integration_table_Change__c
                                                where Config_Table__c = 'SAP_Distribution_Channel__c' and completed__c = false])
  { itc.completed__c = true; changes.add(itc); }
  integer size = changes.size();
  
  for(SAP_Distribution_Channel__c sg:trigger.new){
    if(sg.Distribution_Channel_Description__c != trigger.oldmap.get(sg.id).Distribution_Channel_Description__c)
    {
      Integration_Table_Change__c c = new Integration_Table_Change__c(
      Code_Field__c = 'SAP_DistChannel__c',
      Description_Field__c = 'SAP_Dist_Channel_Desc__c',
      Config_Code_Field__c = 'Distribution_Channel_Code__c',
      Config_Desc_Field__c = 'Distribution_Channel_description__c',
      Config_Table__c = 'SAP_Distribution_Channel__c',
      New_Description__c = sg.Distribution_Channel_Description__c,
      Old_Description__c = trigger.oldmap.get(sg.id).Distribution_Channel_Description__c,
      Code_value__c = sg.Distribution_Channel_Code__c,
      Type__c = 'Account'
     );
     Integration_Table_Change__c c2 = new Integration_Table_Change__c(
      Code_Field__c = 'SAP_DistChannel__c',
      Description_Field__c = 'Prospect_Dist_Channel__c',
      Config_Code_Field__c = 'Distribution_Channel_Code__c',
      Config_Desc_Field__c = 'Distribution_Channel_description__c',
      Config_Table__c = 'SAP_Distribution_Channel__c',
      New_Description__c = sg.Distribution_Channel_Description__c + ' (' + sg.Distribution_Channel_Code__c + ')',
      Old_Description__c = trigger.oldmap.get(sg.id).Distribution_Channel_Description__c + ' (' + trigger.oldmap.get(sg.id).Distribution_Channel_Code__c + ')',
      Code_value__c = sg.Distribution_Channel_Code__c,
      Type__c = 'Account'
     );
     changes.add(c);
     changes.add(c2);
   }

}
 if(changes.size() > 0 && changes.size() > size)
    upsert changes;

}