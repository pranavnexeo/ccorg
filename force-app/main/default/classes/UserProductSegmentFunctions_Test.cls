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
private class UserProductSegmentFunctions_Test {

    static String langcode = '!';
    static Id profileId = [Select Id from Profile where Name = 'Standard User'].Id;
    static String usrname1 = 'testuser1@testuser.testuser';
    static String usrname2 = 'testuser2@testuser.testuser';
    static String empnum1 = 'empnum1';
    static String empnum2 = 'empnum2';
    
    static User usr;
    static User_Product_Segment__c userProductSegment;
    
    static testMethod void test01() {
    	Test.startTest();
        createTestData();
        List<User_Product_Segment__c> alist;
        alist = UserProductSegmentFunctions.getUserProductSegments(usr.Id);
        System.debug(alist);
        createUser(usrname2, empnum2);
        alist = UserProductSegmentFunctions.getUserProductSegments(usr.Id);
        System.debug(alist);
        Test.stopTest();
    }
    
    static void createTestData() {
        createUser(usrname1, empnum1);
        createUserProductSegment();
    }

    static void createUser(String usrname, String empnum) {
        usr = new User();
        usr.Alias = 'tstusr';
        usr.Email = 'testuser@testuser.testuser';
        usr.EmailEncodingKey = 'ISO-8859-1';
        usr.LanguageLocaleKey = 'en_US';
        usr.LastName = 'testusr';
        usr.LocaleSidKey = 'en_US';
        usr.TimeZoneSidKey = 'America/New_York';
        usr.ProfileId = profileId;
        usr.Username = usrname;
        usr.Ashland_Employee_Number__c = empnum;
        insert usr;
    }   
     
    static void createUserProductSegment() {
        userProductSegment =  new User_Product_Segment__c();
        userProductSegment.User__c = usr.Id;
        userProductSegment.Product_Segment_Code__c = '016';
        insert userProductSegment;
        System.debug(userProductSegment);
    }
    
}