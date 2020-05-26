public with sharing class Material_Sales_Data_Functions {

    private static String className = 'Material_Sales_Data_Functions';

    private static String KEY_MATGR1 = 'KEY_MATGR1';
    private static String KEY_MATGR2 = 'KEY_MATGR2';
    private static String KEY_MATGR3 = 'KEY_MATGR3';
    private static String KEY_MATGR4 = 'KEY_MATGR4';
    private static String KEY_MATGR5 = 'KEY_MATGR5';
    private static String KEY_MATNUM = 'KEY_MATNUM';
    private static String KEY_PHERKY = 'KEY_PHERKY';
    
    private static String DIST_CHAN_WT = '10';
    private static String DIST_CHAN_PM = '20';
    private static String DIST_CHAN_AD = '30';
    private static String DIST_CHAN_VA = '40';
    private static String DIST_CHAN_AQ = '50';
    private static Set<String> DCHANS = new Set<String>{DIST_CHAN_WT, DIST_CHAN_PM, DIST_CHAN_AD, DIST_CHAN_VA, DIST_CHAN_AQ};

    private static Integer MAT_NAME_MAX_LENGTH = 70;

    private static String MAT_TYPE_EQUIP = 'EQUIP';
    private static String MAT_TYPE_SRVCE = 'SRVCE';
    private static String ITEM_CATEGORY_SRVCE = 'ZSER';

    private static Map<String, Id> msd2RecTypeIds = null; 
        
    private static Map<String, String> uomCodes = null;

    private static Map<String, List<String>> sapgids = null;

    private static Map<String, SAP_Sales_Org__c> sorgmap = null;

    private static Map<String, SAP_Distribution_Channel__c> dchanmap = null;
    
   @TestVisible private static void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>>>>> ' + s);
    }

    public static void upsert_Material_Sales_Data2(Material_Sales_Data__c[] msda) {
        Map<String, Set<String>> fieldValues = getFieldValues(msda);
        Set<String> matgr1s = fieldValues.get(KEY_MATGR1);
        Set<String> matgr2s = fieldValues.get(KEY_MATGR2);
        Set<String> matgr3s = fieldValues.get(KEY_MATGR3);
        Set<String> matgr4s = fieldValues.get(KEY_MATGR4);
        Set<String> matgr5s = fieldValues.get(KEY_MATGR5);
        Set<String> matnums = fieldValues.get(KEY_MATNUM);
        Set<String> pherkys = fieldValues.get(KEY_PHERKY);
        Product_Hierarchy_Functions.upsert_Product_Hierarchy2(pherkys);
        List<Material_Sales_Data2__c> alist = getMaterial_Sales_Data2(msda, matnums, pherkys, matgr1s, matgr2s, matgr3s, matgr4s, matgr5s);
        system.debug(alist);
        List<Database.Upsertresult> ur =  new List<Database.Upsertresult>();
        try {
            ur = Database.upsert(alist, Material_Sales_Data2__c.Record_Key__c, false);
            system.debug(ur);
        } catch(DmlException de) {
            System.debug(de.getMessage());
            
        } finally {
            //DebugLog_Functions.logUpsertErrors(className, 'upsert_Material_Sales_Data2', ur);
        }
    }
    
    public static void createSharingRecords(Material_Sales_Data2__c[] msd2a) {
        String accessLevel = 'Read';
        String rowCause = Schema.Material_Sales_Data2__share.RowCause.SalesAreaGroup__c;
        List<Material_Sales_Data2__share> msd2Shares = new List<Material_Sales_Data2__share>();
        List<String> msd2ids = new List<String>();
        if (sapgids == null) {
            sapgids = Public_Group_Functions.getSalesAreaPublicGroupIds();
        }
        for(Material_Sales_Data2__c msd2 : msd2a) {
            msd2ids.add(msd2.id);
            String so = msd2.Sales_Org_Code__c;
            String dc = msd2.Dist_Channel_Code__c;
            List<String> groupids = sapgids.get(so + dc);
            if (groupids == null) {
                continue;
            }
            for(String gid : groupids) {
                Material_Sales_Data2__share share = getMsd2share(msd2.id, gid, 
                                                                 accessLevel, rowCause); 
                msd2Shares.add(share);
            }
        }
        deleteSharingRecords(msd2ids, accessLevel, rowCause);
        List<Database.Saveresult> sr = new List<Database.Saveresult>();
        try {
            sr = Database.insert(msd2Shares, false);
        } catch(DmlException de) {
            System.debug(de.getMessage());
        } finally {
            //DebugLog_Functions.logInsertErrors(className, 'createSharingRecords', sr);
        }
    }
    
    public static Material_Sales_Data2__share getMsd2share(String parentId,
                                                           String groupId,
                                                           String accessLevel,
                                                           String rowCause) {
        Material_Sales_Data2__share share = new Material_Sales_Data2__share();
        share.AccessLevel = accessLevel;
        share.ParentId = parentId;
        share.RowCause = rowCause;
        share.UserOrGroupId = groupId;
        return share;
    }
    
    public static void SyncProducts(Material_Sales_Data2__c[] msd2a){
      Set<String> msd2keys = new Set<String>();
      Set<String> prodkeys = new Set<String>();
      Set<String> nosync = new set<String>{'ownerid', 'recordtypeid', 'id'};
      Map<String, Product2>prods = new Map<String, Product2>();
      
      
      Schema.DescribeSObjectResult r = Material_Sales_Data2__c.sObjectType.getDescribe();
      Map<String,Schema.SObjectField> fieldmap = r.fields.getmap();
      
        for(Material_Sales_Data2__c msd2 : msd2a) {
            msd2keys.add(msd2.record_Key__c);
        }
      List<Product2> products = [select id, record_key__c from product2 where record_key__c IN :msd2keys];
      
        for(product2 p:products){
           prodkeys.add(p.record_key__c);
           prods.put(p.record_Key__c, p);
        }
        
        products.clear();
        for(Material_Sales_Data2__c msd2: msd2a){
          product2 p = new product2();
          if(prodkeys.contains(msd2.record_key__c)){
             p = prods.get(msd2.record_key__c);
          } 
          for(String f:fieldmap.keyset()){
            Schema.DescribeFieldResult DFR = fieldmap.get(f).getdescribe();
            
            if( !nosync.contains(f) && DFR.isUpdateable() == true ){
             system.debug('Field: ' + f);
             system.debug('Value: ' + msd2.get(f));
             p.put(f, msd2.get(f));
             }
          }
          products.add(p);
        }
        if(products.size() != 0){
        upsert products;}
    }
    
   @TestVisible private static void deleteSharingRecords(List<String> parentIds,
                                             String accessLevel,
                                             String rowCause) {
        List<Database.DeleteResult> dr = new List<Database.DeleteResult>();
        String rowc = Schema.Material_Sales_Data2__share.RowCause.SalesAreaGroup__c;
        for(List<Material_Sales_Data2__share> alist : [select id 
                                                         from Material_Sales_Data2__share
                                                        where ParentId in :parentIds
                                                          and AccessLevel = :accessLevel
                                                          and RowCause = :rowCause
                                                      ]){
            try {
                dr = Database.delete(alist);
            } catch(DmlException de) {
                System.debug(de.getMessage());
            }
        }
    }
    
   @TestVisible private static Map<String, Set<String>> getFieldValues(Material_Sales_Data__c[] msda) {
        Map<String, Set<String>> amap = new Map<String, Set<String>>();
        Set<String> matnums = new Set<String>();
        Set<String> pherkys = new Set<String>();
        Set<String> matgr1s = new Set<String>();
        Set<String> matgr2s = new Set<String>();
        Set<String> matgr3s = new Set<String>();
        Set<String> matgr4s = new Set<String>();
        Set<String> matgr5s = new Set<String>();
        for(Material_Sales_Data__c msd : msda) {
            matnums.add(msd.Material_Number__c);
            if (msd.Product_Hierarchy__c != null) {pherkys.add(msd.Product_Hierarchy__c);}
            if (msd.Material_Group1__c != null) {matgr1s.add(msd.Material_Group1__c);}
            if (msd.Material_Group2__c != null) {matgr2s.add(msd.Material_Group2__c);}
            if (msd.Material_Group3__c != null) {matgr3s.add(msd.Material_Group3__c);}
            if (msd.Material_Group4__c != null) {matgr4s.add(msd.Material_Group4__c);}
            if (msd.Material_Group5__c != null) {matgr5s.add(msd.Material_Group5__c);}
        }
        amap.put(KEY_MATNUM, matnums);
        amap.put(KEY_PHERKY, pherkys);
        amap.put(KEY_MATGR1, matgr1s);
        amap.put(KEY_MATGR2, matgr2s);
        amap.put(KEY_MATGR3, matgr3s);
        amap.put(KEY_MATGR4, matgr4s);
        amap.put(KEY_MATGR5, matgr5s);
        return amap;
    }
    
   @TestVisible private static Map<String, String> getBaseUOMs(Set<String> mns) {
        Map<String, String> baseUOMs = new Map<String, String>();
        List<Material_General_Data2__c> mgdList = [select Material_Number__c, 
                                                          Base_UOM_Code__r.UOM_Code__c 
                                                     from Material_General_Data2__c
                                                    where Material_Number__c in :mns];
                                                            
        for(Material_General_Data2__c mgd : mgdList) {
            String mnum = mgd.Material_Number__c;
            String buom = mgd.Base_UOM_Code__r.UOM_Code__c;
            baseUOMs.put(mnum, buom);
        }                                            
        return baseUOMs;
    }
    
   @TestVisible private static List<Material_Sales_Data2__c> getMaterial_Sales_Data2(Material_Sales_Data__c[] msda,
                                                                         Set<String> matnums,
                                                                         Set<String> pherkys,
                                                                         Set<String> matgr1s,
                                                                         Set<String> matgr2s,
                                                                         Set<String> matgr3s,
                                                                         Set<String> matgr4s,
                                                                         Set<String> matgr5s) {
        List<Material_Sales_Data2__c> alist = new List<Material_Sales_Data2__c>();
        SAP_Sales_Org__c org;
        SAP_Distribution_Channel__c dch;
        Material_General_Data2__c mgd2;
        Material_Sales_Data2__c msd2;
        List<String> matnumList = new List<String>();
        matnumList.addAll(matnums);
        Map<String, Product_Hierarchy2__c> phmap = Product_Hierarchy_Functions.getProdHerkyMap(pherkys);
        Map<String, Material_Description__c> matDescs = Material_Description_Functions.getMaterialDescriptionMap(matnums);                                 
        Map<String, Material_General_Data2__c> mgd2map = Material_General_Data_Functions.getMaterialGeneralData2Map(matnumList);                                 
        Map<String, String> baseUOMs = getBaseUOMs(matnums);                                 
        Map<String, Material_UOM2__c> altUOMs = Material_UOM_Functions.getAltUoms(matnums);                                 
        Map<String, Material_Pricing_Group1__c> mgr1map = getMaterialGroup1s(matgr1s);
        Map<String, Material_Pricing_Group2__c> mgr2map = getMaterialGroup2s(matgr2s);
        Map<String, Material_Pricing_Group3__c> mgr3map = getMaterialGroup3s(matgr3s);
        Map<String, Material_Pricing_Group4__c> mgr4map = getMaterialGroup4s(matgr4s);
        Map<String, Material_Pricing_Group5__c> mgr5map = getMaterialGroup5s(matgr5s);

        if (sorgmap == null) {sorgmap = SAP_Queries_Functions.getSapSalesOrgMap();}
        if (dchanmap == null) {dchanmap = SAP_Queries_Functions.getSapDistChanMap();}
        if (uomCodes == null) {uomCodes = Material_UOM_Functions.getUOMCodes();}
        
        for (Material_Sales_Data__c msd : msda) {
            String so = msd.Sales_Org__c;
            String dc = msd.Distribution_Channel__c;
            String matnum = msd.Material_Number__c;
            Boolean b = sorgmap.containsKey(so) && 
                        dchanmap.containsKey(dc) &&
                        DCHANS.contains(dc) &&
                        mgd2map.containsKey(matnum);
            if (!b) {continue;}
            
            String matname = getMaterialName(matnum, matDescs);
            String pg = msd.Material_Pricing_Group__c;
            String df = msd.Deletion_Flag__c;
            String rk = msd.Record_Key__c;
            Double moq = msd.Minimum_Order_Qty__c;
            String suom = msd.Sales_Unit__c;
            system.debug('suom:' + suom);
            if (isNull(suom)) {
                suom = baseUOMs.get(matnum);
            } else if (isNull(suom) && uomCodes.containsKey(suom)) {
                suom = uomCodes.get(suom);
            }
            system.debug('suom:' + suom);
            msd2 = new Material_Sales_Data2__c();
            msd2.Name = matname;
            msd2.Material_Number__c = matnum;
            msd2.Sales_Org_Code__c = so;
            msd2.Dist_Channel_Code__c = dc;
            msd2.Record_Key__c = rk;
            msd2.Deletion_Flag__c = df;
            
            org = sorgmap.get(so);
            msd2.SalesOrg_Code__c = org.Id;
            system.debug('record key:' + rk);
            system.debug('org id: ' + org.id);

            dch = dchanmap.get(dc);
            msd2.DistChannel_Code__c = dch.Id;

            setMaterialGeneralData(msd, msd2, mgd2map);
            
            setProductHierarchy(msd, msd2, phmap);
            
            setRecordType(msd, msd2);

            msd2.Minimum_Order_Qty__c = moq;
            msd2.Material_Pricing_Group__c = pg;
        
            setUOM(msd, msd2, altUOMs, suom);
            
            setMaterialGroups(msd, msd2, mgr1map, mgr2map, mgr3map, mgr4map, mgr5map);
            
            alist.add(msd2);
        }
        return alist;
    }
    
   @TestVisible private static String getMaterialName(String matnum,
                                          Map<String, Material_Description__c> matDescs) {
        String matnum2 = String_Functions.removeLeadingZeros(matnum);
        String s = matnum2;
        if (matDescs.containsKey(matnum)) {
            Material_Description__c md = matDescs.get(matnum);
            s = md.Material_Description__c;
            s = s.trim();
            if (s.length() > MAT_NAME_MAX_LENGTH) {
                s = s.substring(0, MAT_NAME_MAX_LENGTH);
            }
            s += (' - ' + matnum2);
        }
        return s;
    }
    
   @TestVisible private static Map<String, Id> getMsd2RecTypeIdMap() {
        Map<String, Id> rmap = new Map<String, Id>();
        Map<String, Id> nmap = RecordType_Functions.RetrieveRecordTypeNameMap('Material_Sales_Data2__c');
        rmap.put(DIST_CHAN_WT, nmap.get('WaterTechnology'));
        rmap.put(DIST_CHAN_PM, nmap.get('PerformanceMaterial'));
        rmap.put(DIST_CHAN_AD, nmap.get('Distribution'));
        rmap.put(DIST_CHAN_VA, nmap.get('Valvoline'));
        rmap.put(DIST_CHAN_AQ, nmap.get('Aqualon'));
        rmap.put(MAT_TYPE_SRVCE, nmap.get('ServiceMaterial'));
        rmap.put(MAT_TYPE_EQUIP, nmap.get('Equipment'));
        return rmap;
    }
    
   @TestVisible private static Id getMsd2RecTypeId(String s) {
        if (msd2RecTypeIds == null) {
            msd2RecTypeIds = getMsd2RecTypeIdMap();
        }
        Id recTypeId = msd2RecTypeIds.get(s);
        return recTypeId;
    }
    
   @TestVisible private static boolean isNull(String s) {
        return (s == null || s.trim().length() == 0);
    }
    
   @TestVisible private static void setMaterialGeneralData(Material_Sales_Data__c msd,
                                               Material_Sales_Data2__c msd2,
                                               Map<String, Material_General_Data2__c> mgd2map) {
        String s = msd.Material_Number__c;
        if (!isNull(s) && mgd2map.containsKey(s)) {
            Material_General_Data2__c mgd2 = mgd2map.get(s);
            msd2.Material_General_Data__c = mgd2.Id;
            msd2.Material_Base_Code__c = mgd2.Material_BaseCode__c;
            msd2.Material_Base_Code_Desc__c = mgd2.Material_Base_Code_Desc__c;
            msd2.Division_Desc__c = mgd2.Division_Desc__c;
        }
    }
    
   @TestVisible private static void setProductHierarchy(Material_Sales_Data__c msd,
                                            Material_Sales_Data2__c msd2,
                                            Map<String, Product_Hierarchy2__c> phmap) {
        String s = msd.Product_Hierarchy__c;
        if (!isNull(s) && phmap.containsKey(s)) {
            Product_Hierarchy2__c ph2 = phmap.get(s);
            msd2.Product_Hierarchy__c   = ph2.Id;
            msd2.PH1_Division__c        = ph2.PH1_Division__c;
            msd2.PH1_Division_Code__c   = ph2.PH1__c;
            msd2.PH2_Line__c            = ph2.PH2_Line__c;
            msd2.PH2_Line_Code__c       = ph2.PH2__c;
            msd2.PH3_Group__c           = ph2.PH3_Group__c;
            msd2.PH3_Group_Code__c      = ph2.PH3__c;
            msd2.PH4_Supplier__c        = ph2.PH4_Supplier__c;
            msd2.PH4_Supplier_Code__c   = ph2.PH4__c;
            msd2.PH5_Family__c          = ph2.PH5_Family__c;
            msd2.PH5_Family_Code__c     = ph2.PH5__c;
            msd2.PH6_Segment__c         = ph2.PH6_Segment__c;
            msd2.PH6_Segment_Code__c    = ph2.PH6__c;
            msd2.PH7_SubSegment__c      = ph2.PH7_SubSegment__c;
            msd2.PH7_SubSegment_Code__c = ph2.PH7__c;
        }
    }
    
   @TestVisible private static void setRecordType(Material_Sales_Data__c msd,
                                      Material_Sales_Data2__c msd2) {
        String dc = msd.Distribution_Channel__c;
        String ph = msd.Product_Hierarchy__c;
        String ic = msd.Item_Category_Group__c;
        Id recTypeId = getMsd2RecTypeId(dc);
        if (!isNull(ic) && ITEM_CATEGORY_SRVCE.equals(ic)) {
            recTypeId = getMsd2RecTypeId(MAT_TYPE_SRVCE);
        } else if (!isNull(ph) && ph.trim().length() > 11) {
            String s1 = ph.substring(0,3);
            String s2 = ph.substring(9,12);
            if ('I50'.equals(s1) && '362'.equals(s2)) {
                recTypeId = getMsd2RecTypeId(MAT_TYPE_EQUIP);
            }
        }
        msd2.RecordTypeId = recTypeId;
    }
    
   @TestVisible private static void setUOM(Material_Sales_Data__c msd,
                               Material_Sales_Data2__c msd2,
                               Map<String, Material_UOM2__c> altUOMs,
                               String suom) {
        String s = msd.Material_Number__c + suom;
        system.debug('uom key: ' + s);
        if (!isNull(suom) && altUOMs.containsKey(s)) {
            Material_UOM2__c uom2 = altUOMs.get(s);
            msd2.Sales_UOM__c = uom2.Id;
        }
    }
    
   @TestVisible private static void setMaterialGroups(Material_Sales_Data__c msd,
                                          Material_Sales_Data2__c msd2,
                                          Map<String, Material_Pricing_Group1__c> mgr1map,
                                          Map<String, Material_Pricing_Group2__c> mgr2map,
                                          Map<String, Material_Pricing_Group3__c> mgr3map,
                                          Map<String, Material_Pricing_Group4__c> mgr4map,
                                          Map<String, Material_Pricing_Group5__c> mgr5map) {
        String mgr1 = msd.Material_Group1__c;
        if (mgr1 != null) {
            msd2.Material_Group1_Code__c = mgr1;
            if (mgr1map.containsKey(mgr1)) {
                Material_Pricing_Group1__c mpg1 = mgr1map.get(mgr1);
                msd2.Material_Group1_Desc__c = mpg1.Material_Pricing_Group1_Description__c;
            }
        }else{
          msd2.Material_group1_Code__c = '';
          msd2.Material_Group1_Desc__c = '';
          }
        String mgr2 = msd.Material_Group2__c;
        if (mgr2 != null) {
            msd2.Material_Group2_Code__c = mgr2;
            if (mgr2map.containsKey(mgr2)) {
                Material_Pricing_Group2__c mpg2 = mgr2map.get(mgr2);
                msd2.Material_Group2_Desc__c = mpg2.Material_Pricing_Group2_Description__c;
            }
        }else{
          msd2.Material_group2_Code__c = '';
          msd2.Material_Group2_Desc__c = '';
          }
        String mgr3 = msd.Material_Group3__c;
        if (mgr3 != null) {
            msd2.Material_Group3_Code__c = mgr3;
            if (mgr3map.containsKey(mgr3)) {
                Material_Pricing_Group3__c mpg3 = mgr3map.get(mgr3);
                msd2.Material_Group3_Desc__c = mpg3.Material_Pricing_Group3_Description__c;
            }
        }else{
          msd2.Material_group3_Code__c = '';
          msd2.Material_Group3_Desc__c = '';
          }
        String mgr4 = msd.Material_Group4__c;
        if (mgr4 != null) {
            msd2.Material_Group4_Code__c = mgr4;
            if (mgr4map.containsKey(mgr4)) {
                Material_Pricing_Group4__c mpg4 = mgr4map.get(mgr4);
                msd2.Material_Group4_Desc__c = mpg4.Material_Pricing_Group4_Description__c;
            }
        }else{
          msd2.Material_group4_Code__c = '';
          msd2.Material_Group4_Desc__c = '';
          }
        String mgr5 = msd.Material_Group5__c;
        if (mgr5 != null) {
            msd2.Material_Group5_Code__c = mgr5;
            if (mgr5map.containsKey(mgr5)) {
                Material_Pricing_Group5__c mpg5 = mgr5map.get(mgr5);
                msd2.Material_Group5_Desc__c = mpg5.Material_Pricing_Group5_Description__c;
            }
        }else{
          msd2.Material_group5_Code__c = '';
          msd2.Material_Group5_Desc__c = '';
          }
    }
    
    public static List<SAP_UOM_Description__c> getMaterialUoms(Id msd2Id) {
        Material_Sales_Data2__c msd = getMaterialSalesData2(msd2Id);
        Id mgd2Id = msd.Material_General_Data__c;
        List<SAP_UOM_Description__c> uoms = Material_UOM_Functions.getMaterialUoms(mgd2Id);
        return uoms;
    }
    
    public static List<Material_UOM2__c> getAltUOMs(Id msd2Id) {
        Material_Sales_Data2__c msd = getMaterialSalesData2(msd2Id);
        List<Material_UOM2__c> uoms = getAltUOMs(msd);
        return uoms;
    }
    
    public static List<Material_UOM2__c> getAltUOMs(Material_Sales_Data2__c msd) {
        Id mgd2Id = msd.Material_General_Data__c;
        List<Material_UOM2__c> uoms = Material_UOM_Functions.getAltUOMs(mgd2Id);
        return uoms;
    }
    
    public static Map<Id, Material_Sales_Data2__c> getMaterialSalesData2Map(Set<id> msd2ids) {
        Map<Id, Material_Sales_Data2__c> amap = new Map<Id, Material_Sales_Data2__c>();
        List<Material_Sales_Data2__c> msd2a = getMaterialSalesData2s(msd2ids);
        return getMaterialSalesData2Map(msd2a);
    }
    
    public static Map<Id, Material_Sales_Data2__c> getMaterialSalesData2Map(List<Material_Sales_Data2__c> msd2a) {
        Map<Id, Material_Sales_Data2__c> amap = new Map<Id, Material_Sales_Data2__c>();
        if (msd2a == null || msd2a.isEmpty()) {
            return null;
        }
        for (Material_Sales_Data2__c msd : msd2a) {
            amap.put(msd.Id, msd);
        }
        return amap;
    }
    
    // Map<Material_Number__c + Plant_Code__c, Material_Plant2__c>
    public static Map<String, Material_Plant2__c> getPlantsMap(List<Material_Sales_Data2__c> msd2a) {
        return getPlantsMap(msd2a, null);
    }
    
    // Map<Material_Number__c + Plant_Code__c, Material_Plant2__c>
    public static Map<String, Material_Plant2__c> getPlantsMap(List<Material_Sales_Data2__c> msd2a,
                                                               Set<id> plantIds) {
        Set<Id> mgd2Ids = getMaterialGeneralData2Ids(msd2a);
        if (mgd2Ids == null || mgd2Ids.isEmpty()) {
            return null;
        }
        Map<String, Material_Plant2__c> amap = Material_Plant_Functions.getPlantsMap(mgd2Ids, plantIds);
        //System.debug(amap);
        if (amap == null || amap.isEmpty()) {
            return null;
        }
        return amap;
    }
    
    //Map<Material_Sales_Data2Id, List<Material_Plant2__c>>
    public static Map<Id, List<Material_Plant2__c>> getMaterialPlantMap(Set<id> msd2Ids) {
        List<Material_Sales_Data2__c> msd2a = getMaterialSalesData2s(msd2Ids);
        Set<Id> mgd2Ids = getMaterialGeneralData2Ids(msd2a);
        Map<Id, List<Material_Plant2__c>> amap = Material_Plant_Functions.getPlantsMap(msd2a, mgd2Ids);
        return amap;
    }
                                                                 
   @TestVisible private static Set<Id> getMaterialGeneralData2Ids(Set<id> msd2ids) {
        List<Material_Sales_Data2__c> msd2a = getMaterialSalesData2s(msd2Ids);
        return getMaterialGeneralData2Ids(msd2a);
    }
    
   @TestVisible private static Set<Id> getMaterialGeneralData2Ids(List<Material_Sales_Data2__c> msd2a) {
        if (msd2a == null || msd2a.isEmpty()) {
            return null;
        }
        Set<Id> mgd2Ids = new Set<Id>();
        for (Material_Sales_Data2__c msd : msd2a) {
            mgd2Ids.add(msd.Material_General_Data__c);
        }
        return mgd2Ids;
    }
    
   @TestVisible private static Material_Sales_Data2__c getMaterialSalesData2(Id msd2Id) {
        List<Material_Sales_Data2__c> msd2a = getMaterialSalesData2s(new Set<Id>{msd2Id});
        if (msd2a != null && !msd2a.isEmpty()) {
            return msd2a[0];
        }
        return null;
    }
    
    public static List<Material_Sales_Data2__c> getMaterialSalesData2s(Set<Id> msd2Ids) {
        List<Material_Sales_Data2__c> msd2a = [select Id, Material_Number__c,
                                                      Base_UOM_Code__c, Sales_Org_Code__c, 
                                                      Material_General_Data__c,
                                                      Material_General_Data__r.Material_Base_Code_Desc__c,
                                                      Material_General_Data__r.Material_Container_Desc__c,
                                                      Product_Hierarchy__c,
                                                      Product_Hierarchy__r.PH1_Division__c,
                                                      Product_Hierarchy__r.PH1__c,
                                                      Product_Hierarchy__r.PH2_Line__c,
                                                      Product_Hierarchy__r.PH2__c,
                                                      Product_Hierarchy__r.PH3_Group__c,
                                                      Product_Hierarchy__r.PH3__c,
                                                      Product_Hierarchy__r.PH4_Supplier__c,
                                                      Product_Hierarchy__r.PH4__c,
                                                      Product_Hierarchy__r.PH5_Family__c,
                                                      Product_Hierarchy__r.PH5__c,
                                                      Product_Hierarchy__r.PH6_Segment__c,
                                                      Product_Hierarchy__r.PH6__c,
                                                      Product_Hierarchy__r.PH7_SubSegment__c,
                                                      Product_Hierarchy__r.PH7__c,
                                                      Record_Key__c,
                                                      Sales_UOM__r.Alternative_UOM__c
                                                 from Material_Sales_Data2__c
                                                where Id in :msd2Ids
                                              ];
        if (msd2a == null || msd2a.isEmpty()) {
            return null;
        }
        return msd2a;
    }
    
    public static List<Material_Plant2__c> getPlants(Id msd2Id) {
        Material_Sales_Data2__c msd = getMaterialSalesData2(msd2Id);
        List<Material_Plant2__c> plants = getPlants(msd);
        return plants;
    }
    
    public static List<Material_Plant2__c> getPlants(Material_Sales_Data2__c msd) {
        List<Material_Plant2__c> plants = Material_Plant_Functions.getPlants(msd);
        return plants;
    }
    
    public static List<Material_Plant2__c> getPlants(String matnum,
                                                     String salesOrg,
                                                     String distChan) {
        Material_Sales_Data2__c msd2 = getMaterial_Sales_Data2(matnum, salesOrg, distChan);
        if (msd2 == null) {
           return null;
        }
        return getPlants(msd2);
    }
    
   @TestVisible private static Material_Sales_Data2__c getMaterial_Sales_Data2(String matnum,
                                                                   String salesOrg,
                                                                   String distChan) {
        String recKey = matnum + salesOrg + distChan;
        debug(recKey);
        Material_Sales_Data2__c msd2 = null;
        try {
            msd2 = [select id, Material_General_Data__c,
                           DistChannel_Code__c, DistChannel_Desc__c,
                           Dist_Channel_Code__c, Material_Number__c,
                           Product_Hierarchy__c, Record_Key__c,
                           SalesOrg_Code__c, SalesOrg_Desc__c,
                           Sales_Org_Code__c
                      from Material_Sales_Data2__c
                     where Record_Key__c = :recKey
                     limit 1];
        } catch(Exception e) {}
        return msd2;
    }
    
   @TestVisible private static Map<String, Material_Pricing_Group1__c> getMaterialGroup1s(Set<String> matgr1s) {
        Map<String, Material_Pricing_Group1__c> amap = new Map<String, Material_Pricing_Group1__c>();
        for (Material_Pricing_Group1__c m : [select Material_Pricing_Group1_Code__c,
                                                    Material_Pricing_Group1_Description__c
                                               from Material_Pricing_Group1__c
                                              where Deleted__c = false
                                                and Material_Pricing_Group1_Code__c in :matgr1s]) {
            amap.put(m.Material_Pricing_Group1_Code__c, m);
        }
        return amap;
    }
    
   @TestVisible private static Map<String, Material_Pricing_Group2__c> getMaterialGroup2s(Set<String> matgr2s) {
        Map<String, Material_Pricing_Group2__c> amap = new Map<String, Material_Pricing_Group2__c>();
        for (Material_Pricing_Group2__c m : [select Material_Pricing_Group2_Code__c,
                                                    Material_Pricing_Group2_Description__c
                                               from Material_Pricing_Group2__c
                                              where Deleted__c = false
                                                and Material_Pricing_Group2_Code__c in :matgr2s]) {
            amap.put(m.Material_Pricing_Group2_Code__c, m);
        }
        return amap;
    }
   @TestVisible private static Map<String, Material_Pricing_Group3__c> getMaterialGroup3s(Set<String> matgr3s) {
        Map<String, Material_Pricing_Group3__c> amap = new Map<String, Material_Pricing_Group3__c>();
        for (Material_Pricing_Group3__c m : [select Material_Pricing_Group3_Code__c,
                                                    Material_Pricing_Group3_Description__c
                                               from Material_Pricing_Group3__c
                                              where Deleted__c = false
                                                and Material_Pricing_Group3_Code__c in :matgr3s]) {
            amap.put(m.Material_Pricing_Group3_Code__c, m);
        }
        return amap;
    }
   @TestVisible private static Map<String, Material_Pricing_Group4__c> getMaterialGroup4s(Set<String> matgr4s) {
        Map<String, Material_Pricing_Group4__c> amap = new Map<String, Material_Pricing_Group4__c>();
        for (Material_Pricing_Group4__c m : [select Material_Pricing_Group4_Code__c,
                                                    Material_Pricing_Group4_Description__c
                                               from Material_Pricing_Group4__c
                                              where Deleted__c = false
                                                and Material_Pricing_Group4_Code__c in :matgr4s]) {
            amap.put(m.Material_Pricing_Group4_Code__c, m);
        }
        return amap;
    }
   @TestVisible private static Map<String, Material_Pricing_Group5__c> getMaterialGroup5s(Set<String> matgr5s) {
        Map<String, Material_Pricing_Group5__c> amap = new Map<String, Material_Pricing_Group5__c>();
        for (Material_Pricing_Group5__c m : [select Material_Pricing_Group5_Code__c,
                                                    Material_Pricing_Group5_Description__c
                                               from Material_Pricing_Group5__c
                                              where Deleted__c = false
                                                and Material_Pricing_Group5_Code__c in :matgr5s]) {
            amap.put(m.Material_Pricing_Group5_Code__c, m);
        }
        return amap;
    }
    
    // called from Material_General_Data_Functions.update_Material_Sales_Data2()
    public static void updateDeletionFlag(Map<Id, String> umap) {
        List<Material_Sales_Data2__c> msd2s = new List<Material_Sales_Data2__c>();
        for (Material_Sales_Data2__c msd2 : [select Id, Deletion_Flag__c,
                                                    Material_General_Data__c
                                               from Material_Sales_Data2__c
                                              where Material_General_Data__c in :umap.keySet()
                                            ]) {
            String gmfd = umap.get(msd2.Material_General_Data__c);
            String smfd = msd2.Deletion_Flag__c;
            if (gmfd == null) {gmfd = '';}
            if (smfd == null) {smfd = '';}
            gmfd = gmfd.trim();
            smfd = smfd.trim();
            if (gmfd != smfd) {
                msd2.Deletion_Flag__c = gmfd;
                msd2s.add(msd2);
            }
        }
        if (!msd2s.isEmpty()) {
            try {update msd2s;} catch(Exception e){System.debug(e);}
        }
    }
    
/*
 ************************************************************
 Test Methods are in Material_Sales_Data_Functions_Test class
 ************************************************************ 
 */    

}