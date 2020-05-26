trigger UpdateOppFromTeamMember on OpportunityTeamMember (before insert) {
 Profile p = [select id, name from Profile where id = :UserInfo.getProfileId() limit 1];
    List<String> idList = new List<String>();
    if(trigger.isinsert){  
        for(OpportunityTeamMember e:trigger.new){
            if(e.OpportunityId != null)
                idList.add(e.OpportunityId);
        }
        List<Opportunity> oppList = [Select Id from Opportunity where Id in :idList];
        IF( p.Name != 'System Administrator' && p.Name != 'System Administrator - SSO Enabled' && oppList.size() > 0){
            update oppList;
        }
     }

}