@isTest
public class cc_3d_ctrl_CheckoutUserInfoCtrlTest {

    static testmethod void initializeCountryMapTest() {
        ccrz__E_LocaleMap__c setting = new ccrz__E_LocaleMap__c(Name = 'US', ccrz__BrowserLocale__c = 'en_US', ccrz__CountryCode__c = 'US', ccrz__Currency__c = 'USD');
        insert setting;
        List<cc_imp_State_County__c> counties = new List<cc_imp_State_County__c>{
            new cc_imp_State_County__c(State__c = 'MN', County__c = 'Olmsted'),
            new cc_imp_State_County__c(State__c = 'MN', County__c = 'Washington'),
            new cc_imp_State_County__c(State__c = 'IL', County__c = 'County1'),
            new cc_imp_State_County__c(State__c = 'IL', County__c = 'County2')
        };
        insert counties;

        cc_3d_ctrl_CheckoutUserInfoController ctrl = null;
        Test.startTest();
        ctrl = new cc_3d_ctrl_CheckoutUserInfoController();
        Test.stopTest();

        System.assert(ctrl != null);
        System.assert(ctrl.countryMap != null);
        System.assert(ctrl.countryMapJSON != null);
        System.assert(ctrl.countryMap.get('US') != null);
        System.assert(ctrl.countyMap != null);
        System.assert(ctrl.countyMapJSON != null);
        System.assert(ctrl.countyMap.get('MN') != null);
        System.assert(ctrl.currencyMap != null);
        System.assert(ctrl.currencyMapJSON != null);
        System.assert(ctrl.currencyMap.get('US') != null);
    }

    static testmethod void  saveCountyTest() {
        Map<String, SObject> m = cc_imp_testUtils.initData();
        

        
        
        userRole ur = [SELECT id from userrole  where developername= 'NEXEOSOLUTIONSORG' limit 1];
        id ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdfdsfgdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A12erft3002', FirstName = 'Nexeo_Integration',UserRoleId = ur.Id);
        insert nexeoIntegrationUser;
         system.runAs(nexeoIntegrationUser)
        {
            insert cc_imp_testUtils.createNexeo3DCustomSetting();
        //insert cc_imp_testUtils.createNexeoCustomSettingList();
        cc_imp_StorefrontSettings__c setting = new cc_imp_StorefrontSettings__c(name=cc_imp_testUtils.DEFAULT_STOREFRONT);
        insert setting;
        ccrz__E_Cart__c c = (ccrz__E_Cart__c) m.get('cart');

        Test.startTest();
        cc_3d_ctrl_CheckoutUserInfoController.saveCounty(cc_imp_testUtils.DEFAULT_STOREFRONT, UserInfo.getUserId(), 'Olmsted', c.Id);
        Test.stopTest();

        ccrz__E_Cart__c cart = [SELECT Id, ccrz__ShipTo__c, ccrz__ShipTo__r.County__c FROM ccrz__E_Cart__c WHERE Id = :c.Id];

        System.assertEquals('Olmsted', cart.ccrz__ShipTo__r.County__c);
        }
    }
}