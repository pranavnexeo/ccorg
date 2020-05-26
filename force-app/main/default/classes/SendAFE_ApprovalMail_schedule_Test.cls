@isTest

private class SendAFE_ApprovalMail_schedule_Test {

    public static testMethod void testme() {
    
    SchedulableContext scMain;
    
    SendAFE_ApprovalMail_schedule safe = new SendAFE_ApprovalMail_schedule();
    safe.execute(scMain);
    
    }
    
}