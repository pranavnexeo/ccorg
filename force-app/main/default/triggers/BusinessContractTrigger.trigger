trigger BusinessContractTrigger on Business_Contract__c (after insert, after update) {
    
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            for(Business_Contract__c b :trigger.new){
                //attachPDFToAccount.savePdf(b.id, b.Customer_Name__c);
            }
        }
        if(Trigger.isUpdate){
            BusinessContracttriggerHandler.UpdateCdf(trigger.new, trigger.oldMap);
        }
    }
}