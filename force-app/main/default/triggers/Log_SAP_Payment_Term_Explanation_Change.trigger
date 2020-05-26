trigger Log_SAP_Payment_Term_Explanation_Change on SAP_Payment_Term_Explanation__c (after update) {
List<Integration_Table_Change__c> changes = new List<Integration_Table_Change__c>();
    for(Integration_Table_Change__c itc:[select Id, New_Description__c, Old_Description__c, Code_Value__c from Integration_table_Change__c
                                        where Config_Table__c = 'SAP_Payment_Term_Explanation__c' and completed__c = false]){
    itc.Completed__c = true;
    changes.add(itc);
    }
    integer size = changes.size();
    
    for(SAP_Payment_Term_Explanation__c spe : trigger.new){
    if(spe.Payment_Term_Explanation__c != Trigger.oldmap.get(spe.id).Payment_Term_Explanation__c){
        Integration_Table_Change__c c = new Integration_Table_Change__c(
        Code_Field__c = 'SAP_Payment_Terms__c',
        Description_Field__c = 'SAP_Payment_Terms_Desc__c',
        Config_Code_Field__c = 'Payment_Term_Code__c',
        Config_Desc_Field__c = 'Payment_Term_Explanation__c',
        Config_Table__c = 'SAP_Payment_Term_Explanation__c',
        New_Description__c = spe.Payment_Term_Explanation__c,
        Old_Description__c = Trigger.oldmap.get(spe.id).Payment_Term_Explanation__c,
        Code_value__c = spe.Payment_Term_Code__c,
        Type__c = 'Account'
        );    
    changes.add(c);
    }
    }
    if(changes.size() > 0 && changes.size() > size)
    upsert changes;   
}