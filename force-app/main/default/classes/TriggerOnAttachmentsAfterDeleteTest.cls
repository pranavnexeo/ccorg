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
private class TriggerOnAttachmentsAfterDeleteTest {

    static testMethod void myUnitTest() {
    
        Profile p = [SELECT Id FROM Profile WHERE Name='Integration User'];
    
    
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorgAD.com');
        System.runAs(u) {
            Material_Sales_Data2__c msd2=new Material_Sales_Data2__c(Attachment_Exist__c=true,Material_Number__c='782222',Dist_Channel_Code__c='31',Record_Key__c='Recordkey01',Sales_Org_Code__c='1000');
            insert msd2;
                    
              
             Blob attachBody = Blob.valueOf('attachment body');
             Attachment attach = new Attachment(Name = 'TestAttachment', ParentId = msd2.Id, Body = attachBody);
             insert attach;
             Boolean errorThrown = false;
             try {
                  delete attach;
             } catch (Exception e) {
                   System.debug(e);
                   errorThrown = true;
             }
             System.assert(!errorThrown);
         }
    }
}