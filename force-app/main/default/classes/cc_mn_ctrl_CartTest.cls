@isTest
public class cc_mn_ctrl_CartTest {
    
    public static Customer_Product_Info__c createCPI(Account currAccount) {
        Customer_Product_Info__c newCustomer_Product_Info = new Customer_Product_Info__c();
            newCustomer_Product_Info.Comp_Account__c = currAccount.Id;
            newCustomer_Product_Info.CoPackAccount__c = currAccount.Id;
            newCustomer_Product_Info.CPI_Account__c = currAccount.Id;
         	newCustomer_Product_Info.ES_Account__c = currAccount.Id;
       	 	newCustomer_Product_Info.Plastics_Account__c = currAccount.Id;
            newCustomer_Product_Info.Customer_Material_Number__c = '12345678999999990';
        	newCustomer_Product_Info.Sales_Org_Code__c = '32';
         	newCustomer_Product_Info.Customer_Number__c = 'abcde123';
        	newCustomer_Product_Info.Material_Number__c = 'xyz12345';
            newCustomer_Product_Info.Distribution_Channel_Code__c = '02';
        	newCustomer_Product_Info.Record_Key__c = '123345rtfdert';
        	newCustomer_Product_Info.CPI_Record_Type__c = '1';
        insert newCustomer_Product_Info;
        return newCustomer_Product_Info;
    }
    
    static testmethod void controllerTest() {
        //insert cc_imp_testUtils.createNexeoCustomSettingList();

        Map<String, SObject> m = cc_imp_testUtils.initData();
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        system.runas(nexeoIntegrationUser)
        {
            insert cc_imp_testUtils.createNexeoCustomSettingList();
        ccrz__E_Cart__c c = (ccrz__E_Cart__c) m.get('cart');
        //retriving the pricelist in order to update the relation with the CPI for the 
        //priceList items
        Account currentAccount = (Account) m.get('userAccount');
        ccrz__E_Pricelist__c priceList = (ccrz__E_Pricelist__c) m.get('priceList');
        // getting all the pricelist items in order to realted them to the CPI
        List<ccrz__E_PriceListItem__c> priceListItems = new List<ccrz__E_PriceListItem__c>();
        Customer_Product_Info__c CPI = createCPI(currentAccount);
        for (ccrz__E_PriceListItem__c pp : [SELECT Id FROM ccrz__E_PriceListItem__c WHERE ccrz__PriceList__c =: priceList.Id]) {
            	pp.CPI__c = CPI.Id;
            priceListItems.add(pp);
        }
        if (!priceListItems.isEmpty()) {
            update priceListItems;
        }
        
        ccrz__E_Rule__c rule = new ccrz__E_Rule__c(
            ccrz__Relation__c='Pricelist Item',
            ccrz__Name__c='PLI-tiered-pricing-rule',
            ccrz__RuleType__c='Tiered',
            ccrz__CurrencyISOCode__c='USD',
            ccrz__RuleSource__c='Pricing',
            ccrz__Enabled__c=true);
        insert rule;
        
        ccrz__E_PriceModifier__c modifier = new ccrz__E_PriceModifier__c(ccrz__DiscountType__c='Price', ccrz__Amount__c=100.00, ccrz__Quantity__c=100, Base_Price__c=50.00);
        insert modifier;

        ccrz__E_RulePricingModifier__c rpm = new ccrz__E_RulePricingModifier__c(ccrz__Rule__c=rule.Id, ccrz__PriceModifier__c=modifier.Id);
        insert rpm;
        
        ccrz__E_RuleTargetPLI__c pliRule = new ccrz__E_RuleTargetPLI__c(ccrz__E_Rule__c=rule.Id, ccrz__E_PriceListItem__c =  priceListItems.get(0).Id);
        insert pliRule;
        
       	ccrz__E_Cart__c theCart = [SELECT Id, ccrz__EncryptedId__c FROM ccrz__E_Cart__c WHERE Id = :c.Id];
        
        cc_mn_ctrl_Cart controller = null;
        System.currentPageReference().getParameters().put('cartId', theCart.ccrz__EncryptedId__c);
        ccrz.cc_CallContext.effAccountGroup = ccrz.cc_CallContext.currAccountGroup;

        Test.startTest();
        controller = new cc_mn_ctrl_Cart();
        Test.stopTest();

        System.assert(controller != null);
        System.assert(controller.extendedCartJSON != null);
        }
    }
    
    // In order to test behavior when the cart has more that one product 
    static testmethod void controllerTestWithMoreThanOneTier() {
        

        Map<String, SObject> m = cc_imp_testUtils.initData();
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        system.runas(nexeoIntegrationUser)
        {
            insert cc_imp_testUtils.createNexeoCustomSettingList();
        ccrz__E_Cart__c c = (ccrz__E_Cart__c) m.get('cart');
        //retriving the pricelist in order to update the relation with the CPI for the 
        //priceList items
		ccrz__E_Product__c product = (ccrz__E_Product__c) m.get('product');
        ccrz__E_CartItem__c cartItem = cc_imp_testUtils.createCartItem(c, 9.99, 2, product, null);
        insert cartItem;
        Account currentAccount = (Account) m.get('userAccount');
        ccrz__E_Pricelist__c priceList = (ccrz__E_Pricelist__c) m.get('priceList');
        // getting all the pricelist items in order to realted them to the CPI
        List<ccrz__E_PriceListItem__c> priceListItems = new List<ccrz__E_PriceListItem__c>();
        Customer_Product_Info__c CPI = createCPI(currentAccount);
        for (ccrz__E_PriceListItem__c pp : [SELECT Id FROM ccrz__E_PriceListItem__c WHERE ccrz__PriceList__c =: priceList.Id]) {
            	pp.CPI__c = CPI.Id;
            priceListItems.add(pp);
        }
        if (!priceListItems.isEmpty()) {
            update priceListItems;
        }
        
        ccrz__E_Rule__c rule = new ccrz__E_Rule__c(
            ccrz__Relation__c='Pricelist Item',
            ccrz__Name__c='PLI-tiered-pricing-rule',
            ccrz__RuleType__c='Tiered',
            ccrz__CurrencyISOCode__c='USD',
            ccrz__RuleSource__c='Pricing',
            ccrz__Enabled__c=true);
        insert rule;
        
        ccrz__E_PriceModifier__c modifier = new ccrz__E_PriceModifier__c(ccrz__DiscountType__c='Price', ccrz__Amount__c=100.00, ccrz__Quantity__c=100, Base_Price__c=50.00);
        insert modifier;

        ccrz__E_RulePricingModifier__c rpm1 = new ccrz__E_RulePricingModifier__c(ccrz__Rule__c=rule.Id, ccrz__PriceModifier__c=modifier.Id);
        ccrz__E_RulePricingModifier__c rpm2 = new ccrz__E_RulePricingModifier__c(ccrz__Rule__c=rule.Id, ccrz__PriceModifier__c=modifier.Id);
        List<ccrz__E_RulePricingModifier__c> rpmList = new List<ccrz__E_RulePricingModifier__c>();
        rpmList.add(rpm1);
        rpmList.add(rpm2);
        insert rpmList;
        
        ccrz__E_RuleTargetPLI__c pliRule = new ccrz__E_RuleTargetPLI__c(ccrz__E_Rule__c=rule.Id, ccrz__E_PriceListItem__c =  priceListItems.get(0).Id);
        insert pliRule;
        
       	ccrz__E_Cart__c theCart = [SELECT Id, ccrz__EncryptedId__c FROM ccrz__E_Cart__c WHERE Id = :c.Id];
        
        cc_mn_ctrl_Cart controller = null;
        System.currentPageReference().getParameters().put('cartId', theCart.ccrz__EncryptedId__c);
        ccrz.cc_CallContext.effAccountGroup = ccrz.cc_CallContext.currAccountGroup;

        Test.startTest();
        controller = new cc_mn_ctrl_Cart();
        Test.stopTest();

        System.assert(controller != null);
        System.assert(controller.extendedCartJSON != null);
        }
    }
}