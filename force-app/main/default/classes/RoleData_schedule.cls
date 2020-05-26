global class RoleData_schedule implements Schedulable {
global void execute(SchedulableContext scMain) {
RoleData_Batch clsBatchSync = new RoleData_Batch();
ID idBatch = Database.executeBatch(clsBatchSync);
}
}