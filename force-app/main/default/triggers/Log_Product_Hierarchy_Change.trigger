trigger  Log_Product_Hierarchy_Change on Product_Hierarchy__c (after update) {
  //Decreased Map Key values by 2 when removing G2
  //@Rajeev
  Map<Integer, String> DescFieldMap = new Map<Integer, String>();
  DescFieldMap.put(1, 'PH1_Division__c');
  DescFieldMap.put(3, 'PH2_Line__c');
  DescFieldMap.put(6, 'PH3_Group__c');
  DescFieldMap.put(9, 'PH4_Supplier__c');
  DescFieldMap.put(12, 'PH5_Family__c');
  DescFieldMap.put(15, 'PH6_Segment__c');
  DescFieldMap.put(18,  'PH7_SubSegment__c');
 
  //Decreased Map Key values by 2 when removing G2
  //@Rajeev
  Map<Integer, String> CodeFieldMap = new Map<Integer, String>();
  CodeFieldMap.put(1, 'PH1_Division_Code__c');
  CodeFieldMap.put(3, 'PH2_Line_Code__c');
  CodeFieldMap.put(6, 'PH3_Group_Code__c');
  CodeFieldMap.put(9, 'PH4_Supplier_Code__c');
  CodeFieldMap.put(12, 'PH5_Family_Code__c');
  CodeFieldMap.put(15, 'PH6_Segment_Code__c');
  CodeFieldMap.put(18,  'PH7_SubSegment_Code__c');
  
  List<Integration_Table_Change__c> changes = new List<Integration_Table_Change__c>();
  for( Integration_Table_Change__c itc:[select id, new_description__c, old_description__c, code_value__c from Integration_table_Change__c
                                                where Config_Table__c = 'Product_Hierarchy__c' and completed__c = false])
  { itc.completed__c = true; changes.add(itc); }
  integer size = changes.size();
 
  for(Product_Hierarchy__c ph:trigger.new){
    if(ph.Product_Hierarchy_Description__c != trigger.oldmap.get(ph.id).Product_Hierarchy_Description__c && ph.Product_Hierarchy_Code__c != null)
    {
      Integration_Table_Change__c c = new Integration_Table_Change__c(
      Code_Field__c = CodeFieldMap.get(ph.Product_Hierarchy_Code__c.length()),
      Description_Field__c = DescFieldMap.get(ph.Product_Hierarchy_Code__c.length()),
      Config_Code_Field__c = 'Product_Hierarchy_Code__c',
      Config_Desc_Field__c = 'Product_Hierarchy_Description__c',
      Config_Table__c = 'Product_Hierarchy__c',
      New_Description__c = ph.Product_hierarchy_Description__c,
      Old_Description__c = trigger.oldmap.get(ph.id).Product_hierarchy_Description__c,
      Code_value__c = ph.Product_hierarchy_Code__c,
      Type__c = 'Material'
     );
     changes.add(c);
   }
  }
  if(changes.size() > 0 && changes.size() > size)
    upsert changes;
}