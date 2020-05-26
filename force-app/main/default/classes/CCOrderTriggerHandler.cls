/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        05/01/2018
*   Author:              Ignacio Gonzalez
*   Last Modified:       
*   Last Modified By:    
*
*   Short Description:  Handler to manage logic triggered by CC Order DML Events
*   
*   
*	
*   **********************************************************************************************************************/
//Without sharing as some users may not have access to the Ship To or Bill To account
public with sharing class CCOrderTriggerHandler {
    
  private boolean m_isExecuting = false;
  private integer BatchSize = 0;

  public CCOrderTriggerHandler(boolean isExecuting, integer size){
    m_isExecuting = isExecuting;
    BatchSize = size;
  }
    
  public void OnAfterInsert(ccrz__E_Order__c[] newRecords){
      List<Id> myNexeoOrdersId = new List<Id>();
      cc_imp_StorefrontSettings__c customSettings = cc_imp_StorefrontSettings__c.getInstance('mynexeo');
      for (ccrz__E_Order__c order:newRecords) {
          if (String.isNotEmpty(order.ccrz__Storefront__c)) {
              if (order.ccrz__Storefront__c.toLowerCase() == customSettings.Store_Front_Name__c) {
                  System.debug('order ' + order);
                  myNexeoOrdersId.add(order.Id);
              }
          }
          
      }
      
      if (!myNexeoOrdersId.isEmpty() ) {
          manageMyNexeoOrders(myNexeoOrdersId);
      }
	
  }
    
  public void OnAfterUpdate(ccrz__E_Order__c[] newRecords) {
      System.debug('FGG newRecords'+newRecords.size());
      List<Id> myNexeoOrdersId = new List<Id>();
      cc_imp_StorefrontSettings__c customSettings = cc_imp_StorefrontSettings__c.getInstance('mynexeo');
      for (ccrz__E_Order__c order:newRecords) {
          if (String.isNotEmpty(order.ccrz__Storefront__c)) {
              if (order.ccrz__Storefront__c.toLowerCase() == customSettings.Store_Front_Name__c
                 && order.Shipping_To__c == null &&  order.Billing_To__c == null) {
                  myNexeoOrdersId.add(order.Id);
              }
          }
      }
      
      if (!myNexeoOrdersId.isEmpty() ) {
          manageMyNexeoOrders(myNexeoOrdersId);
      }    
  }  
  
    
    
  // In order to process CC Orders only for MyNexeo Store Front
  private void manageMyNexeoOrders(List<Id> myNexeoOrdersId) {
      System.debug('FGG myNexeoOrdersId');
      List<ccrz__E_Order__c> myNexeoOrders = new List<ccrz__E_Order__c>();
      for (ccrz__E_Order__c order: [SELECT Id,ccrz__Account__c, ccrz__Account__r.SAP_Accounting_Group__c, ccrz__Account__r.SAP_Bill_To_Account_ID__c,
                         ccrz__Account__r.Parent_Account__r.SAP_Bill_To_Account_ID__c FROM ccrz__E_Order__c WHERE Id IN :myNexeoOrdersId ]) {                           
                                 if (order.ccrz__Account__r.SAP_Accounting_Group__c != null && order.ccrz__Account__r.SAP_Accounting_Group__c.contains('Sold')) {
                                     if (order.ccrz__Account__r.SAP_Bill_To_Account_ID__c != null) {
                                         myNexeoOrders.add(order); 
                                     }
                                 } else {
                                     if (order.ccrz__Account__r.Parent_Account__r.SAP_Bill_To_Account_ID__c != null && order.ccrz__Account__r.Parent_Account__r.SAP_Bill_To_Account_ID__c != null) {
                                         myNexeoOrders.add(order); 
                                     }
                                 }   
                         }

      // Get all ccrz__EffectiveAccountID__c realted to Cart Ids 
      Map<Id, ccrz__E_Cart__c> mapOfCarts = new Map<Id, ccrz__E_Cart__c>();
      Map<Id, Account> effectiveAccounts = new Map<Id, Account>();
      Map<Id, Account> billToAccounts = new Map<Id, Account>();
      Map<Id, Id> effectiveAccountIds = new Map<Id, Id>(); // first Id OrderId Second Id Account Id
      List<Id> billToAccountIds = new List<Id>();
      for (ccrz__E_Order__c order: myNexeoOrders) {
              effectiveAccountIds.put(order.Id, order.ccrz__Account__c);     
      }
      
      //Get all effective Accounts
      for(Account effectiveAccount:[SELECT Id, SAP_Bill_To_Account_ID__c, SAP_Accounting_Group__c, Parent_Account__c, ShippingStreet, ShippingCity,ShippingState, ShippingPostalCode, ShippingCountry, Name,
                           Parent_Account__r.SAP_Bill_To_Account_ID__c FROM Account WHERE Id IN: effectiveAccountIds.values()]){                    
          effectiveAccounts.put(effectiveAccount.Id, effectiveAccount);
          if (String.isNotEmpty(effectiveAccount.SAP_Accounting_Group__c)) {                     
              if(!effectiveAccount.SAP_Accounting_Group__c.contains('Sold')) {
                  billToAccountIds.add(effectiveAccount.Parent_Account__r.SAP_Bill_To_Account_ID__c);
              } else {
                  billToAccountIds.add(effectiveAccount.SAP_Bill_To_Account_ID__c);              
              }
          }
      }
      
      billToAccounts = CCOrderTriggerHelper.getAllBillToAccounts(billToAccountIds);
     
     Map<Id, Account> billToByOrder = new Map<Id, Account>();
     Map<Id, Account> shipToByOrder = new Map<Id, Account>(); 
     //Now related an account with each Order
     for (ccrz__E_Order__c order: myNexeoOrders) {
         System.debug(' effectiveAccounts ' + effectiveAccounts);
         System.debug(' rder.ccrz__Account__c ' + order.ccrz__Account__c);
          Account billTo = effectiveAccounts.get(order.ccrz__Account__c);
          Account shipTo = null;
         
          if (String.isNotEmpty(billTo.SAP_Accounting_Group__c)) {
              if(!billTo.SAP_Accounting_Group__c.contains('Sold')) {
                 shipTo = billToAccounts.get(billTo.Parent_Account__r.SAP_Bill_To_Account_ID__c);
              } else {
                  shipTo = billToAccounts.get(billTo.SAP_Bill_To_Account_ID__c);              
              }
          }
          billToByOrder.put(order.Id, billTo);
          shipToByOrder.put(order.Id, shipTo);
     }
     //Create all the CC Contact Addresses
     //Map<Order.Id, CC Contact Addresses>
     Map<Id, ccrz__E_ContactAddr__c> shipTos = createContactAddress(billToByOrder);
     Map<Id, ccrz__E_ContactAddr__c> billTos = createContactAddress(shipToByOrder);
     insert shipTos.values();
     insert billTos.values();
     //iterate over the order to create the new CC Contact Addresses
     List<ccrz__E_Order__c> ordersToUpdate = new List<ccrz__E_Order__c>();
     for(ccrz__E_Order__c newOrder:myNexeoOrders){
         ccrz__E_ContactAddr__c shipToAccount = shipTos.get(newOrder.Id);
         ccrz__E_ContactAddr__c billToAccount = billTos.get(newOrder.Id);

         newOrder.Shipping_To__c = shipToAccount.Id;
         newOrder.Billing_To__c = billToAccount.Id;
         ordersToUpdate.add(newOrder);
     }
     
      if (ordersToUpdate.size() > 0) {
          update ordersToUpdate;
      }
  }
    
    
  private Map<Id, ccrz__E_ContactAddr__c> createContactAddress(Map<Id, Account> accounts) {
      Map<Id, ccrz__E_ContactAddr__c> newContactAddr = new Map<Id, ccrz__E_ContactAddr__c>();
	  System.debug('accounts ' + accounts);
      for (Id orderId : accounts.keySet() ){
         Account currAccount = accounts.get(orderId);
          if(currAccount.shippingState!=null && currAccount.ShippingCountry!=null){
		if(currAccount.ShippingState.length()>10){
            currAccount.ShippingState=currAccount.ShippingState.substring(0,9);
                }
        if(currAccount.ShippingCountry.length()>10){
            currAccount.ShippingCountry=currAccount.ShippingCountry.substring(0,9);
        }
          }
         ccrz__E_ContactAddr__c cab= new ccrz__E_ContactAddr__c(ccrz__AddressFirstline__c = currAccount.ShippingStreet, 
                                                        ccrz__City__c = currAccount.ShippingCity, 
                                                        ccrz__State__c = currAccount.ShippingState,
                                                                ccrz__StateISOCode__c = currAccount.ShippingState, 
                                                        ccrz__PostalCode__c = currAccount.ShippingPostalCode, 
                                                        ccrz__Country__c = currAccount.ShippingCountry, 
                                                                ccrz__CountryISOCode__c =currAccount.ShippingCountry , 

                                                        ccrz__CompanyName__c = currAccount.Name);
          
         newContactAddr.put(orderId, cab);
      }
      
      return newContactAddr;
        
  }  


}