Global class AccountDirectoryCleanUpBatch implements Database.Batchable<sObject>{
    global String q;
    global AccountDirectoryCleanUpBatch(){
      q = 'select Id,Account_Id__c from Account_Directory__c';
    }

    Global Database.QueryLocator Start(Database.BatchableContext bcMain){
        return Database.getQueryLocator(q);
    }
    
    Global void Execute(Database.BatchableContext bcMain, List<Account_Directory__c> aList){
 
       
        Set<Id> accId = new Set<Id>(); 
        List<Account_Directory__c> adDelete = new List<Account_Directory__c>();
        if(!aList.isempty()){
            for(Account_Directory__c ad: aList){
               if(ad.Account_Id__c != null){
                   accId.add(ad.Account_Id__c); 
                }           
            }
        }
        Map<Id,Account> accMap = new Map<Id, Account>([Select Id,Name from Account where Id in: accId]);
        if(!accMap.isempty()){
            for(Account_Directory__c adc: aList){
                if(!accMap.containskey(adc.Account_Id__c)){
                    adDelete.add(adc);
                }
            }
            
        } 
        if(!adDelete.isEmpty()){
                delete adDelete;
        }
    }
    
    Global void finish(Database.BatchableContext bcMain){
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:bcMain.getJobId()];
        String str = '';
        str += 'Account_Directory_Cleanup_batch(' + a.Id + ' ' + a.status + ')  processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.';
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {'nexeosfdcsupport@nexeosolutions.com'});
        mail.setReplyTo('nexeosfdcsupport@nexeosolutions.com');
        mail.setSenderDisplayName('Account_Directory_batch');
        mail.setSubject('Account_Directory_batch');
        mail.setPlainTextBody(str);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
    }
}