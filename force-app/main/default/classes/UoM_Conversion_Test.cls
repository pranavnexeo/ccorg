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
private class UoM_Conversion_Test {

    static String matnum = '123456789123456789';
    static Double matqty = 10.0;
    static String uomf1 = 'UF1', uomf2 = 'UF2', uomf3 = 'UF3', uomf4 = 'UF4';
    static String uomt1 = 'UT1', uomt2 = 'UT2', uomt3 = 'UT3', uomt4 = 'UT4'; 
     
    static testMethod void myUnitTest() {
    	Test.startTest();
    	createTestData();
    	test01();
    	Test.stopTest();
    }
    
    static void createTestData() {
    	String[] ca = new String[]{uomf1, uomf2, uomf3, uomt1, uomt2, uomt3};
        createUomDesc(ca);
        createUomCode(ca, 'DK1');
        ca = new String[]{uomf1, uomf2, uomt1, uomt2};
        createMatUom2(ca);
        ca = new String[]{uomf4, uomt4};
        createUomDesc(ca);
        createUomCode(ca, 'DK4');
    }
    
    static void createUomCode(String[] ca, String dk) {
    	List<SAP_UOM_Code__c> l = new List<SAP_UOM_Code__c>();
    	for (String c : ca) {
	        SAP_UOM_Code__c u = new SAP_UOM_Code__c();
	        u.Dimension_Key__c = dk;
	        u.ISO_Code__c = c;
	        u.UOM_Code__c = c;
	        u.SI_Unit_Conversion_Denominator__c = 1.0;
	        u.SI_Unit_Conversion_Exponent__c = 0;
	        u.SI_Unit_Conversion_Numerator__c = 1.0;
	        l.add(u);
    	}
        insert l;
    }
    
    static void createUomDesc(String[] ca) {
    	List<SAP_UOM_Description__c> l = new List<SAP_UOM_Description__c>();
        for (String c : ca) {
	        SAP_UOM_Description__c u = new SAP_UOM_Description__c();
	        u.Language_Code__c = 'E';
	        u.External_UOM__c = c;
	        u.UOM_Code__c = c;
	        u.UOM_Description__c = c;
            l.add(u);
        }
        insert l;
    }
    
    static void createMatUom2(String[] ca) {
    	List<Material_UOM2__c> l = new List<Material_UOM2__c>();
        for (String c : ca) {
	    	Material_UOM2__c m = new Material_UOM2__c();
	    	m.Alternative_UOM__c = c;
	    	m.Material_Number__c = matnum;
	    	m.Numerator__c = 100.0;
	    	m.Denominator__c = 10.0;
	    	m.Record_Key__c = matnum + c;
            l.add(m);
        }
        insert l;
    }
    
    static void test01() {
    	UoM_Conversion.retrieve_UoM_Conversion(matnum, matqty, uomf1, uomt1);
        UoM_Conversion.retrieve_UoM_Conversion(matnum, matqty, uomf2, uomt3);
        UoM_Conversion.retrieve_UoM_Conversion(matnum, matqty, uomf3, uomt3);
        UoM_Conversion.retrieve_UoM_Conversion(matnum, matqty, uomf3, uomt2);
        UoM_Conversion.retrieve_UoM_Conversion(matnum, matqty, uomf1, uomt4);
        UoM_Conversion.retrieve_UoM_Conversion(matnum, matqty, uomf2, uomt4);
        UoM_Conversion.retrieve_UoM_Conversion(matnum, matqty, uomf3, uomt4);
        UoM_Conversion.retrieve_UoM_Conversion(matnum, matqty, uomf4, uomt1);
        UoM_Conversion.retrieve_UoM_Conversion(matnum, matqty, uomf4, uomt2);
        UoM_Conversion.retrieve_UoM_Conversion(matnum, matqty, uomf4, uomt3);
    }
}