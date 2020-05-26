@isTest

private class Account_SAP_Values_Sync_Sch_Test {

    public static testMethod void testme() {
    
    SchedulableContext sc;
    
    Account_SAP_Values_Sync_Sch asv = new Account_SAP_Values_Sync_Sch();
    asv.execute(sc);
    
    }
    
}