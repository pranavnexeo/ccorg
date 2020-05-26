public class BusinessContracttriggerHandler {
    
    public static void UpdateCdf(List<Business_Contract__c> busConList, map<id, Business_Contract__c> oldMap){
        List<Contract> lstToUpdate = new List<Contract>();
        Set<Id> busConId = new Set<Id>();
        for(Business_Contract__c b : busConList){
            if(b.Status__c == 'Activated' && oldMap.get(b.id).Status__c != 'Activated')
            busConId.add(b.Id);
        }
        for(Contract obj :[select Id,Business_Contract_Approved__c from Contract where Business_Contract__c IN: busConId  and Status = 'Draft']){
            obj.Business_Contract_Approved__c = True;
            lstToUpdate.add(obj);
            
        }
        if(!lstToUpdate.isEmpty())
            update lstToUpdate;

    }

}