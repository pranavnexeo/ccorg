trigger FAAsettingCurrentLimit on FAA_Request__c (before update) {
    for( FAA_Request__c parent: Trigger.new)
    {
        if((parent.Request_Status__c=='Approved')&& (Trigger.new[0].Request_Status__c != Trigger.old[0].Request_Status__c)){
            List<Category_Limit__c> children = [ SELECT Id,Name,FAA_Request__c,Current_US_Dollar_Limit__c,Desired_US_Dollar_Limit__c from 
            Category_Limit__c where FAA_Request__c = :parent.Id];
        
            List<Category_Limit__c> childrenToUpdate = new List<Category_Limit__c>();
        
            for(Category_Limit__c thischild: children )
            {
                thischild.Current_US_Dollar_Limit__c =thischild.Desired_US_Dollar_Limit__c  ;
           
                childrenToUpdate.add(thischild);
        
            }
            update childrenToUpdate;
        }
    }
}