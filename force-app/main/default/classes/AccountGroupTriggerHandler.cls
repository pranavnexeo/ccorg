public without sharing class AccountGroupTriggerHandler {
    
    public static void Accountgrouppricelistsetup(List<ccrz__E_AccountGroup__c> aglist){
        set<id> accgrpIds = new set<id>();
      
        for(ccrz__E_AccountGroup__c ag : aglist){
            if(ag.Account__c!= null){
                //accId.add(ag.Account__c);
                accgrpIds.add(ag.id);
            }    
        }
        
        if(accgrpIds.size()>0)
            Cloudcraze_Product_Function.add_AccountGroupPriceListSetup(accgrpIds);
        
    }
}