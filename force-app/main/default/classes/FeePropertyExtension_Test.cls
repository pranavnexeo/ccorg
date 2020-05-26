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
private class FeePropertyExtension_Test {
    
    static Fee_Property__c feeProperty;
    //static Keywords__c keyword;
    static FeePropertyExtension ext;

    static void init(){
        
        feeProperty = new Fee_Property__c(State__c = 'Foreign Country-99',county__c='Foreign Country');
        insert feeproperty;
        /*keyword = new Keywords__c(type__c = 'County',controller__c='state',item__c='county');
        insert keyword;*/       
        
        //feeProperty = [select id,state__c,county__c,name from Fee_Property__c where state__c = 'Foreign Country-99'];
        
         
        ApexPages.StandardController con = new ApexPages.StandardController(feeProperty);
        ext = new FeePropertyExtension(con);
    
    }
    
    static testMethod void myUnitTest() {
        
        init();
        ext.getAllCounties();
        ext.getCrossReferenceList();
        ext.emptyFlag = true;
    }
    
}