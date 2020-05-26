global class sch_owner_updates implements schedulable{
    global void execute(SchedulableContext sc){
        Opportunity_Owner_Update_batch r =new Opportunity_Owner_Update_batch();
        id idbatch = database.executebatch(r);
    }   
}