@isTest
private class cc_3d_ctrl_MyAccountOrdersTest {

     @isTest static void test_getExtendedOrdersList3d() 
    {
       Test.startTest();
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

        ccrz__E_ContactAddr__c cshipToAddr = cc_imp_testUtils.createContactAddress(user, 'line1', 'line2', 'line3', 'city', 'IL', 'US','postalCode');
        insert cshipToAddr;

        ccrz__E_ContactAddr__c billToAddr = cc_imp_testUtils.createContactAddress(user, 'line1', 'line2', 'line3', 'city', 'IL', 'US','postalCode');
        insert billToAddr;

        ccrz__E_Cart__c cart1 = cc_imp_testUtils.createCart(userAccount,  billToAddr, cshipToAddr, user, userContact, 'Cart',cc_imp_testUtils.TEST_MYNEXEO_STOREFRONT);
        insert cart1;

        ccrz__E_Cart__c cart2 = cc_imp_testUtils.createCart(userAccount,  billToAddr, cshipToAddr, user, userContact, 'Cart',cc_imp_testUtils.TEST_MYNEXEO_STOREFRONT);
        insert cart2;

        ccrz__E_Order__c myOrder1  = cc_imp_testUtils.createOrder(cart1.ID, userAccount.ID, userContact.ID, user.ID, cshipToAddr.ID, billToAddr.ID);
        myOrder1.Tracking_Number__c='99999';
        myOrder1.ccrz__EncryptedId__c='abc123';
        insert myOrder1;

        ccrz__E_TransactionPayment__c paymentTransaction1 = cc_imp_testUtils.createTransactionPayment(myOrder1.ID,'uid1');
        paymentTransaction1.ccrz__AccountNumber__c = '1233564';
        insert paymentTransaction1;

        ccrz__E_Order__c myOrder2  = cc_imp_testUtils.createOrder(cart2.ID, userAccount.ID, userContact.ID, user.ID, cshipToAddr.ID, billToAddr.ID);
        myOrder2.Tracking_Number__c='99991';
        myOrder2.ccrz__EncryptedId__c='def456';
        insert myOrder2;

        ccrz__E_TransactionPayment__c paymentTransaction2 = cc_imp_testUtils.createTransactionPayment(myOrder2.ID,'uid1');
        paymentTransaction2.ccrz__AccountNumber__c = '345677';

        orderIds.add(myOrder1.ccrz__EncryptedId__c);
        orderIds.add(myOrder2.ccrz__EncryptedId__c);

        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();

        ccrz.cc_RemoteActionResult res = cc_3d_ctrl_MyAccountOrders.getExtendedOrdersList(ctx, orderIds);

        Map<String,Object> holder = (Map<String,Object>)res.data;
        Map<String,cc_3d_ctrl_MyAccountOrders.ExtendedOrderHistory> extendedOrderHistoryMap = (Map<String,cc_3d_ctrl_MyAccountOrders.ExtendedOrderHistory>)holder.get('extendedData');

        cc_3d_ctrl_MyAccountOrders.ExtendedOrderHistory ordHist = extendedOrderHistoryMap.get(myOrder1.ccrz__EncryptedId__c);

        cc_3d_ctrl_MyAccountOrders.ExtendedOrderHistory ordHist2 = extendedOrderHistoryMap.get(myOrder2.ccrz__EncryptedId__c);

        System.assert(res != null);
        System.assert(res.data != null);
        System.assertEquals(res.success,true);
        System.assert( ordHist.trackingNumber == '99999');
        System.assert( ordHist2.trackingNumber == '99991');
        }
       Test.stopTest(); 
     }

    @isTest static void test_getExtendedOrdersList3d_ExceptionsTest() 
    {
       Test.startTest();
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

        ccrz__E_ContactAddr__c cshipToAddr = cc_imp_testUtils.createContactAddress(user, 'line1', 'line2', 'line3', 'city', 'IL', 'US','postalCode');
        insert cshipToAddr;

        ccrz__E_ContactAddr__c billToAddr = cc_imp_testUtils.createContactAddress(user, 'line1', 'line2', 'line3', 'city', 'IL', 'US','postalCode');
        insert billToAddr;

        ccrz__E_Cart__c cart1 = cc_imp_testUtils.createCart(userAccount,  billToAddr, cshipToAddr, user, userContact, 'Cart',cc_imp_testUtils.TEST_MYNEXEO_STOREFRONT);
        insert cart1;

        ccrz__E_Cart__c cart2 = cc_imp_testUtils.createCart(userAccount,  billToAddr, cshipToAddr, user, userContact, 'Cart',cc_imp_testUtils.TEST_MYNEXEO_STOREFRONT);
        insert cart2;

        ccrz__E_Order__c myOrder1  = cc_imp_testUtils.createOrder(cart1.ID, userAccount.ID, userContact.ID, user.ID, cshipToAddr.ID, billToAddr.ID);
        myOrder1.Tracking_Number__c='99999';
        myOrder1.ccrz__EncryptedId__c='123Error';
        insert myOrder1;

        ccrz__E_TransactionPayment__c paymentTransaction1 = cc_imp_testUtils.createTransactionPayment(myOrder1.ID,'uid1');
        paymentTransaction1.ccrz__AccountNumber__c = '1233564';
        insert paymentTransaction1;

        orderIds.add(myOrder1.ccrz__EncryptedId__c);

        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();

        ccrz.cc_RemoteActionResult res = cc_3d_ctrl_MyAccountOrders.getExtendedOrdersList(ctx, orderIds);


        System.assert(res != null);
        System.assertEquals(res.success,false);
        }
       Test.stopTest(); 
     }

}