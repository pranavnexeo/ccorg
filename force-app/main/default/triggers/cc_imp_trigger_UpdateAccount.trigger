//We are currently only executing this trigger before inserting an account record into SFDC
// Additonal execution context like "after insert", "before delete" et.al 
//can be added to this trigger in the future. The corresponding code to executed for the additonal
//context will have to be added to the cc_imp_TriggerHandler_Account class. See 
//https://github.com/kevinohara80/sfdc-trigger-framework for more details

trigger cc_imp_trigger_UpdateAccount on Account (before insert) 
{
    new cc_imp_TriggerHandler_Account().run();
}