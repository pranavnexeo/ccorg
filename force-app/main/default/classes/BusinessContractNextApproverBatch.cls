global class BusinessContractNextApproverBatch extends AbstractNextApproverBatch {

    private static final String OBJECT_TYPE = 'Business_Contract__c';
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        lastTimestamp = System.now().addHours(-1);
        objectType = OBJECT_TYPE;
        qryLocator = Database.getQueryLocator(soql);
        return qryLocator;
    }
    
    global void execute(Database.BatchableContext bc, list<SObject> objs) {
    	List<ProcessInstance> piList = (List<ProcessInstance>)objs;
        Map<Id, Business_Contract__c> nextApprMap = new Map<Id, Business_Contract__c>();
        Map<Id, ProcessInstance> prcInstMap = new Map<Id, ProcessInstance>(piList);
        ProcessInstance prcInst;
        Business_Contract__c contract;
        for(ProcessInstanceWorkItem workItem :[ select Actor.Name,ProcessInstanceId 
                                                  from ProcessInstanceWorkItem
                                                 where ProcessInstanceId in :prcInstMap.keySet()
                                              ]) {
            prcInst = prcInstMap.get(workItem.ProcessInstanceId);
            contract = nextApprMap.get(prcInst.TargetObjectId);  
            if(contract==null) {
                contract = new Business_Contract__c(Id = prcInst.TargetObjectId, 
                                                    Next_Approvers__c = workItem.Actor.Name);
                nextApprMap.put(prcInst.TargetObjectId,contract);
            }
            /* Code to be uncommented if there are multiple 
               approvers that can be set to a single approval step 
             */
            /*
            else {
                contract.Next_Approvers__c+=','+workItem.Actor.Name;
            }
            */
        }
        update nextApprMap.values();
    }

}