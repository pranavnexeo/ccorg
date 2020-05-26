@IsTest
public class cc_imp_mn_AttachmentCleanupTest {
    static testmethod void cleanupTest() {
        

        Map<String, SObject> m = cc_imp_testUtils.initData();
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        system.runas(nexeoIntegrationUser)
        {
            cc_imp_StorefrontSettings__c myNexeoCustomSetting = cc_imp_testUtils.createMyNexeoCustomSetting();
        insert myNexeoCustomSetting;
        ccrz__E_Product__c product = (ccrz__E_Product__c) m.get('product');

        Attachment attach1 = new Attachment(Name = 'test.pdf', Description = cc_imp_mn_AttachmentCleanup.ATTACHMENT_DESCRIPTION, body = Blob.valueOf('Test'), ParentId = product.Id);
		Attachment attach2 = new Attachment(Name = 'test.pdf', Description = cc_imp_mn_AttachmentCleanup.ATTACHMENT_DESCRIPTION, body = Blob.valueOf('Test'), ParentId = product.Id);
        insert new List<Attachment>{attach1, attach2};

        Test.StartTest();
        //cc_imp_mn_AttachmentCleanup.enqueueJob();
        //Database.executeBatch(new cc_imp_mn_AttachmentCleanup());
        cc_imp_mn_AttachmentCleanup.cleanup();
        Test.StopTest();

        List<Attachment> attachments = [SELECT Id FROM Attachment WHERE Description = :cc_imp_mn_AttachmentCleanup.ATTACHMENT_DESCRIPTION];
        System.assertEquals(2, attachments.size());
        }
	}
}