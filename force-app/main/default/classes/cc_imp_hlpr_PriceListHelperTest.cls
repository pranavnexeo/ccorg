@isTest
public class cc_imp_hlpr_PriceListHelperTest {

    static testmethod void getPriceListItemsBySequenceTest() {
        

        Map<String, SObject> m = cc_imp_testUtils.initData();
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        system.runas(nexeoIntegrationUser)
        {
            List<cc_imp_StorefrontSettings__c> setList = cc_imp_testUtils.createNexeoCustomSettingList();
        insert setList;
        ccrz__E_Product__c p = (ccrz__E_Product__c) m.get('product');
        ccrz.cc_CallContext.storefront = cc_imp_testUtils.DEFAULT_STOREFRONT;
        ccrz.cc_CallContext.effAccountGroup = ccrz.cc_CallContext.currAccountGroup;

        Map<Id, ccrz__E_PriceListItem__c> theMap = null;

        Test.startTest();
        theMap = cc_imp_hlpr_PriceListHelper.getPriceListItemsBySequence(new List<Id> {p.Id});
        Test.stopTest();

        System.assert(theMap != null);
        System.assert(theMap.get(p.Id) != null);
        }
    }

    static testmethod void populateProductEntryDataSearchTest() {
        

        Map<String, SObject> m = cc_imp_testUtils.initData();
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        system.runas(nexeoIntegrationUser)
        {
       insert cc_imp_testUtils.createNexeoCustomSettingList();    
        ccrz__E_PriceList__c priceList = (ccrz__E_PriceList__c) m.get('priceList');
        ccrz.cc_CallContext.effAccountGroup = ccrz.cc_CallContext.currAccountGroup;
        List<ccrz__E_PriceListItem__c> pliList = [SELECT Id FROM ccrz__E_PriceListItem__c WHERE ccrz__PriceList__c = :priceList.Id]; 

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
        
        ccrz__E_RuleTargetPLI__c pliRule = new ccrz__E_RuleTargetPLI__c(ccrz__E_Rule__c=rule.Id, ccrz__E_PriceListItem__c=pliList[0].Id);
        insert pliRule;

        List<cc_imp_hlpr_PriceListHelper.PriceListItemTier> tierList = null;

        Test.startTest();
        tierList = cc_imp_hlpr_PriceListHelper.getPriceListItemTier(pliList[0].Id);
        Test.stopTest();

        System.assert(tierList != null);
        }

    }
    
    static testmethod void getPriceListItemTierFGGTest() { 
    	
        

        Map<String, SObject> m = cc_imp_testUtils.initData();
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        system.runas(nexeoIntegrationUser)
        {
            insert cc_imp_testUtils.createNexeoCustomSettingList();
        ccrz__E_PriceList__c priceList = (ccrz__E_PriceList__c) m.get('priceList');
        ccrz.cc_CallContext.effAccountGroup = ccrz.cc_CallContext.currAccountGroup;
        List<ccrz__E_PriceListItem__c> pliList = [SELECT Id FROM ccrz__E_PriceListItem__c WHERE ccrz__PriceList__c = :priceList.Id]; 

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
        
        ccrz__E_RuleTargetPLI__c pliRule = new ccrz__E_RuleTargetPLI__c(ccrz__E_Rule__c=rule.Id, ccrz__E_PriceListItem__c=pliList[0].Id);
        insert pliRule;        
        
        List<cc_imp_hlpr_PriceListHelper.PriceListItemTier> tierList = null;
        
        Test.startTest();
        tierList = cc_imp_hlpr_PriceListHelper.getPriceListItemTierFGG(pliList[0].Id);
        Test.stopTest();

        System.assert(tierList != null);
        }
    }
    
    static testmethod void populateProductEntryDataSearchTestBulk() {
        

        Map<String, SObject> m = cc_imp_testUtils.initData();
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        system.runas(nexeoIntegrationUser)
        {
        insert cc_imp_testUtils.createNexeoCustomSettingList();    
        ccrz__E_PriceList__c priceList = (ccrz__E_PriceList__c) m.get('priceList');
        ccrz.cc_CallContext.effAccountGroup = ccrz.cc_CallContext.currAccountGroup;
              

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
        
  
        List<Id> Ids = new List<Id>();
        List<ccrz__E_RuleTargetPLI__c> pliRules = new List<ccrz__E_RuleTargetPLI__c>();
        for( ccrz__E_PriceListItem__c item :[SELECT Id FROM ccrz__E_PriceListItem__c WHERE ccrz__PriceList__c = :priceList.Id] ) {
            System.debug('here');
            Ids.add(item.Id);
            ccrz__E_RuleTargetPLI__c pliRule = new ccrz__E_RuleTargetPLI__c(ccrz__E_Rule__c=rule.Id, ccrz__E_PriceListItem__c = item.id);
            pliRules.add(pliRule);
        }
         System.debug('pliRules  '  + pliRules.size());
        insert pliRules;
        Map<Id,  List<Object>> mapTiers = cc_imp_hlpr_PriceListHelper.getPriceListItemTierBulk(Ids);
        
		System.assert(!mapTiers.isEmpty());
        }
    }
    
        static testmethod void getPriceListItemsBySequenceESTest() {
        

        Map<String, SObject> m = cc_imp_testUtils.initData();
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        system.runas(nexeoIntegrationUser)
        {   
            List<cc_imp_StorefrontSettings__c> setList = cc_imp_testUtils.createNexeoCustomSettingList();
        insert setList;
        ccrz__E_Product__c p = (ccrz__E_Product__c) m.get('product');
        ccrz.cc_CallContext.storefront = cc_imp_testUtils.DEFAULT_STOREFRONT;
        ccrz.cc_CallContext.effAccountGroup = ccrz.cc_CallContext.currAccountGroup;
        ccrz.cc_CallContext.userCurrency = cc_imp_testUtils.TEST_USER_CURRENCY;

        Map<Id, ccrz__E_PriceListItem__c> theMap = null;

        Test.startTest();
        theMap = cc_imp_hlpr_PriceListHelper.getPriceListItemsBySequenceES(new List<Id> {p.Id});
        Test.stopTest();

        System.assert(theMap != null);
        System.assert(theMap.get(p.Id) != null);
        }
    }

}