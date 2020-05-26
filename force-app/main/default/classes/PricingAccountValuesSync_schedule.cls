global class PricingAccountValuesSync_schedule implements Schedulable {
global void execute(SchedulableContext scMain) {
PricingAccountValuesSync_Batch clsBatchSync = new PricingAccountValuesSync_Batch();
ID idBatch = Database.executeBatch(clsBatchSync);
}
}