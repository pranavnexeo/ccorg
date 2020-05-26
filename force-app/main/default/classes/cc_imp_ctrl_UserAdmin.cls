global with sharing class cc_imp_ctrl_UserAdmin {


	public class CCAddress {
		public String addr1 {get;set;}
		public String addr2 {get;set;}
		public String addr3 {get;set;}
		public String city {get;set;}
		public String state {get;set;}
		public String zip {get;set;}
		public String country {get;set;}
	}

	public class CCAccount {
		public Id accountId {get;set;}
		public Boolean isParent {get;set;}
		public String name {get;set;}
		public CCAddress address {get;set;}

		List<CCContact> contactList {get;set;}
		//Map<Id, CCContact> contactMap {get;set;}

		public CCAccount(){
			contactList = new List<CCContact>();
			//contactMap = new Map<Id, CCContact>();
		}

	}


	public class CCContact {
		// Contact fields
		public Id contactId {get;set;}
		public String firstName {get;set;}
		public String lastName {get;set;}
		public String emailAddress {get;set;}
		public String phoneNumber {get;set;}
		public Boolean isAdmin {get;set;}

		// Account Fields
		public Id accountId {get;set;}

		// User fields
		public Id userId {get;set;}
		public Boolean isActive {get;set;}
	}

	global static final String ACTION_PROMOTE = 'promote';
	global static final String ACTION_DEMOTE = 'demote';
	global static final String ACTION_ACTIVATE = 'activate';
	global static final String ACTION_DEACTIVATE = 'deactivate';
	global static final String ACTION_RESET_PASSWORD = 'resetPassword';
	@RemoteAction
	global static ccrz.cc_RemoteActionResult affectUser(ccrz.cc_RemoteActionContext ctx, String action, String contactOrUserId){
		ccrz.cc_RemoteActionResult response = cc_imp_hlpr_RemoteActionHelper.remoteInit(ctx);
		String debugMessage = 'none';
		try {

			if(ACTION_PROMOTE.equals(action)){
				debugMessage = ACTION_PROMOTE;
				// Get the accounts
				Map<Id, Account> actMap = cc_imp_dao_Account.queryAccessibleAccounts();

				// Find the account at the top (no parent id)
				Account topAccount;
				for(Account a :actMap.values()){
					// if(a.ParentId == null){
					if((a.SAP_Sold_To_Account_Id__c == null) || (a.Id == a.SAP_Sold_To_Account_Id__c)) {
						topAccount = a;
						break; // found it
					}
				}

				// Update the contact to set Is Admin = true
				//		and Account Id = the top account
				Contact c = cc_imp_hlpr_UserAdmin.queryContactById(contactOrUserId);
				c.cc_imp_Is_MyNexeo_Admin__c = true;
                if (topAccount != null) {
				    c.AccountId = topAccount.Id;
                }
				cc_imp_hlpr_UserAdmin.updateContact(c);


			}
			else if(ACTION_DEMOTE.equals(action)){
				debugMessage = ACTION_DEMOTE;

				// Update the contact to set Is Admin = true
				//		and Account Id = the top account
				Contact c = cc_imp_hlpr_UserAdmin.queryContactById(contactOrUserId);
				c.cc_imp_Is_MyNexeo_Admin__c = false;
				cc_imp_hlpr_UserAdmin.updateContact(c);

			}
			else if(ACTION_ACTIVATE.equals(action)){
				debugMessage = ACTION_ACTIVATE;
				User u = cc_imp_dao_User.queryUserForUserId(contactOrUserId);
				if(u != null){
					u.IsActive = true;
					cc_imp_hlpr_UserAdmin.updateUser(u);
					debugMessage = 'User has been activated';
				}

			}
			else if(ACTION_DEACTIVATE.equals(action)){
				debugMessage = ACTION_DEACTIVATE;
				User u = cc_imp_dao_User.queryUserForUserId(contactOrUserId);
				if(u != null){
					u.IsActive = false;
					cc_imp_hlpr_UserAdmin.updateUser(u);
					debugMessage = 'User has been deactivated';
				}
			}
			else if(ACTION_RESET_PASSWORD.equals(action)){
				debugMessage = ACTION_RESET_PASSWORD;

				User u = cc_imp_dao_User.queryUserForUserId(contactOrUserId);
				if(u != null){
					cc_imp_hlpr_UserAdmin.resetPassword(u);
					debugMessage = 'Password has been reset for user.';
				}
			}

		// Return the result
     		cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, true, 
     			new Map<String,Object>{
     				'success' => true,
     				'debugMessage' => debugMessage
     			}
        	);
     	}
     	catch(Exception e){
	     		cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, true, 
     			new Map<String,Object>{
     				'success' => false,
     				'debugMessage' => debugMessage,
     				'message' => e.getMessage(),
     				'cause' => e.getCause(),
     				'trace' => e.getStackTraceString()
     			}
        	);	
     	}		
     	return response;
	}

	@RemoteAction
	global static ccrz.cc_RemoteActionResult toggleUserActivation(ccrz.cc_RemoteActionContext ctx, String userId){
		ccrz.cc_RemoteActionResult response = cc_imp_hlpr_RemoteActionHelper.remoteInit(ctx);
		try {

			// Query the user
			User u = cc_imp_dao_User.queryUserForUserId(userId);

			// Set the active flag
			u.IsActive = !u.IsActive;

			// Update the user
			cc_imp_hlpr_UserAdmin.updateUser(u);

			// Return result
    		cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, true, 
     				new Map<String,Object>{
     					'success' => true
     				}
        		);
     		}
     	catch(Exception e){
	     		cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, false, 
     			new Map<String,Object>{
     				'success' => false,
     				'message' => e.getMessage(),
     				'cause' => e.getCause(),
     				'trace' => e.getStackTraceString()
     			}
        	);	
     	}		
     	return response;		
	}


	@RemoteAction
	global static ccrz.cc_RemoteActionResult addOrUpdateUser(ccrz.cc_RemoteActionContext ctx, Boolean isUpdate, String contactId, String firstName, String lastName, String phoneNumber, String emailAddress, String accountId, Boolean isAdmin){
		ccrz.cc_RemoteActionResult response = cc_imp_hlpr_RemoteActionHelper.remoteInit(ctx);
		//Boolean isAdmin = Boolean.valueOf(isAdminStr);
		Boolean success = true;
		String errorCode;
		try {

			// Fetch the accounts the current user has access to
			// If the supplied account Id is not in the list return an error (unauthorized)
			Map<Id, Account> actMap = cc_imp_dao_Account.queryAccessibleAccounts();
			Id actId = accountId;
			Account act = actMap.get(actId);
			if(act == null){
				success = false;
				errorCode = 'Invalid_Account';
			}

			// Fetch the contacts and make sure the supplied email address is not in the list of contacts
			// otherwise return an error (user exists)
			if(!isUpdate){
				Map<Id, User> userMap = cc_imp_dao_User.queryUsersForAccounts(actMap.keySet());
				//String s = '';
				for(User u :userMap.values()){
					//s += u.Username + ' => ' + emailAddress + '; ';
					if(u.Username.equals(emailAddress)){
						success = false;
						errorCode = 'Already_Exists';

	     				cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, success, 
     						new Map<String,Object>{
     							'success' => false,
     							'error' => errorCode
     						}
        				);	
        				return response;
					}
				}
				//System.assert(false, 'Users: ' + s);
			}
			//System.assert(false, 'after !isUpdate');


			Contact newContact = new Contact(
				firstName  					= firstName,
				LastName 					= lastName,
				email 						= emailAddress,
				phone 						= phoneNumber,
				AccountId 					= act.Id,
				cc_imp_Is_MyNexeo_Admin__c	= isAdmin
			);
			if(isUpdate){
				newContact.Id = contactId;
			}

			// If isAdmin is true, assign the contact to the parent account and mark the isAdmin checkbox on the contact
			// Otherwise assign the contact to the supplied account Id
			// if(isAdmin && act.ParentId != null){
			if(isAdmin && act.SAP_Sold_To_Account_Id__c != null){
				// newContact.AccountId = act.ParentId;
				newContact.AccountId = act.SAP_Sold_To_Account_Id__c;
			}

			// Insert the contact record
			// insert newContact; // need a helper for this - without sharing
			if(isUpdate){
				cc_imp_hlpr_UserAdmin.updateContact(newContact);
			}
			else {
				cc_imp_hlpr_UserAdmin.insertContact(newContact);
			}



			// Create a user record that points to the new contact record (turn off notification or no?)
			User currentUser = cc_imp_dao_User.queryUserForUserId(UserInfo.getUserId());
			System.debug('THE PROFILE ID: ' + currentUser.ProfileId);

			User newUser;
			if(isUpdate){
				newUser = cc_imp_dao_User.queryUserForContactId(contactId);
			}
			else {
				newUser = new User();
				newUser.Alias             = emailAddress.substring(0,8);
				newUser.LocaleSidKey      = currentUser.LocaleSidKey;
				newUser.TimeZoneSidKey    = currentUser.TimeZoneSidKey;
				cc_imp_hlpr_UserAdmin.assignProfileToUser(currentUser.ProfileId, newUser);
				newUser.LanguageLocaleKey = currentUser.LanguageLocaleKey;
				newUser.EmailEncodingKey  = currentUser.EmailEncodingKey;
				newUser.ContactId         = newContact.Id;
			}

			newUser.FirstName         = firstName;
			newUser.LastName          = lastName;
			newUser.Email             = emailAddress;
			newUser.Username          = emailAddress;
			newUser.Phone 			  = phoneNumber;
			
			if(!isUpdate){
				cc_imp_hlpr_UserAdmin.insertUser(newUser, true);
			}
			else {
				// cc_imp_hlpr_UserAdmin.updateUser(newUser);
				updateUser_future(newUser.Id, firstName, lastName, emailAddress, phoneNumber);
			}


			// Return the result
			if(!success){
	     		cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, true, 
     				new Map<String,Object>{
     					'success' => success,
     					'errorCode' => errorCode
     				}
        		);			
			}
			else {
     			cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, true, 
     				new Map<String,Object>{
     					'success' => success
     				}
        		);
     		}
     	}
     	catch(Exception e){
	     		cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, true, 
     			new Map<String,Object>{
     				'success' => false,
     				'message' => e.getMessage(),
     				'cause' => e.getCause(),
     				'trace' => e.getStackTraceString()
     			}
        	);	
     	}		
     	return response;
	}

	@future
	private static void updateUser_future(String userId, String firstName, String lastName, String emailAddress, String phoneNumber){
		User newUser = new User(
			Id 			= userId,
			FirstName   = firstName,
			LastName    = lastName,
			Email       = emailAddress,
			Username 	= emailAddress,
			Phone 		= phoneNumber
		);
		cc_imp_hlpr_UserAdmin.updateUser(newUser);

	}

	private static Map<Id, CCAccount> buildCCAccounts(Map<Id, Account> actMap){
		Map<Id, CCAccount> ccAccountMap = new Map<Id, CCAccount>();
		for(Id key :actMap.keySet()){
			Account a = actMap.get(key);

			CCAccount act = new CCAccount();
			act.accountId = key;
			// act.isParent = (a.ParentId == null);
			act.isParent = (a.SAP_Sold_To_Account_Id__c == null);
			act.name = a.Name;
			CCAddress addr = new CCAddress();
			addr.addr1 = a.ShippingStreet;
			addr.city = a.ShippingCity;
			addr.state = a.ShippingState;
			addr.zip = a.ShippingPostalCode;
			act.address = addr;

			ccAccountMap.put(key, act);
		}
/*
		for(ccrz__E_AccountAddressBook__c addrBk :conAddrMap.values()){
			CCAccount act = ccAccountMap.get(addrBk.ccrz__Account__c);
			if(act != null){
				CCAddress addr = new CCAddress();
				addr.addr1 = addrBk.ccrz__E_ContactAddress__r.ccrz__AddressFirstline__c;
				addr.addr2 = addrBk.ccrz__E_ContactAddress__r.ccrz__AddressSecondline__c;
				addr.addr3 = addrBk.ccrz__E_ContactAddress__r.ccrz__AddressThirdline__c;
				addr.city = addrBk.ccrz__E_ContactAddress__r.ccrz__City__c;
				addr.state = addrBk.ccrz__E_ContactAddress__r.ccrz__StateISOCode__c;
				addr.zip = addrBk.ccrz__E_ContactAddress__r.ccrz__PostalCode__c;
				addr.country = addrBk.ccrz__E_ContactAddress__r.ccrz__CountryISOCode__c;

				act.address = addr;
			}

		}
*/

		return ccAccountMap;
	}
	private static void assignContactsToAccounts(Map<Id, CCAccount> actMap, Map<Id, User> userMap){
		Id currentUser = ccrz.cc_CallContext.currUserId;
		for(Id key :userMap.keySet()){
			User u = userMap.get(key);
			CCAccount ccAct = actMap.get(u.Contact.AccountId);
			if(ccAct != null){

				CCContact con = new CCContact();
				con.contactId = u.Contact.Id;
				con.firstName = u.Contact.firstName;
				con.lastName = u.Contact.lastName;
				con.emailAddress = u.Contact.email;
				con.phoneNumber = u.Contact.phone;
				con.isAdmin = u.Contact.cc_imp_Is_MyNexeo_Admin__c;

				con.accountId = u.Contact.AccountId;

				con.userId = u.Id; 
				con.isActive = u.IsActive;

				ccAct.contactList.add(con);

			}

		}
	}

	@RemoteAction
	global static ccrz.cc_RemoteActionResult retrieveAccountAndUserData(ccrz.cc_RemoteActionContext ctx){
		ccrz.cc_RemoteActionResult response = cc_imp_hlpr_RemoteActionHelper.remoteInit(ctx);
		try {

			// Get the accounts and addresses
			Map<Id, Account> actMap = cc_imp_dao_Account.queryAccessibleAccountsWithAddress();
			Map<Id, ccrz__E_AccountAddressBook__c> conAddrMap = cc_imp_hlpr_UserAdmin.getShippingAddresses(actMap.keySet());
			//Map<Id, CCAccount> ccAccountMap = buildCCAccounts(actMap, conAddrMap);
			Map<Id, CCAccount> ccAccountMap = buildCCAccounts(actMap);

			// Get the contacts
			Map<Id, User> userMap = cc_imp_dao_User.queryUsersForAccounts(actMap.keySet());
			assignContactsToAccounts(ccAccountMap, userMap);


			// Build the CCAccount list with nested contacts and users
			List<CCAccount> actList;

		// Return the result
     		cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, true, 
     			new Map<String,Object>{
     				'success' => true,
     				'accountData' => ccAccountMap.values(),
     				'accountAddrBook' => conAddrMap,
     				'users' => userMap.values()
     			}
        	);
     	}
     	catch(Exception e){
	     		cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, true, 
     			new Map<String,Object>{
     				'success' => false,
     				'message' => e.getMessage(),
     				'cause' => e.getCause(),
     				'trace' => e.getStackTraceString()
     			}
        	);	
     	}		
     	return response;
	}

}