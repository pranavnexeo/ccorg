trigger CdfTrigger on Contract (before update,before insert,after insert,after update) {
    //if(CdfTriggerHandler.isFirstRun()){ 
        if(Trigger.isbefore){
            if(Trigger.isInsert){
                CdfTriggerHandler.Updatesellerandsales(trigger.new);
                CdfTriggerHandler.UpdateCdfFields(trigger.new,null);
                CdfTriggerHandler.UpdateQuantities(trigger.new);
               // CdfTriggerHandler.UpdateBusinessContFields(trigger.new,null);
            }
            if(trigger.isUpdate){
                CdfTriggerHandler.Updatesellerandsales(trigger.new);
                CdfTriggerHandler.updateApproverandComments(trigger.new, trigger.oldMap);
                CdfTriggerHandler.UpdateQuantities(trigger.new);
                //CdfTriggerHandler.UpdateCdfFields(trigger.new, trigger.oldMap);
                //CdfTriggerHandler.UpdateBusinessContFields(trigger.new, trigger.oldMap);
            }
        }
    //}    
    /*if(Trigger.isafter){
        if(Trigger.isInsert){
            CdfTriggerHandler.submitClonedCdf(trigger.new);
        }
        if(trigger.isUpdate){
            CdfTriggerHandler.submitClonedCdf(trigger.new);
        }
    }*/
    
}