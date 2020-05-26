trigger Update_Chemical_Competitive_Competitor_List on Chemical_Competitive__c (after insert, after update) {
  Nexeo_Competitive_Functions.Update_Chemical_Competitive_Competitor_List(trigger.new);
}