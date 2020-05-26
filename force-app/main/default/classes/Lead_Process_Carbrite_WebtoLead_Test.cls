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
private class Lead_Process_Carbrite_WebtoLead_Test {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
       // String carbriteLeadRecordType = RecordType_Functions.LookupRecordTypeId('Car Brite Web to Lead', 'Lead');
        String valvolineCustomerRecordType = RecordType_Functions.LookupRecordTypeId('Valvoline Customer', 'Account');
        List<Lead> leads = new List<Lead>();

        String distributorNumber = '';
        try {       
            distributorNumber = [SELECT SAP_Customer_Number__c FROM ACCOUNT WHERE RecordTypeId = :valvolineCustomerRecordType LIMIT 1].SAP_Customer_Number__c;
            }
        catch (Exception e) {}
        
        Lead l1 = new Lead();
       // l1.RecordTypeId = carbriteLeadRecordType;
        l1.LastName = 'Test1';
        l1.Company = 'Test1';
        //l1.Distributor_Account_Number__c = distributorNumber;
        /*l1.Lead_Street__c = 'Test1 Street';
        l1.Lead_Street_1__c = 'Test1 Street1';
        l1.Lead_Street_2__c = 'Test1 Street2';
        l1.Lead_Street_3__c = 'Test1 Street3';
        //l1.Lead_City__c = 'Test1 City';
        l1.Lead_State__c = 'Test1 State';
        l1.Lead_Zip_Code__c = '12345';
        l1.Lead_Country__c = 'Test1 Country';*/
        
        leads.add(l1);
        
        
        Lead l2 = new Lead();
       // l2.RecordTypeId = carbriteLeadRecordType;
        l2.LastName = 'Test2';
        l2.Company = 'Test2';
        //l2.Distributor_Account_Number__c = 'xyz';
        l2.Street = '';
        l2.City = 'Test2 City';
        l2.State = 'Test2 State';
        l2.PostalCode = '12345';
        l2.Country = 'Test2 Country';
        
        leads.add(l2);
        
        Lead l_test_EmployeeId = new Lead();
       // l_test_EmployeeId.RecordTypeId = carbriteLeadRecordType;
        l_test_EmployeeId.LastName = 'Test2';
        l_test_EmployeeId.Company = 'Test2';
        //l_test_EmployeeId.car_brite_tbm__c = 'A327591';
        //l_test_EmployeeId.Distributor_Account_Number__c = 'xyz';
        l_test_EmployeeId.Street = '';
        l_test_EmployeeId.City = 'Test2 City';
        l_test_EmployeeId.State = 'Test2 State';
        l_test_EmployeeId.PostalCode = '12345';
        l_test_EmployeeId.Country = 'Test2 Country';
        
        leads.add(l_test_EmployeeId);
        
        Lead l3 = new Lead();

        for (Integer i = 0; i < 200; i++)
            {
            l3 = new lead();
           // l3.RecordTypeId = carbriteLeadRecordType;
            l3.LastName = 'Test';
            l3.Company = 'Test';
           // l3.Distributor_Account_Number__c = distributorNumber;
            //l3.car_brite_tbm__c = '0000200127';
            //l3.Lead_Street__c = 'Test Street';
            //l3.Lead_Street_1__c = 'Test Street1';
            //l3.Lead_Street_2__c = 'Test Street2';
            //l3.Lead_Street_3__c = 'Test Street3';
            //l3.Lead_City__c = 'Test City';
            //l3.Lead_State__c = 'Test State';
            //l3.Lead_Zip_Code__c = '12345';
            //l3.Lead_Country__c = 'Test Country';
            leads.add(l3);
            }
        
        insert leads;
        
        
    }
}