public without sharing class CCOrderTriggerHelper {
    
    public static Map<Id, Account> getAllBillToAccounts(List<Id> billToAccountIds) {
        
        Map<Id, Account> billToAccounts = new Map<Id, Account>();
        
      //Get all bill to Accounts
      for(Account billAccount:[SELECT Id, SAP_Bill_To_Account_ID__c, SAP_Accounting_Group__c, Parent_Account__c, ShippingStreet , ShippingCity,ShippingState, ShippingPostalCode, ShippingCountry, Name
                            	FROM Account WHERE Id IN: billToAccountIds]){
          billToAccounts.put(billAccount.Id, billAccount);
      }
        
      return billToAccounts;
    }

}