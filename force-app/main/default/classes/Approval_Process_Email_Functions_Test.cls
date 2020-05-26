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
private class Approval_Process_Email_Functions_Test {

  static testMethod void myUnitTest() {
        Test.startTest();
        //User u=new user();
        //insert u;
        Profile profile = [select id from profile where name='System Administrator'];
        User u1 = new User(alias = 'standt', email='standarduser@testorg.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = profile.Id, 
            timezonesidkey='America/Los_Angeles', username='supplierMain@testorg.com');
            insert u1;
           
        
        Approval_Process_Email_Notification__c APEN = new Approval_Process_Email_Notification__c();
        List<Approval_Process_Email_Notification__c> APENs = new List<Approval_Process_Email_Notification__c>();
        Approval_Process_Email_Notification__c apn=new Approval_Process_Email_Notification__c(key__c='Abhishek Mirajkar',email__c='standarduser@testorg.com',email_List__c='test',user__c=u1.id);
        insert apn;
        APENs.add(apn);
        system.debug('---APENs---'+APENs.size());
        String body = 'The Key\n\nThe Body';
        String subject = 'Abhishek Mirajkar\n';
        String fromAddress = 'mjrumschlag@ashland.com';
        String fromName = 'Matthew Rumschlag';
        
       
       
        
        Approval_Process_Email_Functions.sendnotification(body, subject, fromAddress, fromName);
        
        String body1 = 'The Key\n\nThe Body';
        String subject1 = '[Key: Abhishek Mirajkar]';
        String fromAddress1 = 'mjrumschlag@ashland.com';
        String fromName1 = 'Matthew Rumschlag';
        
        
        Approval_Process_Email_Functions.sendhtmlnotification(body1, subject1, fromAddress1, fromName1);
       
       
  }      
}