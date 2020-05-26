//We are currently only executing this trigger after inserting a contact record into SFDC
// Additonal execution context like "before insert", "before delete" et.al 
//can be added to this trigger in the future. The corresponding code to executed for the additonal
//context will have to be added to the cc_imp_TriggerHandler_Contact class. See 
//https://github.com/kevinohara80/sfdc-trigger-framework for more details

trigger cc_imp_trigger_UpdateContact on Contact (before insert, after insert, after update)
{
    if (Trigger.isInsert && (Trigger.isBefore || Trigger.isAfter)){
        new cc_imp_TriggerHandler_Contact().run();
    }
    
    cc_mn_ContactHandler handler = new cc_mn_ContactHandler();
    
    if (Trigger.isAfter && Trigger.isInsert ) {
        handler.OnAfterInsert(Trigger.new);
    } else if (Trigger.isAfter && Trigger.isUpdate) {
        handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.newMap);
    }
}