@isTest
private class PopulateCCOrderTest {

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

        Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.NEXEO3D_USER_COMMUNITY_PROFILE];

    ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
    insert userAccountGroup;

    Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
    insert userAccount;

    Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
    insert userContact;

    User user = cc_imp_testUtils.createUser(userProfile, userContact, 
      'username@email.com', 'contact@email.com', 'firstName', 'lastName', 'alias');
    insert user;


   // ccrz__E_ContactAddr__c cca = new ccrz__E_ContactAddr__c(ccrz__ContactAddrId__c = 'testdata');
   // insert cca;
    
    ccrz__E_Cart__c ccart = new ccrz__E_Cart__c(ccrz__Account__c = userAccount.id);
    insert ccart;
    
    ccrz__E_Order__c corder = new ccrz__E_Order__c(ccrz__Contact__c = userContact.id,ccrz__OriginatedCart__c = ccart.id);
    insert corder;

        ccrz__E_TransactionPayment__c paymentTransaction1 = new ccrz__E_TransactionPayment__c (ccrz__BillTo__c = userAccount.id,ccrz__CCOrder__c = corder.id);
        paymentTransaction1.ccrz__AccountNumber__c = '1233564';
        insert paymentTransaction1;
        }

     //Test.stopTest();  
     
     //}Catch(exception e){}
   }

    }