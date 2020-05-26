trigger uniqueAgentname on FAA_Request__c (before insert,before update)
{
    Map<String, FAA_Request__c> FAAMap = new Map<String, FAA_Request__c>();
    for (FAA_Request__c FAA : System.Trigger.new)
    {
        if ((FAA.Agent_Name__c != null) && (System.Trigger.isInsert || (FAA.Agent_Name__c != System.Trigger.oldMap.get(FAA.Id).Agent_Name__c)))
        {
            if (FAAMap.containsKey(FAA.Agent_Name__c))
            {
                FAA.Agent_Name__c.addError('Another new FAA has the ' + 'same Agent Name.');
            }
            else
            {
                FAAMap.put(FAA.Agent_Name__c, FAA);
            }
        }
    }
    
    for (FAA_Request__c FAA : [SELECT Agent_Name__c FROM FAA_Request__c WHERE Agent_Name__c IN :FAAMap.KeySet()])
    {
        FAA_Request__c newFAA = FAAMap.get(FAA.Agent_Name__c);
        newFAA.Agent_Name__c.addError('A FAA Request with this Agent Name ' + 'already exists.');
    }
}