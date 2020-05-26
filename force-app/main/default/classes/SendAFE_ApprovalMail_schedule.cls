global class SendAFE_ApprovalMail_schedule implements Schedulable {
    global void execute(SchedulableContext scMain) {
        SendAFE_ApprovalMail_Batch clsBatchSync = new SendAFE_ApprovalMail_Batch();
        ID idBatch = Database.executeBatch(clsBatchSync);
    }
}