trigger Case_After_Upsert on Case (after insert, after update) {

    Case_Functions.processafterUpsert(Trigger.new);
}