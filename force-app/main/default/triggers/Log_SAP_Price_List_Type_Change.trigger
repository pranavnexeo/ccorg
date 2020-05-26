trigger Log_SAP_Price_List_Type_Change on SAP_Price_List_Type__c (after update) {
List<Integration_Table_Change__c> changes = new List<Integration_Table_Change__c>();
    for(Integration_Table_Change__c itc:[select Id, New_Description__c, Old_Description__c, Code_Value__c from Integration_table_Change__c
                                    where Config_Table__c = 'SAP_Price_List_Type__c' and completed__c = false]){
        itc.Completed__c = true;
        changes.add(itc);
        }
    integer size = changes.size();
    
    for(SAP_Price_List_Type__c splt : trigger.new){
    if(splt.Price_List_Type_Name__c != Trigger.oldmap.get(splt.id).Price_List_Type_Name__c){
        Integration_Table_Change__c c = new Integration_Table_Change__c(
        Code_Field__c = 'SAP_Price_List_Type__c',
        Description_Field__c = 'SAP_Price_List_Type_Desc__c',
        Config_Code_Field__c = 'Price_List_Type_Code__c',
        Config_Desc_Field__c = 'Price_List_Type_Name__c',
        Config_Table__c = 'SAP_Price_List_Type__c',
        New_Description__c = splt.Price_List_Type_Name__c,
        Old_Description__c = Trigger.oldmap.get(splt.id).Price_List_Type_Name__c,
        Code_value__c = splt.Price_List_Type_Code__c,
        Type__c = 'Account'
        );
        
    changes.add(c);    
    }
    }
   if(changes.size() > 0 && changes.size() > size)
   upsert changes;     
    
}