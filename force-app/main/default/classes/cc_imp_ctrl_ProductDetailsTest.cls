@isTest
private class cc_imp_ctrl_ProductDetailsTest {

    @isTest
    static void constructorTest() 
    {
       
        Map<String, SObject> m = cc_imp_testUtils.initData();
         Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhxvxcvdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A12xcvxcv3002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
          system.runAs(nexeoIntegrationUser)
        {
         insert cc_imp_testUtils.createNexeoCustomSettingList();    
        ccrz__E_Product__c product = (ccrz__E_Product__c) m.get('product');
        Test.setCurrentPageReference(new PageReference('Page.cc_imp_mn_ProductDetailsBIE'));
        System.currentPageReference().getParameters().put('sku', product.ccrz__SKU__c);
        ccrz.cc_CallContext.effAccountGroup = ccrz.cc_CallContext.currAccountGroup;
       
        cc_imp_ctrl_ProductDetails controller = null;

        Test.startTest();
        controller = new cc_imp_ctrl_ProductDetails();
        Test.stopTest();
        }
       // System.assert(controller != null);
        //System.assertEquals('Major', controller.productType);
        //System.assertEquals('Test123', controller.nexeoMaterialId);

    }
	
	@isTest static void fetchMSDSTest() 
	{
		
        Map<String, SObject> m = cc_imp_testUtils.initData();
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbh34sddc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A12435s3002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
          system.runAs(nexeoIntegrationUser)
        {
            cc_imp_StorefrontSettings__c myNexeoCustomSetting = cc_imp_testUtils.createMyNexeoCustomSetting();

	   insert myNexeoCustomSetting ;
        ccrz__E_Product__c product = (ccrz__E_Product__c) m.get('product');

	   Map <String, String> headerMap = new Map<String, String> ();
	   headerMap.put('Content-Type','application/json');

       Test.setMock(HttpCalloutMock.class, new cc_imp_mn_FetchMSDSMock_HttpResponse(200,'success',mockResponse(), headerMap));

	   cc_imp_testUtils.clearContext();

	   ccrz.cc_CallContext.storefront = cc_imp_testUtils.TEST_MYNEXEO_STOREFRONT;

	   String materialId = '123454646446';

       ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();

	   Test.startTest();
	   ccrz.cc_RemoteActionResult res  = cc_imp_ctrl_ProductDetails.fetchMSDS(ctx,materialId,product.Id);

	  // System.assert(res != null);
	   //System.assert(res.data != null);

	   Test.stopTest();
        }
	}
	

	  private static String mockResponse()
      {
     	return '{\"document\": \"643774\"}';
      }
    
}