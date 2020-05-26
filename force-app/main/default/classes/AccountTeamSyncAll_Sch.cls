global class AccountTeamSyncAll_Sch implements schedulable
{
    global void execute(SchedulableContext sc){
        database.executebatch(new AccountTeamBatch2(userinfo.getsessionid(), system.today()-1, '', false, true));
    }  
}