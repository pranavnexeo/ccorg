global class Account_Directory_Sch implements schedulable
{
    global void execute(SchedulableContext sc){
        Account_Directory_Batch r =new Account_Directory_Batch(0);
        id idbatch = database.executebatch(r);
    }  
}