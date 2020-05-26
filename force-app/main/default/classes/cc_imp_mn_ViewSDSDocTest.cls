@isTest
public class cc_imp_mn_ViewSDSDocTest {
    
    @isTest static void ValidateViewSDSDoc()
    {
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        Account ac = new account(name='test');
        insert ac;
        ApexPages.currentPage().getParameters().put('materialId', '23');
        ApexPages.currentPage().getParameters().put('StrDocType', 'SDS');
        ApexPages.currentPage().getParameters().put('sfid', ac.id);
        
        cc_imp_mn_ViewSDSDoc obj = new cc_imp_mn_ViewSDSDoc();
        obj.ViewSDSDoc();
    }
    @isTest static void ValidateViewCOADoc()
    {
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        Account ac = new account(name='test');
        insert ac;
        ApexPages.currentPage().getParameters().put('materialId', '23');
        ApexPages.currentPage().getParameters().put('batchNumber', '324324');
        ApexPages.currentPage().getParameters().put('StrDocType', 'COA');
        ApexPages.currentPage().getParameters().put('sfid', ac.id);
        
        cc_imp_mn_ViewSDSDoc obj = new cc_imp_mn_ViewSDSDoc();
        obj.ViewSDSDoc();
        
        obj.InsertAttachment('a',ac.id,'afdsfdf');
    }
    @isTest static void ValidateViewInvoiceDoc()
    {
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        Account ac = new account(name='test');
        insert ac;
        ApexPages.currentPage().getParameters().put('invoiceID', '23');
        ApexPages.currentPage().getParameters().put('StrDocType', 'invoice');
        ApexPages.currentPage().getParameters().put('sfid', ac.id);
        
        cc_imp_mn_ViewSDSDoc obj = new cc_imp_mn_ViewSDSDoc();
        obj.ViewSDSDoc();
    }
}