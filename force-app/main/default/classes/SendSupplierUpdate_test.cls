@isTest

public class SendSupplierUpdate_test{

    public static testMethod void testMe(){
        Map<String, SObject> testData = NexeoTestUtils_Test.initData();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
        account acc = new account(name = 'test1234');
        insert acc;
        contact cnt = new contact(LastName = 'test',Account = acc,phone= '1234567890',Role__c = 'Accounting',No_Email__c = true);
        insert cnt;
         Id RtId = Schema.SObjectType.Nexeo_Competitor__c.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
       
        Nexeo_Competitor__c nc = new Nexeo_Competitor__c(name = 'test',Status__c='Active',recordtypeid=RtId);
        insert nc;
       Supplier_Contact__c scon = new Supplier_Contact__c(First_Name__c = 'test',Competitor_Supplier_or_OEM__c = nc.id);
        insert scon;
        
        Supplier_Page_Emails__c  spe = new Supplier_Page_Emails__c(name='test', email__c='aa@dd.com');
        insert spe;
       
        ApexPages.standardcontroller sc = new ApexPages.standardcontroller(nc);
        SendSupplierUpdate s = new SendSupplierUpdate(sc);
        SendSupplierUpdate.wrapperclass w = new SendSupplierUpdate.wrapperclass(spe);
        try{
        s.sendEmail();
        //s.getCreatedDocId();
        }
        catch (exception e){}
        }
    }