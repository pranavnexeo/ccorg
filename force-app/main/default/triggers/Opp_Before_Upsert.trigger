trigger Opp_Before_Upsert on Opportunity (before insert, before update) {
  
   // This trigger populates the Account Ownwer Manager ID field for use in Salesforce Chatter
   // This Trigger Populates Custom Last Modified Fields
    
   Map<string, ID> rectypemap = new map<string, id>();
   rectypemap = recordtype_Functions.RetrieveRecordTypeNameMap('Opportunitiy');
   Set<ID> acctid = new Set<id>();
   Map<ID, ID> AcctOwnerMap = new map<ID, ID>();
   Profile p = [select id, name from Profile where id = :UserInfo.getProfileId() limit 1];
   
   for(Opportunity o : trigger.new){
     acctid.add(o.accountid);
   }
   
   List<Account> accts = [select id, ownerid from account where id in :acctid];   
   Map<ID, ID> Managermap = Chatter_Functions.getManagerMap(accts);
   
   for(Account a:accts){
     AcctOwnerMap.put(a.id, a.ownerid);
   }
   
   for (Opportunity o : Trigger.new)  { 
      o.account_owner_manager_id__c = Managermap.get(acctownermap.get(o.accountid));
      system.debug('P.Name: ' + p.name);
      IF(p.Name != 'System Administrator' && p.Name != 'System Administrator - SSO Enabled'){
      
      o.Last_Modified_By__c = UserInfo.getUserId();
      o.Last_Modified_Date_time__C = system.now();
      system.debug('Last Modified By: ' + o.Last_Modified_By__c + ' = ' + o.lastmodifiedbyid);
      system.debug('Last Modified Date: ' + o.Last_Modified_Date_time__C + ' = ' + o.lastmodifieddate);
      }
   }
   
   OpportunityTriggerHandler.updateProject(trigger.new,trigger.oldMap);
   
}