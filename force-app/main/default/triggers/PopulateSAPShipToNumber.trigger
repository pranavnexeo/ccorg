trigger PopulateSAPShipToNumber on ccrz__E_Order__c (before insert,before Update) {
    
    System.debug('IN TRIGGER POPULATE SAP');
    map<id,ccrz__E_Order__c> ordmap = new map<id,ccrz__E_Order__c>();
    list<Account> listAcct = new list<Account>();
    list<ccrz__E_Order__c> listOrders=new list<ccrz__E_Order__c>();
    set<id> effectiveAccounts=new set<id>();
    for(ccrz__E_Order__c  ordhed : Trigger.new)
    {
        System.debug('IN TRIGGER POPULATE SAP TRIGGER.NEW');
        if(ordhed.ccrz__Storefront__c == 'mynexeo' && ordhed.ccrz__EffectiveAccountID__c!='')                                                                       
        {
            System.debug('STOREFRONT IS MYNEXEO EFFECTIVE ACCOUNT HAS VALUE');
            ordmap.put(ordhed.id,ordhed);
            effectiveAccounts.add(ordhed.ccrz__EffectiveAccountID__c);
        }
    }
    map<id, String> accountmap= new map<id, String>();    
    for(Account acct: [select id,AccountNumber from Account where id in: effectiveAccounts]){
        accountmap.put(acct.id, acct.AccountNumber);
     
    }
    System.debug('FGG accountmapSize'+accountmap.size());
   
    System.debug('FGG ordermap'+ordmap.size());
        for(ccrz__E_Order__c order: ordmap.values()){            
            order.SAP_Ship_To_Account_Number_Trigger__c=accountmap.get(order.ccrz__EffectiveAccountID__c);
            if(order.CC_Cart_Number__c!=null){
                system.debug('FGG '+order.CC_Cart_Number__c);
            order.ccrz__Account__c = order.ccrz__EffectiveAccountID__c;
            }
            System.debug(' TRIGGER ACCOUNT VALUE IS ' + order.ccrz__Account__c );
            System.debug(' TRIGGER ACCOUNT VALUE IS ' + order.ccrz__EffectiveAccountID__c );
            
        }
     /*   
    if(orderstoupdate.size()>0){
          if(RecursiveHandler.isFirstTime){
        RecursiveHandler.isFirstTime = false;
              UpdateShipToCustomerPortal updateOrder= new UpdateShipToCustomerPortal();
              updateOrder.updateShipToValues(orderstoupdate);        
    }
    }*/
    

}