/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        11/20/2017
*    Author:             Ignacio Gonzalez
*   Short Description:  
*						
*   **********************************************************************************************************************/

public with sharing class PriceListTriggerHandler {

  public PriceListTriggerHandler() {
        
  }
  @future  
  public static void OnAfterInsertAsync(Set<ID> newRecordIDs){
    List<ccrz__E_PriceList__c> newRecords = [SELECT Id, PriceListType__c, ccrz__CurrencyISOCode__c, ccrz__Storefront__c FROM  ccrz__E_PriceList__c Where Id in:newRecordIDs];
	//In order to get the map of the pricelist for an account
	Map<Id, ccrz__E_PriceList__c> priceListByAccount = arrangePriceListByAccount(newRecords);
      if (!priceListByAccount.isEmpty()) {
          updateUserCurrency(priceListByAccount);
      }
  }
  
  @future    
  public static void OnAfterUpdateAsync(Set<ID> newRecordIDs){
      List<ccrz__E_PriceList__c> priceListWithCurrencyUp = [SELECT Id, PriceListType__c, ccrz__CurrencyISOCode__c, ccrz__Storefront__c FROM  ccrz__E_PriceList__c Where Id in:newRecordIDs];

      
      	//In order to get the map of the pricelist for an account
	  Map<Id, ccrz__E_PriceList__c> priceListByAccount = arrangePriceListByAccount(priceListWithCurrencyUp);
      if (!priceListByAccount.isEmpty()) {
          updateUserCurrency(priceListByAccount);
      }
      
  }
    
    public static Map<Id, ccrz__E_PriceList__c> arrangePriceListByAccount(ccrz__E_PriceList__c[] priceListRecords){
      //In order to get the ids of the accounts realted to the pricelist
      Map<Id, ccrz__E_PriceList__c> priceMapId = new Map<Id, ccrz__E_PriceList__c>();
      Map<Id, ccrz__E_PriceList__c> priceListByAccount = new Map<Id, ccrz__E_PriceList__c>();
      for (ccrz__E_PriceList__c priceList:priceListRecords) {
          if ( priceList.ccrz__Storefront__c == 'mynexeo' ){	
          		priceMapId.put(priceList.Id, priceList);
          }
      }
      
      //retriving the accounts related to the price list
      for(Account accRelatedToPriceList:[SELECT Id, cc_imp_MyProductList__c FROM Account Where cc_imp_MyProductList__c in:priceMapId.keySet()]){
          ccrz__E_PriceList__c currPriceList = priceMapId.get(accRelatedToPriceList.cc_imp_MyProductList__c);
          if (null != currPriceList) {
              priceListByAccount.put(accRelatedToPriceList.Id, currPriceList);
          }
      }
      
 	  return priceListByAccount;
    
    }
  
  /*
   * We are going to update currency code on the users related to this accounts
   * */
   public static void updateUserCurrency(Map<Id, ccrz__E_PriceList__c> priceListByAccount) {
	//using this list to store updated users
      List<User> updatedUser = new List<User>();
    // using this query to retrieve all the users that are realted to an account
	// this event has been triggered by an after event on a price list so
	// we do not have to check if the account is used by Cloud Craze
    // SELECT Id, CurrencyIsoCode,ccrz__CC_CurrencyCode__c  FROM User Where ContactId IN (SELECT Id FROM Contact Where AccountId in ('001E000000CVVv5'))
      for (User portalUser:[SELECT Id, CurrencyIsoCode,ccrz__CC_CurrencyCode__c,Contact.AccountId  FROM User Where ContactId IN (SELECT Id FROM Contact Where AccountId in :priceListByAccount.keySet())]) {
			ccrz__E_PriceList__c priceList = priceListByAccount.get(portalUser.Contact.AccountId);
          	if(null != priceList) {
			 	portalUser.ccrz__CC_CurrencyCode__c = priceList.ccrz__CurrencyISOCode__c;
                updatedUser.add(portalUser);
          	}	
      }
      
      if (!updatedUser.isEmpty()) {
          if (!Test.isRunningTest()) {
               update updatedUser;
          }
      }
  }  
}