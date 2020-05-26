trigger Update_Consumption_Competitor_List on Consumption__c (after insert, after update) {
   Nexeo_Competitive_Functions.Update_Consumption_Competitor_List(trigger.new);
}