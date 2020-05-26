trigger Log_SAP_Customer_Classification_Change on SAP_Customer_Classification__c (after update) {
List<Integration_Table_Change__c> changes = new List<Integration_Table_Change__c>();
        for(Integration_Table_Change__c itc:[select Id, New_Description__c, Old_Description__c, Code_Value__c from Integration_table_Change__c
                                    where Config_Table__c = 'SAP_Customer_Classification__c' and completed__c = false]){
        itc.Completed__c = true;
        changes.add(itc);
        }
        integer size = changes.size();
        
        for(SAP_Customer_Classification__c scc : trigger.new){
        if(scc.Customer_Classification_Name__c != trigger.oldmap.get(scc.id).Customer_Classification_Name__c){
        Integration_Table_Change__c c = new Integration_Table_Change__c(
        Code_Field__c = 'SAP_Customer_Classification__c',
        Description_Field__c = 'SAP_Customer_Classification_Desc__c',
        Config_Code_Field__c = 'Customer_Classification_Code__c',
        Config_Desc_Field__c = 'Customer_Classification_Name__c',
        Config_Table__c = 'SAP_Customer_Classification__c',
        New_Description__c = scc.Customer_Classification_Name__c,
        Old_Description__c = Trigger.oldmap.get(scc.id).Customer_Classification_Name__c,
        Code_value__c = scc.Customer_Classification_Code__c,
        Type__c = 'Account'
        );
        changes.add(c);
        }
        }
        if(changes.size() > 0 && changes.size() > size)
        upsert changes;   

}