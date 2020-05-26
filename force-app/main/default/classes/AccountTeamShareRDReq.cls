global class AccountTeamShareRDReq implements Database.Batchable<SObject> {

    Set<Id> accountIds = new set<Id>();
    private string callback;
    
    global AccountTeamShareRDReq(string callback){
        this.callback = callback;
        }
    
    global Database.QueryLocator start(Database.BatchableContext bcMain) {
             
             return Database.getQueryLocator('Select Id from Account where Type = \'Customer\' and Account_Team_Updated__c = true');
                          
    }
      
    
    global void execute(Database.BatchableContext bcMain, List<Account> accounts) {
         
         List<AccountTeamMember> team = [Select Id, AccountAccessLevel, AccountId, TeamMemberRole, UserId, IsDeleted from AccountTeamMember where AccountId in : accounts];
         
         //Calling method to create sharing records.
         Account_Team_Functions.createSharingRecordsRDRequest(team,false);
    }

     
    global void finish(Database.BatchableContext bcMain) {
    
    AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:bcMain.getJobId()];
    
    string str = '';
        if(callback != '' && callback != null)
          str += callback + '\n';
        str += 'AccountTeamShareR&DRequest  (' + a.Id + ' ' + a.status + ')  processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.';
        database.executebatch(new AccountTeamShareSalesChurn(str));
        
    }
}