trigger Account_Group_Trigger on ccrz__E_AccountGroup__c (after insert, after update) {

    AccountGroupTriggerHandler.Accountgrouppricelistsetup(Trigger.new);
    
   /* set<id> accgrpIds = new set<id>();
    for(ccrz__E_AccountGroup__c ag : trigger.new){
        accgrpIds.add(ag.id);
    }
    if(accgrpIds.size()>0)
    Cloudcraze_Product_Function.add_AccountGroupPriceListSetup(accgrpIds);
    */

}