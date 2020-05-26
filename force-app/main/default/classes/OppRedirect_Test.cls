/**
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class OppRedirect_Test {

    static Account acc;
    static Opportunity opp;
    static Opportunity opp1;
    static Opportunity opp2;
    static Opportunity opp3;
    static Opportunity opp4;
    
    static testMethod void myUnitTest() {
   		Map<String, SObject> testData = NexeoTestUtils_Test.initData();
        Test.startTest();
        List<Opportunity> Opps = new list<Opportunity>();
        Map<String, Schema.RecordTypeInfo> RTMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName(); 
        acc = new Account(Name='TestAcc');
        insert acc;
        contact c = new contact(Accountid = acc.id, firstname = 'Me', lastname = 'Myself', phone = '999-999-9999', buying_role__c='Designer', Role__c='Manager', No_Email__c = True);
        insert c;

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
        opps.add(opp1);
        
        opp2 = new Opportunity();
        opp2.Customer_Prospect__c = acc.id;
        opp2.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Targets','Opportunity');
        opp2.Name = 'Test Opp';
        opp2.CloseDate=system.today();
        opp2.StageName = '1. Prospect';
        opp2.Type = 'New Business';
        opp2.Contact__c= c.id; 
        opps.add(Opp2);
        
        opp3 = new Opportunity();
        opp3.Customer_Prospect__c = acc.id;
        opp3.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Environmental Services','Opportunity');
        opp3.Name = 'Test Opp';
        opp3.CloseDate=system.today();
        opp3.StageName = '1. Prospect';
        opp3.Type = 'New Business';
        opp3.Contact__c= c.id;
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
        
        
        apexpages.currentpage().getparameters().put('id',opp.id);
        apexpages.currentpage().getparameters().put('RecordType',opp.RecordTypeId);
        
        ApexPages.standardcontroller sc = new ApexPages.standardcontroller(opp);
        OppRedirect_New CR = new OppRedirect_New(sc);
              
        pagereference p = cr.redirect();
        p = cr.redirectClone();
        p = cr.redirectedit();
        p = cr.redirectview();
        
        
        apexpages.currentpage().getparameters().put('id',opp1.id);
        apexpages.currentpage().getparameters().put('RecordType',opp1.RecordTypeId);
        ApexPages.standardcontroller sc1 = new ApexPages.standardcontroller(opp1);
        OppRedirect_New CR1 = new OppRedirect_New(sc1);
              
        pagereference p1 = cr1.redirect();
        p1 = cr1.redirectClone();
        p1 = cr1.redirectedit();
        p1 = cr1.redirectview();
        

        
        apexpages.currentpage().getparameters().put('id',opp2.id);
        apexpages.currentpage().getparameters().put('RecordType',opp2.RecordTypeId);
        ApexPages.standardcontroller sc2 = new ApexPages.standardcontroller(opp2);
        OppRedirect_New CR2 = new OppRedirect_New(sc2);
              
        pagereference p2 = cr2.redirect();
        p2 = cr2.redirectClone();
        p2 = cr2.redirectedit();
        p2 = cr2.redirectview();
        
        
        apexpages.currentpage().getparameters().put('id',opp4.Id);
        apexpages.currentpage().getparameters().put('RecordType',opp4.RecordTypeId);
        ApexPages.standardcontroller sc4 = new ApexPages.standardcontroller(opp4);
        OppRedirect_New CR4 = new OppRedirect_New(sc4);
              
        pagereference p4 = cr4.redirect();
        p4 = cr4.redirectClone();
        p4 = cr4.redirectedit();
        p4 = cr4.redirectview();
        
       
        
        apexpages.currentpage().getparameters().put('id',opp3.id);
        apexpages.currentpage().getparameters().put('RecordType',opp3.RecordTypeId);
        ApexPages.standardcontroller sc3 = new ApexPages.standardcontroller(opp3);
        OppRedirect_New CR3 = new OppRedirect_New(sc3);
              
        pagereference p3 = cr3.redirect();
        p3 = cr3.redirectClone();
        p3 = cr3.redirectedit();
        p3 = cr3.redirectview();
        try{
        update opp;
        }
        catch(exception e){}


    }   
    
    static testMethod void myUnitTest2() {
   		Map<String, SObject> testData = NexeoTestUtils_Test.initData();
        Test.startTest();
        List<Opportunity> Opps = new list<Opportunity>();
        Map<String, Schema.RecordTypeInfo> RTMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName(); 
        acc = new Account(Name='TestAcc');
        acc.Default_Opportunity_Campaign__c = 'Fakuma 2015';
        insert acc;
        contact c = new contact(Accountid = acc.id, firstname = 'Me', lastname = 'Myself', phone = '999-999-9999', buying_role__c='Designer', Role__c='Manager', No_Email__c = True);
        insert c;

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
        opps.add(opp1);
        
        opp2 = new Opportunity();
        opp2.Customer_Prospect__c = acc.id;
        opp2.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Targets','Opportunity');
        opp2.Name = 'Test Opp';
        opp2.CloseDate=system.today();
        opp2.StageName = '1. Prospect';
        opp2.Type = 'New Business';
        opp2.Contact__c= c.id; 
        opps.add(Opp2);
        
        opp3 = new Opportunity();
        opp3.Customer_Prospect__c = acc.id;
        opp3.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Environmental Services','Opportunity');
        opp3.Name = 'Test Opp';
        opp3.CloseDate=system.today();
        opp3.StageName = '1. Prospect';
        opp3.Type = 'New Business';
        opp3.Contact__c= c.id;
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
        
        
        apexpages.currentpage().getparameters().put('id',opp.id);
        apexpages.currentpage().getparameters().put('RecordType',opp.RecordTypeId);
        
        ApexPages.standardcontroller sc = new ApexPages.standardcontroller(opp);
        OppRedirect_New CR = new OppRedirect_New(sc);
              
        pagereference p = cr.redirect();
        p = cr.redirectClone();
        p = cr.redirectedit();
        p = cr.redirectview();
        
        
        apexpages.currentpage().getparameters().put('id',opp1.id);
        apexpages.currentpage().getparameters().put('RecordType',opp1.RecordTypeId);
        ApexPages.standardcontroller sc1 = new ApexPages.standardcontroller(opp1);
        OppRedirect_New CR1 = new OppRedirect_New(sc1);
              
        pagereference p1 = cr1.redirect();
        p1 = cr1.redirectClone();
        p1 = cr1.redirectedit();
        p1 = cr1.redirectview();
        

        
        apexpages.currentpage().getparameters().put('id',opp2.id);
        apexpages.currentpage().getparameters().put('RecordType',opp2.RecordTypeId);
        ApexPages.standardcontroller sc2 = new ApexPages.standardcontroller(opp2);
        OppRedirect_New CR2 = new OppRedirect_New(sc2);
              
        pagereference p2 = cr2.redirect();
        p2 = cr2.redirectClone();
        p2 = cr2.redirectedit();
        p2 = cr2.redirectview();
        
        
        apexpages.currentpage().getparameters().put('id',opp4.Id);
        apexpages.currentpage().getparameters().put('RecordType',opp4.RecordTypeId);
        ApexPages.standardcontroller sc4 = new ApexPages.standardcontroller(opp4);
        OppRedirect_New CR4 = new OppRedirect_New(sc4);
              
        pagereference p4 = cr4.redirect();
        p4 = cr4.redirectClone();
        p4 = cr4.redirectedit();
        p4 = cr4.redirectview();
        
       
        
        apexpages.currentpage().getparameters().put('id',opp3.id);
        apexpages.currentpage().getparameters().put('RecordType',opp3.RecordTypeId);
        ApexPages.standardcontroller sc3 = new ApexPages.standardcontroller(opp3);
        OppRedirect_New CR3 = new OppRedirect_New(sc3);
              
        pagereference p3 = cr3.redirect();
        p3 = cr3.redirectClone();
        p3 = cr3.redirectedit();
        p3 = cr3.redirectview();
        try{
        update opp;
        }
        catch(exception e){}


    }
     
   
}