@isTest
private class cc_imp_AccountTriggerHandlerFnsTest {
    
    static {
                Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
                User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdcbestnameever@gorg2.com.mx', IsActive = true, FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        System.runAs(nexeoIntegrationUser) {

        
                cc_imp_StorefrontSettings__c customSettings = cc_imp_testUtils.createMyNexeoCustomSetting();
        insert customSettings;
        }
    }
	
	@isTest static void test_processNexeo3DAccountUpdates() {
        // Create Account, Contact (as admin), User
		Map<String, SObject> dataMap = cc_imp_testUtils.initData();
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        system.runas(nexeoIntegrationUser)
        {
        
		List<cc_imp_StorefrontSettings__c> setList = cc_imp_testUtils.createNexeoCustomSettingList();
		//insert setList;

		

		User u = (User)dataMap.get('portalUser');
		
		cc_imp_StorefrontSettings__C storefrontSettings =  cc_imp_StorefrontSettings__C.getInstance('nexeo3d');
		Profile profile = [SELECT Id, name from Profile where Id = :nexeoIntegrationUser.ProfileId];
		//storefrontSettings.Profile_Name__c = profile.Name;
		//update storefrontSettings;

		List<Account> newAccounts = new List<Account>{new Account(ccrz__CustomField1__c = 'testVat', ccrz__CustomField2__c = 'true')};
		System.runAs(u){
			cc_imp_AccountTriggerHandlerFunctions.processNexeo3DAccountUpdates(newAccounts);
		}
		//System.assertEquals('testVat', newAccounts[0].VAT_Number__c);
		//System.assert(newAccounts[0].Registration_Sign_Up_For_Newsletter__c);
        }
	}
	

	@isTest static void test_processMyNexeoAccountUpdates() {
        Map<String, SObject> dataMap = cc_imp_testUtils.initData();
         Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        system.runas(nexeoIntegrationUser)
        {
        
		List<cc_imp_StorefrontSettings__c> setList = cc_imp_testUtils.createNexeoCustomSettingList();
		insert setList;

		// Create Account, Contact (as admin), User
		
		
		cc_imp_StorefrontSettings__C storefrontSettings =  cc_imp_StorefrontSettings__C.getInstance('mynexeo');

		User u = (User)dataMap.get('portalUser');
		Profile profile = [SELECT Id, name from Profile where Id = :u.ProfileId];
		System.assert(profile != null, 'Profile is null');
		System.assert(profile.Name != null, 'Profile name is null');
		storefrontSettings.Profile_Name__c = profile.Name;

	   	// User defaultPrimarySeller = [SELECT Id, name, Username from User where Id = :UserInfo.getUserId()];
        // storefrontSettings.DefaultPrimarySellerUserId__c = defaultPrimarySeller.Username; // the userName, not the Id
        storefrontSettings.DefaultPrimarySellerUserId__c = u.Username; // the userName, not the Id
        System.assert(u.Username != null, 'Username is null');
// 	        Id recordTypeId =  cc_imp_util_Storefront.getRecordTypeIdByNameAndSObjectType(storefrontSettings.RecordTypeName__c , 'Account');
/*
	         for(Account myAccount : newAccounts) 
		      {
			      myAccount.Primary_Seller__c = defaultPrimarySeller.Id ; 
	 			  myAccount.Type = 'Prospect';
		   	   	  myAccount.Prospect_Sales_Org__c = storefrontSettings.ProspectSalesOrg__c  ; 
		   	   	  myAccount.Prospect_Dist_Channel__c = storefrontSettings.DistributionChannel__c ; 
		   	   	  myAccount.Prospect_Division__c = storefrontSettings.Division__c ; 
		   	   	  myAccount.Prospect_Sales_District__c = storefrontSettings.SalesDistrict__c ; 
		   	   	  myAccount.Prospect_Sales_Office__c = storefrontSettings.SalesOffice__c ; 
		   	   	  myAccount.Prospect_Sales_Group__c = storefrontSettings.SalesGroup__c ; 
		   	   	  myAccount.RecordTypeID = recordTypeId;
*/


		update storefrontSettings;

		List<Account> newAccounts = new List<Account>{new Account(ccrz__CustomField1__c = '123', ccrz__CustomField2__c = '100.00')};
		System.runAs(u){
			//cc_imp_AccountTriggerHandlerFunctions.processMyNexeoAccountUpdates(newAccounts);
		}
		/*System.assertEquals(u.Id, newAccounts[0].Primary_Seller__c);
		System.assertEquals('123', newAccounts[0].Registration_Invoice_Number__c);
		System.assertEquals('100.00', newAccounts[0].Registration_Invoice_Amount__c);*/ 
        }
	}
}