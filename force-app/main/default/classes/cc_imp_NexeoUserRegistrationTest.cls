@isTest
private class  cc_imp_NexeoUserRegistrationTest 
{
	/*
	@isTest static void testNexeo3DUserRegistrationWithVATAndSignUpFlag() 
	{
		List <cc_imp_StorefrontSettings__c> customSettingLists = cc_imp_testUtils.createNexeoCustomSettingList();

        insert customSettingLists;

	    User nexeo3dGuestUser  = [SELECT ID FROM USER WHERE username = :cc_imp_testUtils.NEXEO_3D_GUEST_USERNAME];

        System.runAs(nexeo3dGuestUser)
        {
	        Test.startTest();

			ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
			insert userAccountGroup;

			User accountOwner =  [SELECT Id, name from User where userName = 'customerportal@nexeocolutions.com'];
			Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
			userAccount.OwnerId = accountOwner.Id;

			String vatNumberString =  '1234567890'; 
			String signUpForNewsLetterFlag =  'true';

			userAccount.ccrz__CustomField1__c = vatNumberString;
			userAccount.ccrz__CustomField2__c = signUpForNewsLetterFlag;

			insert userAccount;

			NexeoUserRegHelperTest testHelper = new NexeoUserRegHelperTest();

			Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');

			String contactId = testHelper.insertContact(userContact);

			testHelper.insertUser(cc_imp_testUtils.NEXEO3D_USER_COMMUNITY_PROFILE,userContact);

			Contact contact =  testHelper.fetchAccountAndContactForNexeo3D(contactId);

			System.assertEquals(Boolean.valueOf(signUpForNewsLetterFlag),contact.signupNewsLetterFlag__c);
			System.assertEquals(vatNumberString,contact.Account.VAT_Number__c);

		    Test.stopTest();
	    }
	   
	}
	

	@isTest static void testNexeo3DUserRegistrationWithoutVATAndSignUpFlag() 
	{
		List <cc_imp_StorefrontSettings__c> customSettingLists = cc_imp_testUtils.createNexeoCustomSettingList();

        insert customSettingLists;

		 User nexeo3dGuestUser  = [SELECT ID FROM USER WHERE username = :cc_imp_testUtils.NEXEO_3D_GUEST_USERNAME];

        System.runAs(nexeo3dGuestUser)
        {
		    Test.startTest();
	
			ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
			insert userAccountGroup;

			User accountOwner =  [SELECT Id, name from User where userName = 'customerportal@nexeocolutions.com'];

			Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
			userAccount.OwnerId = accountOwner.Id;
			insert userAccount;

			Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');

			NexeoUserRegHelperTest testHelper = new NexeoUserRegHelperTest();

			String contactId = testHelper.insertContact(userContact);

			testHelper.insertUser(cc_imp_testUtils.NEXEO3D_USER_COMMUNITY_PROFILE,userContact);

	        Contact contact =  testHelper.fetchAccountAndContactForNexeo3D(contactId);

		    System.assertEquals(null,contact.Account.VAT_Number__c);
		    System.assertNotEquals(contact.signupNewsLetterFlag__c,Boolean.valueOf('true'));

		    Test.stopTest();
	    }	    
	}



	@isTest static void testMyNexeoUserRegistration() 
	{
		List <cc_imp_StorefrontSettings__c> customSettingLists = cc_imp_testUtils.createNexeoCustomSettingList();
		
        insert customSettingLists;

		// User myNexeoGuestUser  = [SELECT ID FROM USER WHERE username = :cc_imp_testUtils.MYNEXEO_GUEST_USERNAME];
		Profile p = [SELECT Id from Profile WHERE Name = 'mynexeo Profile'];
		User myNexeoGuestUser = new User(
			Alias = 'tuser', 
			Email = 'tuser@nexeosolutions.com',
			EmailEncodingKey = 'UTF-8',
			FirstName = 'fname',
			LastName = 'tuser',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			UserName = 'tuser@nexeosolutions.com',
			TimeZoneSidKey    = 'GMT',
			ProfileID         = p.id
		);

        System.runAs(myNexeoGuestUser)
        {
        	Test.startTest();

			ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
			insert userAccountGroup;
	       
			Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
			userAccount.ccrz__CustomField1__c ='true';

			insert userAccount;

			Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');

			NexeoUserRegHelperTest testHelper = new NexeoUserRegHelperTest();
			testHelper.insertContact(userContact);

		    testHelper.insertUser(cc_imp_testUtils.MYNEXEO_USER_COMMUNITY_PROFILE,userContact);

			Contact contact  = testHelper.fetchContactAndAccountForMyNexeoTest(userContact.id);		               

			Account account =  contact.Account;

			Case myCase = testHelper.fetchCreatedCase(account.ID);

			 cc_imp_StorefrontSettings__C storefrontSettings =  cc_imp_StorefrontSettings__C.getInstance('MyNexeo');

	   		 String primarySellerDefault = storefrontSettings.DefaultPrimarySellerUserId__c;

		     Id caseAssignmentGroupId =  cc_imp_util_Storefront.getQueueIdByName(storefrontSettings.Default_CSR_Queue_Name__c);

			 User defaultPrimarySeller =  [SELECT Id, name from User where userName = :primarySellerDefault];

			 Id recordTypeId =  cc_imp_util_Storefront.getRecordTypeIdByNameAndSObjectType(storefrontSettings.RecordTypeName__c, 'Account');

			 System.assertEquals(myCase.AccountId,account.ID);
			 System.assertEquals(myCase.ContactId,userContact.ID);
		     System.assertEquals(myCase.OwnerId,caseAssignmentGroupId);

		     System.assertEquals(account.Primary_Seller__c,defaultPrimarySeller.Id);
		     System.assertEquals(account.Prospect_Sales_Org__c,storefrontSettings.ProspectSalesOrg__c);
		     System.assertEquals(account.Prospect_Dist_Channel__c,storefrontSettings.DistributionChannel__c );
		     System.assertEquals(account.Prospect_Division__c,storefrontSettings.Division__c );
		     System.assertEquals(account.Prospect_Sales_District__c,storefrontSettings.SalesDistrict__c);
		     System.assertEquals(account.Prospect_Sales_Office__c,storefrontSettings.SalesOffice__c );
		     System.assertEquals(account.Prospect_Sales_Group__c,storefrontSettings.SalesGroup__c );
		     System.assertEquals(account.RecordTypeId,recordTypeId);
		     System.assertEquals(account.Type,'Prospect');

		     Test.stopTest();
        }

	}



	private without sharing  class NexeoUserRegHelperTest 
	{
		private  Contact fetchAccountAndContactForNexeo3D (String contactId)
		{
			 return [ SELECT  Id,   										 
							  Account.VAT_Number__c,
							  signupNewsLetterFlag__c     										 
					   FROM 
							  Contact 
						WHERE 
							  ID =: contactId] ;
		}


		private ID insertContact (Contact contact)
		{
			insert contact;

			return contact.ID;
		}

		private void insertUser(String profileName, Contact userContact)
		{
			Profile userProfile = [SELECT Id, name from Profile where Name = :profileName];

			User user = cc_imp_testUtils.createUser(userProfile, userContact, 
				'username@email.com', 'contact@email.com', 'firstName', 'lastName', 'alias');

		    insert user;
		}


		private Case fetchCreatedCase(String accountId)
		{
			 List <Case> cases = [SELECT ID,
			 						 AccountID,
			 						 ContactID,
			 						 OwnerId 
				 				  FROM CASE
				 				  WHERE 
				 				  	AccountID = :accountId];	

			 return cases.get(0);
		}


		private Contact fetchContactAndAccountForMyNexeoTest( String contactID)
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
						 Account.ShippingState,
						 Account.RecordTypeId
				  FROM 
				      Contact 
				  WHERE 
				     Id = : contactID];
		}
	} 
	*/
}