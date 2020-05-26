public with sharing class Material_UOM_Functions {

    private static String className = 'Material_UOM_Functions';

    private static final String KG = 'KG';
    private static final String LB = 'LB';
    
    private static final String DELIM = '~';

    public static final String BASE_UOM_CODE = 'BASE_UOM_CODE';
    public static final String GLOBAL_UOM_CONVERSION_FACTORS = 'GLOBAL_UOM_CONVERSION_FACTORS';

    public static List<SAP_UOM_Code__c> sapUomCodes = null;
    
    public static List<SAP_UOM_Code__c> getSapUomCodes() {
    	if (sapUomCodes == null) {
            sapUomCodes = [Select Id, Dimension_Key__c,
                                  UOM_Code__c, ISO_Code__c, 
                                  Conversion_Field__c,
                                  SI_Unit_Conversion_Numerator__c, 
                                  SI_Unit_Conversion_Exponent__c, 
                                  SI_Unit_Conversion_Denominator__c
                             From SAP_UOM_Code__c
                            where Deleted__c = false
                              and Dimension_Key__c not in ('AAAADL', 'TEMP') 
                            order by Dimension_Key__c
                          ];
    	}
    	return sapUomCodes;
    }
    
    public static Map<String, String> getUOMCodes() {
        Map<String, String> amap = new Map<String, String>();
        for (List<SAP_UOM_Code__c> uoms : [select ISO_Code__c,
                                                  UOM_Code__c
                                             from SAP_UOM_Code__c
                                            where Deleted__c = false     
                                          ]) {
            setUOMCodeMap(amap, uoms);
        }
        return amap;
    }
    
    public static void setUOMCodeMap(Map<String, String> amap,
                                     List<SAP_UOM_Code__c> uoms) {
       for (SAP_UOM_Code__c uom : uoms) {
           if (!isNull(uom.ISO_Code__c)) {
               amap.put(uom.ISO_Code__c, uom.UOM_Code__c);  
           }        
       }                                    
    }

    public static Map<String, String> getExternalUOMCodes() {
        Map<String, String> amap = new Map<String, String>();
        for (List<SAP_UOM_Description__c> uoms : [select External_UOM__c,
                                                         UOM_Code__c
                                                    from SAP_UOM_Description__c
                                                   where Deleted__c = false     
                                                 ]) {
            setExternalUOMCodeMap(amap, uoms);
        }
        return amap;
    }
    
    private static void setExternalUOMCodeMap(Map<String, String> amap,
                                              List<SAP_UOM_Description__c> uoms) {
       for (SAP_UOM_Description__c uom : uoms) {
           if (!isNull(uom.UOM_Code__c)) {
               amap.put(uom.UOM_Code__c, uom.External_UOM__c);  
           }        
       }                                    
    }

    private static boolean isNull(String s) {
        return (s == null || s.trim().length() == 0);
    }
    
    public static void upsert_Material_UOM2(Material_UOM__c[] muoma) {
        List<Material_UOM2__c> alist = getMaterial_UOM2(muoma);
        if (alist.isEmpty()) {
            return;
        }
        upsert_Material_UOM2(alist);
    }
    
    public static void upsert_Material_UOM2(List<Material_UOM2__c> alist) {
        List<Database.Upsertresult> ur =  new List<Database.Upsertresult>();
        try {
            ur = Database.upsert(alist, Material_UOM2__c.Record_Key__c, false);
        } catch(DmlException de) {
            System.debug(de.getMessage());
        } finally {
            //DebugLog_Functions.logUpsertErrors(className, 'upsert_Material_UOM2', ur);
        }
    }

    private static List<Material_UOM2__c> getMaterial_UOM2(Material_UOM__c[] muoma) {
        List<Material_UOM2__c> alist = new List<Material_UOM2__c>();
        Map<String, String> uomCodes = getUOMCodes();
        for(Material_UOM__c muom : muoma) {
            Material_UOM2__c muom2 = getMaterial_UOM2(muom, uomCodes);
            if (muom2 != null) {
                alist.add(muom2);
            }
        }
        return alist;
    }
    
    public static Material_UOM2__c getMaterial_UOM2(Material_UOM__c muom,
                                                    Map<String, String> umap) {
        if (!umap.containsKey(muom.Alternative_UOM__c)) {
            return null;
        }
        String altUom = umap.get(muom.Alternative_UOM__c);
        Material_UOM2__c muom2 = new Material_UOM2__c();
        muom2.Material_Number__c = muom.Material_Number__c;
        muom2.Alternative_UOM__c = altUom;
        //muom2.Record_Key__c = muom.Material_Number__c + altUom;
        muom2.Record_Key__c = muom.Record_Key__c;
        muom2.Denominator__c = muom.Denominator__c;
        muom2.Numerator__c = muom.Numerator__c;
        muom2.Deleted__c = muom.Deleted__c;
                 
        Material_General_Data2__c mgd = new Material_General_Data2__c();
        mgd.Material_Number__c = muom.Material_Number__c;
        muom2.Material_General_Data__r = mgd;

        SAP_UOM_Description__c uom = new SAP_UOM_Description__c();
        uom.UOM_Code__c = altUom;
        muom2.Alt_UOM_Desc__r = uom;
        
        return muom2;
    }   
     
    public static Map<String, Material_UOM2__c> getAltUoms(Set<String> aset) {
        Map<String, Material_UOM2__c> amap = new Map<String, Material_UOM2__c>();
        for (List<Material_UOM2__c> alist : [select Id, Record_Key__c,
                                                    Alternative_UOM_Desc__c
                                               from Material_UOM2__c
                                              where Deleted__c = false
                                                and Material_Number__c in :aset     
                                            ]) {
            for (Material_UOM2__c obj : alist) {
                amap.put(obj.Record_Key__c, obj);  
            }                                    
        }
        return amap;
    }

    public static List<Material_UOM2__c> getAltUOMs(Id mgd2Id) {
        List<Material_UOM2__c> uoms = null;
        try {
            uoms = [select Alt_Gross_Weight__c,
                           Alt_Net_Weight__c,
                           Alternative_UOM__c,
                           Alternative_UOM_Desc__c,
                           Base_UOM_Desc__c,
                           Gross_Weight_in_LBs__c, 
                           Net_Weight_in_LBs__c 
                      from Material_UOM2__c
                     where Material_General_Data__c = :mgd2Id
                       and Deleted__c = false];
        } catch(Exception e) {}
        return uoms;
    }
    
    private static Set<String> getAltUomCodes(Id mgd2Id) {
        Set<String> altUomCodes = new Set<String>();
        List<Material_UOM2__c> uoms = getAltUOMs(mgd2Id);
        if (uoms != null && !uoms.isEmpty()) {
            for (Material_UOM2__c u : uoms) {
                altUomCodes.add(u.Alternative_UOM__c);
            }
        }
        return altUomCodes;
    }
    
    private static Boolean uomCodesContainMassUom(Set<String> ucs) {
        if (ucs == null || ucs.isEmpty()) {
            return false;
        }
        Set<String> massUoms = SAP_Queries_Functions.getMassUoms();
        for (String u : ucs) {
            if (massUoms.contains(u)) {
                return true;
            }
        }
        return false;
    }
    
    public static List<SAP_UOM_Description__c> getMaterialUoms(Id mgd2Id) {
        Set<String> altUomCodes = getAltUomCodes(mgd2Id);
        Set<String> massUoms = new Set<String>{KG, LB}; 
        Boolean b1 = uomCodesContainMassUom(altUomCodes);
        if (b1 && !altUomCodes.contains(KG)) {
            altUomCodes.add(KG);
        }
        if (b1 && !altUomCodes.contains(LB)) {
            altUomCodes.add(LB);
        }
        return SAP_Queries_Functions.getSapUomDescs(altUomCodes);
    }

    public static Double getUomConversionFactor(String fromUomCode, String toUomCode,
                                                Map<String, Map<String, String>> uomConvFactorsMap) {
        return getUomConversionFactor(null, fromUomCode, toUomCode, uomConvFactorsMap);
    }
                                                
    public static Double getUomConversionFactor(String matnum, String fromUomCode, String toUomCode,
                                                Map<String, Map<String, String>> uomConvFactorsMap) {
        Double uomConvFactor = null; 
        Map<String, String> ftmap;
        if (matnum != null && uomConvFactorsMap.containsKey(matnum)) {
            ftmap = uomConvFactorsMap.get(matnum);
            uomConvFactor = getUomConversionFactor(fromUomCode, toUomCode, ftmap);
        }
        if (uomConvFactor == null && uomConvFactorsMap.containsKey(GLOBAL_UOM_CONVERSION_FACTORS)) {
            ftmap = uomConvFactorsMap.get(GLOBAL_UOM_CONVERSION_FACTORS);
            uomConvFactor = getUomConversionFactor(fromUomCode, toUomCode, ftmap);
        }
        if (uomConvFactor == null) {uomConvFactor = 1.0;}
        return uomConvFactor;
    }
    
    private static Double getUomConversionFactor(String fromUomCode, String toUomCode,
                                                 Map<String, String> ftmap) {
        Double ucf = getUomConversionFactor2(fromUomCode, toUomCode, ftmap), f2b = null, b2t = null;
        if (ucf != null) {return ucf;} 
    	String baseUom = null, k = BASE_UOM_CODE + DELIM + fromUomCode;
    	if (ftmap.containsKey(k)) {
    		baseUom = ftmap.get(k);
    	} else {
            k = BASE_UOM_CODE + DELIM + toUomCode;
            if (ftmap.containsKey(k)) {
                baseUom = ftmap.get(k);
            }
    	}
    	if (baseUom != null) {
            f2b = getUomConversionFactor2(fromUomCode, baseUom, ftmap);
            if (f2b != null) {
                b2t = getUomConversionFactor2(baseUom, toUomCode, ftmap);
                if (b2t != null) {ucf = f2b * b2t;}
            }
    	}
        return ucf;
    }
    
    private static Double getUomConversionFactor2(String fromUomCode, String toUomCode,
                                                  Map<String, String> ftmap) {
        Double uomConvFactor = null; 
        String k = fromUomCode + DELIM + toUomCode;
        if (ftmap.containsKey(k)) {
            String s = ftmap.get(k);
            String[] sa = s.split(DELIM);
            System.debug('>>>>>> '+s);
            Double numer = Double.valueOf(sa[0]);
            Double denom = Double.valueOf(sa[1]);
            if (denom != 0) {uomConvFactor = numer / denom;}
        }
        return uomConvFactor;
    }
        
    /*
     * Map<MaterialNumber/GLOBAL_UOM_CONVERSION_FACTORS, Map<FromUOM|ToUOM, Numerator|Denominator>>
     */
    public static Map<String, Map<String, String>> getUomConversionFactors(Set<String> matNums,
                                                                           Set<String> uomCodes) {
        Map<String, Map<String, String>> umap = getMaterialUomConversionFactors(matNums);
        if (umap == null) {
            umap = new Map<String, Map<String, String>>();
        }
        Map<String, String> guom = getGlobalUomConversionFactors(uomCodes);
        if (guom != null) {umap.put(GLOBAL_UOM_CONVERSION_FACTORS, guom);}
        return umap;
    }
    
    public static Map<String, Map<String, String>> getUomConversionFactors(Set<String> uomCodes) {
    	return getUomConversionFactors(null, uomCodes);
    }
    
    private static Map<String, Map<String, String>> getMaterialUomConversionFactors(Set<String> matNums) {
        Map<String, Map<String, String>> mumap = new Map<String, Map<String, String>>();
        if (matNums == null || matNums.isEmpty()) {return null;}
        List<Material_UOM2__c> mlist = [select Alternative_UOM__c,
                                               Base_UOM_Code__c,
                                               Denominator__c,
                                               Material_Number__c,
                                               Numerator__c
                                          from Material_UOM2__c
                                         where Deleted__c = false
                                           and Material_Number__c in :matNums     
                                       ];
        if (mlist == null || mlist.isEmpty()) {return null;}
        Decimal numer, denom;
        String k, v;
        Map<String, String> umap;
        for (Material_UOM2__c mu : mlist) {
            if (!mumap.containsKey(mu.Material_Number__c)) {
                umap = new Map<String, String>();
                mumap.put(mu.Material_Number__c, umap);
            }
            umap = mumap.get(mu.Material_Number__c);
            numer = mu.Numerator__c;
            denom = mu.Denominator__c;
            k = mu.Alternative_UOM__c + DELIM + mu.Base_UOM_Code__c;
            v = numer.toPlainString() + DELIM + denom.toPlainString();
            //System.debug(k+':'+v);
            umap.put(k, v);
            k = mu.Base_UOM_Code__c + DELIM + mu.Alternative_UOM__c;
            v = denom.toPlainString() + DELIM + numer.toPlainString();
            //System.debug(k+':'+v);
            umap.put(k, v);
            k = BASE_UOM_CODE + DELIM + mu.Alternative_UOM__c;
            umap.put(k, mu.Base_UOM_Code__c);
        }
        return mumap;
    }   
    
    public static Map<String, String> getGlobalUomConversionFactors(Set<String> uomCodes) {
        Map<String, String> umap = new Map<String, String>();
        if (uomCodes == null || uomCodes.isEmpty()) {return null;}
        Map<String, String> buom = new Map<String, String>();
        Map<String, SAP_UOM_Code__c> dmap = new Map<String, SAP_UOM_Code__c>();
        getSapUomCodes();
        for (SAP_UOM_Code__c c : sapUomCodes) {
            if (c.Conversion_Field__c == 'X' &&
                c.SI_Unit_Conversion_Numerator__c == 1 &&
                c.SI_Unit_Conversion_Exponent__c == 0 &&
                c.SI_Unit_Conversion_Denominator__c == 1) {
                buom.put(c.Dimension_Key__c, c.UOM_Code__c);
            }
            dmap.put(c.UOM_Code__c, c);
        }
        String baseUom, k, v;
        Decimal numer, denom;
        Integer exp;
        SAP_UOM_Code__c u;
        for (String uc : uomCodes) {
            if (dmap.containsKey(uc)) {
                u = dmap.get(uc);
                if (buom.containsKey(u.Dimension_Key__c)) {
                    baseUom = buom.get(u.Dimension_Key__c);
                    k = BASE_UOM_CODE + DELIM + u.UOM_Code__c;
                    umap.put(k, baseUom);
                    exp = (u.SI_Unit_Conversion_Exponent__c).intValue();
                    numer = u.SI_Unit_Conversion_Numerator__c;
                    if (exp != 0) {numer = numer * Math.pow(10, exp);} 
                    denom = u.SI_Unit_Conversion_Denominator__c;
                    k = u.UOM_Code__c + DELIM + baseUom;
                    v = numer.toPlainString() + DELIM + denom.toPlainString();
                    //System.debug(k+':'+v);
                    umap.put(k, v);
                    k = baseUom + DELIM + u.UOM_Code__c;
                    v = denom.toPlainString() + DELIM + numer.toPlainString();
                    //System.debug(k+':'+v);
                    umap.put(k, v);
                }
            }
        }
        return umap;
    }
    
    
/*
 **********************************************************
 Test Methods are in Material_UOM_Functions_Test class
 ********************************************************** 
 */    

}