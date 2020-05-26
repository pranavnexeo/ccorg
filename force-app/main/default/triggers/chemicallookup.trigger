trigger chemicallookup on Competitive_Analysis_Report__c(before insert) {
    for(Competitive_Analysis_Report__c objective: Trigger.new){
    
  if(objective.Requester__c!='' )
  {
  objective.Ownerid = objective.Requester__c;
  
  }
  
    }
}