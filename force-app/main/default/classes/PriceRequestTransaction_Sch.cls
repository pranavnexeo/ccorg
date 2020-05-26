global class PriceRequestTransaction_Sch implements schedulable
{
    global void execute(SchedulableContext sc){
        PriceRequestTransaction_Batch b = new PriceRequestTransaction_Batch(); 
        database.executebatch(b);
    }  
}