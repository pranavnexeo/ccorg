trigger Update_Plastics_Lost_Order_Competitor_List on Plastics_Lost_Order__c (after insert, after update) {
   Nexeo_Competitive_Functions.Update_Plastics_Lost_Order_Competitor_List(trigger.new);
}