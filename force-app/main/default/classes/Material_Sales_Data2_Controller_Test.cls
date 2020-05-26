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
private class Material_Sales_Data2_Controller_Test {

    public static testMethod void testMe() {
        Test.startTest();
        String matnum = '000000000123456789';
        String plant = '1234';
        String sorg = '1234';
        String dchan = '12';
        String lang = 'E';
        
        SAP_Valuation_Area__c va = new SAP_Valuation_Area__c();
        va.Company_Code__c = sorg;
        va.Valuation_Area__c = plant;
        insert va;
        
        SAP_Plant__c sp = new SAP_Plant__c();
        sp.Plant_Code__c = plant;
        insert sp;

        SAP_Sales_Org__c so = new SAP_Sales_Org__c();
        so.Sales_Org_Code__c = sorg;
        so.Language_Code__c = lang;
        insert so;
        
        SAP_Distribution_Channel__c dc = new SAP_Distribution_Channel__c();
        dc.Distribution_Channel_Code__c = dchan;
        dc.Language_Code__c = lang;
        insert dc;

        Material_Valuation__c mv = new Material_Valuation__c();
        mv.Material_Number__c = matnum;
        mv.Price_Control_Indicator__c = 'S';
        mv.Price_Unit__c = 100.0;
        mv.Record_Key__c = matnum + plant;
        mv.Standard_Price__c = 1234.56;
        mv.Valuation_Area__c = plant;
        insert mv;
        List<String> mvKeys = new List<String> {matnum + plant};

        Material_General_Data2__c mgd2 = new Material_General_Data2__c();
        mgd2.Material_Number__c = matnum;
        insert mgd2;
        
        Material_Plant2__c mp2 = getTestMp2(matnum, plant, sorg, mgd2, sp, so);
        List<Material_Plant2__c> mp2s = new List<Material_Plant2__c> {mp2};
        Map<String, Material_Plant2__c> amap = new Map<String, Material_Plant2__c> {matnum + plant => mp2};

        Material_Sales_Data2__c msd2 = getTestMsd2(matnum, plant, sorg, dchan, mgd2, sp, so, dc);
        System.debug('msd2id ' + msd2.Id );
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(msd2);
        Material_Sales_Data2_Controller mc = new Material_Sales_Data2_Controller(sc);
        System.debug('get record' + sc.getRecord());
        mc.getAltUOMs();
        mc.getMaterial_Sales_Data2();
        mc.getMaterialNumber();
        mc.getPlants();
        mc.getAllOpenOrders();
        Test.stopTest();
    }
    
    private static Material_Plant2__c getTestMp2(String matnum,
                                                 String plant,
                                                 String sorg,
                                                 Material_General_Data2__c mgd2,
                                                 SAP_Plant__c sp,
                                                 SAP_Sales_Org__c so) {
        Material_Plant2__c mp2 = new Material_Plant2__c();
        mp2.Material_Number__c = matnum;
        mp2.Plant_Code__c = plant;
        mp2.SalesOrg_Code__c = sorg;
        mp2.Record_Key__c = matnum + plant + sorg;
        mp2.Material_General_Data__r = mgd2;
        mp2.SAP_Plant__r = sp;
        mp2.SAP_Sales_Org__r = so;
        insert mp2;
        System.debug(' mp2 ' + mp2);
        return mp2;
    }
    
    private static Material_Sales_Data2__c getTestMsd2(String matnum,
                                                       String plant,
                                                       String sorg,
                                                       String dchan,
                                                       Material_General_Data2__c mgd2,
                                                       SAP_Plant__c sp,
                                                       SAP_Sales_Org__c so,
                                                       SAP_Distribution_Channel__c dc) {
        Product_Hierarchy2__c ph2 = getTestProdHerky2();
        
        Material_Sales_Data2__c msd2 = new Material_Sales_Data2__c();
        msd2.Material_Number__c = matnum;
        msd2.Sales_Org_Code__c = sorg;
        msd2.Dist_Channel_Code__c = dchan;
        msd2.Record_Key__c = matnum + sorg + dchan;
        msd2.SalesOrg_Code__r = so;
        msd2.DistChannel_Code__r = dc;
        msd2.Material_General_Data__c = mgd2.Id;
        msd2.Product_Hierarchy__r = ph2;
        insert msd2;
		System.debug(' msd2 ' + msd2);
        return msd2;
    }
    
    private static Product_Hierarchy2__c getTestProdHerky2() {
        Product_Hierarchy__c ph1 = new Product_Hierarchy__c();
        ph1.Language_Code__c = 'E';
        ph1.Product_Hierarchy_Code__c = '!';
        insert ph1;

        Product_Hierarchy__c ph2 = new Product_Hierarchy__c();
        ph2.Language_Code__c = 'E';
        ph2.Product_Hierarchy_Code__c = '!@#';
        insert ph2;

        Product_Hierarchy__c ph3 = new Product_Hierarchy__c();
        ph3.Language_Code__c = 'E';
        ph3.Product_Hierarchy_Code__c = '!@#$%^';
        insert ph3;

        Product_Hierarchy__c ph4 = new Product_Hierarchy__c();
        ph4.Language_Code__c = 'E';
        ph4.Product_Hierarchy_Code__c = '!@#$%^&*(';
        insert ph4;

        Product_Hierarchy__c ph5 = new Product_Hierarchy__c();
        ph5.Language_Code__c = 'E';
        ph5.Product_Hierarchy_Code__c = '!@#$%^&*()!@';
        insert ph5;

        Product_Hierarchy__c ph6 = new Product_Hierarchy__c();
        ph6.Language_Code__c = 'E';
        ph6.Product_Hierarchy_Code__c = '!@#$%^&*()!@#$%';
        insert ph6;

        Product_Hierarchy__c ph7 = new Product_Hierarchy__c();
        ph7.Language_Code__c = 'E';
        ph7.Product_Hierarchy_Code__c = '!@#$%^&*()!@#$%^&*';
        insert ph7;

        Product_Hierarchy2__c pherky2 = new Product_Hierarchy2__c();
        pherky2.Product_Hierarchy__c = ph7.Product_Hierarchy_Code__c;
        pherky2.Product_Hierarchy1__r = ph1;
        pherky2.Product_Hierarchy2__r = ph2;
        pherky2.Product_Hierarchy3__r = ph3;
        pherky2.Product_Hierarchy4__r = ph4;
        pherky2.Product_Hierarchy5__r = ph5;
        pherky2.Product_Hierarchy6__r = ph6;
        pherky2.Product_Hierarchy7__r = ph7;
        insert pherky2;
        return pherky2;
    }
    
}