/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        	03/22/2019
*    Author:             	Francisco Garcia
*   Last Modified:       
*   Last Modified By:    
*	Functional Consultant: 	Jamie Harry  UTN: 3411
*
*   Short Description:  Data Cleanup on AccountTeamMembers object for all inactive users, should run weekly by scheduler.
*   **********************************************************************************************************************/


global class DataCleanupAccountTeamMembers implements 
    Database.Batchable<sObject>, Database.Stateful {
    
    global Database.QueryLocator start(Database.BatchableContext bc) { 
        return Database.getQueryLocator('SELECT ID,UserId FROM ACCOUNTTEAMMEMBER WHERE USER.iSaCTIVE=false');
    }
    global void execute(Database.BatchableContext bc, List<AccountTeamMember> scopeAccountTeamMembers){
        // process each batch of records   
        System.debug('DataCleanupAccountTeamMembers '+scopeAccountTeamMembers.size());            
        delete scopeAccountTeamMembers;
    }    
    global void finish(Database.BatchableContext bc){
        System.debug('DataCleanupAccountTeamMembers '+bc.getJobId());    
    }    
}