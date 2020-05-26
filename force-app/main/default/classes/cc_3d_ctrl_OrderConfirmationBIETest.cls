@isTest
private class cc_3d_ctrl_OrderConfirmationBIETest 
{
    static testmethod void controllerTest() {
        Map<String, SObject> m = cc_imp_testUtils.initData();
        userRole ur = [SELECT id from userrole  where developername= 'NEXEOSOLUTIONSORG' limit 1];
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration',UserRoleId = ur.Id);
        insert nexeoIntegrationUser;
        system.runas(nexeoIntegrationUser)
        {
        insert cc_imp_testUtils.createNexeoCustomSettingList();

        

        ccrz__E_Product__c product = (ccrz__E_Product__c) m.get('product');
        product.NexeoMaterialId__c = 'materialId000';
        product.Product_Number__c = '00000011';
        update product;

        ccrz__E_Order__c theOrder = cc_imp_testUtils.createOrder(m.get('cart').Id, m.get('userAccount').Id, m.get('userContact').Id, m.get('portalUser').Id, null, null);
        insert theOrder;

        ccrz__E_OrderItem__c oi = new ccrz__E_OrderItem__c(
            ccrz__Order__c = theOrder.Id,
            ccrz__Product__c = product.Id,
            ccrz__Price__c = 1.00,
            ccrz__Quantity__c = 1,
            ccrz__SubAmount__c = 1.00
        );
        insert oi;

        theOrder = [SELECT Id, ccrz__EncryptedId__c FROM ccrz__E_Order__c WHERE Id = :theOrder.Id];

        // cc_imp_mn_ctrl_OrderView controller = null;
        cc_3d_ctrl_OrderConfirmationBIE controller = null;
        System.currentPageReference().getParameters().put('o', theOrder.ccrz__EncryptedId__c);
        ccrz.cc_CallContext.effAccountGroup = ccrz.cc_CallContext.currAccountGroup;

        Test.startTest();
        controller = new cc_3d_ctrl_OrderConfirmationBIE();
        Test.stopTest();

        System.assert(controller != null);
        System.assert(controller.extendedOrderJSON != null);
        System.assertEquals(true, controller.updateSequence);
        }

    }

    static testmethod void updateSequenceTest() {
        
        userRole ur = [SELECT id from userrole  where developername= 'NEXEOSOLUTIONSORG' limit 1];
        Map<String, SObject> m = cc_imp_testUtils.initData();
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123dfg002', FirstName = 'Nexeo_Integration',UserRoleId = ur.Id);
        insert nexeoIntegrationUser;
        system.runas(nexeoIntegrationUser)
        {
            insert cc_imp_testUtils.createNexeoCustomSettingList();
        ccrz__E_Product__c product = (ccrz__E_Product__c) m.get('product');
        product.NexeoMaterialId__c = 'materialId000';
        product.Product_Number__c = '00000011';
        update product;

        ccrz__E_Order__c theOrder = cc_imp_testUtils.createOrder(m.get('cart').Id, m.get('userAccount').Id, m.get('userContact').Id, m.get('portalUser').Id, null, null);
        insert theOrder;

        ccrz__E_OrderItem__c oi = new ccrz__E_OrderItem__c(
            ccrz__Order__c = theOrder.Id,
            ccrz__Product__c = product.Id,
            ccrz__Price__c = 1.00,
            ccrz__Quantity__c = 1,
            ccrz__SubAmount__c = 1.00
        );
        insert oi;

        Test.startTest();
        Map<String, cc_3d_ctrl_OrderConfirmationBIE.ExtendedOrderItem> data = new Map<String, cc_3d_ctrl_OrderConfirmationBIE.ExtendedOrderItem>();
        cc_3d_ctrl_OrderConfirmationBIE.ExtendedOrderItem item = new cc_3d_ctrl_OrderConfirmationBIE.ExtendedOrderItem();
        item.sequenceNumber = 100;
        data.put(oi.Id, item);
        cc_3d_ctrl_OrderConfirmationBIE.updateSequence(data);
        Test.stopTest();

        ccrz__E_OrderItem__c uoi = [SELECT Id, cc_imp_Sequence__c FROM ccrz__E_OrderItem__c WHERE Id = :oi.Id];

        System.assertEquals(100, uoi.cc_imp_Sequence__c);
        }
    }

}