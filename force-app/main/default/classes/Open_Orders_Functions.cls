public with sharing class Open_Orders_Functions {

    private static final String DELIM = ' - ';
    private static final Time ZERO_TIME = Time.newInstance(0,0,0,0);
    
    private static void debug(String s) {
    	System.debug(LoggingLevel.INFO, '>>>>>>>> ' + s);
    }
    
    public static void processBeforeUpsert(List<Open_Orders__c> olist) {
        updateFields(olist);
    }
    
    public static void processReordersBeforeUpsert(List<Reorder__c> olist) {
        updateReorderFields(olist);
    }
    
    private static void updateFields(List<Open_Orders__c> olist) {
        Map<Id, Material_Sales_Data2__c> mmap = getMaterialsMap(olist);
        Map<String, String> umap = Material_UOM_Functions.getExternalUOMCodes();
        for (Open_Orders__c o : olist) {
        	updateCurrencyCode(o);
            updateMaterialFields(o, mmap, umap);
            updateDateFields(o);
        }
    }
    
    private static void updateCurrencyCode(Open_Orders__c o) {
        if (!isNull(o.Gross_Product_Value_Currency__c)) {
        	try {o.CurrencyIsoCode = o.Gross_Product_Value_Currency__c.substring(0,3);}
        	catch(Exception e){debug(e.getMessage());}
        }
    }
    
    private static void updateMaterialFields(Open_Orders__c o,
                                             Map<Id, Material_Sales_Data2__c> mmap,
                                             Map<String, String> umap) {
        if (mmap != null && mmap.containsKey(o.Material__c)) {
            Material_Sales_Data2__c m = mmap.get(o.Material__c);
            Material_General_Data2__c g = m.Material_General_Data__r;
            Product_Hierarchy2__c p = m.Product_Hierarchy__r;
            Material_UOM2__c u = m.Sales_UOM__r;
            if (g != null) {
                o.Material_BaseCode_Desc__c = g.Material_Base_Code_Desc__c;
                o.Material_Container_Desc__c = g.Material_Container_Desc__c;
            }
            if (p != null) {
                o.PH1_Division__c = p.PH1_Division__c + DELIM + p.PH1__c;
                o.PH2_Line__c = p.PH2_Line__c + DELIM + p.PH2__c;
                o.PH3_Group__c = p.PH3_Group__c + DELIM + p.PH3__c;
                o.PH4_Supplier__c = p.PH4_Supplier__c + DELIM + p.PH4__c;
                o.PH5_Family__c = p.PH5_Family__c + DELIM + p.PH5__c;
                o.PH6_Segment__c = p.PH6_Segment__c + DELIM + p.PH6__c;
                o.PH7_SubSegment__c = p.PH7_SubSegment__c + DELIM + p.PH7__c;
            }
            if (u != null && u.Alternative_UOM__c != null && 
                umap.containsKey(u.Alternative_UOM__c)) {
                o.Sales_UOM__c = umap.get(u.Alternative_UOM__c);
            } 
        }
    }
    
    private static void updateDateFields(Open_Orders__c o) {
        o.Agreed_Ship_Date2__c = getDate(o.Agreed_Ship_Date__c);
        o.Created_Date2__c = getDate(o.Created_Date__c);
        o.Expected_Ship_Date2__c = getDate(o.Expected_Ship_Date__c);
        o.Goods_Issue_Date2__c = getDate(o.Goods_Issue_Date__c);
        o.Requested_Delivery_Date2__c = getDate(o.Requested_Delivery_Date__c);
        o.Delivery_Date2__c = getDate(o.Delivery_Date__c);
    }
    
    private static Date getDate(String s) {
        if (!isNull(s) && s.length() > 9) {
            try {
                Integer y = Integer.valueOf(s.substring(0, 4));
                Integer m = Integer.valueOf(s.substring(5, 7));
                Integer d = Integer.valueOf(s.substring(8, 10));
                if (y > 1970 && y < 2170 && m > 0 && m < 13) { 
                    return Date.newInstance(y, m, d);
                }
            } catch(Exception e) {}
        }
        return null;
    }
    
    private static Boolean isNull(String s) {
        return (s == null || s.trim().length() == 0);
    }
    
    private static Map<Id, Material_Sales_Data2__c> getMaterialsMap(List<Open_Orders__c> olist) {
        Map<Id, Material_Sales_Data2__c> mmap = new Map<Id, Material_Sales_Data2__c>();
        Set<id> mset = new Set<id>();
        for (Open_Orders__c o : olist) {
            mset.add(o.Material__c);
        }
        mmap = Material_Sales_Data_Functions.getMaterialSalesData2Map(mset);
        return mmap;
    }
    
    private static void updateReorderFields(List<Reorder__c> olist) {
        for (Reorder__c o : olist) {
            updateDateFields(o);
        }
    }
    
    private static void updateDateFields(Reorder__c o) {
        o.Expected_Ship_Date2__c = getDateText(o.Expected_Ship_Date__c);
        o.Requested_Delivery_Date2__c = getDateText(o.Requested_Delivery_Date__c);
    }
    
    private static String getDateText(Date d) {
        String s = '';
        if (d != null) {
            DateTime dt = DateTime.newInstance(d, ZERO_TIME);
            s = dt.format('MMMM dd, yyyy');
        }
        //System.debug(s);
        return s;
    }
    
}