global class AccountTeamShareBatchjob_Sch implements schedulable
{
    global void execute(SchedulableContext sc){
        database.executebatch(new AccountTeamBatch(system.today()-1, '', false, false));
    }  
}