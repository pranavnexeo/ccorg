trigger updateCurrentLimitThroughCatMaster on Category_Master__c (before insert, before update) {
    for(Category_Master__c a : Trigger.new){
       List <FAA_Request__c> faaObj = [select id, Agent_Emp_Number__c from FAA_Request__c where Agent_Emp_Number__c = :a.EmpId__c and Request_Status__c='Approved'];
       if(faaObj.size()>0){
           List <Category_Limit__c> catLim = [select id,FAA_Request__c from Category_Limit__c where FAA_Request__c = :faaObj[0].id and Category__c = :a.CategoryDesc__c];
           if(catLim.size()>0){
                catLim[0].Current_US_Dollar_Limit__c = a.Limit__c;
                update catLim;
           }    
       }
    }
}