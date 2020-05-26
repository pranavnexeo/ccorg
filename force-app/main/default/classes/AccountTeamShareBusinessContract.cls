global class AccountTeamShareBusinessContract implements Database.Batchable<SObject> {

    private string callback;
    
    global AccountTeamShareBusinessContract(string c){
      this.callback = c;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bcMain) {
             
             return Database.getQueryLocator('Select Id from Account where Type = \'Customer\' and Account_Team_Updated__c = true');
                          
    }
      
    
    global void execute(Database.BatchableContext bcMain, List<Account> accounts) {
         
         List<AccountTeamMember> team = [Select Id, AccountAccessLevel, AccountId, TeamMemberRole, UserId, IsDeleted from AccountTeamMember where AccountId in : accounts];
         
         //Calling method to create sharing records.
         Account_Team_Functions.createSharingRecordsBusinessContract(team,false);
    }

     
    global void finish(Database.BatchableContext bcMain) {
    AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:bcMain.getJobId()];
    
    string str = '';
        if(callback != '' && callback != null)
          str += callback + '\n';
        str += 'AccountTeamShareBusinessContract  (' + a.Id + ' ' + a.status + ')  processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.';
        database.executebatch(new AccountTeamShareSampleAnalysisReq(str));

        
    }
}