@isTest
public class cc_imp_ctrl_FileUploadTest {

    static testmethod void uploadFileTest() {
       
		ccrz.cc_RemoteActionContext ctx;
        Map<String, SObject> m = cc_imp_testUtils.initData();
        
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdcio@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A12300dg2', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
          system.runAs(nexeoIntegrationUser)
        {
             insert cc_imp_testUtils.createNexeoCustomSettingList();
        ctx = new ccrz.cc_RemoteActionContext();
        ctx.storefront = 'mynexeo';

        ccrz.cc_RemoteActionResult result = null;
        }
        Test.startTest();
        System.runAs((User) m.get('portalUser')) {
            //result = cc_imp_ctrl_FileUpload.uploadFile(ctx, 'test.txt', 'TXT', 'TXT', 'Test text', 'Test comments');
        }
        Test.stopTest();
    }

    static testmethod void constructorTest() {
         Map<String, SObject> m = cc_imp_testUtils.initData();
        
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhcvbdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A12300cvb2', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
          system.runAs(nexeoIntegrationUser)
        {
             insert cc_imp_testUtils.createNexeoCustomSettingList();
        ccrz__E_Cart__c c = (ccrz__E_Cart__c) m.get('cart');
        ccrz__E_Cart__c theCart = [SELECT Id, ccrz__EncryptedId__c FROM ccrz__E_Cart__c WHERE Id = :c.Id];
        Test.setCurrentPageReference(new PageReference('Page.cc_imp_mn_CartIncBIE'));
        System.currentPageReference().getParameters().put('cartId', theCart.ccrz__EncryptedId__c);
        ccrz.cc_CallContext.effAccountGroup = ccrz.cc_CallContext.currAccountGroup;
       
        cc_imp_ctrl_FileUpload controller = null;

        Test.startTest();
        controller = new cc_imp_ctrl_FileUpload();
        Test.stopTest();

        System.assert(controller != null);
        System.assert(null != controller.extendedCheckoutCartJSON);
        }
    }

    /*
    static testmethod void uploadFileFailTest() {
        insert cc_imp_testUtils.createNexeoCustomSettingList();

        Map<String, SObject> m = cc_imp_testUtils.initData();
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        ctx.storefront = 'mynexeo';

        ccrz.cc_RemoteActionResult result = null;

        Test.startTest();
        result = cc_imp_ctrl_FileUpload.uploadFile(ctx, 'test.txt', 'TXT', 'TXT', 'Test text', 'Test comments');
        Test.stopTest();

        System.assert(result != null);
        System.assert(result.data != null);
        System.debug(result);
        Map<String, Object> data = (Map<String, Object>) result.data;
        System.assert(!(Boolean) data.get('success'));
    } */
}