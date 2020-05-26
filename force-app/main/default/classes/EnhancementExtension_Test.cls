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
private class EnhancementExtension_Test {

    static Enhancement__c en1;
    static Enhancement__c en2;
    static Enhancement__c en3;
    static EnhancementExtension ext;
    static EnhancementExtension ext2;
    static EnhancementExtension ext3;
     
    static void init(){
    
      List<Enhancement__c> enh = new List<Enhancement__c>();
      en1 = new Enhancement__c(
      Name = 'test1',
      Project_Status__c = 'Open'

      );
      
      en2 = new Enhancement__c(
      Name = 'test2',
      Project_Status__c = 'Confirmed',
      Requirements_Garthered__c = true,
      Functional_Design__c = true
      );
      
      en3 = new Enhancement__c(
      Name = 'test3',
      Project_Status__c = 'Confirmed',
      Requirements_Garthered__c = false,
      Functional_Design__c = false
      );
      
      enh.add(en1);
      enh.add(en2);
      enh.add(en3);
      
      insert enh;
    }
    
    static testMethod void myUnitTest() {
    
    init();
    Test.setCurrentPage(Page.New_Enhancement);
    ApexPages.StandardController con = new ApexPages.StandardController(en1);
    
    ext = new EnhancementExtension(con);
    
    ApexPages.StandardController con1 = new ApexPages.StandardController(en2);
    ext2 = new EnhancementExtension(con1);
    
    ApexPages.StandardController con2 = new ApexPages.StandardController(en3);
    ext3 = new EnhancementExtension(con2);
    }
    
    static testMethod void myUnitTest1(){
        myUnitTest();
        Test.startTest();
        ext.enablingcheckbox2();
        ext2.enablingcheckbox2();
        Test.stopTest();
    }


}