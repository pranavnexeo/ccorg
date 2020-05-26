@isTest
private class BusinessContractNextApproverSched_Test {
    public static testMethod void testBusinessContractNext() {
    SchedulableContext sc;
        BusinessContractNextApproverSched bcn = new BusinessContractNextApproverSched();
        bcn.execute(sc);
    }
}