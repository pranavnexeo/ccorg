global class Account_SAP_Values_Sync_Sch implements schedulable
{
    global void execute(SchedulableContext sc){
        Account_SAP_Values_Sync_Batch r =new Account_SAP_Values_Sync_Batch('test');
        id idbatch = database.executebatch(r);
    }  
}