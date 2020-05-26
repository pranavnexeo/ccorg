trigger Log_SAP_Order_Block_Code_Changes on SAP_Order_Block_Code__c (after update) {
List<Integration_Table_Change__c> changes = new List<Integration_Table_Change__c>();
        for(Integration_Table_Change__c itc:[select Id, New_Description__c, Old_Description__c, Code_Value__c from Integration_table_Change__c
                                    where Config_Table__c = 'SAP_Order_Block_Code__c' and completed__c = false]){
        itc.Completed__c = true;
        changes.add(itc);
        }
        integer size = changes.size();
        
        for(SAP_Order_Block_Code__c sob : trigger.new){
        if(sob.Order_Block_Name__c != trigger.oldmap.get(sob.id).Order_Block_Name__c){
        Integration_Table_Change__c c1 = new Integration_Table_Change__c(
        Code_Field__c = 'SAP_Sales_Order_Block__c',
        Description_Field__c = 'SAP_Sales_Order_Block_Desc__c',
        Config_Code_Field__c = 'Order_Block_Code__c',
        Config_Desc_Field__c = 'Order_Block_Name__c',
        Config_Table__c = 'SAP_Order_Block_Code__c',
        New_Description__c = sob.Order_Block_Name__c,
        Old_Description__c = Trigger.oldmap.get(sob.id).Order_Block_Name__c,
        Code_value__c = sob.Order_Block_Code__c,
        Type__c = 'Account'
        );
        Integration_Table_Change__c c2 = new Integration_Table_Change__c(
        Code_Field__c = 'SAP_Central_Order_Block__c',
        Description_Field__c = 'SAP_Central_Order_Block_Desc__c',
        Config_Code_Field__c = 'Order_Block_Code__c',
        Config_Desc_Field__c = 'Order_Block_Name__c',
        Config_Table__c = 'SAP_Order_Block_Code__c',
        New_Description__c = sob.Order_Block_Name__c,
        Old_Description__c = Trigger.oldmap.get(sob.id).Order_Block_Name__c,
        Code_value__c = sob.Order_Block_Code__c,
        Type__c = 'Account'
        );
        changes.add(c1);
        changes.add(c2);
        }
        }
         if(changes.size() > 0 && changes.size() > size)
       upsert changes;   

}