/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Chatter_Functions_Test {

    static Account acc;
    
    
    static testMethod void myUnitTest() {
    
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
        Test.startTest();

        acc = new Account(Name='TestAcc');
        insert acc;
        
        List<user> users = [select id from user where id = :userinfo.getuserid()];
        
        
        Chatter_Functions.createLinkPost(acc.id, 'Test', 'Test');
        Chatter_Functions.addfollow(acc.id);
        Chatter_Functions.removeallfollows(acc.id);
        Chatter_Functions.addfollow(acc.id, new list<string>{userinfo.getuserid()});
        Chatter_Functions.removesubscriber(acc.id);
        Chatter_Functions.addfollow(new list<Account>{acc});
        Chatter_Functions.removesubscriber(acc.id, users);
        Chatter_Functions.addfollow(acc.id);
        Chatter_Functions.removesubscriber(new list<Account>{acc});
        Chatter_Functions.updateuserstatus('My Status');
        Chatter_Functions.updateuserstatus('My New Status', users);
        Chatter_Functions.addfollow(acc.id);
        Chatter_Functions.createTextPost(acc.id, 'Test', 'Test');
        Chatter_Functions.createLinkPostFI(acc.id, 'Test', 'Test');
        Chatter_Functions.createTextPostFI(acc.id, 'Test', 'Test');

        Set<ID> followers = Chatter_Functions.getfollowers(acc.id); 
        list<AccountFeed> AccountFeed = Chatter_Functions.getAccountFeed(acc.id);
        list<NewsFeed> NewsFeed = Chatter_Functions.getMyNewsFeed();
        Chatter_Functions.createLinkPost(acc.id, 'Title', 'Body');
        
        
           
  
        
    }   
     
   
}