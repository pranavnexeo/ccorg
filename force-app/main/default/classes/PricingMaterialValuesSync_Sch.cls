global class PricingMaterialValuesSync_Sch implements schedulable
{
global void execute(SchedulableContext sc){
    PricingMaterialValuesSync_Batch b = new PricingMaterialValuesSync_Batch(); 
    database.executebatch(b);
}  
}