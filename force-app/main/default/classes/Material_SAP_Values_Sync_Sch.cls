global class Material_SAP_Values_Sync_Sch implements schedulable
{
    global void execute(SchedulableContext sc){
        Material_SAP_Values_Sync_Batch r =new Material_SAP_Values_Sync_Batch('test');
        id idbatch = database.executebatch(r);
    }  
}