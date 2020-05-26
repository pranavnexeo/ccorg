/***********************************
 * Author- Veralogics(Pranav)
 * Date- 27-Jan-2020
 * Description- Used in CPI_Beforeupsert trigger.
 * *********************************/
public class CPI_TriggerHandler {
    public static void updateCPIOwner(List<Customer_Product_Info__c> CPIList){
        Set<Id> accountIdSet = new Set<Id>();
        Map<String, Account> mapIdToAccount = new Map<String, Account>();
        
        for(Customer_Product_Info__c objCPI : CPIList){
            if(objCPI.Plastics_Account__c != null) 
            accountIdSet.add(objCPI.Plastics_Account__c);
        }
        
        for(Account objAccount : [Select Id, OwnerId, Owner.isActive, Name from Account where Id In:accountIdSet]){
            if(objAccount.Owner.isActive && !mapIdToAccount.containsKey(objAccount.Id))
            mapIdToAccount.put(objAccount.Id, objAccount);
        }
        
        for(Customer_Product_Info__c objCPI : CPIList){
            if(objCPI.Plastics_Account__c!=null){
                if(mapIdToAccount.containsKey(objCPI.Plastics_Account__c)){
                    objCPI.OwnerId = mapIdToAccount.get(objCPI.Plastics_Account__c).OwnerId;
                }
            }
        }
        
    }
}