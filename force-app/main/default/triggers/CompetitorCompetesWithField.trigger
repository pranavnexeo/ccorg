trigger CompetitorCompetesWithField on Competitor_to_Account__c (after insert, after delete) {
   
	Integer size = 0;

	List<Competitor_to_Account__c> recsToProcess;	   
	List<Account> accounts;
	List<Competitor__c> competitors; 
	List<Id> accountIds = new List<Id>();
	List<Id> competitorIds = new List<Id>();
	Map<Id,String> AccountRecTypeLookup;
	Map<Id,String> CompetitorLookup;
	List<Competitor__c> CompetitorUpdates = new List<Competitor__c>();
	
   
    if (Trigger.isInsert)
		recsToProcess = Trigger.new;
    else
    	recsToProcess = Trigger.old;

	size = recsToProcess.size();
	for(Competitor_to_Account__c rec:recsToProcess) {accountIds.add(rec.Account__c);competitorIds.add(rec.Competitor__c);}

	accounts = Competitor_to_Account_Functions.getAccounts(accountIds);
	competitors = Competitor_to_Account_Functions.getCompetitors(competitorIds);
	AccountRecTypeLookup = Competitor_to_Account_Functions.BuildAccountRecTypeLookup(accounts);
	CompetitorLookup = Competitor_to_Account_Functions.BuildCompetitorLookup(competitors);

	String recType = '';
	String competesWith = '';
	String competesWith_New = '';
      
    for (Competitor_to_Account__c rec:recsToProcess)  
    	{
    	recType = AccountRecTypeLookup.get(rec.Account__c);
    	competesWith = CompetitorLookup.get(rec.Competitor__c);
    	if (competesWith==null) {competesWith='';}
    	
    	
        // Add the Line of Business to the Competes_With field if it is not already there
        if (Trigger.isAfter && Trigger.isInsert)  
        	{
        	if(recType != '')  
        		{           
            	// insert the entry into the Competes_With__c field
				if (competesWith.contains(recType) == false)
					{
					Boolean updateExists = false;
					for(Competitor__c c:CompetitorUpdates) 
					    {if(c.Id==rec.Competitor__c) {updateExists=true;
					    	                          if(c.Competes_With__c.contains(recType)==false) 
					    	                            {c.Competes_With__c+=';'+recType;}
					    	                         }
					    }
					if (updateExists == false)
						{ 
						if(competesWith=='') {competesWith_New = recType;} else {competesWith_New = competesWith + ';' + recType;}
						Competitor__c newCompetitorUpdate = new Competitor__c(id=rec.Competitor__c,Competes_With__c=competesWith_New);  
						CompetitorUpdates.add(newCompetitorUpdate);
						}
					}
         		}
      		}
      	
		// Delete the Line of Business from the Competes_With field if there is no other account tied
		// to the Competitor from the same Line of Business
		else if (Trigger.isAfter && Trigger.isDelete)  
			{
			// If There is a mass deletion, there will be too much processing to do more than one
			if (recsToProcess.size() == 1)
				{
				if(recType != '')
					{
					//Retrieve all other Competitor_to_Account__c Records, excluding current rec
					List<Competitor_to_Account__c> otherRecs = [SELECT Id, 
					                                                   Account__c, 
					                                                   Competitor__c 
					                                              FROM Competitor_to_Account__c 
					                                             WHERE Competitor__c = :rec.Competitor__c 
					                                               AND id <> :rec.Id LIMIT 400];
					List<Id> otherAccountIds = new List<Id>();
					for(Competitor_to_Account__c otherRec:otherRecs) {otherAccountIds.add(otherRec.Account__c);}
					
					//Create necessary fields from Account
					List<Account> otherAccounts = [SELECT Id, 
										                  RecordType.Name, 
										                  SAP_DistChannel__c, 
										                  SAP_Division_Desc__c, 
										                  SAP_Sales_District_Desc__c
										             FROM Account
										            WHERE Id IN :otherAccountIds LIMIT 400];
										            
					//Run RecType processing to build a list
					Map<Id,String> otherAccountRecTypeLookup = Competitor_to_Account_Functions.BuildAccountRecTypeLookup(otherAccounts);
					
					//Rebuild Competes_With with list minus current Account
					competesWith_New = '';
					for(Account otherAccount:otherAccounts)
						{
						String currRecType = otherAccountRecTypeLookup.get(otherAccount.Id);
						if (competesWith_New.contains(currRecType) == false)
							{
							if (competesWith_New == '') 
								{competesWith_New = currRecType;} 
							else 
								{competesWith_New += ';' + currRecType;}
							}
						}
						
					//Create Update Record
					if (competesWith != competesWith_New)
						{
						Competitor__c newCompetitorUpdate = new Competitor__c(id=rec.Competitor__c,Competes_With__c=competesWith_New);  
						CompetitorUpdates.add(newCompetitorUpdate);
						} 
					}
				}
       		}
    	}
    if (CompetitorUpdates.size() > 0) {update(CompetitorUpdates);}
}