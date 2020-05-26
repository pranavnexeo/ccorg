@isTest
private class cc_imp_hlpr_UserAdminTest {
	
	@isTest static void test_InsertContact(){
		userRole ur = [SELECT id from userrole  where developername= 'NEXEOSOLUTIONSORG' limit 1];
        id ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='o234567oo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdnexeodsfgdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A12ert3002', FirstName = 'Poratl User',UserRoleId = ur.Id);
        insert nexeoIntegrationUser;
        system.runAs(nexeoIntegrationUser) {
            List<cc_imp_StorefrontSettings__c> setList = cc_imp_testUtils.createNexeoCustomSettingList();
            insert setList;
        }


		// Create Account, Contact (as admin), User
		Map<String, SObject> dataMap = cc_imp_testUtils.initData();
		Contact c = null;
        System.runAs(nexeoIntegrationUser) {
            c = (Contact)dataMap.get('userContact');
            c.cc_imp_Is_MyNexeo_Admin__c = true;
            update c;
        }
        
		User u = (User)dataMap.get('portalUser');


		Contact c2 = c.clone();
		System.runAs(u){
			cc_imp_hlpr_UserAdmin.insertContact(c2);
		}
		System.assertNotEquals(null, c2.Id);
	}
	
	@isTest static void test_UpdateContact(){
		userRole ur = [SELECT id from userrole  where developername= 'NEXEOSOLUTIONSORG' limit 1];
        id ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='o234567oo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdnexeodsfgdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A12ert3002', FirstName = 'Poratl User',UserRoleId = ur.Id);
        insert nexeoIntegrationUser;
        system.runAs(nexeoIntegrationUser) {
            List<cc_imp_StorefrontSettings__c> setList = cc_imp_testUtils.createNexeoCustomSettingList();
            insert setList;
        }


		// Create Account, Contact (as admin), User
		Map<String, SObject> dataMap = cc_imp_testUtils.initData();
        Contact c = null;
        System.runAs(nexeoIntegrationUser) {
            c = (Contact)dataMap.get('userContact');
            c.cc_imp_Is_MyNexeo_Admin__c = true;
            update c;
        }
		User u = (User)dataMap.get('portalUser');


		String newValue = 'new first name';
		Contact c2 = null;
		System.runAs(u){
            c2 = c.clone();
            
		}

        System.runAs(nexeoIntegrationUser) {
        	insert c2;
        }
        
        c2.firstname = newValue;
        System.runAs(u){
			
			cc_imp_hlpr_UserAdmin.updateContact(c2);
        }
		System.assertEquals(newValue, c2.firstName);
	}
	
}