trigger UpdateOppbysample on Sample_Request__c (after insert) {
Profile p = [select id, name from Profile where id = :UserInfo.getProfileId() limit 1];
    List<String> idList = new List<String>();
    if(trigger.isinsert){  
        for(Sample_Request__c e:trigger.new){
            if(e.Opportunity__c != null)
                idList.add(e.Opportunity__c);  
        }
        List<Opportunity> oppList = [Select Id from Opportunity where Id in :idList];
        IF( p.Name != 'System Administrator' && p.Name != 'System Administrator - SSO Enabled' && oppList.size() > 0){
            update oppList;
        }
     }
}