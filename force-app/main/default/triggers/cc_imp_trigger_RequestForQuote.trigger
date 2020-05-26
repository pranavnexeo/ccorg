trigger cc_imp_trigger_RequestForQuote on ccrz__E_RequestForQuote__c (after insert) {
    new cc_imp_TriggerHandler_RequestForQuote().run();
}