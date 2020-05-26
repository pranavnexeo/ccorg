/**
 *
 * This helper class is to allow fetching of account and contact records without 
 * being affected by the Salesforce sharing model. This is used for triggers where the 
 * user in context doesn't have enough privileges for fetching accounts nor updating contact records.
 *
 */

public without sharing class cc_imp_hlpr_TriggerHelper 
{
	public cc_imp_hlpr_TriggerHelper() 
	{
		
	}

	public static List<Contact> fetchContactAndAccountFieldsForNexeo3D(Set <Id> contactIdList)
	{
       return      [ SELECT  Id,
						 signupNewsLetterFlag__c ,      										 
						 Account.ccrz__CustomField1__c,
						 Account.ccrz__CustomField2__c       										 
				  FROM 
				        Contact 
				  WHERE 
				     ID IN : contactIdList ] ;

	 }



	public static List<Contact> fetchContactAndAccountFieldsForMyNexeo(Set <Id> contactIdList)
	{
       return  [SELECT   Id,
						 NAME,
						 PHONE,
						 EMAIL,
						 Account.ID,
						 Account.ccrz__CustomField1__c,
						 Account.ccrz__CustomField2__c,
						 Account.Name,
						 Account.Primary_Seller__c ,
						 Account.Prospect_Sales_Org__c,
						 Account.Prospect_Dist_Channel__c,
						 Account.Prospect_Division__c,
						 Account.Prospect_Sales_District__c,
						 Account.Prospect_Sales_Office__c,
						 Account.Prospect_Sales_Group__c,
						 Account.ccrz__TaxExemptAccount__c,
						 Account.Type,
						 Account.BillingStreet,
						 Account.BillingCity,
						 Account.BillingCountry,
						 Account.BillingPostalCode,
						 Account.BillingState,
						 Account.ShippingStreet,
						 Account.ShippingCity,
						 Account.ShippingCountry,
						 Account.ShippingPostalCode,
						 Account.ShippingState
				  FROM 
				      Contact 
				  WHERE 
				     Id IN : contactIdList];
  }


  public static void updateContacts(List <Contact> contactList)
	{
		update contactList;
	}

}