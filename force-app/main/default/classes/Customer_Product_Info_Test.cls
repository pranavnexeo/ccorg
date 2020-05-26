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
private class Customer_Product_Info_Test {

    static String sorg = '0000';
    static String dc = '00';
    static String mat = '000000000000000000';
    static String shto = 'ShipTo';
    static String soto = 'SoldTo';
    static String hrky = 'CHerky';
    static String inva = 'invalidAcc';
    static String salesArea = '00000000';
    static Account shipTo, soldTo, cHerky, invalidAcc;
    static Customer_Product_Info__c cpi1, cpi2, cpi3;

    static testMethod void myUnitTest() {
        Test.startTest();
        try {
            createTestData();
            test01();
        } catch (Exception e) {}
        Test.stopTest();
    }
    static testMethod void myUnitTest1() {
     Test.startTest();
        try {
            //createTestData();
            test02();
        } catch (Exception e) {}
        Test.stopTest();
    }
    static testMethod void myUnitTest2() {
        Test.startTest();
        try {
            //createTestData();
            test01b();
        } catch (Exception e) {}
        Test.stopTest();
    }
    static testMethod void myUnitTest3() {
        Test.startTest();
        try {
            //createTestData();
            test01c();
        } catch (Exception e) {}
        Test.stopTest();
    }
    
    
    static void createTestData() {
        cHerky = new Account(Name = 'CHerky');
        cHerky.AccountNumber = hrky;
        insert cHerky;
        soldTo = new Account(Name = 'SoldTo');
        soldTo.AccountNumber = soto;
        soldTo.ParentId = cHerky.Id;
        insert soldTo;
        shipTo = new Account(Name = 'ShipTo');
        shipTo.AccountNumber = shto;
        insert shipTo;
        invalidAcc = new Account(Name = 'invalidAcc');
        invalidAcc.AccountNumber = inva;
        insert invalidAcc;
        createCISRelationship(shipTo, CISRelationships_Functions.SHIPTO, shipTo);
        createCISRelationship(shipTo, CISRelationships_Functions.SOLDTO, soldTo);
        createCISRelationship(soldTo, CISRelationships_Functions.SOLDTO);
     //   createCISRelationship(invalidAcc, 'invalidAcc');

        cpi1 = createCPI('1', '1');
     //   cpi1 = createCPI('1', '2');
     //   cpi2 = createCPI('2', '2');
     //   cpi3 = createCPI('3', '3');
        
    }   
     
    static CISRelationships__c createCISRelationship(Account sourceAcc,
                                                     String custType) {
        return createCISRelationship(sourceAcc, custType, null);
    }
    
    static CISRelationships__c createCISRelationship(Account sourceAcc,
                                                     String custType,
                                                     Account targetAcc) {
        CISRelationships__c cr = new CISRelationships__c();
        cr.Customer_Number__c = sourceAcc.AccountNumber;
        cr.Customer_Type__c = custType;
        cr.Source_Customer__c = sourceAcc.Id;
        if (targetAcc != null) {
            cr.Target_Customer__c = targetAcc.Id;
        }
        cr.Ext_Unique_ID_c__c = cr.Source_Customer__c+cr.Customer_Number__c+salesArea+custType;
        insert cr;
        return cr;
    }
    
    static Customer_Product_Info__c createCPI(String recType, String custMat) {
        Customer_Product_Info__c cpi = new Customer_Product_Info__c();
        cpi.CPI_Record_Type__c = recType;
        cpi.Sales_Org_Code__c = sorg;
        cpi.Distribution_Channel_Code__c = dc;
        cpi.Material_Number__c = mat;
        cpi.ShipTo_Number__c = shto;
        cpi.Customer_Number__c = soto;
        cpi.Customer_Material_Number__c = custMat;
        cpi.Record_Key__c = recType + sorg + dc + soto + shto + custMat + mat;
        cpi.Primary_Indicator__c = 'X';
        insert cpi;
        return cpi;
    }
    
    static void test01() {
        Id SoldToId = CISRelationships_Functions.Lookup_Related_Sold_To(shipTo.Id);
        System.debug(SoldToId);
        String customerNumber = [Select AccountNumber from Account where Id =:SoldToId].AccountNumber;
        System.debug(customerNumber);
        Customer_Product_Info.retrieveCustomerProductInfo(sorg, dc, shipTo.Id, '', mat);
    }
    static void test01b() {
        Id SoldToId = CISRelationships_Functions.Lookup_Related_Sold_To(shipTo.Id);
        System.debug(SoldToId);
        String customerNumber = [Select AccountNumber from Account where Id =:SoldToId].AccountNumber;
        System.debug(customerNumber);       
        Customer_Product_Info.retrieveCustomerProductInfo(sorg, dc, shipTo.Id, shto, mat);
        
      
    }
    static void test01c() {
        system.debug('**Queries**' + Limits.getAggregateQueries());
        Id SoldToId = CISRelationships_Functions.Lookup_Related_Sold_To(shipTo.Id);
        system.debug('**Queries**' + Limits.getAggregateQueries());
        System.debug(SoldToId);
        String customerNumber = [Select AccountNumber from Account where Id =:SoldToId].AccountNumber;
        system.debug('**Queries**' + Limits.getAggregateQueries());
        System.debug(customerNumber);
        system.debug('**Queries**' + Limits.getAggregateQueries());
        Customer_Product_Info.retrieveCustomerProductInfo(sorg, dc, soldTo.Id, '', mat);
        system.debug('**Queries**' + Limits.getAggregateQueries());
      
    }
    static void test02() {
        Id SoldToId = CISRelationships_Functions.Lookup_Related_Sold_To(shipTo.Id);
        System.debug(SoldToId);
        String customerNumber = [Select AccountNumber from Account where Id =:SoldToId].AccountNumber;
        System.debug(customerNumber);
        Customer_Product_Info.retrieveCustomerProductInfo(sorg, dc, soldTo.Id, shto, mat);
        Customer_Product_Info.retrieveCustomerProductInfo(sorg, dc, invalidAcc.Id, inva, mat);
    }

}