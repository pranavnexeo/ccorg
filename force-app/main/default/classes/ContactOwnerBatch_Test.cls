@isTest

public class ContactOwnerBatch_Test{
    
    public static testMethod void testForCommodity(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true);
        insert u;
        
        SAP_Seller__c s = new SAP_Seller__c(Name = 'test', user__c = u.id);
        insert s; 
        
        SAP_Territory__c ST = new SAP_Territory__c(Name = 'test', ZS_Partner__c = s.id, YS_Partner__c = s.id);
        insert ST;
        
        Account acct = new Account
        (name='TestAccount',
        SAP_Vendor_Purchase_Org__c='1000',
        SAP_Supplier_Number__c='123456',
        VendorUniqueId__c='1234561000',
        Type='Vendor',
        SAP_Accounting_Group__c='ZVEN',
        SAP_PartnerFunctionCodeText__c='123456',
        SAP_PartnerFunctionText__c='ZA',
        YY_Partner__c = ST.id , 
        SAP_Customer_Group_2_Desc__c = 'Primary Commodity',
        AccountNumber='123');
        insert acct;
        
        List<contact> con = new list<Contact>();
        contact c = new Contact(firstName='john',lastName='smith',Email='user@acme.com',HasOptedOutOfEmail=true,Accountid = acct.id);                 
        con.add(c);
        insert con;
        
        String test1 = '';
        test.startTest();
        ContactOwnerBatch COB = new ContactOwnerBatch(test1);
        id idbatch = database.executebatch(COB);        
        COB.execute(null,con);
        test.stoptest();
    }
    
    public static testMethod void testForSpeciality(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true);
        insert u;
        
        SAP_Seller__c s = new SAP_Seller__c(Name = 'test', user__c = u.id);
        insert s; 
        
        SAP_Territory__c ST = new SAP_Territory__c(Name = 'test', ZS_Partner__c = s.id);
        insert ST;
        
        Account acct = new Account
        (name='TestAccount',
        SAP_Vendor_Purchase_Org__c='1000',
        SAP_Supplier_Number__c='123456',
        VendorUniqueId__c='1234561000',
        Type='Vendor',
        SAP_Accounting_Group__c='ZVEN',
        SAP_PartnerFunctionCodeText__c='123456',
        SAP_PartnerFunctionText__c='ZA',
        YZ_Partner__c = ST.id , 
        SAP_Customer_Group_2_Desc__c = 'Primary Specialty',
        AccountNumber='123');
        insert acct;
        
        List<contact> con = new list<Contact>();
        contact c = new Contact(firstName='john',lastName='smith',Email='user@acme.com',HasOptedOutOfEmail=true,Accountid = acct.id);                 
        con.add(c);
        insert con;
        
        String test1 = '';
        test.startTest();
        ContactOwnerBatch COB = new ContactOwnerBatch(test1);
        id idbatch = database.executebatch(COB);        
        COB.execute(null,con);
        test.stoptest();
    }
    
    public static testMethod void testForNull(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true);
        insert u;
        
        SAP_Seller__c s = new SAP_Seller__c(Name = 'test', user__c = u.id);
        insert s; 
        
        SAP_Territory__c ST = new SAP_Territory__c(Name = 'test', ZS_Partner__c = s.id);
        insert ST;
        
        Account acct = new Account
        (name='TestAccount',
        SAP_Vendor_Purchase_Org__c='1000',
        SAP_Supplier_Number__c='123456',
        VendorUniqueId__c='1234561000',
        Type='Vendor',
        SAP_Accounting_Group__c='ZVEN',
        SAP_PartnerFunctionCodeText__c='123456',
        SAP_PartnerFunctionText__c='ZA',
        YY_Partner__c = ST.id , 
        SAP_Customer_Group_2_Desc__c = '',
        AccountNumber='123');
        insert acct;
        
        List<contact> con = new list<Contact>();
        contact c = new Contact(firstName='john',lastName='smith',Email='user@acme.com',HasOptedOutOfEmail=true,Accountid = acct.id);                 
        con.add(c);
        insert con;
        
        String test1 = 'test';
        test.startTest();
        ContactOwnerBatch COB = new ContactOwnerBatch(test1);
        id idbatch = database.executebatch(COB);        
        COB.execute(null,con);
        test.stoptest();
    }
}