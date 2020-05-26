public without sharing class UpdatePricingLastRefreshed {
    
    @future(callout=true)
    public static void updateLasttimeRefreshed(List<ID> recordIds){
    
       // Get those records based on the IDs
         List<Account> accts = [SELECT Pricing_Last_Refreshed__c,SAP_DivisionCode__c,Sold_To_Customer_Number__c,SAP_Sales_Org__c,SAP_DistChannel__c,cc_imp_MyProductList__c,Id,Account_Number__c FROM Account WHERE Id IN :recordIds];
         List<Account> acctstoUpdate = new List<Account>(); 
         Set<Id> plset  = new Set<Id>();     
         for(Account act:accts){
           //act.Pricing_Last_Refreshed__c=system.Datetime.now();
           acctstoUpdate.add(act); 
           /*if(act.cc_imp_MyProductList__c != null){
              plset.add(act.cc_imp_MyProductList__c);
           }*/
         }
        if(!Test.isRunningTest()){
            PricingCustomerPortal pricingObject=new PricingCustomerPortal();
            pricingObject.getPricingFromSAP(acctstoUpdate);    
        }
            
        //update acctstoUpdate;
        /*List<ccrz__E_PriceList__c> ccpList = [Select Id,Pricing_Last_Refreshed__c from ccrz__E_PriceList__c where Id in: plset];
        List<ccrz__E_PriceList__c> ccpUpdate = new List<ccrz__E_PriceList__c>();
        for(ccrz__E_PriceList__c ccp : ccpList){
            ccp.Pricing_Last_Refreshed__c = system.now();
            ccpUpdate.add(ccp);
        }
        
        if(!ccpUpdate.isEmpty()){
            recurrsionControl.inFutureContext = true;
            update ccpUpdate;
        }*/
        
    }
    
}