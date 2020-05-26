public with sharing class Nexeo_Competitive_Functions{

public static void Update_Chemical_Competitive_Competitor_List(list<chemical_Competitive__c> cclist){

List<Id> ccIds = new List<Id>();
   List<Nexeo_Competitor_to_Chemical_Competative__c> Updates = new List<Nexeo_Competitor_to_Chemical_Competative__c>();
   
   // Get the IDs of the Chemical Competitives 
   for(Chemical_Competitive__c cc : cclist)
      ccIds.add(cc.id);
           
   // Get a list of Chemical_Competative_to_Competitor that contain the Competatives that have been created/being updated
   List<Nexeo_Competitor_to_Chemical_Competative__c> CCtoC = [SELECT Id, Chemical_Competitive__c, Nexeo_Competitor__c FROM Nexeo_Competitor_to_Chemical_Competative__c WHERE Chemical_Competitive__c IN :ccIds];
      
   // Iterate through the Competitives and determine if a new Chemical_Competative_to_Competitor record needs to be created
   for (Integer i = 0; i < cclist.size(); i++)  {   
      Boolean alreadyExists = false;

      for (Nexeo_Competitor_to_Chemical_Competative__c rec : CCtoC)  {     
         if (rec.Chemical_Competitive__c == cclist.get(i).Id && rec.nexeo_competitor__c == cclist.get(i).Nexeo_Competitor__c)  {
            alreadyExists = true;
            break;
         }       
      }
      
      if (alreadyExists == false && cclist.get(i).Nexeo_Competitor__c != null)  {
         Nexeo_Competitor_to_Chemical_Competative__c newcctoc = new Nexeo_Competitor_to_Chemical_Competative__c(Chemical_competitive__c=cclist.get(i).Id,nexeo_competitor__c=cclist.get(i).nexeo_competitor__c);
         Updates.add(newcctoc);
      }
   }
   
  
   // If any, create the new Chemical_Competative_to_Competitor 
   if(!Updates.isEmpty())
      insert(Updates);

}

public static void Update_Consumption_Competitor_List(list<consumption__c> cclist){

List<Id> ccIds = new List<Id>();
   List<Nexeo_Competitor_to_Consumption__c> Updates = new List<Nexeo_Competitor_to_Consumption__c>();
   
   // Get the IDs of the Consumption
   for(consumption__c cc : cclist)
      ccIds.add(cc.id);
           
   // Get a list of Consumption_to_Competitor that contain the Competatives that have been created/being updated
   List<Nexeo_Competitor_to_Consumption__c> CCtoC = [SELECT Id, Consumption__c, Nexeo_Competitor__c FROM Nexeo_Competitor_to_Consumption__c WHERE Consumption__c IN :ccIds];
      
   // Iterate through the Competitives and determine if a new Consumption_to_Competitor record needs to be created
   for (Integer i = 0; i < cclist.size(); i++)  {   
      Boolean alreadyExists = false;

      for (Nexeo_Competitor_to_Consumption__c rec : CCtoC)  {     
         if (rec.Consumption__c == cclist.get(i).Id && rec.nexeo_competitor__c == cclist.get(i).Nexeo_Competitor__c)  {
            alreadyExists = true;
            break;
         }       
      }
      
      if (alreadyExists == false && cclist.get(i).Nexeo_Competitor__c != null)  {
         Nexeo_Competitor_to_Consumption__c newcctoc = new Nexeo_Competitor_to_Consumption__c(Consumption__c=cclist.get(i).Id,nexeo_competitor__c=cclist.get(i).nexeo_competitor__c);
         Updates.add(newcctoc);
      }
   }
   
  
   // If any, create the new Consumption_to_Competitor 
   if(!Updates.isEmpty())
      insert(Updates);

}

public static void Update_Plastics_Lost_Order_Competitor_List(list<Plastics_Lost_Order__c> cclist){

List<Id> ccIds = new List<Id>();
   List<Nexeo_Competitor_to_Plastics_Lost_Order__c> Updates = new List<Nexeo_Competitor_to_Plastics_Lost_Order__c>();
   
   // Get the IDs of the Plastics Lost Orders
   for(Plastics_Lost_Order__c cc : cclist)
      ccIds.add(cc.id);
           
   // Get a list of Plastics_Lost_Order_to_Competitor that contain the Competatives that have been created/being updated
   List<Nexeo_Competitor_to_Plastics_Lost_Order__c> CCtoC = [SELECT Id, Plastics_Lost_Order__c, Nexeo_Competitor__c FROM Nexeo_Competitor_to_Plastics_Lost_Order__c WHERE Plastics_Lost_Order__c IN :ccIds];
      
   // Iterate through the Competitives and determine if a new Plastics_Lost_Order_to_Competitor record needs to be created
   for (Integer i = 0; i < cclist.size(); i++)  {   
      Boolean alreadyExists = false;

      for (Nexeo_Competitor_to_Plastics_Lost_Order__c rec : CCtoC)  {     
         if (rec.Plastics_Lost_Order__c == cclist.get(i).Id && rec.nexeo_competitor__c == cclist.get(i).Nexeo_Competitor__c)  {
            alreadyExists = true;
            break;
         }       
      }
      
      if (alreadyExists == false && cclist.get(i).Nexeo_Competitor__c != null)  {
         Nexeo_Competitor_to_Plastics_Lost_Order__c newcctoc = new Nexeo_Competitor_to_Plastics_Lost_Order__c(Plastics_Lost_Order__c=cclist.get(i).Id,nexeo_competitor__c=cclist.get(i).nexeo_competitor__c);
         Updates.add(newcctoc);
      }
   }
   
  
   // If any, create the new Plastics_Lost_Order_to_Competitor 
   if(!Updates.isEmpty())
      insert(Updates);

}


public static void Update_Opportunity_List(list<Opportunity> cclist){
/*
List<Id> ccIds = new List<Id>();
   List<Nexeo_Competitor_to_Opportunity__c> Updates = new List<Nexeo_Competitor_to_Opportunity__c>();
   
   // Get the IDs of the Chemical Competitives 
   for(Opportunity cc : cclist)
      ccIds.add(cc.id);
           
   // Get a list of Opportunity_to_Competitor that contain the Competatives that have been created/being updated
   List<Nexeo_Competitor_to_Opportunity__c> CCtoC = [SELECT Id, Opportunity__c, Nexeo_Competitor__c FROM Nexeo_Competitor_to_Opportunity__c WHERE Opportunity__c IN :ccIds];
      
   // Iterate through the Competitives and determine if a new Opportunity_to_Competitor record needs to be created
   for (Integer i = 0; i < cclist.size(); i++)  {   
      Boolean alreadyExists = false;

      for (Nexeo_Competitor_to_Opportunity__c rec : CCtoC)  {     
         if (rec.Opportunity__c == cclist.get(i).Id && rec.nexeo_competitor__c == cclist.get(i).Nexeo_Competitor__c)  {
            alreadyExists = true;
            break;
         }       
      }
      
      if (alreadyExists == false && cclist.get(i).Nexeo_Competitor__c != null)  {
         Nexeo_Competitor_to_Opportunity__c newcctoc = new Nexeo_Competitor_to_Opportunity__c(Opportunity__c=cclist.get(i).Id,nexeo_competitor__c=cclist.get(i).nexeo_competitor__c);
         Updates.add(newcctoc);
      }
   }
   
  
   // If any, create the new Opportunity_to_Competitor 
   if(!Updates.isEmpty())
      insert(Updates);
*/
}

}