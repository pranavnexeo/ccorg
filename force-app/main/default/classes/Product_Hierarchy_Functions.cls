public with sharing class Product_Hierarchy_Functions {

    static Map<String, String> DCHAN_PH1_MAP = new Map<String, String>{'10'=>'I',
                                                                       '20'=>'T',
                                                                       '30'=>'D',
                                                                       '40'=>'V',
                                                                       '50'=>'F',
                                                                       '99'=>'!'};

    // temporary lists just for 04/05/2010 go-live                                                                       
    static Set<String> PH5_SET = new Set<String>{
        '361',
        '362',
        'B00',
        'B01',
        'B02',
        'B04',
        'B05',
        'B06'
    };
    
    static Set<String> PH6_SET = new Set<String>{
        '016',
        '030',
        '033',
        '034',
        '071',
        '103',
        '124',
        '245',
        '366',
        '374',
        '491',
        '542',
        '544',
        '545',
        '546',
        '626',
        '723',
        '724',
        '725',
        '726',
        '727',
        '728',
        '729',
        '730',
        '731',
        '733',
        '734',
        '735',
        '736',
        '737',
        '738',
        '754'
    };
    
    public static void upsert_Product_Hierarchy2(Set<String> pha) {
        if (pha == null || pha.isEmpty()) {
            return;
        }
        List<Product_Hierarchy2__c> alist = new List<Product_Hierarchy2__c>();
        Product_Hierarchy2__c obj;
        Product_Hierarchy__c ph1, ph2, ph3, ph4, ph5, ph6, ph7;
        for (String ph : pha) {
            obj = new Product_Hierarchy2__c();
            obj.Product_Hierarchy__c = ph;
            
            if (ph.length() > 0) {
                ph1 = new Product_Hierarchy__c();
                ph1.Product_Hierarchy_Code__c = ph.substring(0,1) ;//+ 'G2';
                obj.Product_Hierarchy1__r = ph1;
            }
        
            if (ph.length() > 2) {
                ph2 = new Product_Hierarchy__c();
                ph2.Product_Hierarchy_Code__c = ph.substring(0,3)  ;//+ 'G2';
                obj.Product_Hierarchy2__r = ph2;
            }
        
            if (ph.length() > 5) {
                ph3 = new Product_Hierarchy__c();
                ph3.Product_Hierarchy_Code__c = ph.substring(0,6)  ;//+ 'G2';
                obj.Product_Hierarchy3__r = ph3;
            }
        
            if (ph.length() > 8) {
                ph4 = new Product_Hierarchy__c();
                ph4.Product_Hierarchy_Code__c = ph.substring(0,9) ;//+ 'G2';
                obj.Product_Hierarchy4__r = ph4;
            }
        
            if (ph.length() > 11) {
                ph5 = new Product_Hierarchy__c();
                ph5.Product_Hierarchy_Code__c = ph.substring(0,12) ;//+ 'G2';
                obj.Product_Hierarchy5__r = ph5;
            }
        
            if (ph.length() > 14) {
                ph6 = new Product_Hierarchy__c();
                ph6.Product_Hierarchy_Code__c = ph.substring(0,15) ;//+ 'G2';
                obj.Product_Hierarchy6__r = ph6;
            }
        
            if (ph.length() > 17) {
                ph7 = new Product_Hierarchy__c();
                ph7.Product_Hierarchy_Code__c = ph  ;//+ 'G2';
                obj.Product_Hierarchy7__r = ph7;
            }
            
            alist.add(obj);
        }
        
        List<Database.Upsertresult> ur =  new List<Database.Upsertresult>();
        try {
            ur = Database.upsert(alist, Product_Hierarchy2__c.Product_Hierarchy__c, false);
        } catch(DmlException de) {
            System.debug(de.getMessage());
        } finally {
            //DebugLog_Functions.logUpsertErrors(className, 'upsert_Product_Hierarchy2', ur);
        }
    }
    
    public static Map<String, Product_Hierarchy2__c> getProdHerkyMap(Set<String> aset) {
        Map<String, Product_Hierarchy2__c> amap = new Map<String, Product_Hierarchy2__c>();
        for (List<Product_Hierarchy2__c> alist : [select Id,
                                                         PH1__c, PH1_Division__c,
                                                         PH2__c, PH2_Line__c,
                                                         PH3__c, PH3_Group__c,
                                                         PH4__c, PH4_Supplier__c,
                                                         PH5__c, PH5_Family__c,
                                                         PH6__c, PH6_Segment__c,
                                                         PH7__c, PH7_SubSegment__c, 
                                                         Product_Hierarchy__c
                                                    from Product_Hierarchy2__c
                                                   where Product_Hierarchy__c in :aset     
                                                 ]) {
            for (Product_Hierarchy2__c obj : alist) {
                amap.put(obj.Product_Hierarchy__c, obj);  
            }                                    
        }
        return amap;
    }
    
    public static Map<String, String> getProductSegmentMap(Set<String> ph6s) {
        Map<String, String> amap = new Map<String, String>();
        for (List<Product_Hierarchy2__c> alist : [select PH6__c, PH6_Segment__c
                                                    from Product_Hierarchy2__c
                                                   where PH6__c in :ph6s
                                                   order by PH6__c
                                                 ]) {
            for (Product_Hierarchy2__c obj : alist) {
                if (!amap.containsKey(obj.PH6__c)) {
                    amap.put(obj.PH6__c, obj.PH6_Segment__c);
                }  
            }                                    
        }
        if (amap.isEmpty()) {
            return null;
        }
        return amap;
    }
    
    public static Map<String, String> getProductFamilyMap(Set<String> ph5s) {
        Map<String, String> amap = new Map<String, String>();
        for (List<Product_Hierarchy2__c> alist : [select PH5__c, PH5_Family__c
                                                    from Product_Hierarchy2__c
                                                   where PH5__c in :ph5s
                                                   order by PH5__c
                                                 ]) {
            for (Product_Hierarchy2__c obj : alist) {
                if (!amap.containsKey(obj.PH5__c)) {
                    amap.put(obj.PH5__c, obj.PH5_Family__c);
                }  
            }                                    
        }
        if (amap.isEmpty()) {
            return null;
        }
        return amap;
    }
    
    public static List<Product_Hierarchy__c> getProductFamilies(String distChan,
                                                                String prodSegment) {
        return getProductFamilies(distChan, new List<String>{prodSegment});
    }
    
    public static List<Product_Hierarchy__c> getProductFamilies(String distChan,
                                                                List<String> prodSegments) {
        String ph1 = null;
        if (DCHAN_PH1_MAP.containsKey(distChan)) {
            ph1 = DCHAN_PH1_MAP.get(distChan);
        } else {
            return null;
        }
        Map<String, String> amap = new Map<String, String>();
        for (List<Product_Hierarchy2__c> alist : [select PH5__c, PH5_Family__c,
                                                         PH6__c, PH6_Segment__c
                                                    from Product_Hierarchy2__c
                                                   where PH1__c = :ph1
                                                     and PH6__c in :prodSegments
                                                     and PH5__c in :PH5_SET     
                                                 ]) {
            for (Product_Hierarchy2__c obj : alist) {
                amap.put(obj.PH5__c, obj.PH5_Family__c);  
            }                                    
        }
        if (amap.isEmpty()) {
            return null;
        }
        List<Product_Hierarchy__c> plist = new List<Product_Hierarchy__c>();
        for (String k : amap.keySet()) {
            Product_Hierarchy__c ph = new Product_Hierarchy__c();
            ph.Product_Hierarchy_Code__c = k;
            ph.Product_Hierarchy_Description__c = amap.get(k);
            plist.add(ph);
        }
        return plist;
    }
    
    public static List<Product_Hierarchy__c> getProductSegments(String distChan) {
        String ph1 = null;
        if (DCHAN_PH1_MAP.containsKey(distChan)) {
            ph1 = DCHAN_PH1_MAP.get(distChan);
        } else {
            return null;
        }
        Map<String, String> amap = new Map<String, String>();
        for (List<Product_Hierarchy2__c> alist : [select PH6__c, PH6_Segment__c
                                                    from Product_Hierarchy2__c
                                                   where PH1__c = :ph1
                                                     and PH6__c in :PH6_SET     
                                                 ]) {
            for (Product_Hierarchy2__c obj : alist) {
                amap.put(obj.PH6__c, obj.PH6_Segment__c);  
            }                                    
        }
        if (amap.isEmpty()) {
            return null;
        }
        List<Product_Hierarchy__c> plist = new List<Product_Hierarchy__c>();
        for (String k : amap.keySet()) {
            Product_Hierarchy__c ph = new Product_Hierarchy__c();
            ph.Product_Hierarchy_Code__c = k;
            ph.Product_Hierarchy_Description__c = amap.get(k);
            plist.add(ph);
        }
        return plist;
    }
    
    
/*
 **********************************************************
 Test Methods are in Product_Hierarchy_Functions_Test class
 ********************************************************** 
 */    

}