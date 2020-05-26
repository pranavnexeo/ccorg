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
private class Public_Group_Functions_Test {

static testMethod void myUnitTest() {
        Test.startTest();
        
    Id GroupId = Public_Group_Functions.LookupPublicGroupId('Sample Request Admin Group');
    Id QueueId = Public_Group_Functions.LookupQueueId([SELECT Name FROM Group WHERE Type='Queue' LIMIT 1].Name);
    
   
    
    Id newId = Public_Group_Functions.AddUsertoGroup([SELECT Id FROM User WHERE IsActive=true and ProfileId NOT IN ('00eE0000000ISda','00eE0000000ISdf') LIMIT 1].Id,GroupId);
    Public_Group_Functions.RemoveUserfromGroup([SELECT Id FROM User WHERE IsActive=true and ProfileId NOT IN ('00eE0000000ISda','00eE0000000ISdf') LIMIT 1].Id,GroupId);//AVOIDING CUSTOMER PORTAL USERS.
    Boolean check = Public_Group_Functions.UserExistsinGroup([SELECT Id FROM User WHERE IsActive=true and ProfileId NOT IN ('00eE0000000ISda','00eE0000000ISdf') LIMIT 1].Id,GroupId);
    
    Map<String,Id> abcTest = Public_Group_Functions.CreateSampleRequestQueueGroup('ABC');
    System.debug('abcTest=' + abcTest);
    
    Group g = new Group();
    g.Type = 'Regular';
    g.Name = 'ABCD';
    insert g;
    
    SalesAreaPublicGroups__c sapg = new SalesAreaPublicGroups__c();
    sapg.Name = '000000';
    sapg.PublicGroups__c = 'ABCD\r\nEFGH\r\nIJKL';
    insert sapg;
    Public_Group_Functions.getSalesAreaPublicGroupIds();
  }

}