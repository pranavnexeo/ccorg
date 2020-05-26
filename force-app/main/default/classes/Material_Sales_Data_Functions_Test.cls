@isTest
private class Material_Sales_Data_Functions_Test {

    static String lang = 'E';
    static String ph1code = '!';
    static String ph2code = '!@#';
    static String ph3code = '!@#$%^';
    static String ph4code = '!@#$%^&*(';
    static String ph5code = '!@#$%^&*()!@';
    static String ph6code = '!@#$%^&*()!@#$%';
    static String ph7code = '!@#$%^&*()!@#$%^&*';
    
    public static testMethod void testMe() {
        Test.startTest();
        testInsert_Material_Sales_Data2();
        testAltUomsAndPlants();
        Test.stopTest();
    }
    
    private static void testInsert_Material_Sales_Data2() {
        String matnum = '010000000123456789';
        String salesOrg = '1234';
        String distChan = '30';

        Material_General_Data2__c mgd2 = new Material_General_Data2__c();
        mgd2.Material_Number__c = matnum;
        insert mgd2;
        
        List<Material_Sales_Data__c> msda = testGet_Material_Sales_Data(matnum);
        insert msda;
        
        Map<Id, String> umap = new Map<Id, String>();

        Material_Sales_Data2__c msd2 = new Material_Sales_Data2__c();
        msd2.Material_Number__c = matnum;
        msd2.Sales_Org_Code__c = salesOrg;
        msd2.Dist_Channel_Code__c = distChan;
        msd2.Record_Key__c = matnum + salesOrg + distChan;
        msd2.Material_General_Data__c = mgd2.Id;
        insert msd2;
        
        Material_Sales_Data2__c[] msd2a = new Material_Sales_Data2__c[]{};
        
        Set<id> msd2Ids = new Set<id>{msd2.Id};
        Group g = new Group(Name='Test');
        insert g;
        Material_Sales_Data_Functions.createSharingRecords(new List<Material_Sales_Data2__c>{msd2});
        Material_Sales_Data_Functions.getMsd2share(msd2.id,g.id,'Read','Test');
        Material_Sales_Data_Functions.getMaterialSalesData2Map(msd2Ids);
        Material_Sales_Data_Functions.updateDeletionFlag(umap);
        Material_Sales_Data_Functions.getMaterialGeneralData2Ids(msd2Ids);
        Material_Sales_Data_Functions.SyncProducts(msd2a);
    }
    
    private static List<Material_Sales_Data__c> testGet_Material_Sales_Data(String matnum) {
        String PIPE = '\\|';
        String[] salesData = new String[]{'1000|30|D10054305251276741|DR|WC',
                                          '1700|30|D10054305251276741|DR|WC',
                                          '1000|10|I27000000000276741'
                                         };
        List<Material_Sales_Data__c> msda = new List<Material_Sales_Data__c>();
        for (Integer i = 0; i < 1; i++) {
            for (Integer j = 0; j < salesData.size(); j++) {
                Material_Sales_Data__c msd = new Material_Sales_Data__c();
                msd.Material_Number__c = matnum;
                String[] sa = salesData[j].split(PIPE);
                msd.Sales_Org__c = sa[0];
                msd.Distribution_Channel__c = sa[1];
                msd.Record_Key__c = matnum + sa[0] + sa[1];
                msd.Product_Hierarchy__c = sa[2];
                if (sa.size() > 3) {
                    msd.Sales_Unit__c = sa[3];
                    if (sa.size() > 4) {
                        msd.Material_Pricing_Group__c = sa[4];
                    }
                }
                msda.add(msd);
            } 
        }
        return msda;
    }
    
    private static void testAltUomsAndPlants() {
        String matnum = '030000000123456789';
        String plant = '1234';
        String sorg = '1234';
        String dchan = '12';
        
        SAP_Valuation_Area__c va = new SAP_Valuation_Area__c();
        va.Company_Code__c = sorg;
        va.Valuation_Area__c = plant;
        try {insert va;} catch(Exception e) {}
        
        SAP_Plant__c sp = new SAP_Plant__c();
        sp.Plant_Code__c = plant;
        try {insert sp;} catch(Exception e) {}

        SAP_Sales_Org__c so = new SAP_Sales_Org__c();
        so.Sales_Org_Code__c = sorg;
        so.Language_Code__c = lang;
        try {insert so;} catch(Exception e) {}
        
        SAP_Distribution_Channel__c dc = new SAP_Distribution_Channel__c();
        dc.Distribution_Channel_Code__c = dchan;
        dc.Language_Code__c = lang;
        try {insert dc;} catch(Exception e) {}

        Material_Valuation__c mv = new Material_Valuation__c();
        mv.Material_Number__c = matnum;
        mv.Price_Control_Indicator__c = 'S';
        mv.Price_Unit__c = 100.0;
        mv.Record_Key__c = matnum + plant;
        mv.Standard_Price__c = 1234.56;
        mv.Valuation_Area__c = plant;
        try {insert mv;} catch(Exception e) {}
        List<String> mvKeys = new List<String> {matnum + plant};

        Material_General_Data2__c mgd2 = new Material_General_Data2__c();
        mgd2.Material_Number__c = matnum;
        insert mgd2;
        
        Material_Plant2__c mp2 = getTestMp2(matnum, plant, sorg, mgd2, sp, so);
        List<Material_Plant2__c> mp2s = new List<Material_Plant2__c> {mp2};
        Map<String, Material_Plant2__c> amap = new Map<String, Material_Plant2__c> {matnum + plant => mp2};

        Material_Sales_Data2__c msd2 = getTestMsd2(matnum, plant, sorg, dchan, mgd2, sp, so, dc);
        List<Material_Sales_Data2__c> msd2s = new List<Material_Sales_Data2__c>{msd2};
        Set<id> msd2Ids = new Set<id>{msd2.Id};
        Material_Sales_Data_Functions.getAltUOMs(msd2);
        Material_Sales_Data_Functions.getAltUOMs(msd2.Id);
        Material_Sales_Data_Functions.getMaterialUoms(msd2.Id);
        Material_Sales_Data_Functions.getPlants(msd2);
        Material_Sales_Data_Functions.getPlants(msd2.Id);
        Material_Sales_Data_Functions.getPlants(matnum, sorg, dchan);
        Material_Sales_Data_Functions.getPlantsMap(msd2s);
        Material_Sales_Data_Functions.getMaterialPlantMap(msd2Ids);
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
        //getMaterial_Sales_Data2(matnum, sorg, dchan);
        Material_Sales_Data_Functions.getMaterialSalesData2s(new Set<Id>{msd2.id});
        return msd2;
    }
    
    private static Product_Hierarchy2__c getTestProdHerky2() {
        Product_Hierarchy__c ph1 = new Product_Hierarchy__c();
        ph1.Language_Code__c = lang;
        ph1.Product_Hierarchy_Code__c = ph1code;
        insert ph1;

        Product_Hierarchy__c ph2 = new Product_Hierarchy__c();
        ph2.Language_Code__c = lang;
        ph2.Product_Hierarchy_Code__c = ph2code;
        insert ph2;

        Product_Hierarchy__c ph3 = new Product_Hierarchy__c();
        ph3.Language_Code__c = lang;
        ph3.Product_Hierarchy_Code__c = ph3code;
        insert ph3;

        Product_Hierarchy__c ph4 = new Product_Hierarchy__c();
        ph4.Language_Code__c = lang;
        ph4.Product_Hierarchy_Code__c = ph4code;
        insert ph4;

        Product_Hierarchy__c ph5 = new Product_Hierarchy__c();
        ph5.Language_Code__c = lang;
        ph5.Product_Hierarchy_Code__c = ph5code;
        insert ph5;

        Product_Hierarchy__c ph6 = new Product_Hierarchy__c();
        ph6.Language_Code__c = lang;
        ph6.Product_Hierarchy_Code__c = ph6code;
        insert ph6;

        Product_Hierarchy__c ph7 = new Product_Hierarchy__c();
        ph7.Language_Code__c = lang;
        ph7.Product_Hierarchy_Code__c = ph7code;
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

    public static testMethod void test02() {
        Test.startTest();
        String sorg = '1000';
        String dchan = '30';
        String matnum = '000000000000123456';
        String matname = 'TestMaterial';
        SAP_Sales_Org__c so = getSalesOrg(sorg);
        SAP_Distribution_Channel__c dc = getDistChan(dchan);
        Material_Description__c md = getMatDesc(matnum);
        Material_General_Data__c mgd = getMatGenData(matnum);
        Material_General_Data2__c mgd2 = getMatGenData2(matnum);
        getTestProdHerky2();
        Material_Sales_Data__c msd = getMatSalesData(matnum, sorg, dchan);
        List<Material_Sales_Data__c> msda = new List<Material_Sales_Data__c>{msd};
        Material_Sales_Data_Functions.upsert_Material_Sales_Data2(msda);
        List<Material_General_Data__c> mgda = new List<Material_General_Data__c>{mgd};
        //Material_General_Data_Functions.upsert_Material_General_Data2(mgda);
        Test.stopTest();
    }
    
    private static SAP_Sales_Org__c getSalesOrg(String sorg) {
        SAP_Sales_Org__c so = null;
        try {
            so = [select Sales_Org_Code__c 
                    from SAP_Sales_Org__c
                   where Sales_Org_Code__c = :sorg
                   limit 1];
        } catch(Exception e) {}
        if (so == null) {
            so = new SAP_Sales_Org__c();
            so.Sales_Org_Code__c = sorg;
            so.Language_Code__c = lang;
            insert so;
        }
        return so;
    }
    
    private static SAP_Distribution_Channel__c getDistChan(String dchan) {
        SAP_Distribution_Channel__c dc = null;
        try {
            dc = [select Distribution_Channel_Code__c 
                    from SAP_Distribution_Channel__c
                   where Distribution_Channel_Code__c = :dchan
                   limit 1];
        } catch(Exception e) {}
        if (dc == null) {
            dc = new SAP_Distribution_Channel__c();
            dc.Distribution_Channel_Code__c = dchan;
            dc.Language_Code__c = lang;
            insert dc;
        }
        return dc;
    }
    
    private static Material_Description__c getMatDesc(String matnum) {
        Material_Description__c md = null;
        try {
            md = [select Material_Number__c, Material_Description__c 
                     from Material_Description__c
                    where Material_Number__c = :matnum
                    limit 1];
        } catch(Exception e) {}
        if (md == null) {
            md = new Material_Description__c();
            md.Language_Code__c = lang;
            md.Material_Number__c = matnum;
            md.Material_Description__c = 'TestMaterial';
            insert md;
        }
        return md;
    }
    
    private static Material_General_Data__c getMatGenData(String matnum) {
        Material_General_Data__c mgd = null;
        try {
            mgd = [select Material_Number__c 
                     from Material_General_Data__c
                    where Material_Number__c = :matnum
                    limit 1];
        } catch(Exception e) {}
        if (mgd == null) {
            mgd = new Material_General_Data__c();
            mgd.Material_Number__c = matnum;
            insert mgd;
        }
        return mgd;
    }
    
    private static Material_General_Data2__c getMatGenData2(String matnum) {
        Material_General_Data2__c mgd2 = null;
        try {
            mgd2 = [select Material_Number__c 
                      from Material_General_Data2__c
                     where Material_Number__c = :matnum
                     limit 1];
        } catch(Exception e) {}
        if (mgd2 == null) {
            mgd2 = new Material_General_Data2__c();
            mgd2.Material_Number__c = matnum;
            insert mgd2;
        }
        return mgd2;
    }
    
    private static Material_Sales_Data__c getMatSalesData(String matnum, 
                                                          String sorg, 
                                                          String dchan) {
        Material_Sales_Data__c msd = null;
        String recKey = matnum + sorg + dchan;
        try {
            msd = [select Material_Number__c, Sales_Org__c, 
                          Distribution_Channel__c, Product_Hierarchy__c 
                     from Material_Sales_Data__c
                    where Record_Key__c = :recKey
                    limit 1];
        } catch(Exception e) {}
        if (msd == null) {
            msd = new Material_Sales_Data__c();
            msd.Material_Number__c = matnum;
            msd.Sales_Org__c = sorg;
            msd.Distribution_Channel__c = dchan;
            msd.Record_Key__c = recKey;
            msd.Product_Hierarchy__c = ph7code;
            insert msd;
        }
        return msd;
    }
    
}