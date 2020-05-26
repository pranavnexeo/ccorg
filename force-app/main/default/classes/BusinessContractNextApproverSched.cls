global class BusinessContractNextApproverSched implements Schedulable {

    /* Run this code to schedule as hourly job
    System.schedule('Business Contract Next Approver', 
                    '0 0 * * * ?',
                    new BusinessContractNextApproverSched());
    */
    
    global void execute(SchedulableContext sc){
        Database.executeBatch(new BusinessContractNextApproverBatch());
    }

}