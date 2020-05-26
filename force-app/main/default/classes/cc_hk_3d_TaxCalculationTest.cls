@isTest

private class cc_hk_3d_TaxCalculationTest { 

    @isTest static void test_TaxCalculation_Positive_Scenario() {
        Map<String, Object> dataMap = cc_imp_testUtils.initData();
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        system.runas(nexeoIntegrationUser)
        {
        List <cc_imp_StorefrontSettings__c > storeFrontSettingsList = cc_imp_testUtils.createNexeoCustomSettingList();
        insert storeFrontSettingsList ;

        
        ccrz__E_Cart__c cart = (ccrz__E_Cart__c)dataMap.get('cart');
        cart.ccrz__ShipAmount__c = 18.02;
        update cart;

        ccrz__E_CartItem__c cartItem = (ccrz__E_CartItem__c)dataMap.get('cartItem');

        User user = (User)dataMap.get('portalUser');

        Account userAccount = (Account)dataMap.get('userAccount');
        userAccount.VAT_Number__c = '100';
        update userAccount;
 
        Contact userContact = (Contact)dataMap.get('userContact');

        ccrz__E_ContactAddr__c cshipToAddr = cc_imp_testUtils.createContactAddress(user, 'line1', 'line2', 'line3', 'city', 'IL', 'FR','postalCode');
        insert cshipToAddr;

        ccrz__E_ContactAddr__c billToAddr = cc_imp_testUtils.createContactAddress(user, 'line1', 'line2', 'line3', 'city', 'IL', 'FR','postalCode');
        insert billToAddr;


        ccrz__E_Order__c myOrder1  = cc_imp_testUtils.createOrder(cart.ID, userAccount.ID, userContact.ID, user.ID, cshipToAddr.ID, billToAddr.ID);
        insert myOrder1;

        ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_NEXEO3D_STOREFRONT;

        ccrz.cc_bean_MockContactAddress mockContactAddress = new  ccrz.cc_bean_MockContactAddress();
        mockContactAddress.countryCode = 'FR';

        Map<String, Object> inputMap = new Map<String,Object>();
        inputMap.put(ccrz.cc_hk_TaxCalculation.PARAM_CARTID, String.valueOf(cart.Id));
        inputMap.put(ccrz.cc_hk_TaxCalculation.PARAM_SHIPADDR,mockContactAddress);

       Map <String, String> headerMap = new Map<String, String> ();
       headerMap.put('Content-Type', 'text/xml;charset=UTF-8');
       headerMap.put('SOAPAction', 'urn:ec.europa.eu:taxud:vies:services:checkVat#checkVat');

        
        // Test.setMock(HttpCalloutMock.class, new cc_imp_3d_FetchVATValidator_HttpResponse(200,'success',mockResponse(), headerMap));
        Test.setMock(HttpCalloutMock.class, new cc_imp_3d_VatAndTax_HttpResponse(200,'success',mockResponse(), headerMap, true));

         Test.startTest();
        

        cc_hk_3d_TaxCalculation taxCalc = new cc_hk_3d_TaxCalculation();

        Decimal d = taxCalc.getTaxAmount(inputMap);

        Test.stopTest();
        
        //System.assertEquals( d , 0.0);
        System.assertEquals( d , 6.99);
        }
    }

    @isTest static void test_TaxCalculation_NO() {

       String msg0 = '!!!!FIRTST!!!!';
       system.debug(msg0);

        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
      
        List <cc_imp_StorefrontSettings__c > storeFrontSettingsList = cc_imp_testUtils.createNexeoCustomSettingList();

       insert storeFrontSettingsList ;

       Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.MYNEXEO_USER_COMMUNITY_PROFILE];

       String msg1 = '!!!!ONE!!!!';
       system.debug(msg1);

        ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
        insert userAccountGroup;

        Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
        userAccount.VAT_Number__c = '200';
        insert userAccount;

        Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
        insert userContact;

       String msg2 = '!!!!TWO!!!!';
       system.debug(msg2);
        userRole ur = [SELECT id from userrole  where developername= 'NEXEOSOLUTIONSORG' limit 1];
        User user = cc_imp_testUtils.createUser(userProfile, userContact, 
            'username@email.com', 'contact@email.com', 'firstName', 'lastName', 'alias');
        user.userroleid=ur.id;
       // insert user;

        String msg = 'USER ID IS !!!!' + user.Id;
        system.debug(msg);

        ccrz__E_ContactAddr__c address = cc_imp_testUtils.createContactAddress(
            nexeoIntegrationUser,
            'line1',
            'line2',
            'line3',
            'city',
            'state',
            'NL',
            '11111'
        );
        insert address;

        ccrz__E_AccountAddressBook__c addressBook = cc_imp_testUtils.createAccountAddressBook(userAccount,'Billing', address, user, true);
        insert addressBook;

        ccrz.cc_CallContext.currAccount = userAccount;
        ccrz.cc_CallContext.currUserId = user.id;
        ccrz.cc_CallContext.currUser = user;
        ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_NEXEO3D_STOREFRONT;

        /*
        * Product
        */
        ccrz__E_Product__c product = cc_imp_testUtils.createProduct('Product 1', 'product-01', 'Major', cc_imp_testUtils.TEST_NEXEO3D_STOREFRONT);
        insert product;

        /*
        * Parent Product
        */
        ccrz__E_Product__c parentProduct = cc_imp_testUtils.createProduct('Parent Product', 'product-02');
        insert parentProduct;

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

        ccrz__E_PriceList__c priceList = cc_imp_testUtils.createPriceList('General', cc_imp_testUtils.TEST_NEXEO3D_STOREFRONT);
        insert priceList;

        ccrz__E_AccountGroupPriceList__c agrpPriceList =  cc_imp_testUtils.createAccountGroupPriceList(userAccountGroup, priceList);
        insert agrpPriceList;

        List<ccrz__E_PriceListItem__c> priceListItems = cc_imp_testUtils.createPriceListItems(productList, priceList);
        insert priceListItems;

        ccrz__E_Cart__c cart = cc_imp_testUtils.createCart(userAccount, address, address, user, userContact, 'Cart', cc_imp_testUtils.TEST_NEXEO3D_STOREFRONT);
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
        insert myOrder1;

        ccrz.cc_bean_MockContactAddress mockContactAddress = new  ccrz.cc_bean_MockContactAddress();
        mockContactAddress.countryCode = 'NO';

        Map<String, Object> inputMap = new Map<String,Object>();
        inputMap.put(ccrz.cc_hk_TaxCalculation.PARAM_CARTID, cart.id );
        inputMap.put(ccrz.cc_hk_TaxCalculation.PARAM_SHIPADDR,mockContactAddress);

           cc_imp_testUtils.clearContext();

       Map <String, String> headerMap = new Map<String, String> ();
       headerMap.put('Content-Type', 'text/xml;charset=UTF-8');
       headerMap.put('SOAPAction', 'urn:ec.europa.eu:taxud:vies:services:checkVat#checkVat');
        //Test.setMock(HttpCalloutMock.class, new cc_imp_3d_FetchVATValidator_HttpResponse(200,'success',mockResponse(), headerMap));
        Test.setMock(HttpCalloutMock.class, new cc_imp_3d_VatAndTax_HttpResponse(200,'success',mockResponse(), headerMap, false));
        Test.startTest();

        cc_hk_3d_TaxCalculation taxCalc = new cc_hk_3d_TaxCalculation();

        ccrz.cc_CallContext.storefront = storeFrontSettingsList[0].Name;

        Decimal d = taxCalc.getTaxAmount(inputMap);
        
        //System.assertEquals( d , 0.0);
        System.assertEquals( d , 6.99);

        Test.stopTest();

    }

    @isTest static void test_TaxCalculation_ES() {
        Map<String, Object> dataMap = cc_imp_testUtils.initData();
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        system.runas(nexeoIntegrationUser)
        {
        List <cc_imp_StorefrontSettings__c > storeFrontSettingsList = cc_imp_testUtils.createNexeoCustomSettingList();
        insert storeFrontSettingsList ;

        
        ccrz__E_Cart__c cart = (ccrz__E_Cart__c)dataMap.get('cart');
        cart.ccrz__ShipAmount__c = 18.02;
        update cart;

        ccrz__E_CartItem__c cartItem = (ccrz__E_CartItem__c)dataMap.get('cartItem');

        User user = (User)dataMap.get('portalUser');

        Account userAccount = (Account)dataMap.get('userAccount');
        Contact userContact = (Contact)dataMap.get('userContact');

        ccrz__E_ContactAddr__c cshipToAddr = cc_imp_testUtils.createContactAddress(user, 'line1', 'line2', 'line3', 'city', 'IL', 'US','postalCode');
        insert cshipToAddr;

        ccrz__E_ContactAddr__c billToAddr = cc_imp_testUtils.createContactAddress(user, 'line1', 'line2', 'line3', 'city', 'IL', 'US','postalCode');
        insert billToAddr;


        ccrz__E_Order__c myOrder1  = cc_imp_testUtils.createOrder(cart.ID, userAccount.ID, userContact.ID, user.ID, cshipToAddr.ID, billToAddr.ID);
        insert myOrder1;


        ccrz.cc_bean_MockContactAddress mockContactAddress = new  ccrz.cc_bean_MockContactAddress();
        mockContactAddress.countryCode = 'ES';

        Map<String, Object> inputMap = new Map<String,Object>();
        inputMap.put(ccrz.cc_hk_TaxCalculation.PARAM_CARTID, cart.id );
        inputMap.put(ccrz.cc_hk_TaxCalculation.PARAM_SHIPADDR,mockContactAddress);

       Map <String, String> headerMap = new Map<String, String> ();
       headerMap.put('Content-Type', 'text/xml;charset=UTF-8');
       headerMap.put('SOAPAction', 'urn:ec.europa.eu:taxud:vies:services:checkVat#checkVat');
        //Test.setMock(HttpCalloutMock.class, new cc_imp_3d_FetchVATValidator_HttpResponse(200,'success',mockResponse(), headerMap));
        Test.setMock(HttpCalloutMock.class, new cc_imp_3d_VatAndTax_HttpResponse(200,'success',mockResponse(), headerMap, false));

        Test.startTest();

        ccrz.cc_CallContext.storefront = storeFrontSettingsList[0].Name;
        cc_hk_3d_TaxCalculation taxCalc = new cc_hk_3d_TaxCalculation();

        Decimal d = taxCalc.getTaxAmount(inputMap);
        
        // System.assertEquals( d , (cartItem.ccrz__SubAmount__c + cart.ccrz__ShipAmount__c) * 0.21);
        System.assertEquals( d , 6.99);

        List<ccrz__E_Order__c> orders = [SELECT VAT_Number__c,VAT_Tax_Classification__c from ccrz__E_Order__c where id =:myOrder1.Id];

        //System.assertEquals( orders[0].VAT_Tax_Classification__c , 1);

        Test.stopTest();
        }
    }

        @isTest static void test_TaxCalculation_ES_Melilla() {
        Map<String, Object> dataMap = cc_imp_testUtils.initData();
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        system.runas(nexeoIntegrationUser)
        {
        List <cc_imp_StorefrontSettings__c > storeFrontSettingsList = cc_imp_testUtils.createNexeoCustomSettingList();
        insert storeFrontSettingsList ;

        //Map<String, Object> dataMap = cc_imp_testUtils.initData();
        ccrz__E_Cart__c cart = (ccrz__E_Cart__c)dataMap.get('cart');
        ccrz__E_CartItem__c cartItem = (ccrz__E_CartItem__c)dataMap.get('cartItem');
        User user = (User)dataMap.get('portalUser');

        Account userAccount = (Account)dataMap.get('userAccount');
        Contact userContact = (Contact)dataMap.get('userContact');

        ccrz__E_ContactAddr__c cshipToAddr = cc_imp_testUtils.createContactAddress(user, 'line1', 'line2', 'line3', 'city', 'IL', 'US','postalCode');
        insert cshipToAddr;

        ccrz__E_ContactAddr__c billToAddr = cc_imp_testUtils.createContactAddress(user, 'line1', 'line2', 'line3', 'city', 'IL', 'US','postalCode');
        insert billToAddr;


        ccrz__E_Order__c myOrder1  = cc_imp_testUtils.createOrder(cart.ID, userAccount.ID, userContact.ID, user.ID, cshipToAddr.ID, billToAddr.ID);
        insert myOrder1;


        ccrz.cc_bean_MockContactAddress mockContactAddress = new  ccrz.cc_bean_MockContactAddress();
        mockContactAddress.countryCode = 'ES';
        mockContactAddress.state = 'Melilla';

        Map<String, Object> inputMap = new Map<String,Object>();
        inputMap.put(ccrz.cc_hk_TaxCalculation.PARAM_CARTID, cart.id );
        inputMap.put(ccrz.cc_hk_TaxCalculation.PARAM_SHIPADDR,mockContactAddress);

       Map <String, String> headerMap = new Map<String, String> ();
       headerMap.put('Content-Type', 'text/xml;charset=UTF-8');
       headerMap.put('SOAPAction', 'urn:ec.europa.eu:taxud:vies:services:checkVat#checkVat');
        // Test.setMock(HttpCalloutMock.class, new cc_imp_3d_FetchVATValidator_HttpResponse(200,'success',mockResponse(), headerMap));
        Test.setMock(HttpCalloutMock.class, new cc_imp_3d_VatAndTax_HttpResponse(200,'success',mockResponse(), headerMap, false));
        ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_NEXEO3D_STOREFRONT;
        Test.startTest();

        cc_hk_3d_TaxCalculation taxCalc = new cc_hk_3d_TaxCalculation();

        Decimal d = taxCalc.getTaxAmount(inputMap);
        
        //System.assertEquals( d , 0.0);
        System.assertEquals( d , 6.99);

        Test.stopTest();
        }
    }

    static testmethod void  calculateTaxUSTest() {
        Map<String, Object> dataMap = cc_imp_testUtils.initData();
        
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        system.runas(nexeoIntegrationUser)
        {
        List<cc_imp_StorefrontSettings__c> setList = cc_imp_testUtils.createNexeoCustomSettingList();
        insert setList;

        //Map<String, SObject> m = cc_imp_testUtils.initData();
        ccrz__E_Cart__c c = (ccrz__E_Cart__c) dataMap.get('cart');
        ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_NEXEO3D_STOREFRONT;

       Map <String, String> headerMap = new Map<String, String> ();
       headerMap.put('Content-Type', 'text/xml;charset=UTF-8');
       headerMap.put('SOAPAction', 'urn:ec.europa.eu:taxud:vies:services:checkVat#checkVat');
        Test.setMock(HttpCalloutMock.class, new cc_imp_api_TaxTest.TaxCalloutMock());
        ccrz.cc_bean_MockContactAddress mockContactAddress = new  ccrz.cc_bean_MockContactAddress();
        mockContactAddress.countryCode = 'US';

        Map<String, Object> inputMap = new Map<String,Object>();
        inputMap.put(ccrz.cc_hk_TaxCalculation.PARAM_CARTID, c.id );
        inputMap.put(ccrz.cc_hk_TaxCalculation.PARAM_SHIPADDR,mockContactAddress);

        Decimal tax = null;

        Test.startTest();
        cc_hk_3d_TaxCalculation taxCalc = new cc_hk_3d_TaxCalculation();
        tax = taxCalc.getTaxAmount(inputMap);

        Test.stopTest();

        //System.assertEquals(6.99, tax);
        }
    }

    private static String mockResponse()
      {
        String response =  '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">';
        response += '<soap:Body>';
        response += '<checkVatResponse xmlns="urn:ec.europa.eu:taxud:vies:services:checkVat:types">';
        response += '<countryCode>FR</countryCode>';
        response += '<vatNumber>100</vatNumber>';
        response += '<requestDate>2016-09-01+02:00</requestDate>';
        response += '<valid>true</valid>';
        response += '<name>John Doe</name>';
        response += '<address>123 Main St, Anytown, UK</address>';
        response += '</checkVatResponse>';
        response += '</soap:Body>';
        response += '</soap:Envelope>';
        return response;
     }

}