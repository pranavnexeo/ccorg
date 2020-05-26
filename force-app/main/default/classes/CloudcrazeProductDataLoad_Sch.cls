global class CloudcrazeProductDataLoad_Sch implements schedulable
{
    global void execute(SchedulableContext sc){
        CloudcrazeProductDataLoad_batch r = new CloudcrazeProductDataLoad_batch(1,true,'31');
        id idbatch = database.executebatch(r);
    }  
}