@isTest
public class cc_3d_api_ShippingAndHandlingTest { 

   @TestSetup
    static void testSetup() {
        

        Map<String, SObject> m = cc_imp_testUtils.initData();
        userRole ur = [SELECT id from userrole  where developername= 'NEXEOSOLUTIONSORG' limit 1];
        id ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhddsdffgdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A12fdert3002', FirstName = 'Nexeo_Integration',UserRoleId = ur.Id);
        insert nexeoIntegrationUser;
         system.runAs(nexeoIntegrationUser)
        {
            insert cc_imp_testUtils.createNexeo3DCustomSetting();
        //insert cc_imp_testUtils.createNexeoCustomSettingList();

        ccrz.cc_util_Reflection.createStorefrontSetting(cc_imp_testUtils.TEST_NEXEO3D_STOREFRONT);
        ccrz.cc_util_Reflection.updateStorefrontSettings(cc_imp_testUtils.TEST_NEXEO3D_STOREFRONT, 'ccrz__DefaultLanguage__c', 'en_US');

       ccrz__E_Cart__c   myCart = (ccrz__E_Cart__c) m.get('cart');
       myCart.ccrz__Storefront__c = cc_imp_testUtils.TEST_NEXEO3D_STOREFRONT;
       update myCart;

       ccrz__E_Product__c p = (ccrz__E_Product__c) m.get('product');
       p.ccrz__ProductWeight__c = 1000;
       p.ccrz__Storefront__c = cc_imp_testUtils.TEST_NEXEO3D_STOREFRONT;
       update p;

       ccrz__E_CartItem__c i = (ccrz__E_CartItem__c) m.get('cartItem');
       i.ccrz__Quantity__c = 5;
       update i;

        List<cc_3d_Shipping_Rule__c> rules = new List<cc_3d_Shipping_Rule__c>{
            new cc_3d_Shipping_Rule__c(Country_Code__c = 'DE', Shipping_Cost__c = 100, Weight_From__c = 0, Weight_To__c = 10, Shipping_Company_Name__c='FedEx_Test', Delivery_Type__c = '1-2 Days'),
            new cc_3d_Shipping_Rule__c(Country_Code__c = 'ES', Shipping_Cost__c = 100, Weight_From__c = 0, Weight_To__c = 10, Postal_Code_From__c = '00000', Postal_Code_To__c = '10000', Shipping_Company_Name__c='FedEx_Test', Delivery_Type__c = '1-2 Days'),
            new cc_3d_Shipping_Rule__c(Country_Code__c = 'ES', Shipping_Cost__c = 101, Weight_From__c = 0, Weight_To__c = 10, Postal_Code_From__c = '10001', Postal_Code_To__c = '20000', Shipping_Company_Name__c='FedEx_Test', Delivery_Type__c = '1-2 Days')
        };
        insert rules;

        List<cc_3d_Zip_Code_Zone__c> zones = new List<cc_3d_Zip_Code_Zone__c>{
            new cc_3d_Zip_Code_Zone__c(Zip_Code__c = '500', Zone__c = 5),
            new cc_3d_Zip_Code_Zone__c(Zip_Code__c = '90500', Zone__c = 9)
        };
        insert zones;

        List<cc_3d_Zone_Shipping_Rule__c> zoneRules = new List<cc_3d_Zone_Shipping_Rule__c>{
            new cc_3d_Zone_Shipping_Rule__c(Shipping_Option__c='2-Day', Weight__c=12, Zone_2_Cost__c=2, Zone_3_Cost__c=3, Zone_4_Cost__c=4, Zone_5_Cost__c=5, Zone_6_Cost__c=6, Zone_7_Cost__c=7, Zone_8_Cost__c=8, Zone_9_Cost__c=9, Zone_10_Cost__c=10, Zone_11_Cost__c=11, Zone_12_Cost__c=12, Zone_13_Cost__c=13, Zone_14_Cost__c=14, Zone_15_Cost__c=15, Zone_16_Cost__c=16),
            new cc_3d_Zone_Shipping_Rule__c(Shipping_Option__c='Overnight', Weight__c=12, Zone_2_Cost__c=3, Zone_3_Cost__c=4, Zone_4_Cost__c=5, Zone_5_Cost__c=6, Zone_6_Cost__c=7, Zone_7_Cost__c=8, Zone_8_Cost__c=9, Zone_9_Cost__c=10, Zone_10_Cost__c=11, Zone_11_Cost__c=12, Zone_12_Cost__c=13, Zone_13_Cost__c=14, Zone_14_Cost__c=15, Zone_15_Cost__c=16, Zone_16_Cost__c=17),
            new cc_3d_Zone_Shipping_Rule__c(Shipping_Option__c='2-Day', Weight__c=11, Zone_2_Cost__c=4, Zone_3_Cost__c=5, Zone_4_Cost__c=6, Zone_5_Cost__c=7, Zone_6_Cost__c=8, Zone_7_Cost__c=9, Zone_8_Cost__c=10, Zone_9_Cost__c=11, Zone_10_Cost__c=12, Zone_11_Cost__c=13, Zone_12_Cost__c=14, Zone_13_Cost__c=15, Zone_14_Cost__c=16, Zone_15_Cost__c=17, Zone_16_Cost__c=18),
            new cc_3d_Zone_Shipping_Rule__c(Shipping_Option__c='Overnight', Weight__c=11, Zone_2_Cost__c=4, Zone_3_Cost__c=5, Zone_4_Cost__c=6, Zone_5_Cost__c=7, Zone_6_Cost__c=8, Zone_7_Cost__c=9, Zone_8_Cost__c=10, Zone_9_Cost__c=11, Zone_10_Cost__c=12, Zone_11_Cost__c=13, Zone_12_Cost__c=14, Zone_13_Cost__c=15, Zone_14_Cost__c=16, Zone_15_Cost__c=17, Zone_16_Cost__c=18),
            new cc_3d_Zone_Shipping_Rule__c(Shipping_Option__c='2-Day', Weight__c=13, Zone_2_Cost__c=4, Zone_3_Cost__c=5, Zone_4_Cost__c=6, Zone_5_Cost__c=7, Zone_6_Cost__c=8, Zone_7_Cost__c=9, Zone_8_Cost__c=10, Zone_9_Cost__c=11, Zone_10_Cost__c=12, Zone_11_Cost__c=13, Zone_12_Cost__c=14, Zone_13_Cost__c=15, Zone_14_Cost__c=16, Zone_15_Cost__c=17, Zone_16_Cost__c=18),
            new cc_3d_Zone_Shipping_Rule__c(Shipping_Option__c='Overnight', Weight__c=13, Zone_2_Cost__c=4, Zone_3_Cost__c=5, Zone_4_Cost__c=6, Zone_5_Cost__c=7, Zone_6_Cost__c=8, Zone_7_Cost__c=9, Zone_8_Cost__c=10, Zone_9_Cost__c=11, Zone_10_Cost__c=12, Zone_11_Cost__c=13, Zone_12_Cost__c=14, Zone_13_Cost__c=15, Zone_14_Cost__c=16, Zone_15_Cost__c=17, Zone_16_Cost__c=18),
            new cc_3d_Zone_Shipping_Rule__c(Shipping_Option__c='Standard', Weight__c=12, AK_Cost__c = 10, HI_Cost__c = 20, PR_Cost__c = 30)
        };
        insert zoneRules;
        }
    }

    static testmethod void getShippingOptionsTest() 
    {
        ccrz__E_Cart__c cart = [SELECT Id FROM ccrz__E_Cart__c WHERE ccrz__ActiveCart__c = true];

        List<ccrz.cc_ctrl_hlpr_ShippingOption> options = null;

        Test.startTest();

        ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_NEXEO3D_STOREFRONT;

        cc_3d_api_ShippingAndHandling api = new cc_3d_api_ShippingAndHandling();

        options = api.getShippingOptions('00500', null, 'DE', cart.Id, cc_imp_testUtils.DEFAULT_STOREFRONT);
        Test.stopTest();

        System.assert(options != null);
        System.assertEquals(1, options.size());
        System.assertEquals(100, options[0].price);
    }

  
    static  testmethod void getShippingOptionsESTest() 
    {
         ccrz__E_Cart__c cart = [SELECT Id FROM ccrz__E_Cart__c WHERE ccrz__ActiveCart__c = true];
             
        List<ccrz.cc_ctrl_hlpr_ShippingOption> options = null;

        Test.startTest();

        ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_NEXEO3D_STOREFRONT;

      
        cc_3d_api_ShippingAndHandling api = new cc_3d_api_ShippingAndHandling();

        options = api.getShippingOptions('15000', null, 'ES', cart.Id, cc_imp_testUtils.TEST_NEXEO3D_STOREFRONT);

        Test.stopTest();

        System.assert(options != null);
        System.assertEquals(1, options.size());
        System.assertEquals(101, options[0].price);
        System.assertEquals('FedEx_Test', options[0].provider);
        System.assertEquals('1-2 Days', options[0].serviceName);

    }

    static testmethod void getShippingOptionsUSZipPrefixTest() {

        ccrz__E_Cart__c cart = [SELECT Id FROM ccrz__E_Cart__c WHERE ccrz__ActiveCart__c = true];

        List<ccrz.cc_ctrl_hlpr_ShippingOption> options = null;

        Test.startTest();

        ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_NEXEO3D_STOREFRONT;

        cc_3d_api_ShippingAndHandling api = new cc_3d_api_ShippingAndHandling();

        options = api.getShippingOptions('50023', 'MN', 'US', cart.Id, cc_imp_testUtils.TEST_NEXEO3D_STOREFRONT);
        Test.stopTest();

        System.assert(options != null);

        System.assertEquals(3, options.size());

        for (ccrz.cc_ctrl_hlpr_ShippingOption o : options) {
            if (o.serviceName == cc_3d_api_ShippingAndHandling.STANDARD_SHIPPING_OPTION_VALUE) {
                System.assertEquals(0, o.price);
            }
            else if (o.serviceName == cc_3d_api_ShippingAndHandling.TWODAY_SHIPPING_OPTION_VALUE) {
                System.assertEquals(5, o.price);
            }
            else if (o.serviceName == cc_3d_api_ShippingAndHandling.OVERNIGHT_SHIPPING_OPTION_VALUE) {
                System.assertEquals(6, o.price);
            }
            else {
                System.assert(false);
            }
        }
    }

    static testmethod void getShippingOptionsUSZipFullTest() {

        ccrz__E_Cart__c cart = [SELECT Id FROM ccrz__E_Cart__c WHERE ccrz__ActiveCart__c = true];

        List<ccrz.cc_ctrl_hlpr_ShippingOption> options = null;

        Test.startTest();
        ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_NEXEO3D_STOREFRONT;

        cc_3d_api_ShippingAndHandling api = new cc_3d_api_ShippingAndHandling();

        options = api.getShippingOptions('90500', 'MN', 'US', cart.Id, cc_imp_testUtils.TEST_NEXEO3D_STOREFRONT);

        Test.stopTest();

        System.assert(options != null);

        System.assertEquals(3, options.size());
        for (ccrz.cc_ctrl_hlpr_ShippingOption o : options) {
            if (o.serviceName == cc_3d_api_ShippingAndHandling.STANDARD_SHIPPING_OPTION_VALUE) {
                System.assertEquals(0, o.price);
            }
            else if (o.serviceName == cc_3d_api_ShippingAndHandling.TWODAY_SHIPPING_OPTION_VALUE) {
                System.assertEquals(9, o.price);
            }
            else if (o.serviceName == cc_3d_api_ShippingAndHandling.OVERNIGHT_SHIPPING_OPTION_VALUE) {
                System.assertEquals(10, o.price);
            }
            else {
                System.assert(false);
            }
        }
    }

    static testmethod void getShippingOptionsUSHITest() {

        ccrz__E_Cart__c cart = [SELECT Id FROM ccrz__E_Cart__c WHERE ccrz__ActiveCart__c = true];

        List<ccrz.cc_ctrl_hlpr_ShippingOption> options = null;

        Test.startTest();

        ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_NEXEO3D_STOREFRONT;

        cc_3d_api_ShippingAndHandling api = new cc_3d_api_ShippingAndHandling();

        options = api.getShippingOptions('90500', 'HI', 'US', cart.Id, cc_imp_testUtils.TEST_NEXEO3D_STOREFRONT);

        Test.stopTest();

        System.assert(options != null);

        System.assertEquals(3, options.size());

        for (ccrz.cc_ctrl_hlpr_ShippingOption o : options) {
            if (o.serviceName == cc_3d_api_ShippingAndHandling.STANDARD_SHIPPING_OPTION_VALUE) {
                System.assertEquals(20, o.price);
            }
            else if (o.serviceName == cc_3d_api_ShippingAndHandling.TWODAY_SHIPPING_OPTION_VALUE) {
                System.assertEquals(9, o.price);
            }
            else if (o.serviceName == cc_3d_api_ShippingAndHandling.OVERNIGHT_SHIPPING_OPTION_VALUE) {
                System.assertEquals(10, o.price);
            }
            else {
                System.assert(false);
            }
        }
    }

    static testmethod void getShippingOptionsUSAKTest() 
    {

        ccrz__E_Cart__c cart = [SELECT Id FROM ccrz__E_Cart__c WHERE ccrz__ActiveCart__c = true];

        List<ccrz.cc_ctrl_hlpr_ShippingOption> options = null;

        Test.startTest();

        ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_NEXEO3D_STOREFRONT;

        cc_3d_api_ShippingAndHandling api = new cc_3d_api_ShippingAndHandling();

        options = api.getShippingOptions('90500', 'AK', 'US', cart.Id, cc_imp_testUtils.TEST_NEXEO3D_STOREFRONT);

        Test.stopTest();

        System.assert(options != null);

        System.assertEquals(3, options.size());

        for (ccrz.cc_ctrl_hlpr_ShippingOption o : options) {
            if (o.serviceName == cc_3d_api_ShippingAndHandling.STANDARD_SHIPPING_OPTION_VALUE) {
                System.assertEquals(10, o.price);
            }
            else if (o.serviceName == cc_3d_api_ShippingAndHandling.TWODAY_SHIPPING_OPTION_VALUE) {
                System.assertEquals(9, o.price);
            }
            else if (o.serviceName == cc_3d_api_ShippingAndHandling.OVERNIGHT_SHIPPING_OPTION_VALUE) {
                System.assertEquals(10, o.price);
            }
            else {
                System.assert(false);
            }
        }
    }

    static testmethod void getShippingOptionsUSZoneTest() {
        cc_3d_Zone_Shipping_Rule__c rule = new cc_3d_Zone_Shipping_Rule__c(Shipping_Option__c='2-Day', Weight__c=1, Zone_2_Cost__c=2, Zone_3_Cost__c=3, Zone_4_Cost__c=4, Zone_5_Cost__c=5, Zone_6_Cost__c=6, Zone_7_Cost__c=7, Zone_8_Cost__c=8, Zone_9_Cost__c=9, Zone_10_Cost__c=10, Zone_11_Cost__c=11, Zone_12_Cost__c=12, Zone_13_Cost__c=13, Zone_14_Cost__c=14, Zone_15_Cost__c=15, Zone_16_Cost__c=16);
        ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_NEXEO3D_STOREFRONT;
        cc_3d_api_ShippingAndHandling api = new cc_3d_api_ShippingAndHandling();
        System.assertEquals(2, api.getCostForZone(2, rule));
        System.assertEquals(3, api.getCostForZone(3, rule));
        System.assertEquals(4, api.getCostForZone(4, rule));
        System.assertEquals(5, api.getCostForZone(5, rule));
        System.assertEquals(6, api.getCostForZone(6, rule));
        System.assertEquals(7, api.getCostForZone(7, rule));
        System.assertEquals(8, api.getCostForZone(8, rule));
        System.assertEquals(9, api.getCostForZone(9, rule));
        System.assertEquals(10, api.getCostForZone(10, rule));
        System.assertEquals(11, api.getCostForZone(11, rule));
        System.assertEquals(12, api.getCostForZone(12, rule));
        System.assertEquals(13, api.getCostForZone(13, rule));
        System.assertEquals(14, api.getCostForZone(14, rule));
        System.assertEquals(15, api.getCostForZone(15, rule));
        System.assertEquals(16, api.getCostForZone(16, rule));

    }

    static testmethod void getShippingOptionsPRTest() {

        ccrz__E_Cart__c cart = [SELECT Id FROM ccrz__E_Cart__c WHERE ccrz__ActiveCart__c = true];

        List<ccrz.cc_ctrl_hlpr_ShippingOption> options = null;

        Test.startTest();
        ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_NEXEO3D_STOREFRONT;

        cc_3d_api_ShippingAndHandling api = new cc_3d_api_ShippingAndHandling();

        options = api.getShippingOptions('90500', '', 'PR', cart.Id, cc_imp_testUtils.TEST_NEXEO3D_STOREFRONT);
        
        Test.stopTest();

        System.assert(options != null);

        System.assertEquals(3, options.size());

        for (ccrz.cc_ctrl_hlpr_ShippingOption o : options) 
        {
            if (o.serviceName == cc_3d_api_ShippingAndHandling.STANDARD_SHIPPING_OPTION_VALUE) {
                System.assertEquals(30, o.price);
            }
            else if (o.serviceName == cc_3d_api_ShippingAndHandling.TWODAY_SHIPPING_OPTION_VALUE) {
                System.assertEquals(9, o.price);
            }
            else if (o.serviceName == cc_3d_api_ShippingAndHandling.OVERNIGHT_SHIPPING_OPTION_VALUE) {
                System.assertEquals(10, o.price);
            }
            else {
                System.assert(false);
            }
        }
    }

}