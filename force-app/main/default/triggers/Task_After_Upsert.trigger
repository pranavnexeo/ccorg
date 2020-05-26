trigger Task_After_Upsert on Task (after insert, after update) {
	
	Task_Functions.sendEmailsToDevelopmentGroup(trigger.oldMap, trigger.newMap);

}