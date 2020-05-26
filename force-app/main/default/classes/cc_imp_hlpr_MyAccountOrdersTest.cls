@isTest
private class cc_imp_hlpr_MyAccountOrdersTest {


    @isTest static void test_MyAccountOrders_Query() {

        List <cc_imp_StorefrontSettings__c> customSettingLists = cc_imp_testUtils.createNexeoCustomSettingList();
        insert customSettingLists ;

        Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.MYNEXEO_USER_COMMUNITY_PROFILE];

        ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
        insert userAccountGroup;
		Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
        insert userAccount;

        Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
        insert userContact;

        User portalUser = cc_imp_testUtils.createUser(userProfile, userContact, 
            'username@email.com', 'contact@email.com', 'firstName', 'lastName', 'alias');
        //insert portalUser;

        ccrz__E_ContactAddr__c address = cc_imp_testUtils.createContactAddress(
            nexeoIntegrationUser,
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
        ccrz__E_AccountAddressBook__c shippingAddressBook = cc_imp_testUtils.createAccountAddressBook(userAccount,'Shipping', address, nexeoIntegrationUser, true);
        ccrz__E_AccountAddressBook__c billingAddressBook = cc_imp_testUtils.createAccountAddressBook(userAccount,'Billing', address, nexeoIntegrationUser, true);
        addrBookList.add(shippingAddressBook);
        addrBookList.add(billingAddressBook);
        insert addrBookList;

        /*
        * Product
        */
        ccrz__E_Product__c product = cc_imp_testUtils.createProduct('Product 1', 'product-01', 'Major', cc_imp_testUtils.DEFAULT_STOREFRONT);
        insert product;

        /*
        * Parent Product
        */
        ccrz__E_Product__c parentProduct = cc_imp_testUtils.createProduct('Parent Product', 'product-02');
        insert parentProduct;
        System.debug('!!!!!!!11!!!!!!');
        List<ccrz__E_Product__c> productList = new List<ccrz__E_Product__c>();
        productList.add(product);

        /*
        * Category
        */
        ccrz__E_Category__c category = cc_imp_testUtils.createCategory('300000');
        insert category;

        /*
        * Product Category
        */
        ccrz__E_ProductCategory__c productCategory = cc_imp_testUtils.createProductCategory(product, '1001', category);
        insert productCategory;


        /*
        * Price List
        */
        ccrz__E_PriceList__c priceList = cc_imp_testUtils.createPriceList('General', cc_imp_testUtils.DEFAULT_STOREFRONT);
        insert priceList;

        ccrz__E_AccountGroupPriceList__c agrpPriceList =  cc_imp_testUtils.createAccountGroupPriceList(userAccountGroup, priceList);
        insert agrpPriceList;

        /*
        * Price List Item
        */
        List<ccrz__E_PriceListItem__c> priceListItems = cc_imp_testUtils.createPriceListItems(productList, priceList);
        insert priceListItems;
        
                /*
        * Cart
        */
        ccrz__E_Cart__c cart = cc_imp_testUtils.createCart(userAccount, address, address, nexeoIntegrationUser, userContact, 'Cart', cc_imp_testUtils.DEFAULT_STOREFRONT);
        insert cart;

        /*
        * Cart Item
        * - Normal Cart
        */
        ccrz__E_CartItem__c cartItem = cc_imp_testUtils.createCartItem(cart, 9.99, 1, product, null);
        insert cartItem;

        ccrz__E_ContactAddr__c cshipToAddr = cc_imp_testUtils.createContactAddress(nexeoIntegrationUser, 'line1', 'line2', 'line3', 'city', 'IL', 'US','postalCode');
        insert cshipToAddr;

        ccrz__E_ContactAddr__c billToAddr = cc_imp_testUtils.createContactAddress(nexeoIntegrationUser, 'line1', 'line2', 'line3', 'city', 'IL', 'US','postalCode');
        insert billToAddr;


        ccrz__E_Order__c myOrder1  = cc_imp_testUtils.createOrder(cart.ID, userAccount.ID, userContact.ID, nexeoIntegrationUser.ID, cshipToAddr.ID, billToAddr.ID);

        myOrder1.ccrz__EncryptedId__c = 'ABC123';
        myOrder1.ccrz__OrderStatus__c = 'COOL';
        myOrder1.ccrz__OrderDate__c = Date.valueOf('2015-12-31');

        insert myOrder1;


       Test.startTest();

       cc_imp_testUtils.clearContext();

       ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_MYNEXEO_STOREFRONT;
       ccrz.cc_CallContext.currAccountId = userAccount.Id;

       ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();



            //List<ccrz.cc_bean_MockOrder> allOrders = cc_imp_hlpr_MyAccountOrders.getAllOrders(userAccount.Id);

           /* if(allOrders!=null){
                ccrz.cc_bean_MockOrder orderBean = allOrders.get(0);

                System.assert(orderBean.encryptedId == 'ABC123');
            }*/


        Test.stopTest();

    }
    


    @isTest static void test_MyAccountOrdersByOrderId_Query() {

        List <cc_imp_StorefrontSettings__c> customSettingLists = cc_imp_testUtils.createNexeoCustomSettingList();
        insert customSettingLists ;

        Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.MYNEXEO_USER_COMMUNITY_PROFILE];
		Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
        insert userAccountGroup;

        Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
        insert userAccount;

        Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
        insert userContact;

        User portalUser = cc_imp_testUtils.createUser(userProfile, userContact, 
            'username@email.com', 'contact@email.com', 'firstName', 'lastName', 'alias');
        //insert portalUser;

        ccrz__E_ContactAddr__c address = cc_imp_testUtils.createContactAddress(
            nexeoIntegrationUser,
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
        ccrz__E_AccountAddressBook__c shippingAddressBook = cc_imp_testUtils.createAccountAddressBook(userAccount,'Shipping', address, nexeoIntegrationUser, true);
        ccrz__E_AccountAddressBook__c billingAddressBook = cc_imp_testUtils.createAccountAddressBook(userAccount,'Billing', address, nexeoIntegrationUser, true);
        addrBookList.add(shippingAddressBook);
        addrBookList.add(billingAddressBook);
        insert addrBookList;

        /*
        * Product
        */
        ccrz__E_Product__c product = cc_imp_testUtils.createProduct('Product 1', 'product-01', 'Major', cc_imp_testUtils.DEFAULT_STOREFRONT);
        insert product;

        /*
        * Parent Product
        */
        ccrz__E_Product__c parentProduct = cc_imp_testUtils.createProduct('Parent Product', 'product-02');
        insert parentProduct;
        System.debug('!!!!!!!11!!!!!!');
        List<ccrz__E_Product__c> productList = new List<ccrz__E_Product__c>();
        productList.add(product);

        /*
        * Category
        */
        ccrz__E_Category__c category = cc_imp_testUtils.createCategory('300000');
        insert category;

        /*
        * Product Category
        */
        ccrz__E_ProductCategory__c productCategory = cc_imp_testUtils.createProductCategory(product, '1001', category);
        insert productCategory;


        /*
        * Price List
        */
        ccrz__E_PriceList__c priceList = cc_imp_testUtils.createPriceList('General', cc_imp_testUtils.DEFAULT_STOREFRONT);
        insert priceList;

        ccrz__E_AccountGroupPriceList__c agrpPriceList =  cc_imp_testUtils.createAccountGroupPriceList(userAccountGroup, priceList);
        insert agrpPriceList;

        /*
        * Price List Item
        */
        List<ccrz__E_PriceListItem__c> priceListItems = cc_imp_testUtils.createPriceListItems(productList, priceList);
        insert priceListItems;
        
                /*
        * Cart
        */
        ccrz__E_Cart__c cart = cc_imp_testUtils.createCart(userAccount, address, address, nexeoIntegrationUser, userContact, 'Cart', cc_imp_testUtils.DEFAULT_STOREFRONT);
        insert cart;

        /*
        * Cart Item
        * - Normal Cart
        */
        ccrz__E_CartItem__c cartItem = cc_imp_testUtils.createCartItem(cart, 9.99, 1, product, null);
        insert cartItem;

        ccrz__E_ContactAddr__c cshipToAddr = cc_imp_testUtils.createContactAddress(nexeoIntegrationUser, 'line1', 'line2', 'line3', 'city', 'IL', 'US','postalCode');
        insert cshipToAddr;

        ccrz__E_ContactAddr__c billToAddr = cc_imp_testUtils.createContactAddress(nexeoIntegrationUser, 'line1', 'line2', 'line3', 'city', 'IL', 'US','postalCode');
        insert billToAddr;


        ccrz__E_Order__c myOrder1  = cc_imp_testUtils.createOrder(cart.ID, userAccount.ID, userContact.ID, nexeoIntegrationUser.ID, cshipToAddr.ID, billToAddr.ID);

        myOrder1.ccrz__EncryptedId__c = 'ABC123';
        myOrder1.ccrz__OrderStatus__c = 'COOL';
        myOrder1.ccrz__OrderDate__c = Date.valueOf('2015-12-31');

        ccrz__E_TransactionPayment__c paymentTransaction1 = cc_imp_testUtils.createTransactionPayment(myOrder1.ID,'uid1');
        paymentTransaction1.ccrz__AccountType__c ='PO';
        paymentTransaction1.ccrz__AccountNumber__c = '1233564';
        insert paymentTransaction1;

        insert myOrder1;


       Test.startTest();

       cc_imp_testUtils.clearContext();

       ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_MYNEXEO_STOREFRONT;
       ccrz.cc_CallContext.currAccountId = userAccount.Id;

       ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();

            List<String> testOrderIds = new List<String>();

            testOrderIds.add(String.valueOf(myOrder1.Id ));



            List<ccrz__E_Order__c> allOrders = cc_imp_hlpr_MyAccountOrders.queryOrdersByOrderIds(testOrderIds);

            if(allOrders!=null && allOrders.size() > 0){
                ccrz__E_Order__c orderBean = allOrders.get(0);

                System.assert(orderBean.ccrz__EncryptedId__c == 'ABC123');
            }


        Test.stopTest();

    }

       @isTest static void test_MyAccountOrders_Query_With_Params() {

        List <cc_imp_StorefrontSettings__c> customSettingLists = cc_imp_testUtils.createNexeoCustomSettingList();
        insert customSettingLists ;

        Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.MYNEXEO_USER_COMMUNITY_PROFILE];

        ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
        insert userAccountGroup;
Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
        insert userAccount;

        Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
        insert userContact;

        User portalUser = cc_imp_testUtils.createUser(userProfile, userContact, 
            'username@email.com', 'contact@email.com', 'firstName', 'lastName', 'alias');
        //insert portalUser;

        ccrz__E_ContactAddr__c address = cc_imp_testUtils.createContactAddress(
            nexeoIntegrationUser,
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
        ccrz__E_AccountAddressBook__c shippingAddressBook = cc_imp_testUtils.createAccountAddressBook(userAccount,'Shipping', address, nexeoIntegrationUser, true);
        ccrz__E_AccountAddressBook__c billingAddressBook = cc_imp_testUtils.createAccountAddressBook(userAccount,'Billing', address, nexeoIntegrationUser, true);
        addrBookList.add(shippingAddressBook);
        addrBookList.add(billingAddressBook);
        insert addrBookList;

        /*
        * Product
        */
        ccrz__E_Product__c product = cc_imp_testUtils.createProduct('Product 1', 'product-01', 'Major', cc_imp_testUtils.DEFAULT_STOREFRONT);
        insert product;

        /*
        * Parent Product
        */
        ccrz__E_Product__c parentProduct = cc_imp_testUtils.createProduct('Parent Product', 'product-02');
        insert parentProduct;
        System.debug('!!!!!!!11!!!!!!');
        List<ccrz__E_Product__c> productList = new List<ccrz__E_Product__c>();
        productList.add(product);

        /*
        * Category
        */
        ccrz__E_Category__c category = cc_imp_testUtils.createCategory('300000');
        insert category;

        /*
        * Product Category
        */
        ccrz__E_ProductCategory__c productCategory = cc_imp_testUtils.createProductCategory(product, '1001', category);
        insert productCategory;


        /*
        * Price List
        */
        ccrz__E_PriceList__c priceList = cc_imp_testUtils.createPriceList('General', cc_imp_testUtils.DEFAULT_STOREFRONT);
        insert priceList;

        ccrz__E_AccountGroupPriceList__c agrpPriceList =  cc_imp_testUtils.createAccountGroupPriceList(userAccountGroup, priceList);
        insert agrpPriceList;

        /*
        * Price List Item
        */
        List<ccrz__E_PriceListItem__c> priceListItems = cc_imp_testUtils.createPriceListItems(productList, priceList);
        insert priceListItems;
        
                /*
        * Cart
        */
        ccrz__E_Cart__c cart = cc_imp_testUtils.createCart(userAccount, address, address, nexeoIntegrationUser, userContact, 'Cart', cc_imp_testUtils.DEFAULT_STOREFRONT);
        insert cart;

        /*
        * Cart Item
        * - Normal Cart
        */
        ccrz__E_CartItem__c cartItem = cc_imp_testUtils.createCartItem(cart, 9.99, 1, product, null);
        insert cartItem;

        ccrz__E_ContactAddr__c cshipToAddr = cc_imp_testUtils.createContactAddress(nexeoIntegrationUser, 'line1', 'line2', 'line3', 'city', 'IL', 'US','postalCode');
        insert cshipToAddr;

        ccrz__E_ContactAddr__c billToAddr = cc_imp_testUtils.createContactAddress(nexeoIntegrationUser, 'line1', 'line2', 'line3', 'city', 'IL', 'US','postalCode');
        insert billToAddr;


        ccrz__E_Order__c myOrder1  = cc_imp_testUtils.createOrder(cart.ID, userAccount.ID, userContact.ID, nexeoIntegrationUser.ID, cshipToAddr.ID, billToAddr.ID);

        myOrder1.ccrz__EncryptedId__c = 'ABC123';
        myOrder1.ccrz__OrderStatus__c = 'Open';
        myOrder1.ccrz__OrderDate__c = Date.valueOf('2015-12-31');

        insert myOrder1;


       Test.startTest();

       cc_imp_testUtils.clearContext();

       ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_MYNEXEO_STOREFRONT;
       ccrz.cc_CallContext.currAccountId = userAccount.Id;

       ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();

        cc_mn_json_OrderQueryWrapper wrapper = new cc_mn_json_OrderQueryWrapper();
        wrapper.searchOrderStatus = 'Open';

        //List<ccrz.cc_bean_MockOrder>  orders = cc_imp_hlpr_MyAccountOrders.getAllOrdersFilteredByParams(userAccount.Id,wrapper);

        //System.assertEquals(1, orders.size());




        Test.stopTest();

    }

    @isTest static void test_MyAccountOrders_Query_OrderDateNull() {

        List <cc_imp_StorefrontSettings__c> customSettingLists = cc_imp_testUtils.createNexeoCustomSettingList();
        insert customSettingLists ;

        Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.MYNEXEO_USER_COMMUNITY_PROFILE];
		Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
        insert userAccountGroup;

        Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
        insert userAccount;

        Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
        insert userContact;

        User portalUser = cc_imp_testUtils.createUser(userProfile, userContact, 
            'username@email.com', 'contact@email.com', 'firstName', 'lastName', 'alias');
        //insert portalUser;

        ccrz__E_ContactAddr__c address = cc_imp_testUtils.createContactAddress(
            nexeoIntegrationUser,
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
        ccrz__E_AccountAddressBook__c shippingAddressBook = cc_imp_testUtils.createAccountAddressBook(userAccount,'Shipping', address, nexeoIntegrationUser, true);
        ccrz__E_AccountAddressBook__c billingAddressBook = cc_imp_testUtils.createAccountAddressBook(userAccount,'Billing', address, nexeoIntegrationUser, true);
        addrBookList.add(shippingAddressBook);
        addrBookList.add(billingAddressBook);
        insert addrBookList;

        /*
        * Product
        */
        ccrz__E_Product__c product = cc_imp_testUtils.createProduct('Product 1', 'product-01', 'Major', cc_imp_testUtils.DEFAULT_STOREFRONT);
        insert product;

        /*
        * Parent Product
        */
        ccrz__E_Product__c parentProduct = cc_imp_testUtils.createProduct('Parent Product', 'product-02');
        insert parentProduct;
        System.debug('!!!!!!!11!!!!!!');
        List<ccrz__E_Product__c> productList = new List<ccrz__E_Product__c>();
        productList.add(product);

        /*
        * Category
        */
        ccrz__E_Category__c category = cc_imp_testUtils.createCategory('300000');
        insert category;

        /*
        * Product Category
        */
        ccrz__E_ProductCategory__c productCategory = cc_imp_testUtils.createProductCategory(product, '1001', category);
        insert productCategory;


        /*
        * Price List
        */
        ccrz__E_PriceList__c priceList = cc_imp_testUtils.createPriceList('General', cc_imp_testUtils.DEFAULT_STOREFRONT);
        insert priceList;

        ccrz__E_AccountGroupPriceList__c agrpPriceList =  cc_imp_testUtils.createAccountGroupPriceList(userAccountGroup, priceList);
        insert agrpPriceList;

        /*
        * Price List Item
        */
        List<ccrz__E_PriceListItem__c> priceListItems = cc_imp_testUtils.createPriceListItems(productList, priceList);
        insert priceListItems;
        
                /*
        * Cart
        */
        ccrz__E_Cart__c cart = cc_imp_testUtils.createCart(userAccount, address, address, nexeoIntegrationUser, userContact, 'Cart', cc_imp_testUtils.DEFAULT_STOREFRONT);
        insert cart;

        /*
        * Cart Item
        * - Normal Cart
        */
        ccrz__E_CartItem__c cartItem = cc_imp_testUtils.createCartItem(cart, 9.99, 1, product, null);
        insert cartItem;

        ccrz__E_ContactAddr__c cshipToAddr = cc_imp_testUtils.createContactAddress(nexeoIntegrationUser, 'line1', 'line2', 'line3', 'city', 'IL', 'US','postalCode');
        insert cshipToAddr;

        ccrz__E_ContactAddr__c billToAddr = cc_imp_testUtils.createContactAddress(nexeoIntegrationUser, 'line1', 'line2', 'line3', 'city', 'IL', 'US','postalCode');
        insert billToAddr;


        ccrz__E_Order__c myOrder1  = cc_imp_testUtils.createOrder(cart.ID, userAccount.ID, userContact.ID, nexeoIntegrationUser.ID, cshipToAddr.ID, billToAddr.ID);

        myOrder1.ccrz__EncryptedId__c = 'ABC123';
        myOrder1.ccrz__OrderStatus__c = 'COOL';

        insert myOrder1;


       Test.startTest();

       cc_imp_testUtils.clearContext();

       ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_MYNEXEO_STOREFRONT;
       ccrz.cc_CallContext.currAccountId = userAccount.Id;

       ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();



            //List<ccrz.cc_bean_MockOrder> allOrders = cc_imp_hlpr_MyAccountOrders.getAllOrders(userAccount.Id);

            /*if(allOrders!=null){
                ccrz.cc_bean_MockOrder orderBean = allOrders.get(0);

                System.assert(orderBean.encryptedId == 'ABC123');
            }*/


        Test.stopTest();

    }

     @isTest static void test_MyAccountOrders_Query_With_Params_AndNullOrderDate() {

        List <cc_imp_StorefrontSettings__c> customSettingLists = cc_imp_testUtils.createNexeoCustomSettingList();
        insert customSettingLists ;

        Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.MYNEXEO_USER_COMMUNITY_PROFILE];

        ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
        insert userAccountGroup;
Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
        insert userAccount;

        Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
        insert userContact;

        User portalUser = cc_imp_testUtils.createUser(userProfile, userContact, 
            'username@email.com', 'contact@email.com', 'firstName', 'lastName', 'alias');
        //insert portalUser;

        ccrz__E_ContactAddr__c address = cc_imp_testUtils.createContactAddress(
            nexeoIntegrationUser,
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
        ccrz__E_AccountAddressBook__c shippingAddressBook = cc_imp_testUtils.createAccountAddressBook(userAccount,'Shipping', address, nexeoIntegrationUser, true);
        ccrz__E_AccountAddressBook__c billingAddressBook = cc_imp_testUtils.createAccountAddressBook(userAccount,'Billing', address, nexeoIntegrationUser, true);
        addrBookList.add(shippingAddressBook);
        addrBookList.add(billingAddressBook);
        insert addrBookList;

        /*
        * Product
        */
        ccrz__E_Product__c product = cc_imp_testUtils.createProduct('Product 1', 'product-01', 'Major', cc_imp_testUtils.DEFAULT_STOREFRONT);
        insert product;

        /*
        * Parent Product
        */
        ccrz__E_Product__c parentProduct = cc_imp_testUtils.createProduct('Parent Product', 'product-02');
        insert parentProduct;
        System.debug('!!!!!!!11!!!!!!');
        List<ccrz__E_Product__c> productList = new List<ccrz__E_Product__c>();
        productList.add(product);

        /*
        * Category
        */
        ccrz__E_Category__c category = cc_imp_testUtils.createCategory('300000');
        insert category;

        /*
        * Product Category
        */
        ccrz__E_ProductCategory__c productCategory = cc_imp_testUtils.createProductCategory(product, '1001', category);
        insert productCategory;


        /*
        * Price List
        */
        ccrz__E_PriceList__c priceList = cc_imp_testUtils.createPriceList('General', cc_imp_testUtils.DEFAULT_STOREFRONT);
        insert priceList;

        ccrz__E_AccountGroupPriceList__c agrpPriceList =  cc_imp_testUtils.createAccountGroupPriceList(userAccountGroup, priceList);
        insert agrpPriceList;

        /*
        * Price List Item
        */
        List<ccrz__E_PriceListItem__c> priceListItems = cc_imp_testUtils.createPriceListItems(productList, priceList);
        insert priceListItems;
        
                /*
        * Cart
        */
        ccrz__E_Cart__c cart = cc_imp_testUtils.createCart(userAccount, address, address, nexeoIntegrationUser, userContact, 'Cart', cc_imp_testUtils.DEFAULT_STOREFRONT);
        insert cart;

        /*
        * Cart Item
        * - Normal Cart
        */
        ccrz__E_CartItem__c cartItem = cc_imp_testUtils.createCartItem(cart, 9.99, 1, product, null);
        insert cartItem;

        ccrz__E_ContactAddr__c cshipToAddr = cc_imp_testUtils.createContactAddress(nexeoIntegrationUser, 'line1', 'line2', 'line3', 'city', 'IL', 'US','postalCode');
        insert cshipToAddr;

        ccrz__E_ContactAddr__c billToAddr = cc_imp_testUtils.createContactAddress(nexeoIntegrationUser, 'line1', 'line2', 'line3', 'city', 'IL', 'US','postalCode');
        insert billToAddr;


        ccrz__E_Order__c myOrder1  = cc_imp_testUtils.createOrder(cart.ID, userAccount.ID, userContact.ID, nexeoIntegrationUser.ID, cshipToAddr.ID, billToAddr.ID);

        myOrder1.ccrz__EncryptedId__c = 'ABC123';
        myOrder1.ccrz__OrderStatus__c = 'Open';
        //myOrder1.ccrz__OrderDate__c = Date.valueOf('2015-12-31');

        insert myOrder1;


       Test.startTest();

       cc_imp_testUtils.clearContext();

       ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_MYNEXEO_STOREFRONT;
       ccrz.cc_CallContext.currAccountId = userAccount.Id;

       ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();

        cc_mn_json_OrderQueryWrapper wrapper = new cc_mn_json_OrderQueryWrapper();
        wrapper.fromDateStr = '12/31/2015';
        wrapper.toDateStr = '12/31/2017';

        List<ccrz.cc_bean_MockOrder>  orders = cc_imp_hlpr_MyAccountOrders.getAllOrdersFilteredByParams(userAccount.Id,wrapper);

        System.assertEquals(0, orders.size());




        Test.stopTest();

    }
}