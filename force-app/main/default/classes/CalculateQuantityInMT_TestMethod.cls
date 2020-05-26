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
private class CalculateQuantityInMT_TestMethod {

    static testMethod void myUnitTest() {
    
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
        // TO DO: implement unit test
        //Creating test Aqualon Account
        Account test_Aqualon_Acc = new Account();
        test_Aqualon_Acc.Name = 'Test Account';
        //test_Aqualon_Acc.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Aqualon Account', 'Account');
        test_Aqualon_Acc.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Customer', 'Account');
        insert test_Aqualon_Acc;
        
        //Creating test Aqualon Opportunity EMEA
        Opportunity test_Aqualon_Opp_EMEA = new Opportunity ();
        test_Aqualon_Opp_EMEA.Name = 'Test Opportunity';
        test_Aqualon_Opp_EMEA.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Aqualon Opportunity - EMEA', 'Opportunity');
        test_Aqualon_Opp_EMEA.AccountId = test_Aqualon_Acc.Id;
        test_Aqualon_Opp_EMEA.Region__c = 'LAT';
        test_Aqualon_Opp_EMEA.Annualized_Gross_Profit_GP__c = 1000;
        test_Aqualon_Opp_EMEA.CloseDate = System.today() + 150;
        test_Aqualon_Opp_EMEA.StageName = 'Need Analysis - AQ';
        test_Aqualon_Opp_EMEA.Probability = 50;
        test_Aqualon_Opp_EMEA.Corporate_Bid__c = 'Yes'; 
        
        insert test_Aqualon_Opp_EMEA;
                
        //Creating test Product
        Product2 test_Prod = new Product2();
        test_Prod.Name = 'Test Product';
        test_Prod.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Aqualon Product', 'Product2');
        insert test_Prod;
        
        //Querying Standard Pricebook
        Pricebook2 test_Pricebook = [Select Id from Pricebook2 where IsStandard = True AND IsActive = True];
        
        //Creating test PricebookEntry
        PricebookEntry test_Pricebook_Entry = new PricebookEntry();
        test_Pricebook_Entry.Product2Id = test_Prod.Id;
        test_Pricebook_Entry.Pricebook2Id = test_Pricebook.Id;
        test_Pricebook_Entry.UnitPrice = 10;
        test_Pricebook_Entry.UseStandardPrice = False;
        test_Pricebook_Entry.IsActive = True;
        insert test_Pricebook_Entry;
        
        //Creating test OpportunityLineItem
        OpportunityLineItem test_Opp_Line_Item_EMEA = new OpportunityLineItem();
        test_Opp_Line_Item_EMEA.OpportunityId = test_Aqualon_Opp_EMEA.Id;
        test_Opp_Line_Item_EMEA.PricebookEntryId = test_Pricebook_Entry.Id;
        test_Opp_Line_Item_EMEA.UnitPrice = 15;
        test_Opp_Line_Item_EMEA.Quantity = 10000;
        insert test_Opp_Line_Item_EMEA;
                
        //Updating Opportunity RecordType to Aqualon NA
        test_Aqualon_Opp_EMEA.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Aqualon Opportunity - NA', 'Opportunity');
        update test_Aqualon_Opp_EMEA;
                      
    }
}