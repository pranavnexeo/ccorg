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
private class Competitor_to_Account_Functions_Test {

static testMethod void myUnitTest() {
        Test.startTest();
      id ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        List<Account> accts = new List<Account>();
        
        Map<String, Id> AcctRecTypes = RecordType_Functions.RetrieveRecordTypeNameMap('Account');
        
        Account acct_AD_Chemicals = new Account(Name='AD_Chemicals',
                                                RecordTypeId=AcctRecTypes.get('Distribution Customer'),
                                                SAP_Division_Desc__c = 'Chemicals');accts.add(acct_AD_Chemicals);
        Account acct_AD_Composites = new Account(Name='AD_Composites',
                                                RecordTypeId=AcctRecTypes.get('Distribution Customer'),
                                                SAP_Division_Desc__c = 'Composites');accts.add(acct_AD_Composites);
        Account acct_AD_Plastics = new Account(Name='AD_Plastics',
                                                RecordTypeId=AcctRecTypes.get('Distribution Customer'),
                                                SAP_Division_Desc__c = 'Plastics');accts.add(acct_AD_Plastics);
        Account acct_AD_ES = new Account(Name='AD_ES',
                                                RecordTypeId=AcctRecTypes.get('Distribution Customer'),
                                                SAP_Division_Desc__c = 'Environmental Svcs');accts.add(acct_AD_ES);
      /*
      
        Account acct_PM_CAST = new Account(Name='PM_CAST',
                                                RecordTypeId=AcctRecTypes.get('Performance Materials Customer'),
                                                SAP_Division_Desc__c = 'Castings Solutions');accts.add(acct_PM_CAST);
        Account acct_PM_COMP = new Account(Name='PM_COMP',
                                                RecordTypeId=AcctRecTypes.get('Performance Materials Customer'),
                                                SAP_Division_Desc__c = 'Composite Polymers');accts.add(acct_PM_COMP);
        Account acct_PM_SPA = new Account(Name='PM_SPA',
                                                RecordTypeId=AcctRecTypes.get('Performance Materials Customer'),
                                                SAP_Division_Desc__c = 'Specialty Poly & Adh');accts.add(acct_PM_SPA);
        Account acct_Valvoline_DIFM = new Account(Name='Valvoline_DIFM',
                                                RecordTypeId=AcctRecTypes.get('Valvoline Customer'),
                                                SAP_Sales_District_Desc__c = 'DIFM');accts.add(acct_Valvoline_DIFM);
        Account acct_Valvoline_DIY = new Account(Name='Valvoline_DIY',
                                                RecordTypeId=AcctRecTypes.get('Valvoline Customer'),
                                                SAP_Sales_District_Desc__c = 'DIY');accts.add(acct_Valvoline_DIY);
        Account acct_Valvoline_DIY2 = new Account(Name='Valvoline_DIY2',
                                                RecordTypeId=AcctRecTypes.get('Valvoline Customer'),
                                                SAP_Sales_District_Desc__c = 'DIY');accts.add(acct_Valvoline_DIY2);
        Account acct_Valvoline_Specialty = new Account(Name='Valvoline_Specialty',
                                                RecordTypeId=AcctRecTypes.get('Valvoline Customer'),
                                                SAP_Sales_District_Desc__c = 'SPECIALTY');accts.add(acct_Valvoline_Specialty);
        Account acct_Water = new Account(Name='Water',
                                                RecordTypeId=AcctRecTypes.get('Water Prospect'));accts.add(acct_Water);
        Account acct_Water_Drew = new Account(Name='Water_Drew',
                                                RecordTypeId=AcctRecTypes.get('Drew Customer'));accts.add(acct_Water_Drew);
                                                
		*/
                                                
        insert accts;


        Competitor__c competitor = new Competitor__c(Name = 'Test Competitor');
        insert competitor;

        List<Competitor_to_Account__c> newRecs = new List<Competitor_to_Account__c>(); 
        
        for (Account acct:accts)
            {
            Competitor_to_Account__c newRec = new Competitor_to_Account__c(Account__c = acct.Id,Competitor__c = competitor.Id);
            newRecs.add(newRec);
            } 
        insert newRecs;
        Competitor__c checkCompetitor = [SELECT Id, Competes_With__c FROM Competitor__c WHERE Id = :competitor.id];
        
        delete newRecs;

        //Test Opportunities
        //Account oppAcct = new Account(Name='oppAcct',RecordTypeId=AcctRecTypes.get('Valvoline Customer'),
        Account oppAcct = new Account(Name='oppAcct',RecordTypeId=AcctRecTypes.get('Distribution Customer'),
                                      SAP_Sales_District_Desc__c = 'SPECIALTY');insert(oppAcct);
        Opportunity opp = new Opportunity(Name='opp',AccountId=oppAcct.Id,StageName='General Information',CloseDate=System.today());insert(opp);
        Competitor_to_Opportunity__c compOpp = new Competitor_to_Opportunity__c(Opportunity__c = opp.id,Competitor__c=competitor.Id);
        //insert compOpp;
        //delete compOpp;
        
        Competitor_to_Account__c newComptoAcctRec = new Competitor_to_Account__c(Account__c = oppAcct.Id,Competitor__c = competitor.Id);
        try{
        insert newComptoAcctRec;
        delete newComptoAcctRec; 
        }catch(exception e){}
            
   }
}