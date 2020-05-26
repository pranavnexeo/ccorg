trigger Add_PrimaryCompetitor_To_CompetitorToOpportunity on Opportunity (after insert, before update) {

   Nexeo_Competitive_Functions.Update_Opportunity_List(trigger.new);
   
   List<Id> oppIds = new List<Id>();
   List<Competitor_to_Opportunity__c> CompetitorToOpportunitiesUpdates = new List<Competitor_to_Opportunity__c>();

   // Get the IDs of the Opportunities  
   for(Opportunity o : Trigger.new)
      oppIds.add(o.id);
           
   // Get a list of Competitor_to_Opportunities that contain the Opportunities that have been created/being updated
   List<Competitor_to_Opportunity__c> CompToOpps = [SELECT Id, opportunity__c, competitor__c FROM Competitor_to_Opportunity__c WHERE opportunity__c IN :oppIds];
   
   // Iterate through the Opportunities and determine if a new Competitor_to_Opportunity record needs to be created
   for (Integer i = 0; i < Trigger.new.size(); i++)  {   
      Boolean alreadyExists = false;

      for (Competitor_to_Opportunity__c rec : CompToOpps)  {     
         if (rec.opportunity__c == Trigger.new[i].Id && rec.competitor__c == Trigger.new[i].primary_competitor__c)  {
            alreadyExists = true;
            break;
         }       
      }
      
      if (alreadyExists == false && Trigger.new[i].primary_competitor__c != null)  {
         Competitor_to_Opportunity__c newCompToOpps = new Competitor_to_Opportunity__c(opportunity__c=Trigger.new[i].Id,competitor__c=Trigger.new[i].primary_competitor__c);
         CompetitorToOpportunitiesUpdates.add(newCompToOpps);
      }
   }
   
   // If any, create the new Competitor_to_Opportunities 
   if(!CompetitorToOpportunitiesUpdates.isEmpty())
      insert(CompetitorToOpportunitiesUpdates);

}