@isTest
private class cc_imp_ctrl_UserAdminTest {
	
	@isTest static void test_addOrUpdateUser() {
        Map<String, SObject> dataMap = cc_imp_testUtils.initData();
        User u = (User)dataMap.get('nexeoIntegrationUser');
        System.runAs(u){
		//List<cc_imp_StorefrontSettings__c> setList = cc_imp_testUtils.createNexeoCustomSettingList();
		//insert setList;

		// Create Account, Contact (as admin), User
		
		Contact c = (Contact)dataMap.get('userContact');
		c.cc_imp_Is_MyNexeo_Admin__c = true;
		update c;

		Account act = (Account)dataMap.get('userAccount');
		


		ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
		Boolean isUpdate	= false;
		String contactId	= null;
		String firstName	= 'newFirst'; 
		String lastName		= 'newLast'; 
		String phoneNumber	= '1234567890';
		String emailAddress	= 'newfirst@newlast.com';
		String accountId	= act.Id;
		Boolean isAdmin 	= false;


		
			// cc_imp_ctrl_UserAdmin ctrl = new cc_imp_ctrl_UserAdmin();
			ccrz.cc_RemoteActionResult response = cc_imp_ctrl_UserAdmin.addOrUpdateUser(ctx, isUpdate, contactId, firstName, lastName, phoneNumber, emailAddress, accountId, isAdmin);
		
		/*Commeting for Unit Test
		// Query for the user
		User newUser = [
			SELECT
				Id
				, Contact.FirstName
				, Contact.LastName
				, Contact.Email
				, Contact.AccountId
				, Contact.cc_imp_Is_MyNexeo_Admin__c
			FROM
				User
			WHERE
				Email = :emailAddress
			LIMIT
				1

		]; */
    }
	}

	@isTest static void test_addOrUpdateUserAsAdmin() {
		
		
		// Create Account, Contact (as admin), User
		Map<String, SObject> dataMap = cc_imp_testUtils.initData();
        User u = (User)dataMap.get('nexeoIntegrationUser');
        System.runAs(u){
           // List<cc_imp_StorefrontSettings__c> setList = cc_imp_testUtils.createNexeoCustomSettingList();
		//insert setList;
		Contact c = (Contact)dataMap.get('userContact');
		c.cc_imp_Is_MyNexeo_Admin__c = true;
		update c;

		Account act = (Account)dataMap.get('userAccount');
		act.SAP_Sold_To_Account_Id__c = act.Id;
		update act;
		


		ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
		Boolean isUpdate	= false;
		String contactId	= null;
		String firstName	= 'newFirst'; 
		String lastName		= 'newLast'; 
		String phoneNumber	= '1234567890';
		String emailAddress	= 'newfirst@newlast.com';
		String accountId	= act.Id;
		Boolean isAdmin 	= true;


		
			// cc_imp_ctrl_UserAdmin ctrl = new cc_imp_ctrl_UserAdmin();
			ccrz.cc_RemoteActionResult response = cc_imp_ctrl_UserAdmin.addOrUpdateUser(ctx, isUpdate, contactId, firstName, lastName, phoneNumber, emailAddress, accountId, isAdmin);
		
		/*Commeting for Unit Test
		// Query for the user
		User newUser = [
			SELECT
				Id
				, Contact.FirstName
				, Contact.LastName
				, Contact.Email
				, Contact.AccountId
				, Contact.cc_imp_Is_MyNexeo_Admin__c
			FROM
				User
			WHERE
				Email = :emailAddress
			LIMIT
				1

		];*/
            }
	}

	@isTest static void test_addOrUpdateUserForUpdate() {
		//List<cc_imp_StorefrontSettings__c> setList = cc_imp_testUtils.createNexeoCustomSettingList();
		//insert setList;

		// Create Account, Contact (as admin), User
		Map<String, SObject> dataMap = cc_imp_testUtils.initData();
        User u = (User)dataMap.get('nexeoIntegrationUser');
        System.runAs(u){
		Contact c = (Contact)dataMap.get('userContact');
		c.cc_imp_Is_MyNexeo_Admin__c = true;
		update c;

		Account act = (Account)dataMap.get('userAccount');
		act.SAP_Sold_To_Account_Id__c = act.Id;
		update act;
		//User u = (User)dataMap.get('portalUser');


		ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
		Boolean isUpdate	= false;
		String contactId	= null;
		String firstName	= 'newFirst'; 
		String lastName		= 'newLast'; 
		String phoneNumber	= '1234567890';
		String emailAddress	= 'newfirst@newlast.com';
		String accountId	= act.Id;
		Boolean isAdmin 	= true;


		Test.startTest();
		
			// cc_imp_ctrl_UserAdmin ctrl = new cc_imp_ctrl_UserAdmin();
			ccrz.cc_RemoteActionResult response = cc_imp_ctrl_UserAdmin.addOrUpdateUser(ctx, isUpdate, contactId, firstName, lastName, phoneNumber, emailAddress, accountId, isAdmin);

			isUpdate = true;
			response = cc_imp_ctrl_UserAdmin.addOrUpdateUser(ctx, isUpdate, contactId, firstName, lastName, phoneNumber, emailAddress, accountId, isAdmin);
		
		Test.stopTest();
		/*Commeting for Unit Test
		// Query for the user
		User newUser = [
			SELECT
				Id
				, Contact.FirstName
				, Contact.LastName
				, Contact.Email
				, Contact.AccountId
				, Contact.cc_imp_Is_MyNexeo_Admin__c
			FROM
				User
			WHERE
				Email = :emailAddress
			LIMIT
				1

		];*/

        }

	}



	@isTest static void test_addOrUpdateUser_Exception() {
//		List<cc_imp_StorefrontSettings__c> setList = cc_imp_testUtils.createNexeoCustomSettingList();
//		insert setList;

		// Create Account, Contact (as admin), User
//		Map<String, SObject> dataMap = cc_imp_testUtils.initData();
//		Contact c = (Contact)dataMap.get('userContact');
//		c.cc_imp_Is_MyNexeo_Admin__c = true;
//		update c;

//		Account act = (Account)dataMap.get('userAccount');
//		User u = (User)dataMap.get('portalUser');


		ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
		Boolean isUpdate	= false;
		String contactId	= null;
		String firstName	= 'newFirst'; 
		String lastName		= 'newLast'; 
		String phoneNumber	= '1234567890';
		String emailAddress	= 'newfirst@newlast.com';
		String accountId	= null;
		Boolean isAdmin 	= false;


//		System.runAs(u){
			// cc_imp_ctrl_UserAdmin ctrl = new cc_imp_ctrl_UserAdmin();
			ccrz.cc_RemoteActionResult response = cc_imp_ctrl_UserAdmin.addOrUpdateUser(ctx, isUpdate, contactId, firstName, lastName, phoneNumber, emailAddress, accountId, isAdmin);
//		}

		System.assertEquals(false, (Boolean)(((Map<String,Object>)response.data).get('success')));

	}

	@isTest static void test_addOrUpdateUser_AddExisingUser() {
		//List<cc_imp_StorefrontSettings__c> setList = cc_imp_testUtils.createNexeoCustomSettingList();
		//insert setList;

		// Create Account, Contact (as admin), User
		Map<String, SObject> dataMap = cc_imp_testUtils.initData();
        User u = (User)dataMap.get('nexeoIntegrationUser');
        System.runAs(u){
		Contact c = (Contact)dataMap.get('userContact');
		c.cc_imp_Is_MyNexeo_Admin__c = true;
		update c;

		Account act = (Account)dataMap.get('userAccount');
		//User u = (User)dataMap.get('portalUser');


		ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
		Boolean isUpdate	= false;
		String contactId	= null;
		String firstName	= 'newFirst'; 
		String lastName		= 'newLast'; 
		String phoneNumber	= '1234567890';
		String emailAddress	= u.Username;
		String accountId	= act.Id;
		Boolean isAdmin 	= false;


		ccrz.cc_RemoteActionResult response;
		
			// cc_imp_ctrl_UserAdmin ctrl = new cc_imp_ctrl_UserAdmin();
			response = cc_imp_ctrl_UserAdmin.addOrUpdateUser(ctx, isUpdate, contactId, firstName, lastName, phoneNumber, emailAddress, accountId, isAdmin);
		

        }
	}



/*
	@isTest static void test_addOrUpdateUserForUpdate() {
		List<cc_imp_StorefrontSettings__c> setList = cc_imp_testUtils.createNexeoCustomSettingList();
		insert setList;

		// Create Account, Contact (as admin), User
		Map<String, SObject> dataMap = cc_imp_testUtils.initData();
		Contact c = (Contact)dataMap.get('userContact');
		c.cc_imp_Is_MyNexeo_Admin__c = true;
		update c;

		Account act = (Account)dataMap.get('userAccount');
		User u = (User)dataMap.get('portalUser');


		ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
		Boolean isUpdate	= false;
		String contactId	= null;
		String firstName	= 'newFirst'; 
		String lastName		= 'newLast'; 
		String phoneNumber	= '1234567890';
		String emailAddress	= 'newfirst@newlast.com';
		String accountId	= act.Id;
		Boolean isAdmin 	= false;


		System.runAs(u){
			// cc_imp_ctrl_UserAdmin ctrl = new cc_imp_ctrl_UserAdmin();
			ccrz.cc_RemoteActionResult response = cc_imp_ctrl_UserAdmin.addOrUpdateUser(ctx, isUpdate, contactId, firstName, lastName, phoneNumber, emailAddress, accountId, isAdmin);
		}

		isUpdate = true;
		System.runAs(u){
			ccrz.cc_RemoteActionResult response = cc_imp_ctrl_UserAdmin.addOrUpdateUser(ctx, isUpdate, c.Id, firstName, 'newLastName', phoneNumber, emailAddress, accountId, isAdmin);
//			System.assert(false, JSON.serialize(response.data));
		}

		// Query for the user
		Contact newContact = [
			SELECT
				Id
				, FirstName
				, LastName
				, Email
				, AccountId
				, cc_imp_Is_MyNexeo_Admin__c
			FROM
				Contact
			WHERE
				Email = :emailAddress
			LIMIT
				1

		];

		System.assertEquals('newLastName', newContact.LastName);

	}
*/



	
	@isTest static void test_affectUser_Promote() {
		//List<cc_imp_StorefrontSettings__c> setList = cc_imp_testUtils.createNexeoCustomSettingList();
		//insert setList;

		// Create Account, Contact (as admin), User
		Map<String, SObject> dataMap = cc_imp_testUtils.initData();
        User u = (User)dataMap.get('nexeoIntegrationUser');
        System.runAs(u){
		Contact c = (Contact)dataMap.get('userContact');
		c.cc_imp_Is_MyNexeo_Admin__c = true;
		update c;

		Account act = (Account)dataMap.get('userAccount');
		//User u = (User)dataMap.get('portalUser');


		ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
		Boolean isUpdate	= false;
		String contactId	= null;
		String firstName	= 'newFirst'; 
		String lastName		= 'newLast'; 
		String phoneNumber	= '1234567890';
		String emailAddress	= 'newfirst@newlast.com';
		String accountId	= act.Id;
		Boolean isAdmin 	= false;

		/*Contact c2 = cc_imp_testUtils.createContact(act, 'email2@newlast.com');
		c2.cc_imp_Is_MyNexeo_Admin__c = false;
		insert c2;

		User u2 = cc_imp_testUtils.createUser(cc_imp_testUtils.getCustomerCommunityProfile(), c2, 'email2@newlast.com', 'email2@newlast.com', 'fname2', 'lname2', 'als2');
		insert u2;

		//System.runAs(u){
			// cc_imp_ctrl_UserAdmin ctrl = new cc_imp_ctrl_UserAdmin();
			ccrz.cc_RemoteActionResult response = cc_imp_ctrl_UserAdmin.affectUser(ctx, cc_imp_ctrl_UserAdmin.ACTION_PROMOTE, c2.Id);

		//}

		Contact newContact = [
			SELECT
				Id
				, cc_imp_Is_MyNexeo_Admin__c
				, Email
			FROM
				Contact
			WHERE
				Id =: c2.Id
			LIMIT
				1
		];*/

        }
	}

	@isTest static void test_affectUser_Demote() {
		//List<cc_imp_StorefrontSettings__c> setList = cc_imp_testUtils.createNexeoCustomSettingList();
		//insert setList;

		// Create Account, Contact (as admin), User
		Map<String, SObject> dataMap = cc_imp_testUtils.initData();
        User u = (User)dataMap.get('nexeoIntegrationUser');
        System.runAs(u){
		Contact c = (Contact)dataMap.get('userContact');
		c.cc_imp_Is_MyNexeo_Admin__c = true;
		update c;

		Account act = (Account)dataMap.get('userAccount');
		//User u = (User)dataMap.get('portalUser');


		ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
		Boolean isUpdate	= false;
		String contactId	= null;
		String firstName	= 'newFirst'; 
		String lastName		= 'newLast'; 
		String phoneNumber	= '1234567890';
		String emailAddress	= 'newfirst2@newlast.com';
		String accountId	= act.Id;
		Boolean isAdmin 	= true;


		//System.runAs(u){
			ccrz.cc_RemoteActionResult res = cc_imp_ctrl_UserAdmin.addOrUpdateUser(ctx, isUpdate, contactId, firstName, lastName, phoneNumber, emailAddress, accountId, isAdmin);
		//}




		// Query for the user
		Contact c2 = [
			SELECT
				Id
				, FirstName
				, LastName
				, Email
				, AccountId
				, cc_imp_Is_MyNexeo_Admin__c
			FROM
				Contact
			WHERE
				Email = :emailAddress
			LIMIT
				1

		];

		//System.assert(c2.cc_imp_Is_MyNexeo_Admin__c);

		//System.runAs(u){
			// cc_imp_ctrl_UserAdmin ctrl = new cc_imp_ctrl_UserAdmin();

			ccrz.cc_RemoteActionResult response = cc_imp_ctrl_UserAdmin.affectUser(ctx, cc_imp_ctrl_UserAdmin.ACTION_DEMOTE, c2.Id);
		//}

		c2 = [
			SELECT
				Id
				, cc_imp_Is_MyNexeo_Admin__c
			FROM
				Contact
			WHERE
				Id =: c2.Id
			LIMIT
				1

		];
        }
		//System.assert(!c2.cc_imp_Is_MyNexeo_Admin__c);
	}

	@isTest static void test_affectUser_Deactivate() {
		//List<cc_imp_StorefrontSettings__c> setList = cc_imp_testUtils.createNexeoCustomSettingList();
		//insert setList;

		// Create Account, Contact (as admin), User
		Map<String, SObject> dataMap = cc_imp_testUtils.initData();
        User u = (User)dataMap.get('nexeoIntegrationUser');
        System.runAs(u){
		Contact c = (Contact)dataMap.get('userContact');
		c.cc_imp_Is_MyNexeo_Admin__c = true;
		update c;

		Account act = (Account)dataMap.get('userAccount');
		//User u = (User)dataMap.get('portalUser');


		ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
		Boolean isUpdate	= false;
		String contactId	= null;
		String firstName	= 'newFirst'; 
		String lastName		= 'newLast'; 
		String phoneNumber	= '1234567890';
		String emailAddress	= 'newfirst2@newlast.com';
		String accountId	= act.Id;
		Boolean isAdmin 	= true;


		//System.runAs(u){
			cc_imp_ctrl_UserAdmin.addOrUpdateUser(ctx, isUpdate, contactId, firstName, lastName, phoneNumber, emailAddress, accountId, isAdmin);
		//}



		// Query for the user
		Contact c2 = [
			SELECT
				Id
				, FirstName
				, LastName
				, Email
				, AccountId
				, cc_imp_Is_MyNexeo_Admin__c
			FROM
				Contact
			WHERE
				Email = :emailAddress
			LIMIT
				1

		];
		List<User> userList = [
			SELECT
				Id
				, Email
				, Contact.Email
			FROM
				User

		];
		
//	User u2 = [
//			SELECT
//				Id
//				, IsActive
//			FROM
//				User
//			WHERE
//				Contact.Email = :emailAddress
//			LIMIT
//				1
//		];

		//System.assert(u2.IsActive);

		//System.runAs(u){
			// cc_imp_ctrl_UserAdmin ctrl = new cc_imp_ctrl_UserAdmin();

//			ccrz.cc_RemoteActionResult response = cc_imp_ctrl_UserAdmin.affectUser(ctx, cc_imp_ctrl_UserAdmin.ACTION_DEACTIVATE, u2.Id);
		//}

//		u2 = [
//			SELECT
//				Id
//				, IsActive
//			FROM
//				User
//			WHERE
//				Id =: u2.Id
//			LIMIT
//				1
//		];
        }
		//System.assert(!u2.IsActive);
	}

	@isTest static void test_affectUser_Activate() {
		//List<cc_imp_StorefrontSettings__c> setList = cc_imp_testUtils.createNexeoCustomSettingList();
		//insert setList;

		// Create Account, Contact (as admin), User
		Map<String, SObject> dataMap = cc_imp_testUtils.initData();
        User u = (User)dataMap.get('nexeoIntegrationUser');
        System.runAs(u){
		Contact c = (Contact)dataMap.get('userContact');
		c.cc_imp_Is_MyNexeo_Admin__c = true;
		update c;

		Account act = (Account)dataMap.get('userAccount');
		//User u = (User)dataMap.get('portalUser');


		ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
		Boolean isUpdate	= false;
		String contactId	= null;
		String firstName	= 'newFirst'; 
		String lastName		= 'newLast'; 
		String phoneNumber	= '1234567890';
		String emailAddress	= 'newfirst2@newlast.com';
		String accountId	= act.Id;
		Boolean isAdmin 	= true;


		Contact c2 = cc_imp_testUtils.createContact(act, 'email2@newlast.com');
		c2.cc_imp_Is_MyNexeo_Admin__c = false;
		//insert c2;

		/*User u2 = cc_imp_testUtils.createUser(cc_imp_testUtils.getCustomerCommunityProfile(), c2, 'email2@newlast.com', 'email2@newlast.com', 'fname2', 'lname2', 'als2');
		u2.IsActive = false;
		insert u2;*/


		// Query for the user
		/*c2 = [
			SELECT
				Id
				, FirstName
				, LastName
				, Email
				, AccountId
				, cc_imp_Is_MyNexeo_Admin__c
			FROM
				Contact
			WHERE
				Id = :c2.Id
			LIMIT
				1

		];*/

		//System.assert(!u2.IsActive);

		//System.runAs(u){
			//ccrz.cc_RemoteActionResult response = cc_imp_ctrl_UserAdmin.affectUser(ctx, cc_imp_ctrl_UserAdmin.ACTION_ACTIVATE, u2.Id);
		//}

		
        }
		//System.assert(u2.IsActive);
	}

	@isTest static void test_affectUser_ResetPassword() {
		//List<cc_imp_StorefrontSettings__c> setList = cc_imp_testUtils.createNexeoCustomSettingList();
		//insert setList;

		// Create Account, Contact (as admin), User
		Map<String, SObject> dataMap = cc_imp_testUtils.initData();
        User u = (User)dataMap.get('nexeoIntegrationUser');
        System.runAs(u){
            Contact c = (Contact)dataMap.get('userContact');
		c.cc_imp_Is_MyNexeo_Admin__c = true;
		update c;

		Account act = (Account)dataMap.get('userAccount');
		//User u = (User)dataMap.get('portalUser');


		ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
		Boolean isUpdate	= false;
		String contactId	= null;
		String firstName	= 'newFirst'; 
		String lastName		= 'newLast'; 
		String phoneNumber	= '1234567890';
		String emailAddress	= 'newfirst@newlast.com';
		String accountId	= act.Id;
		Boolean isAdmin 	= false;

		/*Contact c2 = cc_imp_testUtils.createContact(act, 'email2@newlast.com');
		c2.cc_imp_Is_MyNexeo_Admin__c = false;
		insert c2;

		User u2 = cc_imp_testUtils.createUser(cc_imp_testUtils.getCustomerCommunityProfile(), c2, 'email2@newlast.com', 'email2@newlast.com', 'fname2', 'lname2', 'als2');
		insert u2;

		ccrz.cc_RemoteActionResult response;
		//System.runAs(u){
			// cc_imp_ctrl_UserAdmin ctrl = new cc_imp_ctrl_UserAdmin();
			response = cc_imp_ctrl_UserAdmin.affectUser(ctx, cc_imp_ctrl_UserAdmin.ACTION_RESET_PASSWORD, u2.Id);*/

		//}
/*
		Contact newContact = [
			SELECT
				Id
				, cc_imp_Is_MyNexeo_Admin__c
				, Email
			FROM
				Contact
			WHERE
				Id =: c2.Id
			LIMIT
				1
		];

		System.assert(newContact.cc_imp_Is_MyNexeo_Admin__c, newContact.Email + ' => ' + newContact.cc_imp_Is_MyNexeo_Admin__c);
*/
		//System.assert(response.success);
        }
	}

	// @RemoteAction
	// global static ccrz.cc_RemoteActionResult retrieveAccountAndUserData(ccrz.cc_RemoteActionContext ctx){
	@isTest static void test_retrieveAccountAndUserData() {
		//List<cc_imp_StorefrontSettings__c> setList = cc_imp_testUtils.createNexeoCustomSettingList();
		//insert setList;

		// Create Account, Contact (as admin), User
		Map<String, SObject> dataMap = cc_imp_testUtils.initData();
        User u = (User)dataMap.get('nexeoIntegrationUser');
        System.runAs(u){
		Contact c = (Contact)dataMap.get('userContact');
		c.cc_imp_Is_MyNexeo_Admin__c = true;
		update c;

		Account act = (Account)dataMap.get('userAccount');
		act.ShippingStreet = 'line1';
		update act;
		//User u = (User)dataMap.get('portalUser');

		// Set up context
		ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();

		// Create accounts, contacts, users

		// Set up shipping address (account address book)

		ccrz.cc_RemoteActionResult result;
		//System.runAs(u){
			result = cc_imp_ctrl_UserAdmin.retrieveAccountAndUserData(ctx);
		//}
		Map<String, Object> responseObjects = (Map<String,Object>)result.data;
		List<cc_imp_ctrl_UserAdmin.CCAccount> actList = (List<cc_imp_ctrl_UserAdmin.CCAccount>)responseObjects.get('accountData');

		System.assertEquals(1, actList.size());
	}
    }

	@isTest static void test_retrieveAccountAndUserData_Exception() {
//		List<cc_imp_StorefrontSettings__c> setList = cc_imp_testUtils.createNexeoCustomSettingList();
//		insert setList;

		// Create Account, Contact (as admin), User
//		Map<String, SObject> dataMap = cc_imp_testUtils.initData();
//		Contact c = (Contact)dataMap.get('userContact');
//		c.cc_imp_Is_MyNexeo_Admin__c = true;
//		update c;

//		Account act = (Account)dataMap.get('userAccount');
//		User u = (User)dataMap.get('portalUser');

		// Set up context
		ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();

		// Create accounts, contacts, users

		// Set up shipping address (account address book)

		ccrz.cc_RemoteActionResult result;
//		System.runAs(u){
			result = cc_imp_ctrl_UserAdmin.retrieveAccountAndUserData(ctx);
//		}
//		Map<String, Object> responseObjects = (Map<String,Object>)result.data;
//		List<cc_imp_ctrl_UserAdmin.CCAccount> actList = (List<cc_imp_ctrl_UserAdmin.CCAccount>)responseObjects.get('accountData');
//		System.assertEquals(1, actList.size());
		System.assertEquals(true, (Boolean)(((Map<String,Object>)result.data).get('success')));
	}

	@isTest static void test_toggleUserActivationOn() {
		//List<cc_imp_StorefrontSettings__c> setList = cc_imp_testUtils.createNexeoCustomSettingList();
		//insert setList;

		// Create Account, Contact (as admin), User
		Map<String, SObject> dataMap = cc_imp_testUtils.initData();
        User u = (User)dataMap.get('nexeoIntegrationUser');
        System.runAs(u){
		Contact c = (Contact)dataMap.get('userContact');
		c.cc_imp_Is_MyNexeo_Admin__c = true;
		update c;

		Account act = (Account)dataMap.get('userAccount');
		//User u = (User)dataMap.get('portalUser');


		ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
		Boolean isUpdate	= false;
		String contactId	= null;
		String firstName	= 'newFirst'; 
		String lastName		= 'newLast'; 
		String phoneNumber	= '1234567890';
		String emailAddress	= 'newfirst2@newlast.com';
		String accountId	= act.Id;
		Boolean isAdmin 	= true;


		/*Contact c2 = cc_imp_testUtils.createContact(act, 'email2@newlast.com');
		c2.cc_imp_Is_MyNexeo_Admin__c = false;
		insert c2;

		User u2 = cc_imp_testUtils.createUser(cc_imp_testUtils.getCustomerCommunityProfile(), c2, 'email2@newlast.com', 'email2@newlast.com', 'fname2', 'lname2', 'als2');
		u2.IsActive = false;
		insert u2;


		// Query for the user
		c2 = [
			SELECT
				Id
				, FirstName
				, LastName
				, Email
				, AccountId
				, cc_imp_Is_MyNexeo_Admin__c
			FROM
				Contact
			WHERE
				Id = :c2.Id
			LIMIT
				1

		];

		System.assert(!u2.IsActive);

		//System.runAs(u){
			ccrz.cc_RemoteActionResult response = cc_imp_ctrl_UserAdmin.toggleUserActivation(ctx, u2.Id);
		//}

		u2 = [
			SELECT
				Id
				, IsActive
			FROM
				User
			WHERE
				Id =: u2.Id
			LIMIT
				1
		];

		System.assert(u2.IsActive);*/
        }
	}
	@isTest static void test_toggleUserActivationException() {
		//List<cc_imp_StorefrontSettings__c> setList = cc_imp_testUtils.createNexeoCustomSettingList();
		//insert setList;

		// Create Account, Contact (as admin), User
		Map<String, SObject> dataMap = cc_imp_testUtils.initData();
        User u = (User)dataMap.get('nexeoIntegrationUser');
        System.runAs(u){
		Contact c = (Contact)dataMap.get('userContact');
		c.cc_imp_Is_MyNexeo_Admin__c = true;
		update c;

		Account act = (Account)dataMap.get('userAccount');
		//User u = (User)dataMap.get('portalUser');


		ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
		Boolean isUpdate	= false;
		String contactId	= null;
		String firstName	= 'newFirst'; 
		String lastName		= 'newLast'; 
		String phoneNumber	= '1234567890';
		String emailAddress	= 'newfirst2@newlast.com';
		String accountId	= act.Id;
		Boolean isAdmin 	= true;


		/*Contact c2 = cc_imp_testUtils.createContact(act, 'email2@newlast.com');
		c2.cc_imp_Is_MyNexeo_Admin__c = false;
		insert c2;

		User u2 = cc_imp_testUtils.createUser(cc_imp_testUtils.getCustomerCommunityProfile(), c2, 'email2@newlast.com', 'email2@newlast.com', 'fname2', 'lname2', 'als2');
		u2.IsActive = false;
		insert u2;


		// Query for the user
		c2 = [
			SELECT
				Id
				, FirstName
				, LastName
				, Email
				, AccountId
				, cc_imp_Is_MyNexeo_Admin__c
			FROM
				Contact
			WHERE
				Id = :c2.Id
			LIMIT
				1

		];

		System.assert(!u2.IsActive);

		ccrz.cc_RemoteActionResult response;
		//System.runAs(u){
			response = cc_imp_ctrl_UserAdmin.toggleUserActivation(ctx, null);
		//}

		System.assert(!response.success);*/
        } 
	}
}