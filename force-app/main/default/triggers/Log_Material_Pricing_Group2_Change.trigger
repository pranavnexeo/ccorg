trigger Log_Material_Pricing_Group2_Change on Material_Pricing_Group2__c (after update) {

  List<Integration_Table_Change__c> changes = new List<Integration_Table_Change__c>();
  for( Integration_Table_Change__c itc:[select id, new_description__c, old_description__c, code_value__c from Integration_table_Change__c
                                                where Config_Table__c = 'Material_Pricing_Group2__c' and completed__c = false])
  { itc.completed__c = true; changes.add(itc); }
  integer size = changes.size();
 
  for(Material_Pricing_Group2__c mpg2:trigger.new){
    if(mpg2.Material_Pricing_Group2_Description__c != trigger.oldmap.get(mpg2.id).Material_Pricing_Group2_Description__c)
    {
      Integration_Table_Change__c c = new Integration_Table_Change__c(
      Code_Field__c = 'Material_Group2_Code__c',
      Description_Field__c = 'Material_Group2_Desc__c',
      Config_Code_Field__c = 'Material_Pricing_Group2_Code__c',
      Config_Desc_Field__c = 'Material_Pricing_Group2_Description__c',
      Config_Table__c = 'Material_Pricing_Group2__c',
      New_Description__c = mpg2.Material_Pricing_Group2_Description__c,
      Old_Description__c = trigger.oldmap.get(mpg2.id).Material_Pricing_Group2_Description__c,
      Code_value__c = mpg2.Material_Pricing_Group2_Code__c,
      Type__c = 'Material'
     );
     changes.add(c);
   }
  }
  if(changes.size() > 0 && changes.size() > size)
    upsert changes;
}