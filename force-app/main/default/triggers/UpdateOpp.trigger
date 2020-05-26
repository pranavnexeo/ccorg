trigger UpdateOpp on Consumption__c (after insert) {
Profile p = [select id, name from Profile where id = :UserInfo.getProfileId() limit 1];
    List<String> idList = new List<String>();
    if(trigger.isinsert){  
        for(Consumption__c e:trigger.new){
            if(e.RelatedOpportunity__c != null)
                idList.add(e.RelatedOpportunity__c);  
        }
        List<Opportunity> oppList = [Select Id from Opportunity where Id in :idList];
        IF( p.Name != 'System Administrator' && p.Name != 'System Administrator - SSO Enabled' && oppList.size() > 0){
            update oppList;
        }
     }
}