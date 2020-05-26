/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        08/30/2016
*    Author:             Francisco Garcia
*   Last Modified:       07/06/2017
*   Last Modified By:    Francisco Garcia   
*
*   Short Description:   Populate My Products List in the account object. 
*                       07/06/2017- Calling pricing after pricelist creation.
*   **********************************************************************************************************************/

trigger PriceListAfterInsert on ccrz__E_PriceList__c (After Insert, After Update) {
 
  if(RecursiveHandler.isFirstTime){
    RecursiveHandler.isFirstTime = false;
    Map<String,Id> mapPriceListIDAccount=new Map<String,Id>();
    
    for(ccrz__E_PriceList__c pl:trigger.new){
        if(pl.PriceListType__c=='CPIPriceList'){
        mapPriceListIDAccount.put(pl.ccrz__PricelistId__c, pl.Id);            
        }
    }
    List<id> accountIDs= new List<id>();
    List<Account> acctToUpdate=new List<Account>();
    for(Account acct: [select id,cc_imp_MyProductList__c,Account_Number__c from Account where Account_Number__c in : mapPriceListIDAccount.keySet()]){
           //acct.cc_imp_MyProductList__c=mapPriceListIDAccount.get(acct.Account_Number__c);
           
        //acctToUpdate.add(acct);
        accountIDs.add(acct.Id);
    }
    
    checkRecursive.resetAccountOnce2();
    
    /*if(trigger.isAfter && trigger.isInsert){
        update acctToUpdate;
    }*/   
    /******Calling pricing update to get pricing before the customer logins ***********/    
    UpdatePricingLastRefreshed.updateLasttimeRefreshed(accountIDs);
    
    if (Trigger.isInsert){
        PriceListTriggerHandler.OnAfterInsertAsync(Trigger.newMap.keySet());
    } else if (Trigger.isUpdate) {
            //Ask this to Paco
          Set<Id> updatedIds = new Set<Id>();
          for (Integer i = 0; i <  Trigger.old.size(); i++) {
              if (Trigger.old[i].ccrz__CurrencyISOCode__c != Trigger.new[i].ccrz__CurrencyISOCode__c) {
                  updatedIds.add(Trigger.new[i].Id);
              }
          }
        PriceListTriggerHandler.OnAfterUpdateAsync(updatedIds);
    }
      
   } 
}