public with sharing class cc_imp_dao_User {

	/**
	 *
	 * Query User records and associated Contact data for the specified accounts
	 *
	 */
	public static Map<Id, User> queryUsersForAccounts(Set<Id> accountIds){
		return new Map<Id, User>([
			SELECT
				Id
				, Username
				, IsActive
				, ProfileId
				, LocaleSidKey 
				, TimeZoneSidKey
				, LanguageLocaleKey
				, EmailEncodingKey	
				, ContactId
				, Contact.Firstname
				, Contact.Lastname
				, Contact.Email
				, Contact.Phone
				, Contact.AccountId
				, Contact.cc_imp_Is_MyNexeo_Admin__c
			FROM
				User
			WHERE
				Contact.AccountId in :accountIds
		]);

	}

	public static User queryUserForUserId(Id userId){
		return [
			SELECT
				Id
				, Username
				, IsActive
				, ProfileId
				, LocaleSidKey 
				, TimeZoneSidKey
				, LanguageLocaleKey
				, EmailEncodingKey	
				, ContactId
				, Contact.Firstname
				, Contact.Lastname
				, Contact.Email
				, Contact.Phone
				, Contact.AccountId
				, Contact.cc_imp_Is_MyNexeo_Admin__c
			FROM
				User
			WHERE
				Id = :userId
			LIMIT
				1
		];

	}


	public static User queryUserForContactId(Id contactId){
		return [
			SELECT
				Id
				, Username
				, IsActive
				, ProfileId
				, LocaleSidKey 
				, TimeZoneSidKey
				, LanguageLocaleKey
				, EmailEncodingKey	
				, ContactId
				, Contact.Firstname
				, Contact.Lastname
				, Contact.Email
				, Contact.Phone
				, Contact.AccountId
				, Contact.cc_imp_Is_MyNexeo_Admin__c
			FROM
				User
			WHERE
				ContactId = :contactId
			LIMIT
				1
		];

	}
}