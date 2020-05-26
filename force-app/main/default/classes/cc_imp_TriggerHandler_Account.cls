public with sharing class cc_imp_TriggerHandler_Account extends cc_imp_TriggerHandler
{

	private Map<Id, Account> newAcctMap;

	public cc_imp_TriggerHandler_Account() 
	{
		 this.newAcctMap = (Map<Id, Account>) Trigger.newMap;
	}

	 public override void beforeInsert() 
	 {
	 	List <Account>accountList = (List<Account>) Trigger.new;
		List <Account>accountListtoUpdate =new List<Account>(); 
         for(Account acct:accountList){
             if(acct.ccrz__UsedByCloudcraze__c==True){
                 accountListtoUpdate.add(acct);                 
             }             	 	                  
         }
        cc_imp_AccountTriggerHandlerFunctions.processNexeo3DAccountUpdates(accountListtoUpdate);
	 	cc_imp_AccountTriggerHandlerFunctions.processMyNexeoAccountUpdates(accountListtoUpdate);
     }
}