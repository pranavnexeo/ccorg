@isTest
private class cc_imp_mn_ctrl_OrderViewTest 
{
	
	 @isTest static void fetchMSDS() 
	{
		cc_imp_StorefrontSettings__c myNexeoCustomSetting = cc_imp_testUtils.createMyNexeoCustomSetting();

	   insert myNexeoCustomSetting ;

	   Map <String, String> headerMap = new Map<String, String> ();
	   headerMap.put('Content-Type','application/json');

       Test.setMock(HttpCalloutMock.class, new cc_imp_mn_FetchMSDSMock_HttpResponse(200,'success',mockResponse(), headerMap));

	   cc_imp_testUtils.clearContext();
	   
	   ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_MYNEXEO_STOREFRONT;

	   String materialId = '123454646446';

       ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();

	   Test.startTest();
	   ccrz.cc_RemoteActionResult res  = cc_imp_mn_ctrl_OrderView.fetchMSDS(ctx,materialId);

	   System.assert(res != null);
	   System.assert(res.data != null);

	   Test.stopTest();
	}
	

	  private static String mockResponse()
      {
     	return '{\"document\": \"643774\"}';
      }
	
    static testmethod void controllerTest() {
        insert cc_imp_testUtils.createNexeoCustomSettingList();

        Map<String, SObject> m = cc_imp_testUtils.initData();
        ccrz__E_Product__c product = (ccrz__E_Product__c) m.get('product');
        product.NexeoMaterialId__c = 'materialId000';
        product.Product_Number__c = '00000011';
        update product;

        ccrz__E_Order__c theOrder = cc_imp_testUtils.createOrder(m.get('cart').Id, m.get('userAccount').Id, m.get('userContact').Id, m.get('portalUser').Id, null, null);
        insert theOrder;
        ccrz__E_TransactionPayment__c thePayment= new ccrz__E_TransactionPayment__c(
        ccrz__AccountNumber__c='123',
        ccrz__CCOrder__c=theOrder.Id        
        );
        insert thePayment;
       		
        ccrz__E_OrderItem__c oi = new ccrz__E_OrderItem__c(
            ccrz__Order__c = theOrder.Id,
            ccrz__Product__c = product.Id,
            ccrz__Price__c = 1.00,
            ccrz__Quantity__c = 1,
            ccrz__SubAmount__c = 1.00
        );
        insert oi;

        theOrder = [SELECT Id, ccrz__EncryptedId__c FROM ccrz__E_Order__c WHERE Id = :theOrder.Id];

        cc_imp_mn_ctrl_OrderView controller = null;
        System.currentPageReference().getParameters().put('o', theOrder.ccrz__EncryptedId__c);
        ccrz.cc_CallContext.effAccountGroup = ccrz.cc_CallContext.currAccountGroup;

        Test.startTest();
        controller = new cc_imp_mn_ctrl_OrderView();
        Test.stopTest();

        System.assert(controller != null);
        System.assert(controller.extendedOrderJSON != null);
        System.assertEquals(true, controller.updateSequence);

    }

    static testmethod void updateSequenceTest() {
        insert cc_imp_testUtils.createNexeoCustomSettingList();

        Map<String, SObject> m = cc_imp_testUtils.initData();
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
        Map<String, cc_imp_mn_ctrl_OrderView.ExtendedOrderItem> data = new Map<String, cc_imp_mn_ctrl_OrderView.ExtendedOrderItem>();
        cc_imp_mn_ctrl_OrderView.ExtendedOrderItem item = new cc_imp_mn_ctrl_OrderView.ExtendedOrderItem();
        item.sequenceNumber = 100;        
        data.put(oi.Id, item);
        cc_imp_mn_ctrl_OrderView.updateSequence(data);
        Test.stopTest();

        ccrz__E_OrderItem__c uoi = [SELECT Id, cc_imp_Sequence__c FROM ccrz__E_OrderItem__c WHERE Id = :oi.Id];

        System.assertEquals(100, uoi.cc_imp_Sequence__c);

    }

    static testmethod void fetchCofATest() {
        cc_imp_StorefrontSettings__c myNexeoCustomSetting = cc_imp_testUtils.createMyNexeoCustomSetting();
        insert myNexeoCustomSetting ;

        Map <String, String> headerMap = new Map<String, String> ();
        headerMap.put('Content-Type','application/json');
        String response = '[{\"material\":\"16106053\",\"batch_number\":\"1234567890\",\"document\":\"XXXXX\",\"status\":[{\"type\":\"S\",\"message\":\"success\"}]}]';

        Test.setMock(HttpCalloutMock.class, new cc_imp_mn_FetchMSDSMock_HttpResponse(200,'success', response, headerMap));

        cc_imp_testUtils.clearContext();
       
        ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_MYNEXEO_STOREFRONT;

        String materialId = '123454646446';
        String batchNumber = '123456';

        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();

        ccrz.cc_RemoteActionResult res = null;

        Test.startTest();
        res  = cc_imp_mn_ctrl_OrderView.fetchCofA(ctx, materialId, batchNumber);
        Test.stopTest();

        System.assert(res != null);
        System.assert(res.data != null);
        Map<String,Object> data = (Map<String,Object>) res.data;
        System.assert((Boolean) data.get('success'));

    }

    static testmethod void fetchCofAFailTest() {
        cc_imp_StorefrontSettings__c myNexeoCustomSetting = cc_imp_testUtils.createMyNexeoCustomSetting();
        insert myNexeoCustomSetting ;

        Map <String, String> headerMap = new Map<String, String> ();
        headerMap.put('Content-Type','application/json');
        String response = '{\"material\":\"16106053\",\"batch_number\":\"1234567890\",\"document\":\"XXXXX\",\"status\":[{\"type\":\"S\",\"message\":\"success\"}]}';

        Test.setMock(HttpCalloutMock.class, new cc_imp_mn_FetchMSDSMock_HttpResponse(200,'success', response, headerMap));

        cc_imp_testUtils.clearContext();
       
        ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_MYNEXEO_STOREFRONT;

        String materialId = '123454646446';
        String batchNumber = '123456';

        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();

        ccrz.cc_RemoteActionResult res = null;

        Test.startTest();
        res  = cc_imp_mn_ctrl_OrderView.fetchCofA(ctx, materialId, batchNumber);
        Test.stopTest();

        System.assert(res != null);
        System.assert(res.data != null);
        Map<String,Object> data = (Map<String,Object>) res.data;
        System.assert(!(Boolean) data.get('success'));

    }
    static testmethod void fetchCofAAttachmentTest() {
        cc_imp_StorefrontSettings__c myNexeoCustomSetting = cc_imp_testUtils.createMyNexeoCustomSetting();
        insert myNexeoCustomSetting ;

        Map<String, SObject> m = cc_imp_testUtils.initData();
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

        Map <String, String> headerMap = new Map<String, String> ();
        headerMap.put('Content-Type','application/json');
        String response = '[{\"material\":\"16106053\",\"batch_number\":\"1234567890\",\"document\":\"XXXXX\",\"status\":[{\"type\":\"S\",\"message\":\"success\"}]}]';

        Test.setMock(HttpCalloutMock.class, new cc_imp_mn_FetchMSDSMock_HttpResponse(200,'success', response, headerMap));

        cc_imp_testUtils.clearContext();
       
        ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_MYNEXEO_STOREFRONT;

        String materialId = '123454646446';
        String batchNumber = '123456';

        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();

        ccrz.cc_RemoteActionResult res = null;

        Test.startTest();
        res  = cc_imp_mn_ctrl_OrderView.fetchCofAAttachment(ctx, materialId, batchNumber, oi.Id);
        Test.stopTest();

        System.assert(res != null);
        System.assert(res.data != null);
        Map<String,Object> data = (Map<String,Object>) res.data;
        System.assert((Boolean) data.get('success'));

    }

}