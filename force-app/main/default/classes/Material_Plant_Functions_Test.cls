@isTest
private class Material_Plant_Functions_Test {


    public static testMethod void testMe() {
        Test.startTest();
        testInsert_Material_Plant();
        testInsert_Material_Plant2();
        Test.stopTest();
    }
    
    private static void testInsert_Material_Plant() {
        List<Material_Plant__c> mpa = testGet_Material_Plant();
        insert mpa;
    }
    
    private static void testInsert_Material_Plant2() {
        String matnum = '000000000123456789';
        String plant = '1234';
        String sorg = '1234';
        String dchan = '12';
        String lang = 'E';
        
        
        
        SAP_Valuation_Area__c va = new SAP_Valuation_Area__c();
        va.Company_Code__c = sorg;
        va.Valuation_Area__c = plant;
        insert va;
        
        Set<String> vas = new Set<String> {plant};
        Map<String, String> plantSalesOrgs = Material_Plant_Functions.getPlantSalesOrgMap(vas);
        
        //sorg += 'G2';
        //plant += 'G2';

        Material_Plant__c mp = new Material_Plant__c();
        mp.Material_Number__c = matnum;
        mp.Plant_Code__c = plant;

        Material_General_Data2__c mgd2 = new Material_General_Data2__c();
        mgd2.Material_Number__c = matnum;
        insert mgd2;
        Set<id> mgd2Ids = new Set<id>{mgd2.Id};
        
        SAP_Plant__c sp = new SAP_Plant__c();
        sp.Plant_Code__c = plant;
        insert sp;
        Set<id> plantIds = new Set<id>{sp.Id};
        
        SAP_Sales_Org__c so = new SAP_Sales_Org__c();
        so.Sales_Org_Code__c = sorg;
        so.Language_Code__c = lang;
        insert so;
        
        system.debug('plantSalesOrgs: ' + plantsalesorgs);
        system.debug('mp: ' + mp);
        Material_Plant2__c mp2 = Material_Plant_Functions.getMaterial_Plant2(mp, plantSalesOrgs);
        system.debug('mp2: ' + mp2);
        insert mp2;
        List<Material_Plant2__c> alist = new List<Material_Plant2__c>{mp2};
        Material_Plant_Functions.upsert_Material_Plant2(alist);
        
        Group g = new Group(Name='Test');
        insert g;
        Material_Plant_Functions.getMp2share(mp2.id,g.id,'Read','Test');
        
        Material_Plant_Functions.createSharingRecords(alist);

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

        List<Material_Plant2__c> mp2s = new List<Material_Plant2__c> {mp2};
        Map<String, Material_Plant2__c> amap = new Map<String, Material_Plant2__c> {matnum + plant => mp2};

        Material_Sales_Data2__c msd2 = getTestMsd2(matnum, plant, sorg, dchan, mgd2, sp, so, dc);
        List<Material_Sales_Data2__c> msd2a = new List<Material_Sales_Data2__c>{msd2};
        Material_Plant_Functions.getPlantsMap(mgd2.Id);
        Material_Plant_Functions.getPlantsMap(mgd2Ids);
        Material_Plant_Functions.getPlantsMap(mgd2Ids, plantIds);
        Material_Plant_Functions.getPlants(msd2);
        Material_Plant_Functions.getPlantsMap(msd2a, mgd2Ids);
        Material_Plant_Functions.getPlantsMap(new List<String>{matnum});
    }
    
    private static List<Material_Plant__c> testGet_Material_Plant() {
        String matnum = '000000000123456789';
        String[] plants = new String[]{'0004','0007','0008','0009','0011','0056','0060','0067','0068','0069',
                                       '0074','0076','0077','0080','0081','0082','0083','0084','0087','0088',
                                       '0096','0106','0107','0112','0123','0125','0131','0136','0139','0160',
                                       '0163','0166','0175','0178','0187','0223'};
        List<Material_Plant__c> mpa = new List<Material_Plant__c>();
        for (Integer i = 0; i < 1; i++) {
            for (Integer j = 0; j < plants.size(); j++) {
                Material_Plant__c mp = new Material_Plant__c();
                mp.Material_Number__c = matnum;
                mp.Plant_Code__c = plants[j];
                mp.Record_Key__c = matnum + plants[j];
                mpa.add(mp);
            } 
        }
        return mpa;
    }
    
    private static Material_Sales_Data2__c getTestMsd2(String matnum,
                                                       String plant,
                                                       String sorg,
                                                       String dchan,
                                                       Material_General_Data2__c mgd2,
                                                       SAP_Plant__c sp,
                                                       SAP_Sales_Org__c so,
                                                       SAP_Distribution_Channel__c dc) {
        Material_Sales_Data2__c msd2 = new Material_Sales_Data2__c();
        msd2.Material_Number__c = matnum;
        msd2.Sales_Org_Code__c = sorg;
        msd2.Dist_Channel_Code__c = dchan;
        msd2.Record_Key__c = matnum + sorg + dchan;
        msd2.SalesOrg_Code__c = so.Id;
        msd2.DistChannel_Code__c = dc.Id;
        msd2.Material_General_Data__c = mgd2.Id;
        insert msd2;
        return msd2;
    }
    
}