trigger NexeoFAAValidateDelegations on Category_Limit__c (before insert, before update) {
    
    for(Category_Limit__c catLim : Trigger.new){
        List <FAA_Request__c> faaObj = [select id, Delegator_Name__c,Delegator_Emp_Number__c from FAA_Request__c where Id = :catLim.FAA_Request__c];
        String delegatorId = faaObj[0].Delegator_Emp_Number__c;
        String CategoryId = catLim.Category__c;
        system.debug('delegatorId : '+delegatorId );
        system.debug('CategoryId : '+CategoryId );
        List <Category_Master__c> catMaster = [select id, Limit__c,CategoryDesc__c,EmpId__c from Category_Master__c where EmpId__c = :delegatorId and CategoryDesc__c = :CategoryId ];
        system.debug('catMaster size is  : '+catMaster.size());
        if(catMaster.size() >0){
            if(catLim.Desired_US_Dollar_Limit__c > catMaster[0].Limit__c){
                catLim.addError('The "Desired Amount" entered is greater than the Allowed Limit for the selected delegator of this FAA Request.');
                //break;
            }
        }else{
            catLim.addError('Delegator selected for this FAA request does not have permission to authorise this category');
            break;
        }
    }
}