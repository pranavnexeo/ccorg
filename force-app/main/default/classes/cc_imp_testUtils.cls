@isTest
public with sharing class cc_imp_testUtils {
    // test
    public static final String DEFAULT_STOREFRONT = 'DefaultStore';
    //public static final String DEFAULT_COMMUNITY_PROFILE = 'CloudCraze Customer Community User';
    public static final String DEFAULT_COMMUNITY_PROFILE = 'CloudCraze Customer Community User Nexeo3D';
    public static User globalFooterTestUser;

    public static final String GOVERNMENT_ACCOUNT_GROUP_ID = 'GOV001';


    public static final String TEST_MYNEXEO_STOREFRONT = 'mynexeo';
    public static final String TEST_NEXEO3D_STOREFRONT = 'nexeo3d';

    public static final String NEXEO3D_GUEST_USER_COMMUNITY_PROFILE = 'CloudBurst Customer Community Profile';
    public static final String MYNEXEO_GUEST_USER_COMMUNITY_PROFILE = 'CloudBurst Customer Community B Profile';

    public static final String NEXEO3D_USER_COMMUNITY_PROFILE = 'CloudCraze Customer Community User Nexeo3D';
    public static final String MYNEXEO_USER_COMMUNITY_PROFILE = 'CloudCraze Customer Community User MyNexeo';


   public static final String NEXEO_3D_GUEST_USERNAME='cloudburst_customer_community@config3-customerportalconfig3.cs40.force.com';
   public static final String MYNEXEO_GUEST_USERNAME= 'cloudburst_customer_community_b@config3-customerportalconfig3.cs40.force.com';
    
   public static final String TEST_USER_CURRENCY = 'USD'; 
    
    /**
    * Initialize test data and return a map of objects created
    *
    * @return Map of objects inserted
    */
    public static Map<String, SObject> initData() {
		Map<String,SObject> resultMap = new Map<String,SObject>();
		userRole ur = [SELECT id from userrole  where developername= 'NEXEOSOLUTIONSORG' limit 1];
        /*
        * Init Custom Setting
        */
        //NEX_Settings__c settings = new NEX_Settings__c(
         //   name='DEFAULT_STOREFRONT',
         //   Government_Account_Group_ID__c = GOVERNMENT_ACCOUNT_GROUP_ID
        //);
        //insert settings;
        
        //Creating nexeo Integration User
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123002', FirstName = 'Nexeo_Integration',UserRoleId = ur.Id);
        insert nexeoIntegrationUser;
        system.runas(nexeoIntegrationUser)
		{
        Profile userProfile = cc_imp_testUtils.getCustomerCommunityProfile();
		//test.starttest();
        /*
        * Account Group
        */
        ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
        insert userAccountGroup;

        /*
        * Account
        */
        Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
        insert userAccount;

        /*
        * Contact
        */
        Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
        insert userContact;
        //test.stoptest();
        
        
		User portalUser;
		
        portalUser = cc_imp_testUtils.createUser(userProfile, userContact, 'username@email.com', 'contact@email.com', 'firstName', 'lastName', 'alias');
        insert portalUser;
        
        
        /* Contact Address
        */
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

        /*
        * Account Address Book
        */
        List<ccrz__E_AccountAddressBook__c> addrBookList = new List<ccrz__E_AccountAddressBook__c>();
        ccrz__E_AccountAddressBook__c shippingAddressBook = cc_imp_testUtils.createAccountAddressBook(userAccount,'Shipping', address, portalUser, true);
        ccrz__E_AccountAddressBook__c billingAddressBook = cc_imp_testUtils.createAccountAddressBook(userAccount,'Billing', address, portalUser, true);
        addrBookList.add(shippingAddressBook);
        addrBookList.add(billingAddressBook);
        insert addrBookList;

        /*
        * CCRZ Call Context
        */
        ccrz.cc_CallContext.currAccount = userAccount;
        ccrz.cc_CallContext.currAccountId = userAccount.Id;
        ccrz.cc_CallContext.currAccountGroup = userAccountGroup;
        ccrz.cc_CallContext.currUserId = portalUser.id;
        ccrz.cc_CallContext.currUser = portalUser;
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
        ccrz__E_Cart__c cart = cc_imp_testUtils.createCart(userAccount, address, address, portalUser, userContact, 'Cart', cc_imp_testUtils.DEFAULT_STOREFRONT);
        insert cart;

        /*
        * Cart Item
        * - Normal Cart
        */
        ccrz__E_CartItem__c cartItem = cc_imp_testUtils.createCartItem(cart, 9.99, 1, product, null);
        insert cartItem;

        /*
        * Order
        *
        */
        /*
        ccrz__E_Order__c theOrder = createOrder(cart.Id, userAccount.Id, userContact.Id, portalUser.Id, address.Id, address.Id);
        insert theOrder;
        */

        /*
        * Order Item
        *
        */
        /*
        ccrz__E_OrderItem__c parentOrderItem = createOrderItem(theOrder.Id, 'oi1', 'Major', parentProduct.Id, null, null, 1.00, 1, 1.00);
        insert parentOrderItem;
        ccrz__E_OrderItem__c childOrderItem = createOrderItem(theOrder.Id, 'oi2', 'Minor', product.Id, parentOrderItem.Id, parentProduct.Id, 1.00, 1, 1.00);
        insert childOrderItem;
        */


        /*
        ccrz__E_TransactionPayment__c tp = createTransactionPayment(theOrder.Id, 'uid');
        insert tp;
        */
        

        
        //resultMap.put('order', theOrder);
        resultMap.put('cart', cart);
        resultMap.put('cartItem', cartItem);
        resultMap.put('product', product);
        resultMap.put('priceList', priceList);
        resultMap.put('address', address);
        resultMap.put('portalUser', portalUser);
        resultMap.put('userAccount', userAccount);
        resultMap.put('userAccountGroup', userAccountGroup);
        resultMap.put('userContact', userContact);
        resultMap.put('category', category);
        resultMap.put('shippingAddressBook', shippingAddressBook);
        resultMap.put('billingAddressBook', billingAddressBook);
        resultMap.put('nexeoIntegrationUser', nexeoIntegrationUser);
        //resultMap.put('transactionPayment', tp);
		}
        return resultMap;
		
    }

    /**
    * Initialize test data with a page reference
    *
    * @return Map of objects inserted
    */
    public static Map<String, SObject> initData(PageReference pageRef) {
        Map<String,SObject> initResult = initData();

        ccrz__E_Cart__c cart = (ccrz__E_Cart__c)initResult.get('cart');

        List<ccrz__E_Cart__c> cartEnc = [
            SELECT
                id,
                ccrz__EncryptedId__c
            FROM
                ccrz__E_Cart__c
            WHERE
                id = :cart.id
        ];

        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('cartId', cartEnc.get(0).ccrz__EncryptedId__c);

        return initResult;
    }

    public static Profile getCustomerCommunityProfile(){
        Profile p;
        try {
        p = [
            SELECT
                Id
                ,Name
            FROM
                Profile
            WHERE
                Name = :DEFAULT_COMMUNITY_PROFILE
            LIMIT
            1
        ];
        }catch(Exception e){
            System.assertNotEquals(null, p, 'You must create a profile named ' + DEFAULT_COMMUNITY_PROFILE + ' or modify this test case.');
        }
        return p;
    }

    public static Account createAccount(ccrz__E_AccountGroup__c accountGroup){
        Account a1 = new Account  (Name='Test Account');
        if(accountGroup != null){
            a1.ccrz__E_AccountGroup__c = accountGroup.Id;
        }
        return a1;
    }

    public static ccrz__E_AccountGroup__c createAccountGroup(String grpName){
        ccrz__E_AccountGroup__c actGrp = new ccrz__E_AccountGroup__c(
            Name = grpName,
            ccrz__PriceListSelectionMethod__c = 'Best Price'
        );
        return actGrp;
    }

    public static ccrz__E_PriceList__c createPriceList(String plName, String storefront){
        ccrz__E_PriceList__c pl = new ccrz__E_PriceList__c(
                Name = plName,
                ccrz__CurrencyISOCode__c = 'USD',
                ccrz__Enabled__c = true,
                ccrz__StartDate__c = Date.today(),
                ccrz__EndDate__c = Date.today().addDays(30),
                ccrz__Storefront__c = storefront
        );
        return pl;
    }

    public static ccrz__E_AccountGroupPriceList__c createAccountGroupPriceList(ccrz__E_AccountGroup__c accountGroup, ccrz__E_Pricelist__c priceList){
        ccrz__E_AccountGroupPriceList__c agpl = new ccrz__E_AccountGroupPriceList__c (
            ccrz__AccountGroup__c = accountGroup.Id,
            ccrz__Pricelist__c = priceList.Id,
            ccrz__Sequence__c = 100,
            ccrz__Enable__c = true,
            ccrz__StartDate__c = Date.today(),
            ccrz__EndDate__c = Date.today().addDays(30)
        );
        return agpl;
    }

    public static List<ccrz__E_PriceListItem__c> createPriceListItems(List<ccrz__E_Product__c> products, ccrz__E_PriceList__c priceList){
        List<ccrz__E_PriceListItem__c> pliList = new List<ccrz__E_PriceListItem__c>();
        for(ccrz__E_Product__c prod :products){
            ccrz__E_PriceListItem__c item = new ccrz__E_PriceListItem__c(
                    ccrz__EndDate__c = Date.today().addDays(30),
                    ccrz__Price__c = 10,
                    ccrz__PriceList__c = priceList.Id,
                    ccrz__Product__c = prod.Id,
                    ccrz__StartDate__c = Date.today(),
                    Currency_ISO_Code__c = 'USD',
                    ccrz__UnitOfMeasure__c = 'Each'
            );
            pliList.add(item);
        }
        return pliList;
    }

    public static Contact createContact(Account a, String emailAddress){
        Contact con = new Contact(
            FirstName='Test',
            Lastname='User',
            Accountid=a.id,
            Email=emailAddress
        );
        return con;
    }

    public static User createUser(Profile p, Contact c, String username, String emailAddress, String firstName, String lastName, String alias){
        User u = new User(
            FirstName         = firstName,
            LastName          = lastName,
            Email             = emailAddress,
            Alias             = alias,
            Username          = username,
            LocaleSidKey      = 'en_US',
            TimeZoneSidKey    = 'GMT',
            ProfileID         = p.id,
            LanguageLocaleKey = 'en_US',
            EmailEncodingKey  = 'UTF-8',
            ContactId         = c.id
        );
        return u;
    }


    /*
    public static List<ccrz__E_CompositeProduct__c> createCompositeProducts(List<ccrz__E_Product__c> componentProducts, ccrz__E_Product__c parentProduct, ccrz__E_RelatedProductGroup__c relatedGroup){
        List<ccrz__E_CompositeProduct__c> compositeProductList = new List<ccrz__E_CompositeProduct__c>();
        ccrz__E_CompositeProduct__c newCompProd;
        for(ccrz__E_Product__c compProd :componentProducts){
            newCompProd = new ccrz__E_CompositeProduct__c(
                ccrz__Composite__c = parentProduct.Id,
                ccrz__Component__c = compProd.Id,
                ccrz__ProductGroup__c = relatedGroup.Id
            );
            compositeProductList.add(newCompProd);
        }
        return compositeProductList;
    }
    */

    public static ccrz__E_Product__c createProduct(String name, String sku, String productType, String storefront){
        if(productType == null){
            productType = 'Product';
        }
        // Create Product
        ccrz__E_Product__c prod = new ccrz__E_Product__c();
        prod.Name = name;
        prod.ccrz__SKU__c = sku;
        prod.ccrz__ProductType__c = productType;
        prod.ccrz__ProductStatus__c = 'Released';
        prod.ccrz__Storefront__c = storefront;
        prod.NexeoMaterialId__c = 'Test123';
        prod.Product_Number__c = '1234567890';
        return prod;
    }

    public static ccrz__E_Product__c createProduct(String name, String sku, String storefront){
        return createProduct(name, sku, 'Product', storefront);
    }

    public static ccrz__E_Product__c createProduct(String name, String sku){
        return createProduct(name, sku, DEFAULT_STOREFRONT);
    }

    public static ccrz__E_Spec__c createSpec(String name, String description, String displayName, Integer dv2000, Integer dv2500, Integer recommendedValue, Integer sequence, String uom, String specGroup, Boolean isVisible, Boolean displayInFooter, Boolean displayInLimit, Boolean displayInEnough){
        ccrz__E_Spec__c spec = new ccrz__E_Spec__c();
        spec.Name = name; 
        spec.ccrz__Desc__c = description;
        spec.ccrz__DisplayName__c = displayName; 
        spec.ccrz__IsVisibleInCatalog__c = false;
        spec.ccrz__Sequence__c = 10;
        spec.ccrz__SpecGroup__c = specGroup;
        return spec;
    }

    public static List<ccrz__E_ProductSpec__c> createProductSpecs(ccrz__E_Product__c product, Map<ccrz__E_Spec__c, String> specToValueMap){
        List<ccrz__E_ProductSpec__c> prodSpecList = new List<ccrz__E_ProductSpec__c>();
        ccrz__E_ProductSpec__c newProdSpec;
        for(ccrz__E_Spec__c theSpec :specToValueMap.keySet()){
            newProdSpec = new ccrz__E_ProductSpec__c(
                ccrz__Product__c = product.Id,
                ccrz__Spec__c = theSpec.Id,
                ccrz__SpecValue__c = specToValueMap.get(theSpec)
            );
            prodSpecList.add(newProdSpec);
        }
        return prodSpecList;
    }

    /*
    public static ccrz__E_RelatedProductGroup__c createRelatedProductGroup(String grpName, String grpId){
        ccrz__E_RelatedProductGroup__c grp = new ccrz__E_RelatedProductGroup__c(
            Name = grpName,
            ccrz__GroupId__c = grpId
        );
        return grp;
    }
    */


    // Create contact address - owner is the portal user or guest (Site Guest User)
    // cart and order link to CC Contact Address for billto/shipto.
    public static ccrz__E_ContactAddr__c createContactAddress(User portalUser, String line1, String line2, String line3, String city, String state, String country, String postalCode ){
        String msg = 'PORTAL ID !!!' + portalUser.Id;
        System.debug(msg);

        ccrz__E_ContactAddr__c addr = new ccrz__E_ContactAddr__c(
            ownerId = portalUser.Id,
            ccrz__AddressFirstline__c = line1,
            ccrz__AddressSecondline__c = line2,
            ccrz__AddressThirdline__c = line3,
            ccrz__City__c = city,
            ccrz__State__c = state,
            ccrz__Country__c = country,
            ccrz__PostalCode__c = postalCode
        );
        return addr;

    }

    public static ccrz__E_AccountAddressBook__c createAccountAddressBook(Account acct, String addrType, ccrz__E_ContactAddr__c contactAddr, User portalUser, Boolean isDefault){
        ccrz__E_AccountAddressBook__c addrBook = new ccrz__E_AccountAddressBook__c(
            ccrz__Account__c = acct.Id,
            ccrz__AccountId__c = acct.Id,
            ccrz__AddressType__c = addrType, // Billing/Shipping
            ccrz__E_ContactAddress__c = contactAddr.Id,
            ccrz__Default__c = isDefault,
            ccrz__Owner__c = portalUser.Id
        );
        return addrBook;
    }

    // Type = Cart/Wishlist
    public static ccrz__E_Cart__c createCart(Account acct, ccrz__E_ContactAddr__c billToAddr, ccrz__E_ContactAddr__c shipToAddr, User portalUser, Contact portalContact, String cartType, String storefront){
        String cartName = 'Shopping Cart';

        ccrz__E_Cart__c cart = new ccrz__E_Cart__c(
            ccrz__Account__c = acct.Id,
            ccrz__ActiveCart__c = true,
            ccrz__BillTo__c = billToAddr.Id,
            ccrz__CartStatus__c = 'Open',
            ccrz__CartType__c = cartType,
            ccrz__Contact__c = portalContact.Id,
            ccrz__BuyerFirstName__c = portalContact.Firstname,
            ccrz__BuyerLastName__c = portalContact.Lastname,
            ccrz__Name__c = cartName,
            ccrz__ShipTo__c = shipToAddr.Id,
            ccrz__Storefront__c = storefront,
            ccrz__CurrencyISOCode__c = 'USD',
            CurrencyIsoCode = 'USD',
            ccrz__User__c = portalUser.Id
        );

        return cart;
    }

    public static ccrz__E_CartItem__c createCartItem(ccrz__E_Cart__c cart, Decimal price, Decimal quantity, ccrz__E_Product__c product, ccrz__E_CartItem__c parentCartItem){
        ccrz__E_CartItem__c cartItem = new ccrz__E_CartItem__c(
            ccrz__Cart__c = cart.Id,
            ccrz__Price__c = price,
            ccrz__Quantity__c = quantity,
            ccrz__SubAmount__c = price * quantity,  
            ccrz__CartItemType__c = product.ccrz__ProductType__c, // Major/Minor/Coupon
            ccrz__ProductType__c = product.ccrz__ProductType__c, // Major/Minor/Coupon
            ccrz__Product__c = product.Id,
            ccrz__UnitOfMeasure__c = 'Each',
            CurrencyIsoCode = 'USD',
            ccrz__ItemStatus__c = 'Available'
        );
        if(parentCartItem != null){
            cartItem.ccrz__ParentCartItem__c = parentCartItem.Id;
        }
        return cartItem;
    }

    /*
    public static ccrz__E_ProductMedia__c createProductMedia(Id parentId, Boolean enabled, String description, String alt_message, String media_type, String product_media_source){
            ccrz__E_ProductMedia__c pm = new ccrz__E_ProductMedia__c  ();

            if(parentId != null){
                pm.ccrz__Product__c = parentId;
                pm.ccrz__AltMessage__c = alt_message;
                pm.ccrz__Enabled__c = enabled;
                pm.ccrz__MediaType__c = media_type;
                pm.ccrz__ProductMediaSource__c = product_media_source;
                pm.ccrz__ProductDescription__c = description;
            }
            return pm;
    }
    */
    /*
    public static ccrz__E_ProductMedia__c createProductMedia(ccrz__E_Product__c product, String mediaType) {
        ccrz__E_ProductMedia__c productMedia = new ccrz__E_ProductMedia__c(
            ccrz__Enabled__c = true,
            ccrz__MediaType__c = mediaType,
            ccrz__Product__c = product.id
            // ccrz__ProductMediaId__c = ''
        );
        return productMedia;
    }
    */

    /*
    public static Attachment createAttachment(Id parentId, Blob body, String title, String description, String content_type){
            Attachment a = new Attachment(ParentId = parentId, Name = title);

            if(parentId != null){
                a.Description = description;
                a.ContentType = content_type;
                a.Body = body;
            }
            return a;
    }
    */

    /*
    public static Attachment createAttachment(String name, SObject parent) {
        Attachment attachment = new Attachment(
            Body = Blob.valueOf('attachment body'),
            Name = name,
            ParentId = parent.id
        );
        return attachment;
    }
    */

    public static User createAndInsertUserObjects(){
        Profile p = getCustomerCommunityProfile();

        ccrz__E_AccountGroup__c ag = createAccountGroup('grpName');
        insert ag;

        Account a = createAccount(ag);
        insert a;

        Contact c = createContact(a, 'testuser@bearnaked.com');
        insert c;

        User u = createUser(p, c, 'testuser@bearnaked.com', 'testuser@bearnaked.com', 'Test', 'User', 'tusr');
        insert u;

        return u;
    }

    public static ccrz__E_Category__c createCategory(String categoryId) {
        ccrz__E_Category__c category = new ccrz__E_Category__c(
            ccrz__CategoryID__c = categoryId
        );
        return category;
    }

    public static ccrz__E_ProductCategory__c createProductCategory(ccrz__E_Product__c product, String productCategoryId, ccrz__E_Category__c category) {
        ccrz__E_ProductCategory__c productCategory = new ccrz__E_ProductCategory__c (
            ccrz__Category__c = category.id,
            ccrz__Product__c = product.id,
            ccrz__ProductCategoryId__c = productCategoryId
        );
        return productCategory;
    }

    /*
    public static ccrz__E_OrderItem__c createOrderItem(Id orderId, String orderItemId, String lineType, Id productId, Id parentOrderItemId, Id parentProductId, Decimal price, Decimal quantity, Decimal subAmount){
        ccrz__E_OrderItem__c oi = new ccrz__E_OrderItem__c();
        oi.ccrz__Order__c = orderId;
        oi.ccrz__OrderItemId__c = orderItemId;
        oi.ccrz__OrderLineType__c = lineType;
        oi.ccrz__Product__c = productId;
        oi.ccrz__ParentOrderItem__c = parentOrderItemId;
        oi.ccrz__ParentProduct__c = parentProductId;
        oi.ccrz__Price__c = price;
        oi.ccrz__Quantity__c = quantity;
        oi.ccrz__SubAmount__c = subAmount;
        return oi;
    }
    */

    public static ccrz__E_Order__c createOrder(Id cartId, Id accountId, Id contactId, Id ownerId, Id shipToId, Id billToId){
        ccrz__E_Order__c theOrder = new ccrz__E_Order__c();
        theOrder.ccrz__OriginatedCart__c = cartId;
        theOrder.ccrz__Account__c = accountId;
        theOrder.ccrz__Contact__c = contactId;
        theOrder.OwnerId = ownerId;
        theOrder.ccrz__ShipTo__c = shipToId;
        theOrder.ccrz__BillTo__c = billToId;
        return theOrder;

    }
    
    public static ccrz__E_TransactionPayment__c createTransactionPayment(Id orderId, String uid){
        ccrz__E_TransactionPayment__c tp = new ccrz__E_TransactionPayment__c();
        tp.ccrz__CCOrder__c = orderId;
        tp.ccrz__TransactionPaymentId__c = uid;

//      tp.Transaction_End__c = '';
        tp.ccrz__Amount__c = 1.0;
        tp.ccrz__AccountNumber__c = 'abc';
        tp.ccrz__AccountType__c = 'abc';
//      tp.Approval_Code__c = 'abc';
//      tp.Credit_Card_Type__c = 'Visa';
        tp.ccrz__TransactionCode__c = 'tcode';
        tp.ccrz__ExpirationMonth__c = 12;
        tp.ccrz__ExpirationYear__c = 2016;
//      tp.CVV_Match__c = 'M';
//      tp.AVS_Match__c = 'M';

        return tp;
    }

    /*
    public static void globalFooterSetupTestData() {
        ccrz__E_AccountGroup__c testAccountGroup = cc_imp_testUtils.createAccountGroup('testAccountGroup');

        Account testAccount = new Account(
            Name                    = 'TEST_ACCOUNT',
            ccrz__E_AccountGroup__c = testAccountGroup.Id,
            OwnerId                 = UserInfo.getUserId(),
            Type                    = 'Customer',
            BillingStreet           = globalFooterGenerateRandomString(32),
            BillingCity             = globalFooterGenerateRandomString(32)
        );
        insert testAccount;

        Contact contactCC = new Contact(
            FirstName            = 'CloudCraze',
            LastName             = 'TestUser',
            AccountId            = testAccount.Id
        );
        insert contactCC;

        Profile profile = [SELECT
                                Id
                            FROM
                                Profile
                            WHERE
                                Name = :DEFAULT_COMMUNITY_PROFILE LIMIT 1];

        User testOwner = [SELECT
                                TimeZoneSidKey
                                , UserRoleId
                            FROM
                                User
                            WHERE
                                Id = :UserInfo.getUserId()];

        String emailAddress = String.valueOf(System.now().getTime() + '@cc-test.mail');
        globalFooterTestUser = new User(
            Alias                    = 'cctest',
            Email                    = emailAddress,
            EmailEncodingKey         = 'UTF-8',
            LastName                 = 'TestUser',
            LanguageLocaleKey        = 'en_US',
            LocaleSidKey             = 'en_US',
            ProfileId                = profile.Id,
            TimeZoneSidKey           = testOwner.TimeZoneSidKey,
            Username                 = emailAddress,
            isActive                 = true,
            ContactId                = contactCC.Id,
            Contact                  = contactCC,
            ccrz__CC_CurrencyCode__c = 'USD'
        );
        insert globalFooterTestUser;
    }
    */

    /*
    public static String globalFooterGenerateRandomString(Integer len) {
        final String RANDOM_CHARS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
        String returnValue = '';
        Integer random;
        do {
            random = Math.mod(Math.abs(Crypto.getRandomInteger()),RANDOM_CHARS.length());
            returnValue += RANDOM_CHARS.substring(random,random + 1);
        } while (returnValue.length() < len);

        return returnValue;
    }
    */


    public static ccrz__E_Order__c emailOrderTestOrder;
    /*
    public static void emailOrdersetupTestData() {
        cc_imp_testUtils.initData();

        ccrz__E_ContactAddr__c shippingAddress = new ccrz__E_ContactAddr__c(
            ccrz__FirstName__c         = 'firstname'
            , ccrz__LastName__c          = 'lastname'
            , ccrz__AddressFirstline__c  = 'firstline'
            , ccrz__AddressSecondline__c = 'secondline'
            , ccrz__City__c              = 'Chicago'
            , ccrz__State__c             = 'Illinois'
            , ccrz__StateISOCode__c      = 'IL'
            , ccrz__PostalCode__c        = '55555'
            , ccrz__Country__c           = 'US'
            , ccrz__HomePhone__c         = '555-555-5555'
        );
        insert shippingAddress;

        emailOrderTestOrder = new ccrz__E_Order__c(
            ccrz__EncryptedId__c = 'encryptedorderid'
            , ccrz__ShipTo__c    = shippingAddress.Id
        );
        insert emailOrderTestOrder;

        List<ccrz__E_OrderItem__c> orderItems = new List<ccrz__E_OrderItem__c> {
            new ccrz__E_OrderItem__c(
                ccrz__Quantity__c    = 1
                , ccrz__Price__c     = 9.99
                , ccrz__SubAmount__c = 9.99
                , ccrz__Order__c     = emailOrderTestOrder.Id
                , ccrz__ProductType__c = 'Bundle'
            ),
            new ccrz__E_OrderItem__c(
                ccrz__Quantity__c    = 1
                , ccrz__Price__c     = 9.99
                , ccrz__SubAmount__c = 9.99
                , ccrz__Order__c     = emailOrderTestOrder.Id
                , ccrz__ProductType__c = 'Dynamic Kit'
            )
        };
        insert orderItems;
    }
    */


    /*
    public static void checkoutTestSetupTestData() {
        ccrz__E_AccountGroup__c checkoutTest_testAccountGroup = cc_imp_testUtils.createAccountGroup('testAccountGroup');

        checkoutTest_testAccount = new Account(
            Name                    = 'TEST_ACCOUNT',
            ccrz__E_AccountGroup__c = checkoutTest_testAccountGroup.Id,
            OwnerId                 = UserInfo.getUserId(),
            Type                    = 'Customer',
            BillingStreet           = checkoutTestGenerateRandomString(32),
            BillingCity             = checkoutTestGenerateRandomString(32)
        );
        insert checkoutTest_testAccount;

        checkoutTest_testContact = new Contact(
            FirstName            = 'CloudCraze',
            LastName             = 'TestUser',
            AccountId            = checkoutTest_testAccount.Id
        );
        insert checkoutTest_testContact;

        Profile profile = [SELECT
                                Id
                            FROM
                                Profile
                            WHERE
                                Name = :DEFAULT_COMMUNITY_PROFILE LIMIT 1];

        User testOwner = [SELECT
                                TimeZoneSidKey
                                , UserRoleId
                            FROM
                                User
                            WHERE
                                Id = :UserInfo.getUserId()];

        checkoutTest_emailAddress = String.valueOf(System.now().getTime() + '@cc-test.mail');
        checkoutTest_testUser = new User(
            Alias                    = 'cctest',
            Email                    = checkoutTest_emailAddress,
            EmailEncodingKey         = 'UTF-8',
            LastName                 = 'TestUser',
            LanguageLocaleKey        = 'en_US',
            LocaleSidKey             = 'en_US',
            ProfileId                = profile.Id,
            TimeZoneSidKey           = testOwner.TimeZoneSidKey,
            Username                 = checkoutTest_emailAddress,
            isActive                 = true,
            ContactId                = checkoutTest_testContact.Id,
            Contact                  = checkoutTest_testContact,
            ccrz__CC_CurrencyCode__c = 'USD'
        );
        insert checkoutTest_testUser;
    }
    */

    /*
    public static String checkoutTestGenerateRandomString(Integer len) {
        final String RANDOM_CHARS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
        String returnValue = '';
        Integer random;
        do {
            random = Math.mod(Math.abs(Crypto.getRandomInteger()),RANDOM_CHARS.length());
            returnValue += RANDOM_CHARS.substring(random,random + 1);
        } while (returnValue.length() < len);

        return returnValue;
    }
    */

    /*
    public static ccrz__E_ContactAddr__c checkoutTestGetContactAddress() {
        return new ccrz__E_ContactAddr__c(
            ccrz__AddressFirstline__c = '100 Pine Street',
            ccrz__City__c             = 'SmallTown',
            ccrz__DaytimePhone__c     = '(847) 555-1212',
            ccrz__FirstName__c        = 'Test',
            ccrz__HomePhone__c        = '(847) 555-1212',
            ccrz__LastName__c         = 'User',
            ccrz__PostalCode__c       = '60601',
            ccrz__State__c            = 'Idaho',
            ccrz__StateISOCode__c     = 'ID',
            ccrz__CountryISOCode__c   = 'USA'
        );
    }
    */

    public static String checkoutTest_emailAddress;
    public static Account checkoutTest_testAccount;
    public static Contact checkoutTest_testContact;
    public static User checkoutTest_testUser;



    public static cc_imp_StorefrontSettings__c createMyNexeoCustomSetting()
    {
                //insert page layouts in order to use the ids
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
       	User testUser1 = new User(Alias = 'tAstroS8', Email='testusernexeo5@portalnexeo.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='testusernexeo5@portalnexeo.com', IsActive = true,Ashland_Employee_Number__c = 'A733476');
        insert testUser1; 
        ccrz__E_PageLabel__c body;
        System.runAs(testUser1) {
           List<ccrz__E_PageLabel__c> pageLabels = new List<ccrz__E_PageLabel__c>();
           body = new ccrz__E_PageLabel__c( ccrz__ValueRT__c = 'Body', Name = 'MyPricingMyNexeo_EmailBody');
           pageLabels.add(body);
           insert pageLabels;
        }
        
        
        cc_imp_StorefrontSettings__c myNexeoCustomSetting = new cc_imp_StorefrontSettings__c( name='mynexeo',
            Profile_Name__c = MYNEXEO_GUEST_USER_COMMUNITY_PROFILE,
            DefaultPrimarySellerUserId__c = 'customerportal@nexeocolutions.com',
            Default_CSR_Queue_Name__c = 'Customer_Portal_Support',
            ProspectSalesOrg__c = 'Portal Sales Org',
            Division__c = 'Portal Division',
            DistributionChannel__c = 'Portal Distribution Channel',
            SalesDistrict__c = 'Portal Sales District',
            SalesOffice__c = 'Portal Sales Office',
            SalesGroup__c = 'Portal Sales Group',
            RecordTypeName__c = 'Portal_Prospect',
            ContactRecordTypeName__c = 'Portal_Contact',
            ViewCreditHistoryURLPath__c = 'sap/bc/zsd_credit_hist',
            MyInvoiceEndpointURLPath__c = 'sap/bc/zsd_invoice',
            VATValidatorEndpointURLPath__c = 'http://ec.europa.eu/taxation_customs/vies/services/checkVatTestService',
            TaxServiceFindBySequence__c = true,
            TaxServiceRequestMethod__c = 'mynexeo',
            MyWasteSummaryEndpointPath__c = 'test',
            Waste_Summery_Reports_On_Page__c = 5,
            Live_Agent_Id__c = '57244000000CnvA',
            Live_Agent_JS_Component__c = 'https://d.la2-c2cs-iad.salesforceliveagent.com/chat',
            Live_Agent_Org_Id__c = '00D0t0000004XFF',
            Live_Agent_URL__c = 'https://c.la2-c2cs-iad.salesforceliveagent.com/content/g/js/42.0/deployment.js',
            ES_Orders_To_Show__c = 'Complete/Invoiced',
            Nexeo_Integration_User_Id__c = '005E0000000Yzrd',
            Store_Front_Name__c = 'mynexeo',
            OrderReviewRedirect__c = '/mynexeo/ccrz__MyAccount?cartId=&viewState=myOrders',
            Pagination_My_Pricing__c = 5,
            Material_Type_Send_Email_Primary_Seller__c = 'COMMODITY, SPECIALTY',
            Archived_Price_Letters_To_Show__c = 6,
            My_Pricing_Nexeo_Email_Body__c = Body.Id,
            ORG_Default_Wide_Address__c = 'mynexeodonotreply@nexeosolutions.com',
            urlOrdersImage__c = 'https://images.nexeo3d.com/wp-content/uploads/mynexeo/ordercenter.jpg',
            urlServiceImage__c = 'https://images.nexeo3d.com/wp-content/uploads/mynexeo/newsinfo.jpg',
            guest_User_ID__c = '0055A000009s7Ce'                                                                             
                                                                                             

            );

        return myNexeoCustomSetting;
    }


  public static cc_imp_StorefrontSettings__c createNexeo3DCustomSetting()
    {
        //insert page layouts in order to use the ids
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
       	User testUser1 = new User(Alias = 'tAstroS1', Email='testuserooo@portalnexeo.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='testusernexeo11@portalnexeo.com', IsActive = true,Ashland_Employee_Number__c = 'A733dr472');
        insert testUser1; 
        ccrz__E_PageLabel__c body;
        ccrz__E_PageLabel__c subject;
        System.runAs(testUser1) {
            List<ccrz__E_PageLabel__c> pageLabels = new List<ccrz__E_PageLabel__c>();
            body = new ccrz__E_PageLabel__c( ccrz__ValueRT__c = 'Body', Name = 'ContactUs3d_EmailBody');
            subject = new ccrz__E_PageLabel__c( ccrz__ValueRT__c = 'Subject', Name = 'ContactUs3d_EmailSubject');    
            pageLabels.add(body);
            pageLabels.add(subject);
            insert pageLabels;
        }
        cc_imp_StorefrontSettings__c nexeo3DCustomSetting = new cc_imp_StorefrontSettings__c( name='nexeo3d',
            Profile_Name__c = NEXEO3D_GUEST_USER_COMMUNITY_PROFILE,
            VATValidatorEndpointURLPath__c = 'http://ec.europa.eu/taxation_customs/vies/services/checkVatTestService',
            RecordTypeName__c = 'Portal_Prospect',
            ContactRecordTypeName__c = 'Portal_Contact',
            TaxServiceFindBySequence__c = false,
            TaxServiceRequestMethod__c = 'nexeo3d',
            TaxServiceTimeout__c = 20000,
            Contact_Us_3D_Email_Body__c = body.Id,
            Contact_Us_3D_Email_Subject__c = subject.Id,
            Contact_Us_3D_Email__c = 'emailtest@nexeosolutionstest.com',
            PerformTaxCalculation__c =  false
            
            );

        return nexeo3DCustomSetting;
    }



  public static List<cc_imp_StorefrontSettings__c> createNexeoCustomSettingList()
    {
        List <cc_imp_StorefrontSettings__c > storeFrontSettingsList = new List <cc_imp_StorefrontSettings__c>();

        storeFrontSettingsList.add(createNexeo3DCustomSetting());
        //storeFrontSettingsList.add(createMyNexeoCustomSetting());
        
        return storeFrontSettingsList;
    }


    public static void clearContext()
    {
       ccrz.cc_CallContext.currAccountId = null;
       ccrz.cc_CallContext.currContact = null;
       ccrz.cc_CallContext.storefront = null;
    }
    
    public static CC_SFDC_Settings__c createCPICustomSetting() {
        Id ProfileGuestUserId = [select id from Profile where name= 'MyNexeo Profile'].Id;
        User guestUser = new User(Alias = 'standt2', Email='ooo@guesttestorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileGuestUserId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@guestgorg2.com', IsActive = true,Ashland_Employee_Number__c = '124A123', FirstName = 'Guest User');
        insert guestUser;
        
        CC_SFDC_Settings__c myNexeoCustomSetting = new CC_SFDC_Settings__c(
            Name = 'CPI_MyNexeo',
            Get_Products_Zero_Price__c = false,
            GuestProfileId__c = guestUser.Id,
            Number_Of_Last_Login_Days__c = '',
            Pricing_Refresh_time__c = 4,
            Profile_Id__c = '',
            ProspectCSREmail__c = '',
            ProspectCSRName__c = 'Not Assigned yet.',
            ProspectCSRTel__c = '',
            prospectMessage__c = 'Thank you for completing your registration on MyNexeo! We will setup your account and send you a welcome email once setup is complete.',
            ProspectSellerEmail__c = '',
            ProspectSellerName__c = '',
            ProspectSellerTel__c = ''

            );

        return myNexeoCustomSetting;
    }
   
    public static List<CC_SFDC_Settings__c> createCPICustomSettingList(){
        List <CC_SFDC_Settings__c > storeFrontSettingsList = new List <CC_SFDC_Settings__c>();

        storeFrontSettingsList.add(createCPICustomSetting());
        
        return storeFrontSettingsList;
    }

}