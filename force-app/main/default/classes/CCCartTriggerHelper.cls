/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        05/04/2018
*   Author:              Ignacio Gonzalez
*   Last Modified:       
*   Last Modified By:    
*
*   Short Description:  Helper for trigger CCCartTrigger
*   
*   
*	
*   **********************************************************************************************************************/
public with sharing class CCCartTriggerHelper {

  private boolean m_isExecuting = false;
  private integer BatchSize = 0;

  public CCCartTriggerHelper(boolean isExecuting, integer size){
    m_isExecuting = isExecuting;
    BatchSize = size;
  }
    
  public void OnBeforeInsert(ccrz__E_Cart__c[] newRecords) {
      //Only Apply for MyNexeo
      cc_imp_StorefrontSettings__c customSettings = cc_imp_StorefrontSettings__c.getInstance('mynexeo');
      
      List<ccrz__E_Cart__c> cartsToValidate = new List<ccrz__E_Cart__c>();
      for (ccrz__E_Cart__c theCart:newRecords) {
          //Cartt to validate has fields Bill To and Ship To equals to Empty
          if(theCart.ccrz__Storefront__c != null) {
              if (theCart.ccrz__Storefront__c.toLowerCase() == customSettings.Store_Front_Name__c
                    && theCart.ccrz__BillTo__c == null
                    && theCart.ccrz__BillTo__c == null) {
                  cartsToValidate.add(theCart);
              }
          }
      }    
        validateBillToShipTo(cartsToValidate);
          
  }   
  
  //We are going to validate the current cart in order to have 
  //the CC fields Bill To and Ship To populate
  //after is has been created by any process, 
  //this only applies for MyNexeo  
  private void validateBillToShipTo(List<ccrz__E_Cart__c> cartsToValidate){
      List<String> accontIdsToUse = new List<String>();
      for(ccrz__E_Cart__c theCart:cartsToValidate) {
          accontIdsToUse.add(theCart.ccrz__EffectiveAccountID__c);     
      }
      
      List<Account> accontsToUse = [SELECT Id, BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,ShippingCountry, Type,ccrz__UsedByCloudcraze__c 
        							FROM Account WHERE Id IN: accontIdsToUse];
      //this Id refers to Account.Id
      Map<Id, ccrz__E_ContactAddr__c> billTos = createContactAddr(accontsToUse, true);
      Map<Id, ccrz__E_ContactAddr__c> shipTos = createContactAddr(accontsToUse, false);
      if (!billTos.isEmpty() && !shipTos.isEmpty()) {
          insert billTos.values();
          insert shipTos.values();
          for (ccrz__E_Cart__c theCart:cartsToValidate) {
               ccrz__E_ContactAddr__c billTo = billTos.get(theCart.ccrz__EffectiveAccountID__c);
               ccrz__E_ContactAddr__c shipTo = shipTos.get(theCart.ccrz__EffectiveAccountID__c);
               theCart.ccrz__BillTo__c = billTo.Id;
               theCart.ccrz__ShipTo__c = shipTo.Id;                                        
          }
      }
       
      
  }
    
  private Map<Id, ccrz__E_ContactAddr__c> createContactAddr(List<Account> accontsToUse, Boolean isShipTo) {
  	Map<Id, ccrz__E_ContactAddr__c> contactAddrMap = new Map<Id, ccrz__E_ContactAddr__c>(); 
    for(Account currentAccount : accontsToUse){
        
    	if (isShipTo){
            String shipToAdd = '';
            String shipToCountry = '';
             if(currentAccount.shippingState!=null && currentAccount.ShippingCountry!=null){
                 	if(currentAccount.ShippingState.length()>10){
                    	shipToAdd = currentAccount.ShippingState.substring(0,9);
                    } else  {
                        shipToAdd = currentAccount.ShippingState;
                    }
                    if(currentAccount.ShippingCountry.length()>10){    
                    	shipToCountry = currentAccount.ShippingCountry.substring(0,9);
                    } else {
                        shipToCountry = currentAccount.ShippingCountry;
                    }
             }
            ccrz__E_ContactAddr__c cas= new ccrz__E_ContactAddr__c(ccrz__AddressFirstline__c = currentAccount.shippingStreet, 
                                                        ccrz__City__c = currentAccount.ShippingCity, 
                                                        ccrz__State__c = shipToAdd,
                                                        ccrz__StateISOCode__c = shipToAdd, 
                                                        ccrz__PostalCode__c = currentAccount.ShippingPostalCode, 
                                                        ccrz__Country__c = shipToCountry, 
                                                        ccrz__CountryISOCode__c = shipToCountry); 
            

             contactAddrMap.put(currentAccount.Id, cas);
        } else {
            String billToAdd = '';
            String billToCountry = '';
             if(currentAccount.BillingState!=null && currentAccount.BillingCountry!=null){
                 if(currentAccount.BillingState.length()>10){
                    billToAdd = currentAccount.BillingState.substring(0,9);
                 } else {
                     billToAdd = currentAccount.BillingState;
                 }
                 
                 if(currentAccount.BillingCountry.length()>10){  
                    billToCountry = currentAccount.BillingCountry.substring(0,9);
                 } else {
                     billToCountry = currentAccount.BillingCountry;
                 }
             }            
             ccrz__E_ContactAddr__c cab= new ccrz__E_ContactAddr__c(ccrz__AddressFirstline__c = currentAccount.BillingStreet, 
                                                        ccrz__City__c = currentAccount.BillingCity, 
                                                        ccrz__State__c = billToAdd,
                                                        ccrz__StateISOCode__c = billToAdd, 
                                                        ccrz__PostalCode__c = currentAccount.BillingPostalCode, 
                                                        ccrz__Country__c = billToCountry, 
                                                        ccrz__CountryISOCode__c = billToCountry); 
            contactAddrMap.put(currentAccount.Id, cab);
        }

    }  
    return contactAddrMap;      
      
  }
}