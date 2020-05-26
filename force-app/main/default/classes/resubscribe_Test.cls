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
private class resubscribe_Test {

static testMethod void myUnitTest() {
Map<String, SObject> testData = NexeoTestUtils_Test.initData();    
Test.startTest();
List<Contact> lc = new List <contact>();
List<Lead> ll = new List <lead>();
// Create a new email and envelope object.
Messaging.InboundEmail email = new Messaging.InboundEmail() ;
Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

// Create a new test contact and insert it in the test method.
Contact c = new Contact(firstName='john',
Price_Letter_Delivery_Method__c = 'email',
lastName='smith',
Email='user@acme.com.co',
HasOptedOutOfEmail=true);
insert c;

// Create a new test lead and insert it in the test method.
Lead l = new lead(firstName='John',
lastName='Smith',
Company='Salesforce',
Email='user@acme.com.mx',
HasOptedOutOfEmail=true);
insert l;



lc.add(c);
ll.add(l);

// Test with the subject that matches the unsubscribe statement.
email.subject = 'test resubscribe test';
env.fromAddress = 'user@acme.com.es';

// Call the class and test it with the data in the testMethod.

resubscribe resubscribeObj = new resubscribe();
try{
resubscribeObj.handleInboundEmail(email, env );
}catch (Exception e) {
}
Test.stopTest();
      
}
        
// The following test methods provide adequate code coverage.
// There are two methods, one that does the testing
// with a valid "unsubcribe" in the subject line
// and one the does not contain "unsubscribe" in the
// subject line.


}