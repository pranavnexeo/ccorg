trigger Log_SAP_Industry_Code_Change on SAP_Industry_Code__c (after update) {
    List<Integration_Table_Change__c> changes = new List<Integration_Table_Change__c>();
        for(Integration_Table_Change__c itc:[select Id, New_Description__c, Old_Description__c, Code_Value__c from Integration_table_Change__c
                                    where Config_Table__c = 'SAP_Industry_Code__c' and completed__c = false]){
        itc.Completed__c = true;
        changes.add(itc);
        }
    integer size = changes.size();

    for(SAP_Industry_Code__c sic : trigger.new){
    if(sic.Industry_Name__c != Trigger.oldmap.get(sic.id).Industry_Name__c){
        Integration_Table_Change__c c1 = new Integration_Table_Change__c(
        Code_Field__c = 'SAP_Industry_Code1__c',
        Description_Field__c = 'SAP_Industry_Code1_Desc__c',
        Config_Code_Field__c = 'Industry_Code__c',
        Config_Desc_Field__c = 'Industry_Name__c',
        Config_Table__c = 'SAP_Industry_Code__c',
        New_Description__c = sic.Industry_Name__c,
        Old_Description__c = Trigger.oldmap.get(sic.id).Industry_Name__c,
        Code_value__c = sic.Industry_Code__c,
        Type__c = 'Account'
        );
        Integration_Table_Change__c c2 = new Integration_Table_Change__c(
        Code_Field__c = 'SAP_Industry_Code2__c',
        Description_Field__c = 'SAP_Industry_Code2_Desc__c',
        Config_Code_Field__c = 'Industry_Code__c',
        Config_Desc_Field__c = 'Industry_Name__c',
        Config_Table__c = 'SAP_Industry_Code__c',
        New_Description__c = sic.Industry_Name__c,
        Old_Description__c = Trigger.oldmap.get(sic.id).Industry_Name__c,
        Code_value__c = sic.Industry_Code__c,
        Type__c = 'Account'
        );
        Integration_Table_Change__c c3 = new Integration_Table_Change__c(
        Code_Field__c = 'SAP_Industry_Code3__c',
        Description_Field__c = 'SAP_Industry_Code3_Desc__c',
        Config_Code_Field__c = 'Industry_Code__c',
        Config_Desc_Field__c = 'Industry_Name__c',
        Config_Table__c = 'SAP_Industry_Code__c',
        New_Description__c = sic.Industry_Name__c,
        Old_Description__c = Trigger.oldmap.get(sic.id).Industry_Name__c,
        Code_value__c = sic.Industry_Code__c,
        Type__c = 'Account'
        );
        Integration_Table_Change__c c4 = new Integration_Table_Change__c(
        Code_Field__c = 'SAP_Industry_Code4__c',
        Description_Field__c = 'SAP_Industry_Code4_Desc__c',
        Config_Code_Field__c = 'Industry_Code__c',
        Config_Desc_Field__c = 'Industry_Name__c',
        Config_Table__c = 'SAP_Industry_Code__c',
        New_Description__c = sic.Industry_Name__c,
        Old_Description__c = Trigger.oldmap.get(sic.id).Industry_Name__c,
        Code_value__c = sic.Industry_Code__c,
        Type__c = 'Account'
        );
        Integration_Table_Change__c c5 = new Integration_Table_Change__c(
        Code_Field__c = 'SAP_Industry_Code5__c',
        Description_Field__c = 'SAP_Industry_Code5_Desc__c',
        Config_Code_Field__c = 'Industry_Code__c',
        Config_Desc_Field__c = 'Industry_Name__c',
        Config_Table__c = 'SAP_Industry_Code__c',
        New_Description__c = sic.Industry_Name__c,
        Old_Description__c = Trigger.oldmap.get(sic.id).Industry_Name__c,
        Code_value__c = sic.Industry_Code__c,
        Type__c = 'Account'
        );
        
    changes.add(c1);
    changes.add(c2);
    changes.add(c3);
    changes.add(c4);
    changes.add(c5);
    }
    } 
    if(changes.size() > 0 && changes.size() > size)
    upsert changes;   
}