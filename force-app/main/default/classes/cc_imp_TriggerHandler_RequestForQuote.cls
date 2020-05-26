public with sharing class cc_imp_TriggerHandler_RequestForQuote extends cc_imp_TriggerHandler {

    public override void afterInsert() {
        List <ccrz__E_RequestForQuote__c> theList = (List<ccrz__E_RequestForQuote__c>) Trigger.new;

        cc_imp_RequestForQuoteTriggerHandler.createNexCareForNewRFQ(theList);
    }

}