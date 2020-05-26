@isTest
private class cc_imp_ctrl_ContactUsTest  
{
    
    @isTest static void test_createCase_Positive_Scenario() 
    {
        //Creating nexeo Integration User
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        
        List <cc_imp_StorefrontSettings__c > storeFrontSettingsList = cc_imp_testUtils.createNexeoCustomSettingList();

       insert storeFrontSettingsList ;

       Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.MYNEXEO_USER_COMMUNITY_PROFILE];

        ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
        insert userAccountGroup;

        Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
        insert userAccount;

        Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
        insert userContact;

        User user = cc_imp_testUtils.createUser(userProfile, userContact, 
            'cc_imp_username@email.com', 'contact@email.com', 'firstName', 'lastName', 'alias');

       //cc_imp_testUtils.clearContext();
       ccrz.cc_CallContext.currAccountId = userAccount.Id;
       ccrz.cc_CallContext.currContact = userContact;
       ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_MYNEXEO_STOREFRONT;
     
       ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();

       Test.startTest();

       ccrz.cc_RemoteActionResult res  = cc_imp_ctrl_ContactUs.createCase(ctx, 'subject', 'reason','comments');

       System.assert(res != null);

       //System.assertEquals(res.success,true);

        //List<NexCare__c> nexCareList = [SELECT ID FROM NexCare__c where Account_Name__c = :userAccount.Id LIMIT 1];
        //System.assertEquals(1, nexCareList.size());

       Test.stopTest();
        
    }


    @isTest static void test_createCase_Negative_Scenario() 
    {
        //Creating nexeo Integration User
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        
        List <cc_imp_StorefrontSettings__c > storeFrontSettingsList = cc_imp_testUtils.createNexeoCustomSettingList();

       insert storeFrontSettingsList ;

       Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.MYNEXEO_USER_COMMUNITY_PROFILE];

        ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
        insert userAccountGroup;

        Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
        insert userAccount;

        Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
        insert userContact;

        User user = cc_imp_testUtils.createUser(userProfile, userContact, 
            'username@email.com', 'contact@email.com', 'firstName', 'lastName', 'alias');

       cc_imp_testUtils.clearContext();

       ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();

       Test.startTest();

       ccrz.cc_RemoteActionResult res  = cc_imp_ctrl_ContactUs.createCase(ctx, 'subject', 'reason','comments');

       System.assert(res != null);

       System.assertEquals(res.success,false);

       List <Case> cases =  [SELECT ID FROM CASE WHERE AccountId = :userAccount.Id LIMIT 1] ;
       
       System.assertEquals(cases, new List<Case>());

       Test.stopTest(); 
    }
    

    @isTest static void test_Get_Reason_Code_Options() 
    {
        //Creating nexeo Integration User
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        
        cc_imp_CaseCreationReasonCodes__c caseCreationReasonCodes = new cc_imp_CaseCreationReasonCodes__c( name='Discount beyond terms',
            optionsLabel__c = '04 – Discount beyond terms',
            optionsValue__c = 'Discount_beyond_terms',
            Storefront__c = 'MyNexeo' );

       insert caseCreationReasonCodes ;

       ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_MYNEXEO_STOREFRONT;

       Test.startTest();

       List<cc_imp_bean_SelectOption> reasonCodesOptions = cc_imp_ctrl_ContactUs.getCaseCreateReasonCodes();

       System.assert(reasonCodesOptions.size() > 0);

       Test.stopTest(); 
     }


     @isTest static void test_Get_Subject_Code_Options() 
    {
        //Creating nexeo Integration User
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        
        cc_imp_CaseCreationSubject__c caseCreationSubjectCodes = new cc_imp_CaseCreationSubject__c( name='  DisputeInvoice',
            optionsLabel__c = 'Dispute Invoice',
        NexCare_Tier_2_Value__c = 'Web Form – General',
            optionsValue__c = 'DisputeInvoice',
            Storefront__c = 'MyNexeo' );

       insert caseCreationSubjectCodes ;

      ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_MYNEXEO_STOREFRONT;

       Test.startTest();

       List<cc_imp_bean_SelectOption> subjectCodesOptions = cc_imp_ctrl_ContactUs.getCaseCreateSubject();

       System.assert(subjectCodesOptions.size() > 0);

       Test.stopTest(); 
     }
    



     @isTest static void test_fetchInvoice() 
   {  
 
     //Creating nexeo Integration User
     Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
     User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123002', FirstName = 'Nexeo_Integration');
     insert nexeoIntegrationUser;
       
     cc_imp_StorefrontSettings__c myNexeoCustomSetting = cc_imp_testUtils.createMyNexeoCustomSetting();

     insert myNexeoCustomSetting ;

     Map <String, String> headerMap = new Map<String, String> ();
     headerMap.put('Content-Type','application/json');

       Test.setMock(HttpCalloutMock.class, new cc_imp_mn_FetchInvoiceMock_HttpResponse(200,'success',mockResponse(), headerMap));

       cc_imp_testUtils.clearContext();

     ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_MYNEXEO_STOREFRONT;

     String invoiceId = '123454646446';

       ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();

     Test.startTest();
     ccrz.cc_RemoteActionResult res  = cc_imp_ctrl_ContactUs.fetchMyInvoicePdf(ctx,invoiceId);

     System.assert(res != null);
     System.assert(res.data != null);

     Test.stopTest();

  }

     @isTest static void test_fetchInvoiceAttachment() 
   {  
     /*cc_imp_StorefrontSettings__c myNexeoCustomSetting = cc_imp_testUtils.createMyNexeoCustomSetting();
     insert myNexeoCustomSetting;

        Map<String, SObject> m = cc_imp_testUtils.initData();
        ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_MYNEXEO_STOREFRONT;
        ccrz__E_Invoice__c invoice = new ccrz__E_Invoice__c(
            ccrz__BillTo__c = m.get('userAccount').Id,
            ccrz__Contact__c = m.get('userContact').Id,
            ccrz__CurrencyCode__c = 'USD',
            ccrz__DateDue__c = Date.today(),
            ccrz__DateIssued__c = Date.today(),
            ccrz__OriginalAmount__c = 100.00,
            ccrz__RemainingAmount__c = 100.00,
            ccrz__SoldTo__c = m.get('userAccount').Id,
            ccrz__Storefront__c = cc_imp_testUtils.TEST_MYNEXEO_STOREFRONT,
            ccrz__User__c = m.get('portalUser').Id
        );
        insert invoice;

     Map <String, String> headerMap = new Map<String, String> ();
     headerMap.put('Content-Type','application/json');

       Test.setMock(HttpCalloutMock.class, new cc_imp_mn_FetchInvoiceMock_HttpResponse(200,'success',mockResponse(), headerMap));

       cc_imp_testUtils.clearContext();

     ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_MYNEXEO_STOREFRONT;

     String invoiceId = '123454646446';

       ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();

     Test.startTest();
     ccrz.cc_RemoteActionResult res  = cc_imp_ctrl_ContactUs.fetchMyInvoiceAttachment(ctx,invoiceId,invoice.Id);

     System.assert(res != null);
     System.assert(res.data != null);

     Test.stopTest();*/

  }


     private static String mockResponse()
      {
        return '{\"document\": \"643774\"}';
      }


      @isTest static void test_fetchInvoices(){
        //Creating nexeo Integration User
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
          
                List <cc_imp_StorefrontSettings__c> customSettingLists = cc_imp_testUtils.createNexeoCustomSettingList();
        insert customSettingLists ;

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


       Test.startTest();


       Map <String, String> headerMap = new Map<String, String> ();
     headerMap.put('Content-Type','application/json');

       Test.setMock(HttpCalloutMock.class, new cc_imp_mn_FetchInvoiceMock_HttpResponse(200,'success',mockResponse(), headerMap));


       cc_imp_testUtils.clearContext();

       ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_MYNEXEO_STOREFRONT;
       ccrz.cc_CallContext.currAccountId = userAccount.Id;

       ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();

       ccrz.cc_RemoteActionResult res  = cc_imp_ctrl_ContactUs.getAllInvoicesForShipToAddress(ctx);
       
      System.assert(res != null);
      System.assert(res.data != null);

      Test.stopTest();*/
       

      }

    static testmethod void disputeInvoiceTest() {
       
      /*  List<cc_imp_StorefrontSettings__c> setList = cc_imp_testUtils.createNexeoCustomSettingList();
        insert setList;

        Map<String, SObject> m = cc_imp_testUtils.initData();
        ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_MYNEXEO_STOREFRONT;
        ccrz__E_Invoice__c invoice = new ccrz__E_Invoice__c(
            ccrz__BillTo__c = m.get('userAccount').Id,
            ccrz__Contact__c = m.get('userContact').Id,
            ccrz__CurrencyCode__c = 'USD',
            ccrz__DateDue__c = Date.today(),
            ccrz__DateIssued__c = Date.today(),
            ccrz__OriginalAmount__c = 100.00,
            ccrz__RemainingAmount__c = 100.00,
            ccrz__SoldTo__c = m.get('userAccount').Id,
            ccrz__Storefront__c = cc_imp_testUtils.TEST_MYNEXEO_STOREFRONT,
            ccrz__User__c = m.get('portalUser').Id
        );
        insert invoice;

        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();

        ccrz.cc_RemoteActionResult res = null;

        Test.startTest();
        res  = cc_imp_ctrl_ContactUs.disputeInvoice(ctx, invoice.Id);
        Test.stopTest();

        System.assert(res != null);*/

    }
    
    static testmethod void initializeClassProspectAccount() {
        //Creating nexeo Integration User
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        
       cc_imp_StorefrontSettings__c  storeFrontSettingsList = cc_imp_testUtils.createMyNexeoCustomSetting();
       insert storeFrontSettingsList ;
        
       List<CC_SFDC_Settings__c> CPICustomSettingList = cc_imp_testUtils.createCPICustomSettingList();
       insert CPICustomSettingList;

       Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.MYNEXEO_USER_COMMUNITY_PROFILE];

       ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
        insert userAccountGroup;

       Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
        userAccount.AccountNumber = 'P78666';
       insert userAccount;

       Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
       insert userContact;

       User user = cc_imp_testUtils.createUser(userProfile, userContact, 
            'cc_imp_username@email.com', 'contact@email.com', 'firstName', 'lastName', 'alias');


       ccrz.cc_CallContext.currAccountId = userAccount.Id;
       ccrz.cc_CallContext.currContact = userContact;
       ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_MYNEXEO_STOREFRONT;
        
       Test.startTest();
        cc_imp_ctrl_ContactUs newInstanceClass = new cc_imp_ctrl_ContactUs();
       Test.stopTest();
    }
    
    static testmethod void initializeClass() {
        //Creating nexeo Integration User
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        
       cc_imp_StorefrontSettings__c  storeFrontSettingsList = cc_imp_testUtils.createMyNexeoCustomSetting();
       insert storeFrontSettingsList ;
        
       List<CC_SFDC_Settings__c> CPICustomSettingList = cc_imp_testUtils.createCPICustomSettingList();
       insert CPICustomSettingList;

       Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.MYNEXEO_USER_COMMUNITY_PROFILE];

       ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
       insert userAccountGroup;
        
       User SAPSeller = new User(
         ProfileId = [SELECT Id FROM Profile WHERE Name = 'Plant Manager Platform'].Id,
         LastName = 'last',
         Email = 'test' + System.currentTimeMillis() + '@testmynexeo.com',
         Username = 'test' + System.currentTimeMillis() + '@testmynexeo.com',
         CompanyName = 'Nexeo',
         Phone = '0098976543',
         Title = 'title',
         Alias = 'alias',
         TimeZoneSidKey = 'America/Los_Angeles',
         EmailEncodingKey = 'UTF-8',
         LanguageLocaleKey = 'en_US',
         LocaleSidKey = 'en_US'
    	);
	   insert SAPSeller;
        
       SAP_Seller__c seller = new SAP_Seller__c();
		seller.User__c = SAPSeller.Id; 
	   insert seller;
        
       Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
       	userAccount.AccountNumber = '0000126990';
        userAccount.Type = 'Customer';
        userAccount.ZC_Partner__c = seller.Id;
        userAccount.Primary_Seller__c = SAPSeller.Id;
       insert userAccount;

       Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
       insert userContact;

       User user = cc_imp_testUtils.createUser(userProfile, userContact, 
            'cc_imp_username@email.com', 'contact@email.com', 'firstName', 'lastName', 'alias');


       ccrz.cc_CallContext.currAccountId = userAccount.Id;
       ccrz.cc_CallContext.currContact = userContact;
       ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_MYNEXEO_STOREFRONT;
        
       Test.startTest();
        cc_imp_ctrl_ContactUs newInstanceClass = new cc_imp_ctrl_ContactUs();
       Test.stopTest();
    }
    
    static testmethod void initializeClassPhoneWithExt() {
        //Creating nexeo Integration User
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        
       cc_imp_StorefrontSettings__c  storeFrontSettingsList = cc_imp_testUtils.createMyNexeoCustomSetting();
       insert storeFrontSettingsList ;
        
       List<CC_SFDC_Settings__c> CPICustomSettingList = cc_imp_testUtils.createCPICustomSettingList();
       insert CPICustomSettingList;

       Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.MYNEXEO_USER_COMMUNITY_PROFILE];

       ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
       insert userAccountGroup;
        
       User SAPSeller = new User(
         ProfileId = [SELECT Id FROM Profile WHERE Name = 'Plant Manager Platform'].Id,
         LastName = 'last',
         Email = 'test' + System.currentTimeMillis() + '@testmynexeo.com',
         Username = 'test' + System.currentTimeMillis() + '@testmynexeo.com',
         CompanyName = 'Nexeo',
         Phone = '0098976543 ext 3456',
         Title = 'title',
         Alias = 'alias',
         TimeZoneSidKey = 'America/Los_Angeles',
         EmailEncodingKey = 'UTF-8',
         LanguageLocaleKey = 'en_US',
         LocaleSidKey = 'en_US'
    	);
	   insert SAPSeller;
        
       SAP_Seller__c seller = new SAP_Seller__c();
		seller.User__c = SAPSeller.Id; 
	   insert seller;
        
       Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
       	userAccount.AccountNumber = '0000126990';
        userAccount.Type = 'Customer';
        userAccount.ZC_Partner__c = seller.Id;
        userAccount.Primary_Seller__c = SAPSeller.Id;
       insert userAccount;

       Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
       insert userContact;

       User user = cc_imp_testUtils.createUser(userProfile, userContact, 
            'cc_imp_username@email.com', 'contact@email.com', 'firstName', 'lastName', 'alias');


       ccrz.cc_CallContext.currAccountId = userAccount.Id;
       ccrz.cc_CallContext.currContact = userContact;
       ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_MYNEXEO_STOREFRONT;
        
       Test.startTest();
        cc_imp_ctrl_ContactUs newInstanceClass = new cc_imp_ctrl_ContactUs();
       Test.stopTest();
    }
    
     static testmethod void initializeClass11DigitsPhone() {
        //Creating nexeo Integration User
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;         
       cc_imp_StorefrontSettings__c  storeFrontSettingsList = cc_imp_testUtils.createMyNexeoCustomSetting();
       insert storeFrontSettingsList ;
        
       List<CC_SFDC_Settings__c> CPICustomSettingList = cc_imp_testUtils.createCPICustomSettingList();
       insert CPICustomSettingList;

       Profile userProfile = [SELECT Id, name from Profile where Name = :cc_imp_testUtils.MYNEXEO_USER_COMMUNITY_PROFILE];

       ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
       insert userAccountGroup;
        
       User SAPSeller = new User(
         ProfileId = [SELECT Id FROM Profile WHERE Name = 'Plant Manager Platform'].Id,
         LastName = 'last',
         Email = 'test' + System.currentTimeMillis() + '@testmynexeo.com',
         Username = 'test' + System.currentTimeMillis() + '@testmynexeo.com',
         CompanyName = 'Nexeo',
         Phone = '10989765431',
         Title = 'title',
         Alias = 'alias',
         TimeZoneSidKey = 'America/Los_Angeles',
         EmailEncodingKey = 'UTF-8',
         LanguageLocaleKey = 'en_US',
         LocaleSidKey = 'en_US'
    	);
	   insert SAPSeller;
        
       SAP_Seller__c seller = new SAP_Seller__c();
		seller.User__c = SAPSeller.Id; 
	   insert seller;
        
       Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
       	userAccount.AccountNumber = '0000126990';
        userAccount.Type = 'Customer';
        userAccount.ZC_Partner__c = seller.Id;
        userAccount.Primary_Seller__c = SAPSeller.Id;
       insert userAccount;

       Contact userContact = cc_imp_testUtils.createContact(userAccount, 'contact@email.com');
       insert userContact;

       User user = cc_imp_testUtils.createUser(userProfile, userContact, 
            'cc_imp_username@email.com', 'contact@email.com', 'firstName', 'lastName', 'alias');


       ccrz.cc_CallContext.currAccountId = userAccount.Id;
       ccrz.cc_CallContext.currContact = userContact;
       ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_MYNEXEO_STOREFRONT;
        
       Test.startTest();
        cc_imp_ctrl_ContactUs newInstanceClass = new cc_imp_ctrl_ContactUs();
       Test.stopTest();
    }
    
}