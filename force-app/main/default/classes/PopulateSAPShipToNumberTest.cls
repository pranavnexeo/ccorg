@isTest
private class PopulateSAPShipToNumberTest {
	
  @isTest static void test_populatOrders() 
  {
  
  //Try{
     //Test.startTest();
userRole ur = [SELECT id from userrole  where developername= 'NEXEOSOLUTIONSORG' limit 1];
        id ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123002', FirstName = 'Nexeo_Integration',UserRoleId = ur.Id);
        insert nexeoIntegrationUser;
         system.runAs(nexeoIntegrationUser)
        {
     List <cc_imp_StorefrontSettings__c > storeFrontSettingsList  = cc_imp_testUtils.createNexeoCustomSettingList();

     insert storeFrontSettingsList ;
       List<String> orderIds = new List <String>();

        Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.MYNEXEO_USER_COMMUNITY_PROFILE];

    ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
    insert userAccountGroup;

    Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
    insert userAccount;

    Account secondAcct = new Account  (Name='Effective Account 2');
    	if(userAccountGroup != null){
    		secondAcct.ccrz__E_AccountGroup__c = userAccountGroup.Id;
    	}
    	insert secondAcct;

    Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
    insert userContact;

    User user = cc_imp_testUtils.createUser(userProfile, userContact, 
      'username@email.com', 'contact@email.com', 'firstName', 'lastName', 'alias');
    insert user;

    
    ccrz__E_Cart__c ccart = new ccrz__E_Cart__c(ccrz__Account__c = userAccount.id);
    insert ccart;
    Test.startTest();
    ccrz__E_Order__c corder = new ccrz__E_Order__c(ccrz__Contact__c = userContact.id,ccrz__OriginatedCart__c = ccart.id, ccrz__EffectiveAccountID__c = secondAcct.id , ccrz__Storefront__c = 'mynexeo');
    insert corder;
    Test.stopTest();

    List<ccrz__E_Order__c> lookUpOrder = [select ccrz__Account__c from ccrz__E_Order__c where id =: corder.id];

    String one = String.valueOf(lookUpOrder[0].ccrz__Account__c);
    String two = String.valueOf(secondAcct.id);
        }
   // System.assertEquals(one,two);


     //Test.stopTest();  
     
     //}Catch(exception e){}
   }
	
}