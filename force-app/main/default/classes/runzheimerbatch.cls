global class runzheimerbatch implements Database.Batchable<sObject>{


    public String Query;


    global Database.QueryLocator start(Database.BatchableContext bc) {
    query='select id,billingstreet,SAP_Street__c,runzheimer_batch_Updated__c from Account where runzheimer_batch_Updated__c = false AND (Type=\'Prospect\' OR Type=\'Customer\') Limit 25000';
    return Database.getQueryLocator(query);   
    }
    
    global void execute(Database.BatchableContext BC, list<Account> acc){
    
        list<Account> listtoupdate = new list<Account>();
        for(Account a: acc)
            {   
                if( !String.isBlank(a.billingStreet) && !String.isBlank(a.SAP_Street__c)){
                
               //if((a.billingStreet != '' || a.billingStreet != null) && (a.SAP_Street__c != '' || a.SAP_Street__c != null )){
               
                a.billingStreet = a.billingStreet+'.';
                a.SAP_Street__c = a.SAP_Street__c+'.';
                a.runzheimer_batch_Updated__c=true; 
                listtoupdate.add(a);
               
               }
                
            }
        update listtoupdate;    
    }
    
    global void finish(Database.BatchableContext BC){

    
    } 

}