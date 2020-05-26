/**
 *
 * This helper class is to allow insertion of certain objects without 
 * being affected by the Salesforce sharing model.
 *
 */
public without sharing class cc_imp_hlpr_FileUpload {
	//public static void insertCase(Case c){
	//	insert c;
	//}

	public static void insertNexCare(NexCare__c nexcare){
		insert nexcare;
	}

	public static void insertAttachment(Attachment a){
		insert a;
	}
}