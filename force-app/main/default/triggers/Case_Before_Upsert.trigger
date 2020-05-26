trigger Case_Before_Upsert on Case (before insert, before update) {

    Case_Functions.processBeforeUpsert(Trigger.new);
}