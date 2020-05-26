global with sharing class cc_mn_hk_EffectiveAccount extends ccrz.cc_hk_EffectiveAccount {
	public cc_mn_hk_EffectiveAccount() {
		
	}

	global override Map<String,Object> fetchAccounts(Map<String,Object> inputData){
		// Parent Hierarchy or Account Group
		String fetchMode = (String)(inputData.get(PARAM_FETCH_MODE));

		// Whether to include the user's assigned account.
		// ASSIGNED_ACCOUNT_ALWAYS = 'Always';
		// ASSIGNED_ACCOUNT_NEVER = 'Never';
		// ASSIGNED_ACCOUNT_ONLYEMPTY = 'OnlyEmpty';		
		String assignedAcctMode = (String)(inputData.get(PARAM_ASSIGNED_ACCT_MODE));
		System.debug('*** fetchAccounts: fetchMode: ' + fetchMode + ', assignedMode: ' + assignedAcctMode);

		// Check if the user is an admin, otherwise only return the account the user is assigned to
		// * This query uses curUserId to avoid the CloudCraze query for User and Contact that
		// occur when using CallContext.curUser and CallContext.curContact, since the query
		// needs to return the cc_imp_Is_MyNexeo_Admin__c field from the contact.
		Id curUserId = ccrz.cc_CallContext.currUserId;

		User curUser = [
			SELECT
				Contact.cc_imp_Is_MyNexeo_Admin__c
				, Contact.AccountId
				, Contact.Account.SAP_Sold_To_Account_Id__c
			FROM
				User
			WHERE
				Id = :curUserId
			LIMIT
				1
		];

		Boolean isAdmin = curUser.Contact.cc_imp_Is_MyNexeo_Admin__c;


		System.debug('*** fetchAccounts: admin: ' + isAdmin);

		// Query the accounts
		Id curAccountId = ccrz.cc_CallContext.currAccountId;
		if(isAdmin && curUser.Contact.Account.SAP_Sold_To_Account_Id__c != null){
			curAccountId = curUser.Contact.Account.SAP_Sold_To_Account_Id__c;

		}
//		System.debug('*** fetchAccounts: user: ' + curUserId + ', acct: ' + curAccountId);

		String theQuery = buildquery(curAccountId, isAdmin);
//		System.debug('*** fetchAccounts: theQuery: ' + theQuery);

		// List<Account> accountList = (List<Account>)Database.query(theQuery);
		List<Account> accountList = cc_mn_hlpr_EffectiveAccount.queryEffectiveAccounts(theQuery);
//		System.debug('*** fetchAccounts: accountList: ' + JSON.serializePretty(accountList));
//		for(Account a: accountList){
//			a.Name += ' - mod';
//		}

		Set<Id> acctIds = new Set<Id>();
		Map<Id, Account> accountMap = new Map<Id, Account>();
		acctIds.add(curAccountId);
		Map<Id, ccrz.cc_bean_EffectiveAccount> selectedAccounts = new Map<Id, ccrz.cc_bean_EffectiveAccount>();
		ccrz.cc_bean_EffectiveAccount eAct;
		for(Account a :accountList){
			eAct = new ccrz.cc_bean_EffectiveAccount(a);
			selectedAccounts.put(a.Id, eAct);
			
			// a.Name += ' - mod'; // for testing
			selectedAccounts.put(a.Id, eAct);
			acctIds.add(a.Id);
			accountMap.put(a.Id, a);
		}
		// System.debug('*** Account IDs: ' + JSON.serializePretty(acctIds));
		// System.debug('*** Account Map: ' + JSON.serializePretty(accountMap));


/*
			SELECT
				Id
				, ccrz__Account__c
				, ccrz__AddressType__c

				// Fields from ContactAddr
				, ccrz__E_ContactAddress__r.Id
				, ccrz__E_ContactAddress__r.ccrz__AddressFirstline__c
				, ccrz__E_ContactAddress__r.ccrz__AddressSecondline__c
				, ccrz__E_ContactAddress__r.ccrz__AddressThirdline__c
				, ccrz__E_ContactAddress__r.ccrz__City__c
				, ccrz__E_ContactAddress__r.ccrz__StateISOCode__c
				, ccrz__E_ContactAddress__r.ccrz__CountryISOCode__c
				, ccrz__E_ContactAddress__r.ccrz__PostalCode__c
*/		


		// Create the list of cc_bean_EffectiveAccount 
		// List<ccrz.cc_bean_EffectiveAccount> selectedAccounts = new List<ccrz.cc_bean_EffectiveAccount>();
		System.debug('*** AccountIds: ' + acctIds);
		Map<Id, ccrz__E_AccountAddressBook__c> addrs = cc_imp_dao_Account.getBillingAndShippingAddresses(acctIds);
		try {
			for(ccrz__E_AccountAddressBook__c ab :addrs.values()){
				if(ab.ccrz__Default__c){
					eAct = selectedAccounts.get(ab.ccrz__Account__c);
					if('Shipping' == ab.ccrz__AddressType__c){
						eAct.shippingAddress = buildMockAddr(ab);
					}
					else if('Billing' == ab.ccrz__AddressType__c){
						eAct.billingAddress = buildMockAddr(ab);
					}
					// selectedAccounts = buildEffectiveAccountData(accountList, 'AddressBook');
					// selectedAccounts = buildEffectiveAccountData(accountList, 'Account');
				}

			}
		}
		catch(Exception e){
			System.debug('*** fetchAccounts: error: ' + e.getMessage() + ' => ' + e.getStackTraceString());
		}

		System.debug('*** fetchAccounts: selectedAccounts: ' + selectedAccounts);

		return new Map<String, Object>{
			PARAM_EFFACCOUNT_LIST => selectedAccounts.values()
		};
	}

/*
				// Fields from ContactAddr
				, ccrz__E_ContactAddress__r.Id
				, ccrz__E_ContactAddress__r.ccrz__AddressFirstline__c
				, ccrz__E_ContactAddress__r.ccrz__AddressSecondline__c
				, ccrz__E_ContactAddress__r.ccrz__AddressThirdline__c
				, ccrz__E_ContactAddress__r.ccrz__City__c
				, ccrz__E_ContactAddress__r.ccrz__StateISOCode__c
				, ccrz__E_ContactAddress__r.ccrz__CountryISOCode__c
				, ccrz__E_ContactAddress__r.ccrz__PostalCode__c
*/
	public static ccrz.cc_bean_MockContactAddress buildMockAddr(ccrz__E_AccountAddressBook__c addr){
		ccrz.cc_bean_MockContactAddress mockAddr = new ccrz.cc_bean_MockContactAddress();
		mockAddr.address1 = addr.ccrz__E_ContactAddress__r.ccrz__AddressFirstline__c;
		mockAddr.address2 = addr.ccrz__E_ContactAddress__r.ccrz__AddressSecondline__c;
		mockAddr.address3 = addr.ccrz__E_ContactAddress__r.ccrz__AddressThirdline__c;
		mockAddr.city = addr.ccrz__E_ContactAddress__r.ccrz__City__c;
		mockAddr.countryCode = addr.ccrz__E_ContactAddress__r.ccrz__CountryIsoCode__c;
		mockAddr.postalCode = addr.ccrz__E_ContactAddress__r.ccrz__PostalCode__c;
		mockAddr.stateCode = addr.ccrz__E_ContactAddress__r.ccrz__StateIsoCode__c;

		return mockAddr;
	}

	private static String buildQuery(String assignedAccount, Boolean includeAllAccounts) {
		String query = 'SELECT Id ' +
					', Name' +
					', AccountNumber ' +
					', Account_Number__c ' +
					', ccrz__E_AccountGroup__c ' +
					', SAP_Sold_To_Account_Id__c ' +


				', BillingStreet ' +
				', BillingCity ' +
				', BillingState ' +
				', BillingPostalCode ' +
				', BillingCountry ' +
				', ShippingStreet ' +
				', ShippingCity ' +
				', ShippingState ' +
				', ShippingPostalCode ' +
				', ShippingCountry ' +

				' FROM ' +
					' Account ' +
				' WHERE' +
					' Id = \'' + assignedAccount + '\'';

		if(includeAllAccounts){
			query += ' OR ' +
						' SAP_Sold_To_Account_Id__c = \'' + assignedAccount + '\'';
		}
		return query;
	}

}