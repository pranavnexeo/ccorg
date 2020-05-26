//Author - Matt
global class AccountTeamPurgeBatch implements Database.Batchable < SObject > {
    global string q;
    global AccountTeamPurgeBatch(boolean doprospect) {
        q = 'select id from AccountTeamMember where (Account.type = \'Customer\'';
        
        if(doprospect)
          q += ' or Account.type = \'Prospect\'';
        
        q += ')';

        q += ' and (Account.YI_Partner__c = null';
        q += ' and Account.YY_Partner__c = null';
        q += ' and Account.YZ_Partner__c = null';
        q += ' and Account.ZH_Partner__c = null';
        q += ' and Account.ZC_Partner__c = null';
        q += ' and Account.ZU_Partner__c = null)';
        q += ' and ((NOT TeamMemberRole LIKE \'%Backup%\') OR ';
        q += 'User.IsActive = false)';

    }

    //Start method
    global Database.QueryLocator start(Database.BatchableContext bcMain) {
        return Database.getQueryLocator(q);
    }

    //Execute Method
    global void execute(Database.BatchableContext bcMain, List <AccountTeamMember> alist) {
       delete alist;
    }

    //Finish Method
    global void finish(Database.BatchableContext bcMain) {

    }
}