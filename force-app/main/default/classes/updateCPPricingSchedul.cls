global class updateCPPricingSchedul implements Schedulable {

    global void execute(SchedulableContext ctx) {
        updateCPPricingBatch Job = New updateCPPricingBatch();
        database.executeBatch(Job, 1);  
    }
    
}