trigger AddCompetitorToAccounts on Competitor_to_Opportunity__c (before insert) {

    //Create a List of all the OpportunityIds
    List<Id> oppIds = new List<Id>();
    for(Competitor_to_Opportunity__c rec:Trigger.new) {
       oppIds.add(rec.Opportunity__c);
    }

    //Retrieve All Opportunity Accounts
    List<Opportunity> opportunities;
    List<Account> accounts;
    List<Id> acctIds = new List<Id>();
    Map<id,id> OpptoAcct = new Map<id,id>();
    
    opportunities = [SELECT Id, AccountId FROM Opportunity WHERE Id IN :oppIds];
    for(Opportunity rec:opportunities) {
       acctIds.add(rec.AccountId);
       OpptoAcct.put(rec.id,rec.AccountId);
    }

        
    //Retrieve All Competitor_to_Account__c entries for Related Accounts
    List<Competitor_to_Account__c> ComptoAccts;
    ComptoAccts = [SELECT Id, Account__c, Competitor__c FROM Competitor_to_Account__c WHERE Account__c IN :acctIds];
    List<Competitor_to_Account__c> CompetitortoAccountUpdates = new List<Competitor_to_Account__c>();

    for (Integer i = 0; i < Trigger.new.size(); i++) 
        {
        Boolean alreadyExists = false;
        
        for(Competitor_to_Account__c rec:ComptoAccts)
            {
            if ((rec.Account__c == OpptoAcct.get(Trigger.new[i].Opportunity__c)) && (rec.Competitor__c == Trigger.new[i].Competitor__c))
                {alreadyExists = true;}
            }
         
        if (alreadyExists == false)
            {
            Competitor_to_Account__c newCompetitortoAccountUpdate = new Competitor_to_Account__c(Account__c=OpptoAcct.get(Trigger.new[i].Opportunity__c),Competitor__c=Trigger.new[i].Competitor__c);  
            CompetitortoAccountUpdates.add(newCompetitortoAccountUpdate);
            } 
        }
        
    if(CompetitortoAccountUpdates.size() > 0) {insert(CompetitortoAccountUpdates);}
   
//      // Check if the competitor to insert is already associated with the Opportunity. If so, do not add it again
//      // Also, if this is true, then the Competitor should be listed with the account. No need to add it again
//      if (Opportunity_Competitor_Functions.competitorOpportunityAssociated(Trigger.new[i].Opportunity__c, Trigger.new[i].Competitor__c))  {
//         Trigger.new[i].Competitor__c.addError('This Opportunity already has that Competitor listed. You cannot add it more than once');
//      }    
//      else  {
//
//         boolean competitorExistsWithAccount = false;
//         boolean competitorExistsWithParentAccount = false;
//
//         // Get the Id of the Account tied to the Opportunity
//         String accountId = Opportunity_Competitor_Functions.getAccountIdFromOpportunity(Trigger.new[i].Opportunity__c);           
//         if (accountId.length() == 18)
//            accountId = accountId.substring(0, 15);  
//               
//         // Check if the Competitor is already tied to the Account in the Account to Competitor table
//         // If found, then there is no need to add it to the table
//         competitorExistsWithAccount = Opportunity_Competitor_Functions.competitorAccountAssociated(accountId, Trigger.new[i].Competitor__c);      
//         if (!competitorExistsWithAccount)  {
//            Opportunity_Competitor_Functions.insertAccountToCompetitor(accountId, Trigger.new[i].Competitor__c);
//            // Check if account has a Parent Id. If so, see if the Competitor needs to be added to the Parent Account
//            String parentAccountId = Opportunity_Competitor_Functions.getParentAccountId(accountId);
//
//            if (parentAccountId != NULL) {
//               competitorExistsWithParentAccount = Opportunity_Competitor_Functions.competitorAccountAssociated(parentAccountId, Trigger.new[i].Competitor__c);
//               if(!competitorExistsWithParentAccount)
//                  Opportunity_Competitor_Functions.insertAccountToCompetitor(parentAccountId, Trigger.new[i].Competitor__c);
//            }
//         }         
//      }    
//   }
}