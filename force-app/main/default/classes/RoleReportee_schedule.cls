global class RoleReportee_schedule implements Schedulable {
global void execute(SchedulableContext scMain) {
RoleReportee_Batch clsBatchSync = new RoleReportee_Batch();
ID idBatch = Database.executeBatch(clsBatchSync, 1);
}
}