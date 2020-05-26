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
private class Opportunity_Functions_Test {

    static testMethod void test01() {
        Test.startTest();
        createOppMaterial();
        Test.stopTest();
    }
    
    static void createOppMaterial() {
    	Map <String, ID>RTMap = RecordType_Functions.RetrieveRecordTypeNameMap('Opportunity_Material__c');
        Id omrt = RTMap.get('AQ Opportunity Material');
    	Date cdate = Date.today().addDays(30);
    	Opportunity op = new Opportunity(Name='TestOp',StageName='Open',CloseDate=cdate);
    	insert op;

        List<Opportunity_Material__c> oms = new List<Opportunity_Material__c>();
        oms.add(getOpportunityMaterial(op, omrt, 'KG'));
        oms.add(getOpportunityMaterial(op, omrt, 'LB'));
        insert oms;
    }
    
    static Opportunity_Material__c getOpportunityMaterial(Opportunity op,
                                                          Id rectype, 
                                                          String uom) {
        Opportunity_Material__c om = new Opportunity_Material__c();
        om.Opportunity__c = op.Id;
        om.Sales_Price__c = 100.0;
        om.Quantity__c = 10.0;
        om.RecordTypeID = rectype;
        om.Unit_of_Measure__c = uom;
        return om;
    }
}