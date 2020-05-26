/**
 *
 * This helper class is to allow insertion of certain objects without 
 * being affected by the Salesforce sharing model. This is used in instances where the 
 * user in context doesn't have enough privileges for creating cases.
 *
 */


public without sharing class cc_imp_hlpr_ContactUsCreateCase 
{

	public static void insertCase(Case c)
	{
		insert c;
	}
	
	public static void insertNexCare(NexCare__c nexcare){
		insert nexcare;
	}

	public static void insertNexCares(List<NexCare__c> nexcares){
		insert nexcares;
	}

	public static void insertCases(List <Case> cases)
	{
		insert cases;
	}

	public static Id getNexCareRecordId() {
		String developerName = 'Requests';
		String objectType = 'NexCare__c';
    	RecordType recordTypeRecord = [Select Id from RecordType Where DeveloperName = :developerName AND SobjectType = :objectType];
    	return recordTypeRecord.Id;
	}
}