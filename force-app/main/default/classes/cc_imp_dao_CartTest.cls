@isTest

private class cc_imp_dao_CartTest {

	@isTest static void test_retrieve_vat_number() {

        //Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.MYNEXEO_USER_COMMUNITY_PROFILE];

        List <cc_imp_StorefrontSettings__c > storeFrontSettingsList = cc_imp_testUtils.createNexeoCustomSettingList();
        insert storeFrontSettingsList ;

        Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.MYNEXEO_USER_COMMUNITY_PROFILE];
		Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
        insert userAccountGroup;

        /*
        * Account
        */
        Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
        userAccount.VAT_Number__c = '100';
        insert userAccount;



        /*
        * Contact
        */
        Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
        insert userContact;

        /*
        * Portal User
        */
        User portalUser = cc_imp_testUtils.createUser(userProfile, userContact, 'username@email.com', 'contact@email.com', 'firstName', 'lastName', 'alias');
        //insert portalUser;

        /*
        * Contact Address
        */
        ccrz__E_ContactAddr__c address = cc_imp_testUtils.createContactAddress(
            nexeoIntegrationUser,
            'line1',
            'line2',
            'line3',
            'city',
            'state',
            'FR',
            '11111'
        );
        insert address;

        /*
        * Account Address Book
        */
        ccrz__E_AccountAddressBook__c addressBook = cc_imp_testUtils.createAccountAddressBook(userAccount,'Billing', address, nexeoIntegrationUser, true);
        insert addressBook;

        /*
        * CCRZ Call Context
        */
        ccrz.cc_CallContext.currAccount = userAccount;
        ccrz.cc_CallContext.currUserId = nexeoIntegrationUser.id;
        ccrz.cc_CallContext.currUser = nexeoIntegrationUser;
        ccrz.cc_CallContext.storefront = cc_imp_testUtils.DEFAULT_STOREFRONT;

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
        * Related Product Group
        */
        /*
        ccrz__E_RelatedProductGroup__c relatedProductGroup = cc_imp_testUtils.createRelatedProductGroup('group 1', '2001');
        insert relatedProductGroup;
        */

        /*
        * Price List
        */
        ccrz__E_PriceList__c priceList = cc_imp_testUtils.createPriceList('General', cc_imp_testUtils.DEFAULT_STOREFRONT);
        insert priceList;

        ccrz__E_AccountGroupPriceList__c agrpPriceList =  cc_imp_testUtils.createAccountGroupPriceList(userAccountGroup, priceList);
        insert agrpPriceList;


        /*
        * Product Media
        */
        /*
        ccrz__E_ProductMedia__c productMedia = cc_imp_testUtils.createProductMedia(product,'Product Image Thumbnail');
        insert productMedia;
        */

        /*
        * Attachment
        */
        /*
        Attachment attachment = cc_imp_testUtils.createAttachment('Product Image', productMedia);
        insert attachment;
        */

        /*
        * Price List Item
        */
        List<ccrz__E_PriceListItem__c> priceListItems = cc_imp_testUtils.createPriceListItems(productList, priceList);
        insert priceListItems;

        /*
        * Composite Products
        */
//        List<ccrz__E_CompositeProduct__c> compositeProducts = cc_imp_testUtils.createCompositeProducts(productList, parentProduct, relatedProductGroup);
//        insert compositeProducts;

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

     

        ccrz__E_Cart__c queryCart = cc_imp_dao_Cart.queryVatNumberByCartId(cart.Id);
        System.assert(queryCart.ccrz__Account__r.VAT_Number__c.equals('100'));



	}

		@isTest static void test_retrieve_vat_number_200() {

        List <cc_imp_StorefrontSettings__c > storeFrontSettingsList = cc_imp_testUtils.createNexeoCustomSettingList();
        insert storeFrontSettingsList ;
		
        Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.MYNEXEO_USER_COMMUNITY_PROFILE];
		Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
        insert userAccountGroup;

        /*
        * Account
        */
        Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
        userAccount.VAT_Number__c = '200';
        insert userAccount;



        /*
        * Contact
        */
        Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
        insert userContact;

        /*
        * Portal User
        */
        User portalUser = cc_imp_testUtils.createUser(userProfile, userContact, 'username@email.com', 'contact@email.com', 'firstName', 'lastName', 'alias');
        //insert portalUser;

        /*
        * Contact Address
        */
        ccrz__E_ContactAddr__c address = cc_imp_testUtils.createContactAddress(
            nexeoIntegrationUser,
            'line1',
            'line2',
            'line3',
            'city',
            'state',
            'FR',
            '11111'
        );
        insert address;

        /*
        * Account Address Book
        */
        ccrz__E_AccountAddressBook__c addressBook = cc_imp_testUtils.createAccountAddressBook(userAccount,'Billing', address, nexeoIntegrationUser, true);
        insert addressBook;

        /*
        * CCRZ Call Context
        */
        ccrz.cc_CallContext.currAccount = userAccount;
        ccrz.cc_CallContext.currUserId = nexeoIntegrationUser.id;
        ccrz.cc_CallContext.currUser = nexeoIntegrationUser;
        ccrz.cc_CallContext.storefront = cc_imp_testUtils.DEFAULT_STOREFRONT;

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
        * Related Product Group
        */
        /*
        ccrz__E_RelatedProductGroup__c relatedProductGroup = cc_imp_testUtils.createRelatedProductGroup('group 1', '2001');
        insert relatedProductGroup;
        */

        /*
        * Price List
        */
        ccrz__E_PriceList__c priceList = cc_imp_testUtils.createPriceList('General', cc_imp_testUtils.DEFAULT_STOREFRONT);
        insert priceList;

        ccrz__E_AccountGroupPriceList__c agrpPriceList =  cc_imp_testUtils.createAccountGroupPriceList(userAccountGroup, priceList);
        insert agrpPriceList;


        /*
        * Product Media
        */
        /*
        ccrz__E_ProductMedia__c productMedia = cc_imp_testUtils.createProductMedia(product,'Product Image Thumbnail');
        insert productMedia;
        */

        /*
        * Attachment
        */
        /*
        Attachment attachment = cc_imp_testUtils.createAttachment('Product Image', productMedia);
        insert attachment;
        */

        /*
        * Price List Item
        */
        List<ccrz__E_PriceListItem__c> priceListItems = cc_imp_testUtils.createPriceListItems(productList, priceList);
        insert priceListItems;

        /*
        * Composite Products
        */
//        List<ccrz__E_CompositeProduct__c> compositeProducts = cc_imp_testUtils.createCompositeProducts(productList, parentProduct, relatedProductGroup);
//        insert compositeProducts;

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

        String idAsString = String.valueOf(cart.Id);

        ccrz__E_Cart__c queryCart = cc_imp_dao_Cart.queryVatNumberByCartId(Id.valueOf(idAsString));
       System.assert(queryCart.ccrz__Account__r.VAT_Number__c.equals('200'));



	}

		@isTest static void test_retrieve_vat_number_999() {

        List <cc_imp_StorefrontSettings__c > storeFrontSettingsList = cc_imp_testUtils.createNexeoCustomSettingList();
        insert storeFrontSettingsList ;

        Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.MYNEXEO_USER_COMMUNITY_PROFILE];
		Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
        insert userAccountGroup;

        /*
        * Account
        */
        Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
        userAccount.VAT_Number__c = '999';
        insert userAccount;



        /*
        * Contact
        */
        Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
        insert userContact;

        /*
        * Portal User
        */
        User portalUser = cc_imp_testUtils.createUser(userProfile, userContact, 'username@email.com', 'contact@email.com', 'firstName', 'lastName', 'alias');
       // insert portalUser;

        /*
        * Contact Address
        */
        ccrz__E_ContactAddr__c address = cc_imp_testUtils.createContactAddress(
            nexeoIntegrationUser,
            'line1',
            'line2',
            'line3',
            'city',
            'state',
            'FR',
            '11111'
        );
        insert address;

        /*
        * Account Address Book
        */
        ccrz__E_AccountAddressBook__c addressBook = cc_imp_testUtils.createAccountAddressBook(userAccount,'Billing', address, nexeoIntegrationUser, true);
        insert addressBook;

        /*
        * CCRZ Call Context
        */
        ccrz.cc_CallContext.currAccount = userAccount;
        ccrz.cc_CallContext.currUserId = nexeoIntegrationUser.id;
        ccrz.cc_CallContext.currUser = nexeoIntegrationUser;
        ccrz.cc_CallContext.storefront = cc_imp_testUtils.DEFAULT_STOREFRONT;

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
        * Related Product Group
        */
        /*
        ccrz__E_RelatedProductGroup__c relatedProductGroup = cc_imp_testUtils.createRelatedProductGroup('group 1', '2001');
        insert relatedProductGroup;
        */

        /*
        * Price List
        */
        ccrz__E_PriceList__c priceList = cc_imp_testUtils.createPriceList('General', cc_imp_testUtils.DEFAULT_STOREFRONT);
        insert priceList;

        ccrz__E_AccountGroupPriceList__c agrpPriceList =  cc_imp_testUtils.createAccountGroupPriceList(userAccountGroup, priceList);
        insert agrpPriceList;


        /*
        * Product Media
        */
        /*
        ccrz__E_ProductMedia__c productMedia = cc_imp_testUtils.createProductMedia(product,'Product Image Thumbnail');
        insert productMedia;
        */

        /*
        * Attachment
        */
        /*
        Attachment attachment = cc_imp_testUtils.createAttachment('Product Image', productMedia);
        insert attachment;
        */

        /*
        * Price List Item
        */
        List<ccrz__E_PriceListItem__c> priceListItems = cc_imp_testUtils.createPriceListItems(productList, priceList);
        insert priceListItems;

        /*
        * Composite Products
        */
//        List<ccrz__E_CompositeProduct__c> compositeProducts = cc_imp_testUtils.createCompositeProducts(productList, parentProduct, relatedProductGroup);
//        insert compositeProducts;

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

        String idAsString = String.valueOf(cart.Id);

        ccrz.cc_bean_MockContactAddress mockContactAddress = new  ccrz.cc_bean_MockContactAddress();
        mockContactAddress.countryCode = 'FR';

        Map<String, Object> inputMap = new Map<String,Object>();
        inputMap.put(ccrz.cc_hk_TaxCalculation.PARAM_CARTID, String.valueOf(cart.Id));
        inputMap.put(ccrz.cc_hk_TaxCalculation.PARAM_SHIPADDR,mockContactAddress);




		String cartId = (String)inputMap.get(ccrz.cc_hk_TaxCalculation.PARAM_CARTID);

        ccrz__E_Cart__c queryCart = cc_imp_dao_Cart.queryVatNumberByCartId(Id.valueOf(cartId));
        System.assert(queryCart.ccrz__Account__r.VAT_Number__c.equals('999'));



	}


}