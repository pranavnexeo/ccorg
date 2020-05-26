global class ZTERR_Sch implements schedulable
{
    global void execute(SchedulableContext sc){
        
        Territory2Model m = [select id from Territory2Model where state = 'Active' limit 1];
        Territory2Type ZDOG = [select id from Territory2Type where MasterLabel = 'ZDOG' limit 1];
        Territory2Type ZTER = [select id from Territory2Type where MasterLabel = 'ZTER' limit 1];
        database.executebatch(new ZDOG_Batch(m, ZDOG, ZTER));
    }  
}