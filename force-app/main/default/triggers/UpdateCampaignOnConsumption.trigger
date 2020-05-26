/*The trigger is written to populate Primary Campaign Source based on Account related to consumption.
  @Author Rajeev */
  
 
trigger UpdateCampaignOnConsumption on Consumption__c (before insert,before update) {
  Set<Id> AccIds = new Set<Id>(); 
    for(Consumption__c c : Trigger.new){
      AccIds.add(c.Account_Name__c);
    }
 List<Account_related_to_campaign__c> RelAcc = [Select Account__c, Campaign__c from Account_related_to_campaign__c where Account__c
                                                In :AccIds and Campaign__r.IsActive = True Order by Createddate DESC];
 Map<Id,Id> AccCamMap = new Map<Id,id>();
  for(Account_related_to_campaign__c ac : RelAcc){
      If(!AccCamMap.ContainsKey(ac.Account__c)){
         AccCamMap.put(ac.Account__c,ac.Campaign__c);
       }
     }                                            
 for(Consumption__c cc: Trigger.new){ 
      cc.Campaign__c = AccCamMap.get(cc.Account_Name__c);
   }
}