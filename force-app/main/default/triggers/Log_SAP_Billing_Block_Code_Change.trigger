trigger Log_SAP_Billing_Block_Code_Change on SAP_Billing_Block_Code__c (after update) {
    List<Integration_Table_Change__c> changes = new List<Integration_Table_Change__c>();
    for(Integration_Table_Change__c itc:[select id, new_description__c, old_description__c, code_value__c from Integration_table_Change__c
                                     where Config_Table__c = 'SAP_Billing_Block_Code__c' and completed__c = false]){
                                     itc.completed__c = true;
                                     changes.add(itc); 
                                     }
      integer size = changes.size();
      
    for(SAP_Billing_Block_Code__c sbbc : trigger.new){
      if(sbbc.Billing_Block_Name__c != trigger.oldmap.get(sbbc.id).Billing_Block_Name__c){
      
      Integration_Table_Change__c c1 = new Integration_Table_Change__c(
      Code_Field__c = 'SAP_Central_Billing_Block__c',
      Description_Field__c = 'SAP_Central_Billing_Block_Desc__c',
      Config_Code_Field__c = 'Billing_Block_Code__c',
      Config_Desc_Field__c = 'Billing_Block_Name__c',
      Config_Table__c = 'SAP_Billing_Block_Code__c',
      New_Description__c = sbbc.Billing_Block_Name__c,
      Old_Description__c = trigger.oldmap.get(sbbc.id).Billing_Block_Name__c,
      Code_value__c = sbbc.Billing_Block_Code__c,
      Type__c = 'Account'
      );
      Integration_Table_Change__c c2 = new Integration_Table_Change__c(
      Code_Field__c = 'SAP_Sales_Billing_Block__c',
      Description_Field__c = 'SAP_Sales_Billing_Block_Desc__c',
      Config_Code_Field__c = 'Billing_Block_Code__c',
      Config_Desc_Field__c = 'Billing_Block_Name__c',
      Config_Table__c = 'SAP_Billing_Block_Code__c',
      New_Description__c = sbbc.Billing_Block_Name__c,
      Old_Description__c = trigger.oldmap.get(sbbc.id).Billing_Block_Name__c,
      Code_value__c = sbbc.Billing_Block_Code__c,
      Type__c = 'Account'
      );
    changes.add(c1);
    changes.add(c2);
    }
    }
    if(changes.size() > 0 && changes.size() > size)
    upsert changes;                                   
}