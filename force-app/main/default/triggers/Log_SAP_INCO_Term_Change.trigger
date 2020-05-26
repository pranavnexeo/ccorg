trigger Log_SAP_INCO_Term_Change on SAP_INCO_Term__c (after update) {
List<Integration_Table_Change__c> changes = new List<Integration_Table_Change__c>();
        for(Integration_Table_Change__c itc:[select id, new_description__c, old_description__c, code_value__c from Integration_table_Change__c
                      where Config_Table__c = 'SAP_INCO_Term__c' and completed__c = false])
                      { 
                      itc.completed__c = true; 
                      changes.add(itc);
                      }
                      integer size = changes.size();
                      
      for(SAP_INCO_Term__c sit : trigger.new){
      if(sit.INCO_Term_Name__c != trigger.oldmap.get(sit.id).INCO_Term_Name__c){
      Integration_Table_Change__c c = new Integration_Table_Change__c(
      Code_Field__c = 'SAP_INCO_Terms1__c',
      Description_Field__c = 'SAP_INCO_Terms1_Desc__c',
      Config_Code_Field__c = 'INCO_Term_Code__c',
      Config_Desc_Field__c = 'INCO_Term_Name__c',
      Config_Table__c = 'SAP_INCO_Term__c',
      New_Description__c = sit.INCO_Term_Name__c,
      Old_Description__c = trigger.oldmap.get(sit.id).INCO_Term_Name__c,
      Code_value__c = sit.INCO_Term_Code__c,
      Type__c = 'Account'
      );
      changes.add(c);
      }
      }
      if(changes.size() > 0 && changes.size() > size)
      upsert changes;
}