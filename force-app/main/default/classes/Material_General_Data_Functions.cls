public with sharing class Material_General_Data_Functions {

    private static String className = 'Material_General_Data_Functions';
    
    private static String KEY_MATNUM = 'KEY_MATNUM';
    private static String KEY_MBASCD = 'KEY_MBASCD';
    private static String KEY_MCNTCD = 'KEY_MCNTCD';
    private static String KEY_MGRPCD = 'KEY_MGRPCD';
    private static String KEY_MTYPCD = 'KEY_MTYPCD';

    private static Map<String, String> uomCodes = Material_UOM_Functions.getUOMCodes();

    public static void upsert_Material_General_Data2(Material_General_Data__c[] mgda) {
        List<Material_General_Data2__c> alist = getMaterial_General_Data2(mgda, uomCodes);
        if (alist.isEmpty()) {
            return;
        }
        upsert_Material_General_Data2(alist);
    }
    
    public static void update_Material_Sales_Data2(Map<Id, Material_General_Data__c> omap,
                                                   Map<Id, Material_General_Data__c> nmap) {
        if (omap == null || omap.isEmpty() || 
            nmap == null || nmap.isEmpty()) {return;}
        List<String> matnums = new List<String>();
        for (Material_General_Data__c omgd : omap.values()) {
            Material_General_Data__c nmgd = nmap.get(omgd.Id);
            String omfd = omgd.Marked_for_deletion__c;
            String nmfd = nmgd.Marked_for_deletion__c;
            if (omfd == null) {omfd = '';}
            if (nmfd == null) {nmfd = '';}
            omfd = omfd.trim();
            nmfd = nmfd.trim();
            if (omfd != nmfd) {matnums.add(nmgd.Material_Number__c);}
        }
        if (!matnums.isEmpty()) {
            List<Material_General_Data2__c> mgd2s = getMaterialGeneralData2s(matnums);
            Map<Id, String> umap = new Map<Id, String>();
            for (Material_General_Data2__c mgd2 : mgd2s) {
                umap.put(mgd2.Id, mgd2.Marked_for_deletion__c);
            }
            Material_Sales_Data_Functions.updateDeletionFlag(umap);
        }
    }
    
    private static void upsert_Material_General_Data2(List<Material_General_Data2__c> alist) {
        List<Database.Upsertresult> ur =  new List<Database.Upsertresult>();
        try {
            ur = Database.upsert(alist, Material_General_Data2__c.Material_Number__c, false);
        } catch(DmlException de) {
            System.debug(de.getMessage());
        } finally {
            //DebugLog_Functions.logUpsertErrors(className, 'upsert_Material_General_Data2', ur);
        }
    }
    
    private static List<Material_General_Data2__c> getMaterial_General_Data2(Material_General_Data__c[] mgda,
                                                                             Map<String, String> umap) {
        List<Material_General_Data2__c> alist = new List<Material_General_Data2__c>();
        Map<String, Set<String>> fv = getFieldValues(mgda);
        Map<String, Material_Base_Code__c> bmap = Material_Base_Code_Functions.getMaterialBaseCodeMap(fv.get(KEY_MBASCD)); 
        Map<String, Material_Container_Code__c> cmap = Material_Container_Code_Functions.getMaterialContainerCodeMap(fv.get(KEY_MCNTCD)); 
        Map<String, Material_Description__c> dmap = Material_Description_Functions.getMaterialDescriptionMap(fv.get(KEY_MATNUM)); 
        Map<String, Material_Group__c> gmap = Material_Group_Functions.getMaterialGroupMap(fv.get(KEY_MGRPCD)); 
        Map<String, Material_Type__c> tmap = Material_Type_Functions.getMaterialTypeMap(fv.get(KEY_MTYPCD)); 
        Map<String, SAP_Sales_Division__c> sdmap = SAP_Queries_Functions.getSapSalesDivisionMap();
        
        for(Material_General_Data__c mgd : mgda) {
            Material_General_Data2__c mgd2;
            mgd2 = new Material_General_Data2__c();
            mgd2.Material_Number__c = mgd.Material_Number__c;
            mgd2.Gross_Weight__c = mgd.Gross_Weight__c;
            mgd2.Net_Weight__c = mgd.Net_Weight__c;
            mgd2.Marked_for_deletion__c = mgd.Marked_for_deletion__c;
            mgd2.Ext_Material_Group_Code__c = mgd.Ext_Material_Group_Code__c;
            
            setDivision(mgd, mgd2, sdmap);
            
            setBaseUOM(mgd, mgd2, umap);
            
            setWeightUOM(mgd, mgd2, umap);
            
            setBaseCode(mgd, mgd2, bmap);
            
            setContainerCode(mgd, mgd2, cmap);
            
            setDescription(mgd, mgd2, dmap);
            
            setGroup(mgd, mgd2, gmap);
            
            setType(mgd, mgd2, tmap);
    
            alist.add(mgd2);
        }
        return alist;
    }
    
   
    private static boolean isNull(String s) {
        return (s == null || s.trim().length() == 0);
    }
    
    private static Map<String, Set<String>> getFieldValues(Material_General_Data__c[] mgda) {
        Map<String, Set<String>> amap = new Map<String, Set<String>>();
        Set<String> matnums = new Set<String>();
        Set<String> mbascds = new Set<String>();
        Set<String> mcntcds = new Set<String>();
        Set<String> mgrpcds = new Set<String>();
        Set<String> mtypcds = new Set<String>();
        for(Material_General_Data__c mgd : mgda) {
            matnums.add(mgd.Material_Number__c);
            if (!isNull(mgd.Base_Code__c)) {
                mbascds.add(mgd.Base_Code__c);
            }
            if (!isNull(mgd.Container_Code__c)) {
                mcntcds.add(mgd.Container_Code__c);
            }
            if (!isNull(mgd.Material_Group_Code__c)) {
                mgrpcds.add(mgd.Material_Group_Code__c);
            }
            if (!isNull(mgd.Material_Type_Code__c)) {
                mtypcds.add(mgd.Material_Type_Code__c);
            }
        }
        amap.put(KEY_MATNUM, matnums);
        amap.put(KEY_MBASCD, mbascds);
        amap.put(KEY_MCNTCD, mcntcds);
        amap.put(KEY_MGRPCD, mgrpcds);
        amap.put(KEY_MTYPCD, mtypcds);
        return amap;
    }
    
    private static void setDivision(Material_General_Data__c mgd,
                                    Material_General_Data2__c mgd2,
                                    Map<String, SAP_Sales_Division__c> sdmap) {
        String divCode = mgd.Division_Code__c;
        if (!isNull(divCode) && sdmap.containsKey(divCode)) {
            SAP_Sales_Division__c sd = sdmap.get(divCode);
            mgd2.Division_Code__c = divCode;
            mgd2.Division_Id__c = sd.Id;
        }
    }
    
    private static void setBaseUOM(Material_General_Data__c mgd,
                                   Material_General_Data2__c mgd2,
                                   Map<String, String> umap) {
        if (!isNull(mgd.Base_UOM__c) && umap.containsKey(mgd.Base_UOM__c)) {
            SAP_UOM_Description__c buom = new SAP_UOM_Description__c();
            buom.UOM_Code__c = umap.get(mgd.Base_UOM__c);
            mgd2.Base_UOM_Code__r = buom;
        }
    }
    
    private static void setWeightUOM(Material_General_Data__c mgd,
                                     Material_General_Data2__c mgd2,
                                     Map<String, String> umap) {
        String uom = mgd.Weight_Unit__c;
        if (isNull(uom)) {
            uom = mgd.Base_UOM__c;
        }
        if (!isNull(uom) && umap.containsKey(uom)) {
            SAP_UOM_Description__c wuom = new SAP_UOM_Description__c();
            wuom.UOM_Code__c = umap.get(uom);
            mgd2.Weight_UOM_Code__r = wuom;
        }
    }
    
    private static void setBaseCode(Material_General_Data__c mgd,
                                    Material_General_Data2__c mgd2,
                                    Map<String, Material_Base_Code__c> bmap) {
        String s = mgd.Base_Code__c;
        if (!isNull(s) && bmap.containsKey(s)) {
            Material_Base_Code__c mbc = bmap.get(s);
            mgd2.Material_Base_Code__c = mbc.Id;
        }
    }
    
    private static void setContainerCode(Material_General_Data__c mgd,
                                         Material_General_Data2__c mgd2,
                                         Map<String, Material_Container_Code__c> cmap) {
        String s = mgd.Container_Code__c;
        if (!isNull(s) && cmap.containsKey(s)) {
            Material_Container_Code__c mcc = cmap.get(s);
            mgd2.Material_Container_Code__c = mcc.Id;
        }
    }
    
    private static void setDescription(Material_General_Data__c mgd,
                                       Material_General_Data2__c mgd2,
                                       Map<String, Material_Description__c> dmap) {
        String s = mgd.Material_Number__c;
        if (!isNull(s) && dmap.containsKey(s)) {
            Material_Description__c md = dmap.get(s);
            mgd2.Material_Desc_Code__c = md.Id;
        }
    }
    
    private static void setGroup(Material_General_Data__c mgd,
                                 Material_General_Data2__c mgd2,
                                 Map<String, Material_Group__c> gmap) {
        String s = mgd.Material_Group_Code__c;
        if (!isNull(s) && gmap.containsKey(s)) {
            Material_Group__c mg = gmap.get(s);
            mgd2.Material_Group_Code__c = mg.Id;
        }
    }
    
    private static void setType(Material_General_Data__c mgd,
                                Material_General_Data2__c mgd2,
                                Map<String, Material_Type__c> tmap) {
        String s = mgd.Material_Type_Code__c;
        if (!isNull(s) && tmap.containsKey(s)) {
            Material_Type__c mt = tmap.get(s);
            mgd2.Material_Type_Code__c = mt.Id;
        }
    }
    
    public static List<Material_General_Data2__c> getMaterialGeneralData2s(List<String> matnums) {
        List<Material_General_Data2__c> mgd2a = [select id, 
                                                        Division_Desc__c,
                                                        Marked_for_deletion__c,
                                                        Material_BaseCode__c,
                                                        Material_Base_Code_Desc__c,
                                                        Material_Number__c
                                                   from Material_General_Data2__c
                                                  where Material_Number__c in :matnums
                                                ];
        if (mgd2a == null || mgd2a.isEmpty()) {
            return null;
        }
        return mgd2a;
    }
    
    public static Map<String, Material_General_Data2__c> getMaterialGeneralData2Map(List<String> matnums) {
        Map<String, Material_General_Data2__c> amap = new Map<String, Material_General_Data2__c>();
        List<Material_General_Data2__c> mgd2a = getMaterialGeneralData2s(matnums);
        if (mgd2a == null || mgd2a.isEmpty()) {
            return amap;
        }
        for (Material_General_Data2__c m : mgd2a) {
            amap.put(m.Material_Number__c, m);
        }
        return amap;
    }
    
    public static Set<Id> getMaterialGeneralData2Ids(List<String> matnums) {
        List<Material_General_Data2__c> mgd2a = getMaterialGeneralData2s(matnums);
        if (mgd2a == null || mgd2a.isEmpty()) {
            return null;
        }
        return getMaterialGeneralData2Ids(mgd2a);
    }
    
    public static Set<Id> getMaterialGeneralData2Ids(List<Material_General_Data2__c> mgd2a) {
        Set<Id> mgd2Ids = new Set<Id>();
        for (Material_General_Data2__c mgd2 : mgd2a) {
            mgd2Ids.add(mgd2.id);
        }
        return mgd2Ids;
    }
    
/*
 **********************************************************
 Test Methods
 ********************************************************** 
 */    

    public static testMethod void testMe() {
        Test.startTest();
        test01();
        Test.stopTest();
    }
    
    private static void test01() {
        String lc = 'E';
        Material_General_Data__c mgd = new Material_General_Data__c();
        Material_Description__c md = new Material_Description__c();
        md.Language_Code__c = lc;
        md.Material_Number__c = '000000000123456789';
        insert md;
        mgd.Material_Number__c = md.Material_Number__c;
        mgd.Gross_Weight__c = 1.075;
        mgd.Net_Weight__c = 1.000;
        mgd.Base_UOM__c = 'ABC';
        Material_Base_Code__c bc = new Material_Base_Code__c();
        bc.Material_Base_Code__c = '12345678';
        insert bc; 
        mgd.Base_Code__c = bc.Material_Base_Code__c;
        Material_Container_Code__c cc = new Material_Container_Code__c();
        cc.Material_Container_Code__c = '12345';
        insert cc;
        mgd.Container_Code__c = cc.Material_Container_Code__c;
        Material_Group__c mg = new Material_Group__c();
        mg.Language_Code__c = lc;
        mg.Material_Group_Code__c = '1234';
        insert mg;
        mgd.Material_Group_Code__c = mg.Material_Group_Code__c;
        Material_Type__c mt = new Material_Type__c();
        mt.Language_Code__c = lc;
        mt.Material_Type_Code__c = 'ABCD';
        insert mt;
        mgd.Material_Type_Code__c = mt.Material_Type_Code__c;
        insert mgd;
        testInsert_Material_General_Data2(mgd);
        getMaterialGeneralData2Ids(new List<String>{'000000000123456789'});
        getMaterialGeneralData2Map(new List<String>{'000000000123456789'});
        mgd.Marked_for_deletion__c = 'X';
        update mgd;
    }
    
    private static void testInsert_Material_General_Data2(Material_General_Data__c mgd) {
        List<Material_General_Data__c> alist = new List<Material_General_Data__c>{mgd};
        Map<String, String> umap = new Map<String, String> {'ABC' => 'ABC'};
        List<Material_General_Data2__c> blist = getMaterial_General_Data2(alist, umap);
        upsert_Material_General_Data2(blist);
    }
    
}