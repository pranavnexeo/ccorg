/**
 * Description: Updating unit test to create its own users
 * Date: 10 / 4 / 2017
 * Developer: Ignacio Gonzalez 
 * */
@isTest
private class Task_Functions_Test {

    static Map<String, Schema.RecordTypeInfo> AccRTMap = Account.sObjectType.getDescribe().getRecordTypeInfosByName();
    static Account a;
    static Task t;
    static User u;
    
    static void debug(String s) {
        System.debug(LoggingLevel.INFO, 'Task_Functions_Test : ' + s);
    }
    
    static void createTestData() {
        Map<String, SObject> testData = NexeoTestUtils_Test.initData();
        //Getting a profile for use with the test users
        Profile p = [SELECT Id FROM Profile WHERE Name='Inactive Users'];
        // In order to have a unique User Name accross all salesforce orgs
        String uniqueUserName = 'testuser1' + DateTime.now().getTime() + '@testorg.com';
        //Inserting a user that will be the manager of the user that we will use on this test
        User manager = new User(UserName = uniqueUserName, Email = 'testuser1@test.com', ProfileId = p.Id, LastName='Manager',
                                Alias = 'test1', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US',
                                LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles');
    	insert manager;
        uniqueUserName = 'testuser2' + DateTime.now().getTime() + '@testorg.com';
        //User to use across this test
    	u = new User(UserName = uniqueUserName, Email = 'testuser2@test.com', managerid = manager.Id, ProfileId = p.Id, LastName='Testing',
                    	Alias = 'test2', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US',
                        LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles');
        insert u;
        a = new Account(Name='Test Account', OwnerId=u.Id);
        a.RecordTypeId = AccRTMap.get('Distribution Customer').getrecordtypeid();
        insert a;
        
       
        t = new Task();
        t.WhatId = a.Id;
        t.development_group__c = 'Vinyl Ester Resins';
        t.ActivityDate = System.today();
        t.Notify_account_Owner__c = 'Yes';
        t.Manager_Alert__c = 'Yes';
        t.Subject = 'Test task';
        t.Description = 'Test task';
        insert t;

        t = [select id, accountid, account.ownerid, account.owner.email, 
                    account.recordtypeid, ActivityDate, 
                    description, development_group__c,
                    lastmodifiedby.email,
                    lastmodifiedby.firstname, 
                    lastmodifiedby.lastname, lastmodifiedbyid,
                    Manager_Alert__c, Notify_account_Owner__c, 
                    Owner.FirstName, Owner.LastName, Priority, Subject 
               from task where Id = :t.Id];
              
        debug('Account : ' + a + ' Task : ' + t);
    }
    
    static testMethod void myUnitTest() {
        Test.startTest();
        createTestData();
        List<String> emlist = new list<String>();
        emlist.add(t.account.owner.email);
        Map<Id, Task> tmap = new Map<Id, Task>();
        tmap.put(t.Id, t);
        List <Task> tlist=new List<Task>();
        tlist.add(t); 
        try {
            task_Functions.sendEmail(t, emlist);
        } catch(Exception e) {}

        try {
            task_Functions.sendEmailsToDevelopmentGroup(tmap, tmap);
        } catch(Exception e) {}

        try {
            task_Functions.createtaskandsendemails(u.id, a.id, 'subj', 'descn', a);
        } catch(Exception e) {}
        try{
            task_Functions.sendEmailsToAccountOwner(tlist);
        } catch(Exception e){}
            
    }
}