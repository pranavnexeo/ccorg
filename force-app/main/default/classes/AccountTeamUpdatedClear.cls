//Author - Matt
global class AccountTeamUpdatedClear implements Database.Batchable < SObject > {
    global string q;
    global AccountTeamUpdatedClear() {
        q = 'select id from Account where Account_Team_Updated__c = true';
    }

    //Start method
    global Database.QueryLocator start(Database.BatchableContext bcMain) {
        return Database.getQueryLocator(q);
    }

    //Execute Method
    global void execute(Database.BatchableContext bcMain, List < Account > alist) {

        for(Account a:alist){
          a.Account_Team_Updated__c = false;
        }
        update alist;
    }
        //Finish Method
    global void finish(Database.BatchableContext bcMain) {
       AccountTeamPurgeBatch p = new AccountTeamPurgeBatch(true);
       database.executebatch(p);
    }
}