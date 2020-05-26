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
private class User_Functions_Test {

static testMethod void myUnitTest() {
        Test.startTest();
      
   String name = User_Functions.RetrieveUserName('00530000000kFvU');

    Id LookupUserId = User_Functions.LookupActiveUserbyFullName('Jon Keener');
    System.debug('Id = ' + LookupUserId);
    User_Functions.RetrieveUserName(LookupUserId);

    Id LookupUserId2 = User_Functions.LookupInactiveUserbyFullName('Jon Keener');
    System.debug('Id = ' + LookupUserId2);

    Id LookupUserId3 = User_Functions.LookupUserbyFullName('Jon Keener');
    System.debug('Id = ' + LookupUserId3);

    User_Functions.LookupActiveUsersbyFullName(new List<String>{'Jon Keener'});
    
    System.debug('getLoggedInUserEmail : '+User_Functions.getLoggedInUserEmail());
    
    System.debug('isSysAdmin : '+User_Functions.isSysAdmin()); 
    System.debug('isSupport : '+User_Functions.isSupport()); 

}



}