/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        08/16/2016
*   Author:              Avionos
*   Last Modified:       08/16/2016
*   Last Modified By:    Avionos
*
*   Short Description:  
*   This class contains unit tests for validating the behavior of the cc_imp_ctrl_MyAccountOrders Apex class . 
*   **********************************************************************************************************************/



@isTest
private class cc_imp_ctrl_MyAccountOrdersTest 
{
    
     @isTest static void test_getExtendedOrdersList() 
    {
       Test.startTest();

       List <cc_imp_StorefrontSettings__c > storeFrontSettingsList  = cc_imp_testUtils.createNexeoCustomSettingList();

       insert storeFrontSettingsList ;
       List<String> orderIds = new List <String>();
        Map<String, SObject> testData = NexeoTestUtils_Test.initData(); 
        Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.MYNEXEO_USER_COMMUNITY_PROFILE];

        ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
        insert userAccountGroup;

        Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
        insert userAccount;

        Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
        insert userContact;

       /* User user = cc_imp_testUtils.createUser(userProfile, userContact, 
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
        myOrder1.ccrz__EncryptedId__c = 'ABC123';
        insert myOrder1;

        ccrz__E_TransactionPayment__c paymentTransaction1 = cc_imp_testUtils.createTransactionPayment(myOrder1.ID,'uid1');
        paymentTransaction1.ccrz__AccountType__c ='PO';
        paymentTransaction1.ccrz__AccountNumber__c = '1233564';
        insert paymentTransaction1;

        ccrz__E_Order__c myOrder2  = cc_imp_testUtils.createOrder(cart2.ID, userAccount.ID, userContact.ID, user.ID, cshipToAddr.ID, billToAddr.ID);
        myOrder2.ccrz__EncryptedId__c = 'DEF456';
        insert myOrder2;

        ccrz__E_TransactionPayment__c paymentTransaction2 = cc_imp_testUtils.createTransactionPayment(myOrder2.ID,'uid1');
        paymentTransaction2.ccrz__AccountType__c ='PO';
        paymentTransaction2.ccrz__AccountNumber__c = '345677';

        orderIds.add(myOrder1.ccrz__EncryptedId__c);
        //orderIds.add(myOrder2.ccrz__EncryptedId__c);

        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();

        ccrz.cc_RemoteActionResult res = cc_imp_ctrl_MyAccountOrders.getExtendedOrdersList(ctx, orderIds);

        Map<String,Object> holder = (Map<String,Object>)res.data;
        Map<String,cc_imp_ctrl_MyAccountOrders.ExtendedOrderHistory> extendedOrderHistoryMap = (Map<String,cc_imp_ctrl_MyAccountOrders.ExtendedOrderHistory>)holder.get('extendedData');

        cc_imp_ctrl_MyAccountOrders.ExtendedOrderHistory ordHist = extendedOrderHistoryMap.get(myOrder1.ccrz__EncryptedId__c);

        system.debug(ordHist.poNumber);
 


        System.assert(res != null);
        System.assert(res.data != null);
        System.assertEquals(res.success,true);
        System.assertEquals(ordHist.poNumber,'1233564');


       Test.stopTest(); */
     }

    @isTest static void test_getExtendedOrdersList_Exceptions() 
    {
       Test.startTest();

       List <cc_imp_StorefrontSettings__c > storeFrontSettingsList  = cc_imp_testUtils.createNexeoCustomSettingList();

       insert storeFrontSettingsList ;
       List<String> orderIds = new List <String>();
         Map<String, SObject> testData = NexeoTestUtils_Test.initData(); 
        Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.MYNEXEO_USER_COMMUNITY_PROFILE];

        ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
        insert userAccountGroup;

        Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
        insert userAccount;

        Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
        insert userContact;

        /*User user = cc_imp_testUtils.createUser(userProfile, userContact, 
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
        myOrder1.ccrz__EncryptedId__c = '123Error';
        insert myOrder1;

        ccrz__E_TransactionPayment__c paymentTransaction1 = cc_imp_testUtils.createTransactionPayment(myOrder1.ID,'uid1');
        paymentTransaction1.ccrz__AccountType__c ='PO';
        paymentTransaction1.ccrz__AccountNumber__c = '1233564';
        insert paymentTransaction1;

        ccrz__E_Order__c myOrder2  = cc_imp_testUtils.createOrder(cart2.ID, userAccount.ID, userContact.ID, user.ID, cshipToAddr.ID, billToAddr.ID);
        myOrder2.ccrz__EncryptedId__c = 'DEF456';
        insert myOrder2;

        ccrz__E_TransactionPayment__c paymentTransaction2 = cc_imp_testUtils.createTransactionPayment(myOrder2.ID,'uid1');
        paymentTransaction2.ccrz__AccountType__c ='PO';
        paymentTransaction2.ccrz__AccountNumber__c = '345677';

        orderIds.add(myOrder1.ccrz__EncryptedId__c);
        //orderIds.add(myOrder2.ccrz__EncryptedId__c);

        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();

        ccrz.cc_RemoteActionResult res = cc_imp_ctrl_MyAccountOrders.getExtendedOrdersList(ctx, orderIds);

        System.assert(res != null);
        System.assertEquals(res.success,false);

       Test.stopTest(); */
     }

    @isTest static void test_fetchInvoices(){

        List <cc_imp_StorefrontSettings__c> customSettingLists = cc_imp_testUtils.createNexeoCustomSettingList();
        insert customSettingLists ;
        Map<String, SObject> testData = NexeoTestUtils_Test.initData(); 
        Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.MYNEXEO_USER_COMMUNITY_PROFILE];

        ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
        insert userAccountGroup;

        Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
        insert userAccount;

        Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
        insert userContact;
		/*userRole ur = [SELECT id from userrole  where developername= 'NexeoImportExportCustomerServiceRep' limit 1];
        User portalUser = cc_imp_testUtils.createUser(userProfile, userContact, 
            'username@email.com', 'contact@email.com', 'firstName', 'lastName', 'alias');
        portaluser.userroleid=ur.id;
        insert portalUser;
		Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc62325765@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123567500223', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
          system.runAs(nexeoIntegrationUser)
        {
        ccrz__E_ContactAddr__c address = cc_imp_testUtils.createContactAddress(
            portalUser,
            'line1',
            'line2',
            'line3',
            'city',
            'state',
            'country',
            '11111'
        );
        insert address;

        List<ccrz__E_AccountAddressBook__c> addrBookList = new List<ccrz__E_AccountAddressBook__c>();
        ccrz__E_AccountAddressBook__c shippingAddressBook = cc_imp_testUtils.createAccountAddressBook(userAccount,'Shipping', address, portalUser, true);
        ccrz__E_AccountAddressBook__c billingAddressBook = cc_imp_testUtils.createAccountAddressBook(userAccount,'Billing', address, portalUser, true);
        addrBookList.add(shippingAddressBook);
        addrBookList.add(billingAddressBook);
        insert addrBookList;

       
        ccrz__E_Product__c product = cc_imp_testUtils.createProduct('Product 1', 'product-01', 'Major', cc_imp_testUtils.DEFAULT_STOREFRONT);
        insert product;

   
        ccrz__E_Product__c parentProduct = cc_imp_testUtils.createProduct('Parent Product', 'product-02');
        insert parentProduct;
        System.debug('!!!!!!!11!!!!!!');
        List<ccrz__E_Product__c> productList = new List<ccrz__E_Product__c>();
        productList.add(product);

     
        ccrz__E_Category__c category = cc_imp_testUtils.createCategory('300000');
        insert category;

      
        ccrz__E_ProductCategory__c productCategory = cc_imp_testUtils.createProductCategory(product, '1001', category);
        insert productCategory;


      
        ccrz__E_PriceList__c priceList = cc_imp_testUtils.createPriceList('General', cc_imp_testUtils.DEFAULT_STOREFRONT);
        insert priceList;

        ccrz__E_AccountGroupPriceList__c agrpPriceList =  cc_imp_testUtils.createAccountGroupPriceList(userAccountGroup, priceList);
        insert agrpPriceList;

        List<ccrz__E_PriceListItem__c> priceListItems = cc_imp_testUtils.createPriceListItems(productList, priceList);
        insert priceListItems;
        
      
        ccrz__E_Cart__c cart = cc_imp_testUtils.createCart(userAccount, address, address, portalUser, userContact, 'Cart', cc_imp_testUtils.DEFAULT_STOREFRONT);
        insert cart;

    
        ccrz__E_CartItem__c cartItem = cc_imp_testUtils.createCartItem(cart, 9.99, 1, product, null);
        insert cartItem;

        ccrz__E_ContactAddr__c cshipToAddr = cc_imp_testUtils.createContactAddress(portalUser, 'line1', 'line2', 'line3', 'city', 'IL', 'US','postalCode');
        insert cshipToAddr;

        ccrz__E_ContactAddr__c billToAddr = cc_imp_testUtils.createContactAddress(portalUser, 'line1', 'line2', 'line3', 'city', 'IL', 'US','postalCode');
        insert billToAddr;


        ccrz__E_Order__c myOrder1  = cc_imp_testUtils.createOrder(cart.ID, userAccount.ID, userContact.ID, portalUser.ID, cshipToAddr.ID, billToAddr.ID);

        myOrder1.ccrz__EncryptedId__c = 'ABC123';
        myOrder1.ccrz__OrderStatus__c = 'COOL';
        myOrder1.ccrz__OrderDate__c = Date.valueOf('2015-12-31');

        insert myOrder1;


       Test.startTest();


       Map <String, String> headerMap = new Map<String, String> ();
     headerMap.put('Content-Type','application/json');

       Test.setMock(HttpCalloutMock.class, new cc_imp_mn_FetchInvoiceMock_HttpResponse(200,'success',mockResponse(), headerMap));

       cc_imp_testUtils.clearContext();

       ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_MYNEXEO_STOREFRONT;
       ccrz.cc_CallContext.currAccountId = userAccount.Id;

       ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();

       ccrz.cc_RemoteActionResult res  = cc_imp_ctrl_MyAccountOrders.getAllInvoicesForShipToAddress(ctx);
       
      System.assert(res != null);
      System.assert(res.data != null);

      Test.stopTest();
        }
		*/
       

      }


    @isTest static void test_fetchInvoicesWithParams (){

        List <cc_imp_StorefrontSettings__c> customSettingLists = cc_imp_testUtils.createNexeoCustomSettingList();
        insert customSettingLists ;
         Map<String, SObject> testData = NexeoTestUtils_Test.initData(); 
        Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.MYNEXEO_USER_COMMUNITY_PROFILE];

        ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
        insert userAccountGroup;

        Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
        insert userAccount;

        Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
        insert userContact;

        /*User portalUser = cc_imp_testUtils.createUser(userProfile, userContact, 
            'username@email.com', 'contact@email.com', 'firstName', 'lastName', 'alias');
        insert portalUser;

        ccrz__E_ContactAddr__c address = cc_imp_testUtils.createContactAddress(
            portalUser,
            'line1',
            'line2',
            'line3',
            'city',
            'state',
            'country',
            '11111'
        );
        insert address;

        List<ccrz__E_AccountAddressBook__c> addrBookList = new List<ccrz__E_AccountAddressBook__c>();
        ccrz__E_AccountAddressBook__c shippingAddressBook = cc_imp_testUtils.createAccountAddressBook(userAccount,'Shipping', address, portalUser, true);
        ccrz__E_AccountAddressBook__c billingAddressBook = cc_imp_testUtils.createAccountAddressBook(userAccount,'Billing', address, portalUser, true);
        addrBookList.add(shippingAddressBook);
        addrBookList.add(billingAddressBook);
        insert addrBookList;

        
        ccrz__E_Product__c product = cc_imp_testUtils.createProduct('Product 1', 'product-01', 'Major', cc_imp_testUtils.DEFAULT_STOREFRONT);
        insert product;

        
        ccrz__E_Product__c parentProduct = cc_imp_testUtils.createProduct('Parent Product', 'product-02');
        insert parentProduct;
        System.debug('!!!!!!!11!!!!!!');
        List<ccrz__E_Product__c> productList = new List<ccrz__E_Product__c>();
        productList.add(product);

       
        ccrz__E_Category__c category = cc_imp_testUtils.createCategory('300000');
        insert category;

       
        ccrz__E_ProductCategory__c productCategory = cc_imp_testUtils.createProductCategory(product, '1001', category);
        insert productCategory;


        
        ccrz__E_PriceList__c priceList = cc_imp_testUtils.createPriceList('General', cc_imp_testUtils.DEFAULT_STOREFRONT);
        insert priceList;

        ccrz__E_AccountGroupPriceList__c agrpPriceList =  cc_imp_testUtils.createAccountGroupPriceList(userAccountGroup, priceList);
        insert agrpPriceList;

        List<ccrz__E_PriceListItem__c> priceListItems = cc_imp_testUtils.createPriceListItems(productList, priceList);
        insert priceListItems;
        
                
        ccrz__E_Cart__c cart = cc_imp_testUtils.createCart(userAccount, address, address, portalUser, userContact, 'Cart', cc_imp_testUtils.DEFAULT_STOREFRONT);
        insert cart;

        
        ccrz__E_CartItem__c cartItem = cc_imp_testUtils.createCartItem(cart, 9.99, 1, product, null);
        insert cartItem;

        ccrz__E_ContactAddr__c cshipToAddr = cc_imp_testUtils.createContactAddress(portalUser, 'line1', 'line2', 'line3', 'city', 'IL', 'US','postalCode');
        insert cshipToAddr;

        ccrz__E_ContactAddr__c billToAddr = cc_imp_testUtils.createContactAddress(portalUser, 'line1', 'line2', 'line3', 'city', 'IL', 'US','postalCode');
        insert billToAddr;


        ccrz__E_Order__c myOrder1  = cc_imp_testUtils.createOrder(cart.ID, userAccount.ID, userContact.ID, portalUser.ID, cshipToAddr.ID, billToAddr.ID);

        myOrder1.ccrz__EncryptedId__c = 'ABC123';
        myOrder1.ccrz__OrderStatus__c = 'COOL';
        myOrder1.ccrz__OrderDate__c = Date.valueOf('2015-12-31');

        insert myOrder1;

        ccrz__E_Invoice__c invoice = new ccrz__E_Invoice__c();
        invoice.ccrz__BillAddress__c = address.Id;
        invoice.ccrz__BillTo__c = userAccount.Id;
        invoice.ccrz__CCOrder__c = myOrder1.Id;
        invoice.ccrz__Contact__c = userContact.Id;
        invoice.ccrz__DateDue__c = Date.valueOf('2016-12-31');
        invoice.ccrz__DateIssued__c = Date.valueOf('2016-10-09');
        invoice.ccrz__OriginalAmount__c = 100.00;
        invoice.ccrz__RemainingAmount__c = 60.00;
        invoice.ccrz__SoldAddress__c = address.Id;
        invoice.ccrz__SoldTo__c = userAccount.Id;
        invoice.ccrz__Status__c = 'Closed';

        insert invoice;


       Test.startTest();


       Map <String, String> headerMap = new Map<String, String> ();
     headerMap.put('Content-Type','application/json');

       Test.setMock(HttpCalloutMock.class, new cc_imp_mn_FetchInvoiceMock_HttpResponse(200,'success',mockResponse(), headerMap));

       cc_imp_testUtils.clearContext();

       ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_MYNEXEO_STOREFRONT;
       ccrz.cc_CallContext.currAccountId = userAccount.Id;

       ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();

       String json = '{\"fromDateStr\":\"2016-10-8\",\"searchInvoiceInput\":\"\",\"searchInvoiceStatus\":\"Closed\",\"searchInvoiceType\":\"\",\"sortCriteria\":\"Name\",\"sortDir\":\"Desc\",\"toDateStr\":\"2016-10-10\"}';

       ccrz.cc_RemoteActionResult res  = cc_imp_ctrl_MyAccountOrders.searchAllInvoices(ctx, json);

        Map<String,Object> holder = (Map<String,Object>)res.data;
        List<Map<String,Object>> invoices  = (List<Map<String,Object>>)holder.get('invoices');

        

       
      System.assert(res != null);
      System.assert(res.data != null);
      //System.assertEquals(1,invoices.size());

      Test.stopTest();*/
       

      }

     @isTest static void test_getAllOrdersForShipToAddress() 
    {
       Test.startTest();

       List <cc_imp_StorefrontSettings__c > storeFrontSettingsList  = cc_imp_testUtils.createNexeoCustomSettingList();

       insert storeFrontSettingsList ;
       List<String> orderIds = new List <String>();
        Map<String, SObject> testData = NexeoTestUtils_Test.initData(); 
        Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.MYNEXEO_USER_COMMUNITY_PROFILE];

        ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
        insert userAccountGroup;

        Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
        insert userAccount;

        Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
        insert userContact;

        /*User user = cc_imp_testUtils.createUser(userProfile, userContact, 
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
        myOrder1.ccrz__EncryptedId__c = 'ABC123';
        myOrder1.ccrz__OrderDate__c = Date.today();
        insert myOrder1;

        ccrz__E_TransactionPayment__c paymentTransaction1 = cc_imp_testUtils.createTransactionPayment(myOrder1.ID,'uid1');
        paymentTransaction1.ccrz__AccountType__c ='PO';
        paymentTransaction1.ccrz__AccountNumber__c = '1233564';
        insert paymentTransaction1;

        ccrz__E_Order__c myOrder2  = cc_imp_testUtils.createOrder(cart2.ID, userAccount.ID, userContact.ID, user.ID, cshipToAddr.ID, billToAddr.ID);
        myOrder2.ccrz__EncryptedId__c = 'DEF456';
        myOrder2.ccrz__OrderDate__c = Date.today();
        insert myOrder2;

        ccrz__E_TransactionPayment__c paymentTransaction2 = cc_imp_testUtils.createTransactionPayment(myOrder2.ID,'uid1');
        paymentTransaction2.ccrz__AccountType__c ='PO';
        paymentTransaction2.ccrz__AccountNumber__c = '345677';

        orderIds.add(myOrder1.ccrz__EncryptedId__c);
        //orderIds.add(myOrder2.ccrz__EncryptedId__c);

        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        ctx.effAccountId = userAccount.Id;

        ccrz.cc_RemoteActionResult res = cc_imp_ctrl_MyAccountOrders.getAllOrdersForShipToAddress(ctx);

        Map<String,Object> holder = (Map<String,Object>)res.data;
        List<ccrz.cc_bean_MockOrder> foundOrders = (List<ccrz.cc_bean_MockOrder>)holder.get('orders');

        System.assert(res != null);
        System.assert(res.data != null);
        System.assertEquals(res.success,true);
        System.assertEquals(foundOrders.size(), 2);


       Test.stopTest(); */
     }


     @isTest static void test_searchAllOrdersByParams() 
    {
       Test.startTest();

       List <cc_imp_StorefrontSettings__c > storeFrontSettingsList  = cc_imp_testUtils.createNexeoCustomSettingList();

       insert storeFrontSettingsList ;
       List<String> orderIds = new List <String>();
         Map<String, SObject> testData = NexeoTestUtils_Test.initData(); 
        Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.MYNEXEO_USER_COMMUNITY_PROFILE];

        ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
        insert userAccountGroup;

        Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
        insert userAccount;

        Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
        insert userContact;

        /*User user = cc_imp_testUtils.createUser(userProfile, userContact, 
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
        myOrder1.ccrz__EncryptedId__c = 'ABC123';
        myOrder1.ccrz__OrderDate__c = Date.today();
        insert myOrder1;

        ccrz__E_TransactionPayment__c paymentTransaction1 = cc_imp_testUtils.createTransactionPayment(myOrder1.ID,'uid1');
        paymentTransaction1.ccrz__AccountType__c ='PO';
        paymentTransaction1.ccrz__AccountNumber__c = '1233564';
        insert paymentTransaction1;

        ccrz__E_Order__c myOrder2  = cc_imp_testUtils.createOrder(cart2.ID, userAccount.ID, userContact.ID, user.ID, cshipToAddr.ID, billToAddr.ID);
        myOrder2.ccrz__EncryptedId__c = 'DEF456';
        myOrder2.ccrz__OrderDate__c = Date.today();
        insert myOrder2;

        ccrz__E_TransactionPayment__c paymentTransaction2 = cc_imp_testUtils.createTransactionPayment(myOrder2.ID,'uid1');
        paymentTransaction2.ccrz__AccountType__c ='PO';
        paymentTransaction2.ccrz__AccountNumber__c = '345677';

        orderIds.add(myOrder1.ccrz__EncryptedId__c);
        //orderIds.add(myOrder2.ccrz__EncryptedId__c);

        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        ctx.effAccountId = userAccount.Id;

        cc_mn_json_OrderQueryWrapper wrap = new cc_mn_json_OrderQueryWrapper();
    
        wrap.searchOrderInput = 'Open'; 
        wrap.searchOrderStatus = 'Open';
        wrap.fromDateStr = Date.today().format();
        wrap.toDateStr = Date.today().format();
        // wrap.ascending = '5';
        wrap.sortCriteria = 'OrderName';
        wrap.sortDir = 'DESC'; 

        String criteria = wrap.serialize();


        ccrz.cc_RemoteActionResult res = cc_imp_ctrl_MyAccountOrders.searchAllOrdersByParams(ctx, criteria);

        Map<String,Object> holder = (Map<String,Object>)res.data;
        List<ccrz.cc_bean_MockOrder> foundOrders = (List<ccrz.cc_bean_MockOrder>)holder.get('orders');

        System.assert(res != null);
        System.assert(res.data != null);
        System.assertEquals(res.success,true);
        System.assertEquals(foundOrders.size(), 0);


       Test.stopTest(); */
     }


      @isTest static void test_reorderByPoNumber() 
    {
       Test.startTest();

       List <cc_imp_StorefrontSettings__c > storeFrontSettingsList  = cc_imp_testUtils.createNexeoCustomSettingList();

       insert storeFrontSettingsList ;
       List<String> orderIds = new List <String>();
         Map<String, SObject> testData = NexeoTestUtils_Test.initData(); 
        Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.MYNEXEO_USER_COMMUNITY_PROFILE];

        ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
        insert userAccountGroup;

        Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
        insert userAccount;

        Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
        insert userContact;

        /*User user = cc_imp_testUtils.createUser(userProfile, userContact, 
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
        myOrder1.ccrz__EncryptedId__c = 'ABC123';
        myOrder1.ccrz__OrderDate__c = Date.today();
        myOrder1.ccrz__OrderStatus__c = 'Open';
        insert myOrder1;

        ccrz__E_TransactionPayment__c paymentTransaction1 = cc_imp_testUtils.createTransactionPayment(myOrder1.ID,'uid1');
        paymentTransaction1.ccrz__AccountType__c ='PO';
        paymentTransaction1.ccrz__AccountNumber__c = '1233564';
        insert paymentTransaction1;

        ccrz__E_Order__c myOrder2  = cc_imp_testUtils.createOrder(cart2.ID, userAccount.ID, userContact.ID, user.ID, cshipToAddr.ID, billToAddr.ID);
        myOrder2.ccrz__EncryptedId__c = 'DEF456';
        myOrder2.ccrz__OrderDate__c = Date.today();
        myOrder2.ccrz__OrderStatus__c = 'Open';
        insert myOrder2;

        ccrz__E_TransactionPayment__c paymentTransaction2 = cc_imp_testUtils.createTransactionPayment(myOrder2.ID,'uid1');
        paymentTransaction2.ccrz__AccountType__c ='PO';
        paymentTransaction2.ccrz__AccountNumber__c = '345677';

        orderIds.add(myOrder1.ccrz__EncryptedId__c);
        //orderIds.add(myOrder2.ccrz__EncryptedId__c);

        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        ctx.effAccountId = userAccount.Id;

        cc_mn_json_OrderQueryWrapper wrap = new cc_mn_json_OrderQueryWrapper();
    
        // wrap.searchOrderInput = 'Open'; 
        wrap.searchOrderStatus = 'Open';
        // wrap.fromDateStr = Date.today().format();
        // wrap.toDateStr = Date.today().format();
        // wrap.ascending = '5';
        // wrap.sortCriteria = 'OrderName';
        wrap.sortDir = 'Asc';  // remove this to force an exception

        String criteria = wrap.serialize();


        ccrz.cc_RemoteActionResult res = cc_imp_ctrl_MyAccountOrders.reorderByPONumber(ctx, criteria);

        Map<String,Object> holder = (Map<String,Object>)res.data;
        List<ccrz.cc_bean_MockOrder> foundOrders = (List<ccrz.cc_bean_MockOrder>)holder.get('orders');

        System.assert(res != null);
        System.assert(res.data != null);
        System.assertEquals(res.success,true);
        System.assertEquals(1, foundOrders.size());


       Test.stopTest(); */
     }    

     @isTest
     static void test_OrderWrapper(){
        cc_imp_ctrl_MyAccountOrders.ExtendedOrderHistory eh1 = new cc_imp_ctrl_MyAccountOrders.ExtendedOrderHistory();
        eh1.poNumber =  'po1';
        eh1.orderNumber = 'ord1';
        cc_imp_ctrl_MyAccountOrders.OrderWrapper wrap1 = new cc_imp_ctrl_MyAccountOrders.OrderWrapper(eh1, true);

        cc_imp_ctrl_MyAccountOrders.ExtendedOrderHistory eh2 = new cc_imp_ctrl_MyAccountOrders.ExtendedOrderHistory();
        eh2.poNumber =  'po2';
        eh2.orderNumber = 'ord2';
        cc_imp_ctrl_MyAccountOrders.OrderWrapper wrap2 = new cc_imp_ctrl_MyAccountOrders.OrderWrapper(eh2, true);

        System.assertEquals(-1, wrap1.compareTo(wrap2));

        wrap1.isAscending = false;
        wrap2.isAscending = false;
        System.assertEquals(1, wrap1.compareTo(wrap2));

     }

      @isTest static void test_reorderByPoNumberWithException() 
    {
       Test.startTest();

       List <cc_imp_StorefrontSettings__c > storeFrontSettingsList  = cc_imp_testUtils.createNexeoCustomSettingList();

       insert storeFrontSettingsList ;
       List<String> orderIds = new List <String>();
         Map<String, SObject> testData = NexeoTestUtils_Test.initData(); 
        Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.MYNEXEO_USER_COMMUNITY_PROFILE];

        ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
        insert userAccountGroup;

        Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
        insert userAccount;

        Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
        insert userContact;

        /*User user = cc_imp_testUtils.createUser(userProfile, userContact, 
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
        myOrder1.ccrz__EncryptedId__c = 'ABC123';
        myOrder1.ccrz__OrderDate__c = Date.today();
        myOrder1.ccrz__OrderStatus__c = 'Open';
        insert myOrder1;

        ccrz__E_TransactionPayment__c paymentTransaction1 = cc_imp_testUtils.createTransactionPayment(myOrder1.ID,'uid1');
        paymentTransaction1.ccrz__AccountType__c ='PO';
        paymentTransaction1.ccrz__AccountNumber__c = '1233564';
        insert paymentTransaction1;

        ccrz__E_Order__c myOrder2  = cc_imp_testUtils.createOrder(cart2.ID, userAccount.ID, userContact.ID, user.ID, cshipToAddr.ID, billToAddr.ID);
        myOrder2.ccrz__EncryptedId__c = 'DEF456';
        myOrder2.ccrz__OrderDate__c = Date.today();
        myOrder2.ccrz__OrderStatus__c = 'Open';
        insert myOrder2;

        ccrz__E_TransactionPayment__c paymentTransaction2 = cc_imp_testUtils.createTransactionPayment(myOrder2.ID,'uid1');
        paymentTransaction2.ccrz__AccountType__c ='PO';
        paymentTransaction2.ccrz__AccountNumber__c = '345677';

        orderIds.add(myOrder1.ccrz__EncryptedId__c);
        //orderIds.add(myOrder2.ccrz__EncryptedId__c);

        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        ctx.effAccountId = userAccount.Id;

        cc_mn_json_OrderQueryWrapper wrap = new cc_mn_json_OrderQueryWrapper();
    
        // wrap.searchOrderInput = 'Open'; 
        wrap.searchOrderStatus = 'Open';

        String criteria = wrap.serialize();


        ccrz.cc_RemoteActionResult res = cc_imp_ctrl_MyAccountOrders.reorderByPONumber(ctx, criteria);

        Map<String,Object> holder = (Map<String,Object>)res.data;
        List<ccrz.cc_bean_MockOrder> foundOrders = (List<ccrz.cc_bean_MockOrder>)holder.get('orders');

        System.assert(res != null);
        System.assert(res.data != null);
        System.assertEquals(false, res.success);


       Test.stopTest(); */
     }

    @isTest static void test_fetchInvoicesNullOrderDate(){

                List <cc_imp_StorefrontSettings__c> customSettingLists = cc_imp_testUtils.createNexeoCustomSettingList();
        insert customSettingLists ;
         Map<String, SObject> testData = NexeoTestUtils_Test.initData(); 
        Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.MYNEXEO_USER_COMMUNITY_PROFILE];

        ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
        insert userAccountGroup;

        Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
        insert userAccount;

        Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
        insert userContact;

        /*User portalUser = cc_imp_testUtils.createUser(userProfile, userContact, 
            'username@email.com', 'contact@email.com', 'firstName', 'lastName', 'alias');
        insert portalUser;

        ccrz__E_ContactAddr__c address = cc_imp_testUtils.createContactAddress(
            portalUser,
            'line1',
            'line2',
            'line3',
            'city',
            'state',
            'country',
            '11111'
        );
        insert address;

        List<ccrz__E_AccountAddressBook__c> addrBookList = new List<ccrz__E_AccountAddressBook__c>();
        ccrz__E_AccountAddressBook__c shippingAddressBook = cc_imp_testUtils.createAccountAddressBook(userAccount,'Shipping', address, portalUser, true);
        ccrz__E_AccountAddressBook__c billingAddressBook = cc_imp_testUtils.createAccountAddressBook(userAccount,'Billing', address, portalUser, true);
        addrBookList.add(shippingAddressBook);
        addrBookList.add(billingAddressBook);
        insert addrBookList;

        
        ccrz__E_Product__c product = cc_imp_testUtils.createProduct('Product 1', 'product-01', 'Major', cc_imp_testUtils.DEFAULT_STOREFRONT);
        insert product;

        
        ccrz__E_Product__c parentProduct = cc_imp_testUtils.createProduct('Parent Product', 'product-02');
        insert parentProduct;
        System.debug('!!!!!!!11!!!!!!');
        List<ccrz__E_Product__c> productList = new List<ccrz__E_Product__c>();
        productList.add(product);

       
        ccrz__E_Category__c category = cc_imp_testUtils.createCategory('300000');
        insert category;

       
        ccrz__E_ProductCategory__c productCategory = cc_imp_testUtils.createProductCategory(product, '1001', category);
        insert productCategory;


        
        ccrz__E_PriceList__c priceList = cc_imp_testUtils.createPriceList('General', cc_imp_testUtils.DEFAULT_STOREFRONT);
        insert priceList;

        ccrz__E_AccountGroupPriceList__c agrpPriceList =  cc_imp_testUtils.createAccountGroupPriceList(userAccountGroup, priceList);
        insert agrpPriceList;

        List<ccrz__E_PriceListItem__c> priceListItems = cc_imp_testUtils.createPriceListItems(productList, priceList);
        insert priceListItems;
        
                
        ccrz__E_Cart__c cart = cc_imp_testUtils.createCart(userAccount, address, address, portalUser, userContact, 'Cart', cc_imp_testUtils.DEFAULT_STOREFRONT);
        insert cart;

        
        ccrz__E_CartItem__c cartItem = cc_imp_testUtils.createCartItem(cart, 9.99, 1, product, null);
        insert cartItem;

        ccrz__E_ContactAddr__c cshipToAddr = cc_imp_testUtils.createContactAddress(portalUser, 'line1', 'line2', 'line3', 'city', 'IL', 'US','postalCode');
        insert cshipToAddr;

        ccrz__E_ContactAddr__c billToAddr = cc_imp_testUtils.createContactAddress(portalUser, 'line1', 'line2', 'line3', 'city', 'IL', 'US','postalCode');
        insert billToAddr;


        ccrz__E_Order__c myOrder1  = cc_imp_testUtils.createOrder(cart.ID, userAccount.ID, userContact.ID, portalUser.ID, cshipToAddr.ID, billToAddr.ID);

        myOrder1.ccrz__EncryptedId__c = 'ABC123';
        myOrder1.ccrz__OrderStatus__c = 'COOL';
        //myOrder1.ccrz__OrderDate__c = Date.valueOf('2015-12-31');

        insert myOrder1;


       Test.startTest();

       Map <String, String> headerMap = new Map<String, String> ();
     headerMap.put('Content-Type','application/json');

       Test.setMock(HttpCalloutMock.class, new cc_imp_mn_FetchInvoiceMock_HttpResponse(200,'success',mockResponse(), headerMap));

       cc_imp_testUtils.clearContext();

       ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_MYNEXEO_STOREFRONT;
       ccrz.cc_CallContext.currAccountId = userAccount.Id;

       ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();

       ccrz.cc_RemoteActionResult res  = cc_imp_ctrl_MyAccountOrders.getAllInvoicesForShipToAddress(ctx);
       
      System.assert(res != null);
      System.assert(res.data != null);

      Test.stopTest();*/

       

      }    

    @isTest static void test_getAllOrdersForShipToAddressOrderDateNull() 
    {
       Test.startTest();

       List <cc_imp_StorefrontSettings__c > storeFrontSettingsList  = cc_imp_testUtils.createNexeoCustomSettingList();

       insert storeFrontSettingsList ;
       List<String> orderIds = new List <String>();
         Map<String, SObject> testData = NexeoTestUtils_Test.initData(); 
        Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.MYNEXEO_USER_COMMUNITY_PROFILE];

        ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
        insert userAccountGroup;

        Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
        insert userAccount;

        Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
        insert userContact;

        /*User user = cc_imp_testUtils.createUser(userProfile, userContact, 
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
        myOrder1.ccrz__EncryptedId__c = 'ABC123';
        //myOrder1.ccrz__OrderDate__c = Date.today();
        insert myOrder1;

        ccrz__E_TransactionPayment__c paymentTransaction1 = cc_imp_testUtils.createTransactionPayment(myOrder1.ID,'uid1');
        paymentTransaction1.ccrz__AccountType__c ='PO';
        paymentTransaction1.ccrz__AccountNumber__c = '1233564';
        insert paymentTransaction1;

        ccrz__E_Order__c myOrder2  = cc_imp_testUtils.createOrder(cart2.ID, userAccount.ID, userContact.ID, user.ID, cshipToAddr.ID, billToAddr.ID);
        myOrder2.ccrz__EncryptedId__c = 'DEF456';
        //myOrder2.ccrz__OrderDate__c = Date.today();
        insert myOrder2;

        ccrz__E_TransactionPayment__c paymentTransaction2 = cc_imp_testUtils.createTransactionPayment(myOrder2.ID,'uid1');
        paymentTransaction2.ccrz__AccountType__c ='PO';
        paymentTransaction2.ccrz__AccountNumber__c = '345677';

        orderIds.add(myOrder1.ccrz__EncryptedId__c);
        //orderIds.add(myOrder2.ccrz__EncryptedId__c);

        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        ctx.effAccountId = userAccount.Id;

        ccrz.cc_RemoteActionResult res = cc_imp_ctrl_MyAccountOrders.getAllOrdersForShipToAddress(ctx);

        Map<String,Object> holder = (Map<String,Object>)res.data;
        List<ccrz.cc_bean_MockOrder> foundOrders = (List<ccrz.cc_bean_MockOrder>)holder.get('orders');

        System.assert(res != null);
        System.assert(res.data != null);
        System.assertEquals(res.success,true);
        System.assertEquals(foundOrders.size(), 2);


       Test.stopTest();*/ 
     }

      private static String mockResponse()
      {
        return '{\"document\": \"643774\"}';
      }
}