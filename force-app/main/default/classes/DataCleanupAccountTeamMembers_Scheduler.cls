/***********************************************************************************************************************   
Univar Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        	03/22/2019
*    Author:             	Francisco Garcia
*   Last Modified:       
*   Last Modified By:    
*	Functional Consultant: 	Jamie Harry  UTN: 3411
*
*   Short Description:  Scheduler Class to run Batch class DataCleanupAccountTeamMembers
*   **********************************************************************************************************************/


global class DataCleanupAccountTeamMembers_Scheduler implements Schedulable{
    
    
    global void execute(SchedulableContext ctx) {
        DataCleanupAccountTeamMembers atmClass=new DataCleanupAccountTeamMembers();   
    }
public void scheduleit()
    {
        DataCleanupAccountTeamMembers_Scheduler sch_class = new DataCleanupAccountTeamMembers_Scheduler();
        String cron_exp = '0 0 12 ? * SAT *';       
       	System.schedule('Data Cleanup Account Team Members inactive users', cron_exp, sch_class);
        
    }

}