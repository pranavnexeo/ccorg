/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        05/03/2018
*   Author:              Ignacio Gonzalez
*   Last Modified:       
*   Last Modified By:    
*
*   Short Description:  Unit test for CCOrderTrigger, CCOrderTriggerHandler, CCOrderTriggerHelper
*   
*   
*   
*   **********************************************************************************************************************/
@isTest
public class CCOrderTriggerTest {

    @isTest 
    public static void insertCCOrder() {
       //Insert custom setting for this test
       Map<String, SObject> m = cc_imp_testUtils.initData();
        userRole ur = [SELECT id from userrole  where developername= 'NEXEOSOLUTIONSORG' limit 1];
        id ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhddsfgdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A12ert3002', FirstName = 'Nexeo_Integration',UserRoleId = ur.Id);
        insert nexeoIntegrationUser;
         system.runAs(nexeoIntegrationUser)
        {
       cc_imp_StorefrontSettings__c myNexeoCustomSetting = cc_imp_testUtils.createMyNexeoCustomSetting();
       insert myNexeoCustomSetting ;
        
        
        ccrz__E_Product__c product = (ccrz__E_Product__c) m.get('product');
        product.NexeoMaterialId__c = 'materialId000';
        product.Product_Number__c = '00000011';
        update product;

        
        Account shipToAccount = (Account) m.get('userAccount');
        shipToAccount.SAP_Accounting_Group__c = 'Sold To';        
        
        
        Account billToAccount = new Account(name = 'SoldToAccountForShipTo' + shipToAccount.Id);
        insert billToAccount;
        System.debug('billToAccount ' + billToAccount);
        
        shipToAccount.SAP_Bill_To_Account_ID__c = billToAccount.Id;
        update shipToAccount;
        System.debug('shipToAccount ' + shipToAccount);

        ccrz__E_Order__c theOrder = cc_imp_testUtils.createOrder(m.get('cart').Id, m.get('userAccount').Id, m.get('userContact').Id, m.get('portalUser').Id, null, null);
        theOrder.ccrz__Storefront__c = 'mynexeo';
        theOrder.ccrz__Account__c = shipToAccount.Id;
        theOrder.ccrz__EffectiveAccountID__c = String.valueOf(shipToAccount.Id);
        insert theOrder;
        
        theOrder = [SELECT Id, Shipping_To__c, Billing_To__c FROM ccrz__E_Order__c WHERE Id =: theOrder.Id];
        
        //System.assertNotEquals(null, theOrder.Shipping_To__c);
       // System.assertNotEquals(null, theOrder.Billing_To__c);
        }
    }
    
        @isTest 
    public static void updateCCOrder() {
       //Insert custom setting for this test
       Map<String, SObject> m = cc_imp_testUtils.initData();
        userRole ur = [SELECT id from userrole  where developername= 'NEXEOSOLUTIONSORG' limit 1];
        id ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhddsfgdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A12ert3002', FirstName = 'Nexeo_Integration',UserRoleId = ur.Id);
        insert nexeoIntegrationUser;
         system.runAs(nexeoIntegrationUser)
        {
       cc_imp_StorefrontSettings__c myNexeoCustomSetting = cc_imp_testUtils.createMyNexeoCustomSetting();
       insert myNexeoCustomSetting ;
        
        ccrz__E_Product__c product = (ccrz__E_Product__c) m.get('product');
        product.NexeoMaterialId__c = 'materialId000';
        product.Product_Number__c = '00000011';
        update product;

        
        Account shipToAccount = (Account) m.get('userAccount');
        shipToAccount.SAP_Accounting_Group__c = 'Sold To';        
        
        
        Account billToAccount = new Account(name = 'SoldToAccountForShipTo' + shipToAccount.Id);
        insert billToAccount;
        System.debug('billToAccount ' + billToAccount);
        
        shipToAccount.SAP_Bill_To_Account_ID__c = billToAccount.Id;
        update shipToAccount;
        System.debug('shipToAccount ' + shipToAccount);

        ccrz__E_Order__c theOrder = cc_imp_testUtils.createOrder(m.get('cart').Id, m.get('userAccount').Id, m.get('userContact').Id, m.get('portalUser').Id, null, null);

        insert theOrder;
        
        theOrder.ccrz__Storefront__c = 'mynexeo';
        theOrder.ccrz__Account__c = shipToAccount.Id;
        theOrder.ccrz__EffectiveAccountID__c = String.valueOf(shipToAccount.Id);
        update theOrder;
        
        theOrder = [SELECT Id, Shipping_To__c, Billing_To__c FROM ccrz__E_Order__c WHERE Id =: theOrder.Id];
        
       // System.assertNotEquals(null, theOrder.Shipping_To__c);
       // System.assertNotEquals(null, theOrder.Billing_To__c);
        }
    }
    
    @isTest 
    public static void shipToCCOrder() {
       //Insert custom setting for this test
       Map<String, SObject> m = cc_imp_testUtils.initData();
        userRole ur = [SELECT id from userrole  where developername= 'NEXEOSOLUTIONSORG' limit 1];
        id ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhddsfgdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A12ert3002', FirstName = 'Nexeo_Integration',UserRoleId = ur.Id);
        insert nexeoIntegrationUser;
         system.runAs(nexeoIntegrationUser)
        {
        cc_imp_StorefrontSettings__c myNexeoCustomSetting = cc_imp_testUtils.createMyNexeoCustomSetting();
       insert myNexeoCustomSetting ;
        
        //Map<String, SObject> m = cc_imp_testUtils.initData();
        ccrz__E_Product__c product = (ccrz__E_Product__c) m.get('product');
        product.NexeoMaterialId__c = 'materialId000';
        product.Product_Number__c = '00000011';
        update product;

        
        Account shipToAccount = (Account) m.get('userAccount');
        shipToAccount.SAP_Accounting_Group__c = 'Ship To';
        
        Account parentAccount = new Account(name = 'ParentAccountoAccountForShipTo' + shipToAccount.Id);
             
        
        Account billToAccount = new Account(name = 'SoldToAccountForShipTo' + shipToAccount.Id);
        
        insert billToAccount;
        System.debug('billToAccount ' + billToAccount);
        parentAccount.SAP_Bill_To_Account_ID__c = billToAccount.Id;
         insert parentAccount;   
        
        shipToAccount.Parent_Account__c = parentAccount.Id;
        update shipToAccount;
        System.debug('shipToAccount ' + shipToAccount);

        ccrz__E_Order__c theOrder = cc_imp_testUtils.createOrder(m.get('cart').Id, m.get('userAccount').Id, m.get('userContact').Id, m.get('portalUser').Id, null, null);

        insert theOrder;
        
        theOrder.ccrz__Storefront__c = 'mynexeo';
        theOrder.ccrz__Account__c = shipToAccount.Id;
        theOrder.ccrz__EffectiveAccountID__c = String.valueOf(shipToAccount.Id);
        update theOrder;
        
        theOrder = [SELECT Id, Shipping_To__c, Billing_To__c FROM ccrz__E_Order__c WHERE Id =: theOrder.Id];
        
      //  System.assertNotEquals(null, theOrder.Shipping_To__c);
       // System.assertNotEquals(null, theOrder.Billing_To__c);
        }
    }

    @isTest 
    public static void update200CCOrder() {
       //Insert custom setting for this test
       Map<String, SObject> m = cc_imp_testUtils.initData();
        userRole ur = [SELECT id from userrole  where developername= 'NEXEOSOLUTIONSORG' limit 1];
        id ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhddsfgdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A12ert3002', FirstName = 'Nexeo_Integration',UserRoleId = ur.Id);
        insert nexeoIntegrationUser;
         system.runAs(nexeoIntegrationUser)
        {
        cc_imp_StorefrontSettings__c myNexeoCustomSetting = cc_imp_testUtils.createMyNexeoCustomSetting();
       insert myNexeoCustomSetting ;
        
        //Map<String, SObject> m = cc_imp_testUtils.initData();
        ccrz__E_Product__c product = (ccrz__E_Product__c) m.get('product');
        product.NexeoMaterialId__c = 'materialId000';
        product.Product_Number__c = '00000011';
        update product;

        
        Account shipToAccount = (Account) m.get('userAccount');
        shipToAccount.SAP_Accounting_Group__c = 'Sold To'; 
        
        
        
        Account billToAccount = new Account(name = 'SoldToAccountForShipTo' + shipToAccount.Id);
        insert billToAccount;
        System.debug('billToAccount ' + billToAccount);
        
        shipToAccount.SAP_Bill_To_Account_ID__c = billToAccount.Id;
        update shipToAccount;
        System.debug('shipToAccount ' + shipToAccount);

        
        List<ccrz__E_Cart__c> cartSet = new List<ccrz__E_Cart__c>();
        //create carts
        for (Integer i = 0; i < 200; i ++) {
            ccrz__E_Cart__c newCart = cc_imp_testUtils.createCart((Account) m.get('userAccount'), (ccrz__E_ContactAddr__c) m.get('address'), (ccrz__E_ContactAddr__c) m.get('address'), (User) m.get('portalUser'), (Contact) m.get('userContact'), 'Cart', cc_imp_testUtils.DEFAULT_STOREFRONT);
            cartSet.add(newCart);
        }
        
        insert cartSet;
        
        List<ccrz__E_CartItem__c> cartItemSet = new List<ccrz__E_CartItem__c>();
        
        //Create cart Items
        for (ccrz__E_Cart__c currentCart:cartSet) {
            ccrz__E_CartItem__c cartItem = cc_imp_testUtils.createCartItem(currentCart, 9.99, 1, product, null);
            cartItemSet.add(cartItem);
        }
        
        insert cartItemSet;
        
        List<ccrz__E_Order__c> orderSet = new List<ccrz__E_Order__c>();
        //Create orders
        for (ccrz__E_Cart__c currentCart:cartSet) {
            ccrz__E_Order__c newOrder = cc_imp_testUtils.createOrder(currentCart.Id, m.get('userAccount').Id, m.get('userContact').Id, m.get('portalUser').Id, null, null);
            orderSet.add(newOrder);
        }    
        
        insert orderSet;
        
        System.debug(' cartSet ' + cartSet.size());
        System.debug(' orderSet ' + orderSet.size());
        System.debug(' cartItemSet ' + cartItemSet.size());
        
        Set<Id> currentOrdersIds = new Set<Id>();
        
        for (ccrz__E_Order__c currentOrder:orderSet) {
             currentOrder.ccrz__Storefront__c = 'mynexeo';
             currentOrder.ccrz__Account__c = shipToAccount.Id;
             currentOrder.ccrz__EffectiveAccountID__c = String.valueOf(shipToAccount.Id);
             currentOrdersIds.add(currentOrder.Id);
        }
        
        update orderSet;
        
        Set<Id> shippingIds = new Set<Id>();
        Set<Id> billingIds = new Set<Id>();
        
        for (ccrz__E_Order__c updatedOrder :[SELECT Id, Shipping_To__c, Billing_To__c FROM ccrz__E_Order__c WHERE Id IN: currentOrdersIds]){
                shippingIds.add(updatedOrder.Shipping_To__c);
                billingIds.add(updatedOrder.Billing_To__c);            
        }
        
       // System.assertEquals(200, shippingIds.size());
       // System.assertEquals(200, billingIds.size());
        }
     
    }
/*
    @isTest 
    public static void update300CCOrder() {
       //Insert custom setting for this test
       cc_imp_StorefrontSettings__c myNexeoCustomSetting = cc_imp_testUtils.createMyNexeoCustomSetting();
       insert myNexeoCustomSetting ;
        
        Map<String, SObject> m = cc_imp_testUtils.initData();
        ccrz__E_Product__c product = (ccrz__E_Product__c) m.get('product');
        product.NexeoMaterialId__c = 'materialId000';
        product.Product_Number__c = '00000011';
        update product;

        
        Account shipToAccount = (Account) m.get('userAccount');
        shipToAccount.SAP_Accounting_Group__c = 'Sold To';        
        
        
        Account billToAccount = new Account(name = 'SoldToAccountForShipTo' + shipToAccount.Id);
        insert billToAccount;
        System.debug('billToAccount ' + billToAccount);
        
        shipToAccount.SAP_Bill_To_Account_ID__c = billToAccount.Id;
        update shipToAccount;
        System.debug('shipToAccount ' + shipToAccount);

        
        List<ccrz__E_Cart__c> cartSet = new List<ccrz__E_Cart__c>();
        //create carts
        for (Integer i = 0; i < 300; i ++) {
            ccrz__E_Cart__c newCart = cc_imp_testUtils.createCart((Account) m.get('userAccount'), (ccrz__E_ContactAddr__c) m.get('address'), (ccrz__E_ContactAddr__c) m.get('address'), (User) m.get('portalUser'), (Contact) m.get('userContact'), 'Cart', cc_imp_testUtils.DEFAULT_STOREFRONT);
            cartSet.add(newCart);
        }
        
        insert cartSet;
        
        List<ccrz__E_CartItem__c> cartItemSet = new List<ccrz__E_CartItem__c>();
        
        //Create cart Items
        for (ccrz__E_Cart__c currentCart:cartSet) {
            ccrz__E_CartItem__c cartItem = cc_imp_testUtils.createCartItem(currentCart, 9.99, 1, product, null);
            cartItemSet.add(cartItem);
        }
        
        insert cartItemSet;
        
        List<ccrz__E_Order__c> orderSet = new List<ccrz__E_Order__c>();
        //Create orders
        for (ccrz__E_Cart__c currentCart:cartSet) {
            ccrz__E_Order__c newOrder = cc_imp_testUtils.createOrder(currentCart.Id, m.get('userAccount').Id, m.get('userContact').Id, m.get('portalUser').Id, null, null);
            orderSet.add(newOrder);
        }    
        
        insert orderSet;
        
        System.debug(' cartSet ' + cartSet.size());
        System.debug(' orderSet ' + orderSet.size());
        System.debug(' cartItemSet ' + cartItemSet.size());
        
        Set<Id> currentOrdersIds = new Set<Id>();
        
        for (ccrz__E_Order__c currentOrder:orderSet) {
             currentOrder.ccrz__Storefront__c = 'mynexeo';
             currentOrder.ccrz__Account__c = shipToAccount.Id;
             currentOrder.ccrz__EffectiveAccountID__c = String.valueOf(shipToAccount.Id);
             currentOrdersIds.add(currentOrder.Id);
        }
        
        update orderSet;
        
        Set<Id> shippingIds = new Set<Id>();
        Set<Id> billingIds = new Set<Id>();
        
        for (ccrz__E_Order__c updatedOrder :[SELECT Id, Shipping_To__c, Billing_To__c FROM ccrz__E_Order__c WHERE Id IN: currentOrdersIds]){
                shippingIds.add(updatedOrder.Shipping_To__c);
                billingIds.add(updatedOrder.Billing_To__c);            
        }
        
        System.assertEquals(300, shippingIds.size());
        System.assertEquals(300, billingIds.size());

     
    }    */
    /*
        @isTest 
    public static void update200CCOrderWorstCase() {
       //Insert custom setting for this test
       cc_imp_StorefrontSettings__c myNexeoCustomSetting = cc_imp_testUtils.createMyNexeoCustomSetting();
       insert myNexeoCustomSetting ;
        
        Map<String, SObject> m = cc_imp_testUtils.initData();
        ccrz__E_Product__c product = (ccrz__E_Product__c) m.get('product');
        product.NexeoMaterialId__c = 'materialId000';
        product.Product_Number__c = '00000011';
        update product;
    
        List<ccrz__E_AccountGroup__c> accountGroups = new List<ccrz__E_AccountGroup__c>();
        for (Integer i = 0; i < 200; i ++) {
             ccrz__E_AccountGroup__c userAccountGroup = cc_imp_testUtils.createAccountGroup('accountGroup');
             accountGroups.add(userAccountGroup);
        }
        
        insert accountGroups;
        
        Map<Id, Account> billToAccountsMap = new Map<Id, Account>();
        for (ccrz__E_AccountGroup__c userAccountGroup : accountGroups) { 
             Account billToAccount = new Account(name = 'SoldToAccountForShipTo' + userAccountGroup.Id);
             billToAccountsMap.put(userAccountGroup.Id, billToAccount);
        }
        
        insert billToAccountsMap.values();
        
        List<Account> userAccounts = new List<Account>();
        for (ccrz__E_AccountGroup__c userAccountGroup : accountGroups) {
             Account billToAccount = billToAccountsMap.get(userAccountGroup.id);
             Account userAccount = cc_imp_testUtils.createAccount(userAccountGroup);
             userAccount.SAP_Accounting_Group__c = 'Sold To';
             userAccount.SAP_Bill_To_Account_ID__c = billToAccount.Id;
             userAccounts.add(userAccount);
        }
        
        insert userAccounts;
            
        
        List<Contact> userContacts = new List<Contact>();
        Integer i = 0;
        for (Account userAccount:userAccounts) {
             String randomEmail = String.valueOf(Datetime.now().getTime()) + String.valueOf(i) + 'usernamenexeo@supernexeoemail.com';
             Contact userContact = cc_imp_testUtils.createContact(userAccount, randomEmail);
             userContacts.add(userContact);
             i++;
        }
        
        insert userContacts;
        
        //Create portal Users
        List<User> portalUsers = new List<User>();
        Profile userProfile = cc_imp_testUtils.getCustomerCommunityProfile();
        for (Contact userContact:userContacts) {
             User portalUser = cc_imp_testUtils.createUser(userProfile, userContact, userContact.Email, userContact.Email, 'firstName', 'lastName', 'alias');
             portalUsers.add(portalUser);
        }
        
        insert portalUsers;
        
        //Create addresses
        Map<Id, ccrz__E_ContactAddr__c> addresses = new Map<Id, ccrz__E_ContactAddr__c>();
        for (User portalUser:portalUsers) {
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
            addresses.put(portalUser.Id, address);
        }
        
        insert addresses.values();
        
        
        //Create addresses
        List<ccrz__E_AccountAddressBook__c> addressBook = new List<ccrz__E_AccountAddressBook__c>();
        for (User portalUser:portalUsers) {
           ccrz__E_ContactAddr__c contactAddr = addresses.get(portalUser.Id);
           ccrz__E_AccountAddressBook__c addrBookShip = new ccrz__E_AccountAddressBook__c(
            ccrz__Account__c = portalUser.AccountId,
            ccrz__AccountId__c = portalUser.AccountId,
            ccrz__AddressType__c = 'Shipping', // Billing/Shipping
            ccrz__E_ContactAddress__c = contactAddr.Id,
            ccrz__Default__c = true,
            ccrz__Owner__c = portalUser.Id
        );
                    ccrz__E_AccountAddressBook__c addrBookBill = new ccrz__E_AccountAddressBook__c(
            ccrz__Account__c = portalUser.AccountId,
            ccrz__AccountId__c = portalUser.AccountId,
            ccrz__AddressType__c = 'Billing', // Billing/Shipping
            ccrz__E_ContactAddress__c = contactAddr.Id,
            ccrz__Default__c = true,
            ccrz__Owner__c = portalUser.Id
        );
            addressBook.add(addrBookShip);
            addressBook.add(addrBookBill);
        }
        
        insert addressBook;
           

        
        List<ccrz__E_Cart__c> cartSet = new List<ccrz__E_Cart__c>();
        //create carts
        for (User portalUser: portalUsers) {
            String cartName = 'Shopping Cart';
            ccrz__E_ContactAddr__c contactAddr = addresses.get(portalUser.Id);
            ccrz__E_Cart__c newCart = new ccrz__E_Cart__c(
                ccrz__Account__c = portalUser.AccountId,
                ccrz__ActiveCart__c = true,
                ccrz__BillTo__c = contactAddr.Id,
                ccrz__CartStatus__c = 'Open',
                ccrz__CartType__c = 'Cart',
                ccrz__Contact__c = portalUser.ContactId,
                ccrz__BuyerFirstName__c = portalUser.Firstname,
                ccrz__BuyerLastName__c = portalUser.Lastname,
                ccrz__Name__c = cartName,
                ccrz__ShipTo__c = contactAddr.Id,
                ccrz__Storefront__c = cc_imp_testUtils.DEFAULT_STOREFRONT,
                ccrz__CurrencyISOCode__c = 'USD',
                CurrencyIsoCode = 'USD',
                OwnerId = portalUser.Id,
                ccrz__User__c = portalUser.Id
            );
            cartSet.add(newCart);
        }
        
        insert cartSet;
        
        List<ccrz__E_CartItem__c> cartItemSet = new List<ccrz__E_CartItem__c>();
        
        //Create cart Items
        for (ccrz__E_Cart__c currentCart:cartSet) {
            ccrz__E_CartItem__c cartItem = cc_imp_testUtils.createCartItem(currentCart, 9.99, 1, product, null);
            cartItemSet.add(cartItem);
        }
        
        insert cartItemSet;
        
        Map<Id, ccrz__E_Order__c> orderSet = new Map<Id, ccrz__E_Order__c>();
        //Create orders
        for (ccrz__E_Cart__c currentCart:cartSet) {
                ccrz__E_Order__c newOrder = new ccrz__E_Order__c();
                newOrder.ccrz__OriginatedCart__c = currentCart.Id;
                newOrder.ccrz__Account__c = currentCart.ccrz__Account__c;
                newOrder.ccrz__EffectiveAccountID__c = String.valueOf(currentCart.ccrz__Account__c);
                newOrder.ccrz__Contact__c = currentCart.ccrz__Contact__c;
                newOrder.OwnerId = currentCart.OwnerId;
                newOrder.ccrz__ShipTo__c = currentCart.ccrz__ShipTo__c;
                newOrder.ccrz__BillTo__c = currentCart.ccrz__BillTo__c;
            orderSet.put(currentCart.Id, newOrder);
        }    
        
        insert orderSet.values();
        
        System.debug(' cartSet ' + cartSet.size());
        System.debug(' orderSet ' + orderSet.size());
        System.debug(' cartItemSet ' + cartItemSet.size());
        
        Set<Id> currentOrdersIds = new Set<Id>();
        Integer accountIndex = 0;
        for (ccrz__E_Order__c currentOrder:orderSet.values()) {
             currentOrder.ccrz__Storefront__c = 'mynexeo';
             currentOrder.ccrz__Account__c = userAccounts.get(accountIndex).Id;
             currentOrder.ccrz__EffectiveAccountID__c = String.valueOf(currentOrder.ccrz__Account__c);    
             currentOrdersIds.add(currentOrder.Id);
             accountIndex++;
        }
        
        update orderSet.values();
        
        Set<Id> shippingIds = new Set<Id>();
        Set<Id> billingIds = new Set<Id>();
        Set<Id> accountIds = new Set<Id>();
        
        for (ccrz__E_Order__c updatedOrder :[SELECT Id, Shipping_To__c, Billing_To__c,ccrz__Account__c  FROM ccrz__E_Order__c WHERE Id IN: currentOrdersIds]){
                shippingIds.add(updatedOrder.Shipping_To__c);
                billingIds.add(updatedOrder.Billing_To__c);
                accountIds.add(updatedOrder.ccrz__Account__c);         
        }
       
        System.assertEquals(200, shippingIds.size());
        System.assertEquals(200, billingIds.size());
        System.assertEquals(200, accountIds.size());

     
    } */
}