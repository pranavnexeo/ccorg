@isTest
private class Add_Primary_Contact_To_Contact_Role_Test {

static Account acc;
    static Opportunity opp;
    static Opportunity opp1;
    static Opportunity opp2;
    static Opportunity opp3;
    static Opportunity opp4;
    
    static testMethod void myUnitTest() {
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;

    Test.startTest();
        List<Opportunity> Opps = new list<Opportunity>();
        Map<String, Schema.RecordTypeInfo> RTMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName(); 
        acc = new Account(Name='TestAcc');
        insert acc;
        contact c = new contact(Accountid = acc.id, firstname = 'Me', lastname = 'Myself', phone = '999-999-9999', buying_role__c='Designer', Role__c='Manager', No_Email__c = True);
        insert c;     
       Contact con = new Contact(firstName='john',lastName='smith',Email='user@acme.com',HasOptedOutOfEmail=true,Accountid = acc.id);
              insert con;
        String profileId = [SELECT Id FROM Profile WHERE Name LIKE '%Inactive Users%' limit 1].Id;
        User ADEUser = new User(
             LastName = 'last',
             Email = 'test@test.com' + System.currentTimeMillis(),
             Username = 'test@test.com' + System.currentTimeMillis(),
             CompanyName = 'myNexeoTest',
             ProfileId = profileId,
             Title = 'title',
             Alias = 'alias',
             TimeZoneSidKey = 'America/Los_Angeles',
             EmailEncodingKey = 'UTF-8',
             LanguageLocaleKey = 'en_US',
             LocaleSidKey = 'en_US',
             ADE_Technical_Representative__c = true
        );
        
        insert ADEUser;
                  
        opp = new Opportunity();
        opp.Customer_Prospect__c = acc.id;
        opp.accountid = acc.id;
        opp.RecordTypeId = RTMap.get('Distribution Chemicals').getrecordtypeid();
        opp.Name = 'Test Opp';
        opp.CloseDate=system.today();
        opp.Award_Start_Date__c=null;
        opp.StageName = '1. Prospect';
        opp.Type = 'New Business';
        opp.Contact__c= c.id; 
        opp.ADE_Technical_Representative1__c = ADEUser.Id;
        //opp.contactid= c.id;
        opps.add(opp); 
        
        opp1 = new Opportunity();
        opp1.Customer_Prospect__c = acc.id;
        opp1.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Plastics','Opportunity');
        opp1.Name = 'Test Opp';
        opp1.CloseDate=system.today();
        opp1.Award_Start_Date__c=null;
        opp1.StageName = '1. Prospect';
        opp1.Type = 'New Business';
        opp1.Contact__c= c.id; 
        opp1.ADE_Technical_Representative1__c = ADEUser.Id;
        opps.add(opp1);
        
        opp2 = new Opportunity();
        opp2.Customer_Prospect__c = acc.id;
        opp2.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Targets','Opportunity');
        opp2.Name = 'Test Opp';
        opp2.CloseDate=system.today();
        opp2.StageName = '1. Prospect';
        opp2.Type = 'New Business';
        opp2.Contact__c= c.id;
        opp2.ADE_Technical_Representative1__c = ADEUser.Id;
        opps.add(Opp2);
        
        opp3 = new Opportunity();
        opp3.Customer_Prospect__c = acc.id;
        opp3.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Environmental Services','Opportunity');
        opp3.Name = 'Test Opp';
        opp3.CloseDate=system.today();
        opp3.StageName = '1. Prospect';
        opp3.Type = 'New Business';
        opp3.Contact__c= c.id;
        opp3.ADE_Technical_Representative1__c = ADEUser.Id;
        opps.add(Opp3); 
        
        opp4 = new Opportunity();
        opp4.Customer_Prospect__c = acc.id;
        opp4.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Plastics EMEA','Opportunity');
        opp4.Name = 'Test Opp1';
        opp4.CloseDate=system.today();
        opp4.Award_Start_Date__c=null;
        opp4.StageName = '1. Prospect';
        opp4.Type = 'New Business';
        opp4.Contact__c= c.id; 
        opp4.ADE_Technical_Representative1__c = ADEUser.Id;
        opps.add(opp4);
        
        insert opps;
opps[3].Contact__c= con.id; 
update opps;
        Test.stopTest();
}
}