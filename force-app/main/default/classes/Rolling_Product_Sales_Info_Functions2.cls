public class Rolling_Product_Sales_Info_Functions2 {

    private static final CustomSettings__c CUSTOM_SETTINGS = CustomSettings__c.getOrgDefaults();
    
    private static Integer MAX_PSF_RECS = 600; 

    private static final Integer ARRAY_SIZE = 14;
    
    private static final Map<Integer,String> mnthLablMap = new Map<Integer,String>{
        1 => 'JAN', 2 => 'FEB', 3 => 'MAR',  4 => 'APR',  5 => 'MAY',  6 => 'JUN',
        7 => 'JUL', 8 => 'AUG', 9 => 'SEP', 10 => 'OCT', 11 => 'NOV', 12 => 'DEC'};

    public static final Date START_DATE = getStartDate();
    
    public static final Date END_DATE = START_DATE.addMonths(-12);
    
    public static final String MONTH_01 = (START_DATE+'').substring(0,7);
    
    private static String[] MONTH_LABELS = getLabels();

    private static final String DELIM = '-';

    private static final String PSF_SAMNT = 'PSF_SAMNT';
    private static final String PSF_GMVAL = 'PSF_GMVAL';
    private static final String PSF_GMPCT = 'PSF_GMPCT';
    private static final String PSF_VOLKG = 'PSF_VOLKG';
    private static final String PSF_VOLLB = 'PSF_VOLLB';
    private static final String PSF_VOLUN = 'PSF_VOLUN';
    private static final String PSF_VOLGL = 'PSF_VOLGL';
    private static final String PSF_VOLPT = 'PSF_VOLPT';
    
    private static String psfCurrencyIsoCode = 'USD';
    
    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>>>>>>> ' + s);
    }
    
    public static Date getStartDate() {
        Date newStartingDate = null;
        if (CUSTOM_SETTINGS != null) {
            newStartingDate = CUSTOM_SETTINGS.BW_Data_Start_Date__c;
        }
        if (newStartingDate == null) {
            newStartingDate = System.Today().addMonths(-1);
        }
        return newStartingDate;
    }
    
    private static String[] getLabels() {
        String[] v = new String[ARRAY_SIZE];
        Date ndate;
        for(Integer i = 1; i < ARRAY_SIZE; i++) {
            ndate = START_DATE.addMonths(1-i);
            v[i] = mnthLablMap.get(ndate.month())+'-'+ndate.year();
        }
        return v;   
    }
    
    public static String getPsfQuery(Boolean accFilter,
                                     Boolean matIdFilter, 
                                     Boolean matNameFilter) {
        String q = '' +
            'select id, ' +
            '       Account__r.Account_Number__c, ' +
            '       Account__r.Id, ' +
            '       CurrencyIsoCode, ' +
            '       GM__c, GMpct__c, ' +
            '       Material2__r.Id, ' + 
            '       Material2__r.Material_Number__c, ' + 
            '       Material2__r.Name, ' + 
            '       Month_Year__c, ' +  
            '       Sales_Volume_UOM__c, ' + 
            '       Sales_Amount__c, ' + 
            '       Sales_Volume_in_KGs__c, ' + 
            '       Sales_Volume_in_LBs__c, ' +
            '       Sales_Volume_in_UNs__c, ' +
            '       Sales_Volume_in_GALs__c, ' +
            '       Sales_Volume_in_PTs__c ' +
            '  from Product_Sales_Figure__c ' +
            ' where Month_Year__c <= :START_DATE ' +
            '   and Month_Year__c >= :END_DATE ';
        if (accFilter) {q += ' and Account__c = :accountId';}
        if (matIdFilter) {q += ' and Material2__r.Id = :materialId';}
        if (matNameFilter) {q += ' and Material2__r.Name like :materialName';}
        q += ' order by Account__c, Material2__c, Month_Year__c ' +  
             ' limit :MAX_PSF_RECS';
        return q;
    }
    
    public static List<SelectOption> getMaterialSelectOptions(String accountId) {
        List<SelectOption> solist = new List<SelectOption>();
        Integer n = 0;
        for (AggregateResult[] ars : [
            select Material2__r.Name matname,
                   Material2__r.Id matid
              from Product_Sales_Figure__c 
             where Month_Year__c <= :START_DATE
               and Month_Year__c >= :END_DATE
               and Account__c = :accountId
          group by Material2__r.Name, Material2__r.Id 
          order by Material2__r.Name, Material2__r.Id 
        ]) {
            for (AggregateResult ar : ars) {
                // value, label
                solist.add(new SelectOption(
                    (String)ar.get('matid'), 
                    (String)ar.get('matname')));
            }
        }
        //debug(''+solist);
        return solist;
    }

    public static void upsertRollingProductSalesInfo(List<Product_Sales_Figure__c> psfa) {
        // Map(psfKey, Map(fieldName, fieldValues)) -- Sales Figures Map
        Map<String, Map<String, Double[]>> mapA = new Map<String, Map<String, Double[]>>();
        Map<String, Rolling_Product_Sales_Info__c> rmap = new Map<String, Rolling_Product_Sales_Info__c>();
        setRpsiMap(psfa, mapA, rmap);
        try {upsert rmap.values() Rolling_Product_Sales_Info__c.Fields.Key__c;} 
        catch(Exception e) {debug(e.getMessage());}
    }
    
    public static List<Rolling_Product_Sales_Info__c> getRollingProductSalesInfo(
                                                            Id accountId, 
                                                            String materialId,  
                                                            String materialName) {
        // Map(psfKey, Map(fieldName, fieldValues)) -- Sales Figures Map
        Map<String, Map<String, Double[]>> mapA = new Map<String, Map<String, Double[]>>();
        Map<String, Rolling_Product_Sales_Info__c> rmap = new Map<String, Rolling_Product_Sales_Info__c>();
        Boolean matIdFilter = false, matNameFilter = false;
        if (materialId != null && materialId.trim().length() > 0) {
            matIdFilter = true;
            materialId = materialId.trim();
        }
        if (materialName != null && materialName.trim().length() > 0) {
            matNameFilter = true;
            materialName = '%' + materialName.trim() + '%';
        }
        String q = getPsfQuery(true, matIdFilter, matNameFilter);
        for(List<Product_Sales_Figure__c> psfa : Database.query(q)) {
            setRpsiMap(psfa, mapA, rmap);
        }
        mapA = null;
        return sortRpsiList(rmap.values());
    }
    
    private static List<Rolling_Product_Sales_Info__c> sortRpsiList(List<Rolling_Product_Sales_Info__c> rlist) {
        Map<String, Rolling_Product_Sales_Info__c> rmap = new Map<String, Rolling_Product_Sales_Info__c>();
        for (Rolling_Product_Sales_Info__c r : rlist) {rmap.put(r.Material2__r.Name, r);}
        rlist = null;
        List<String> matList = new List<String>();
        matList.addAll(rmap.keySet());
        matList.sort();
        List<Rolling_Product_Sales_Info__c> slist = new List<Rolling_Product_Sales_Info__c>();
        for (String m : matList) {slist.add(rmap.get(m));}
        rmap = null;
        return slist;
    }
    
    private static void setRpsiMap(List<Product_Sales_Figure__c> psfa,
                                   Map<String, Map<String, Double[]>> mapA, 
                                   Map<String, Rolling_Product_Sales_Info__c> rmap) {
        updatePsfMaps(psfa, mapA, rmap);
        Map<String, Double[]> mapB;
        Rolling_Product_Sales_Info__c rpsi;                                         
        for(String keyA : mapA.keySet()) {
            mapB = mapA.get(keyA);
            rpsi = rmap.get(keyA);
            if (mapB.containsKey(PSF_SAMNT)) {setAmounts  (rpsi, mapB.get(PSF_SAMNT));}
            if (mapB.containsKey(PSF_GMVAL)) {setGMs      (rpsi, mapB.get(PSF_GMVAL));}
            if (mapB.containsKey(PSF_GMPCT)) {setGMpcts   (rpsi, mapB.get(PSF_GMPCT));}
            if (mapB.containsKey(PSF_VOLKG)) {setVolumeKgs(rpsi, mapB.get(PSF_VOLKG));}
            if (mapB.containsKey(PSF_VOLLB)) {setVolumeLbs(rpsi, mapB.get(PSF_VOLLB));}
            if (mapB.containsKey(PSF_VOLUN)) {setVolumeUns(rpsi, mapB.get(PSF_VOLUN));}
            if (mapB.containsKey(PSF_VOLGL)) {setVolumeGls(rpsi, mapB.get(PSF_VOLGL));}
            if (mapB.containsKey(PSF_VOLPT)) {setVolumePts(rpsi, mapB.get(PSF_VOLPT));}
        }
    }
    
    private static String getPsfKey(Product_Sales_Figure__c psf) {
        return MONTH_01 + DELIM + psf.Account__r.Id + DELIM + psf.Material2__r.Id;
    }

    private static void updatePsfMaps(List<Product_Sales_Figure__c> psfa,
                                      Map<String, Map<String, Double[]>> mapA,
                                      Map<String, Rolling_Product_Sales_Info__c> rmap) {
        Map<String, Double[]> mapB;
        Rolling_Product_Sales_Info__c rpsi;                                         
        for(Product_Sales_Figure__c psf : psfa) {
            String keyA = getPsfKey(psf);
            if (mapA.containsKey(keyA)) {
                mapB = mapA.get(keyA);
            } else {
                mapB = getInitMapB();
                mapA.put(keyA, mapB);
                rpsi = getRpsi(psf);
                rmap.put(keyA, rpsi);
            }
            updatePsfMap(psf, mapB);
        }
    }
    
    private static void updatePsfMap(Product_Sales_Figure__c psf,
                                     Map<String, Double[]> mapB) {
        Date pDate = psf.Month_Year__c;
        if (pDate == null) {return;}
        Double pSAmt = psf.Sales_Amount__c;
        Double pGM = psf.GM__c;
        Double pGMpct = psf.GMpct__c;
        Double pSVKg = psf.Sales_Volume_in_KGs__c;
        Double pSVLb = psf.Sales_Volume_in_LBs__c;
        Double pSVUn = psf.Sales_Volume_in_UNs__c;
        Double pSVGl = psf.Sales_Volume_in_GALs__c;
        Double pSVPt = psf.Sales_Volume_in_PTs__c;
        Integer indx = pDate.monthsBetween(START_DATE) + 1;
        updatePsfMap(mapB, PSF_SAMNT, pSAmt, indx);
        updatePsfMap(mapB, PSF_GMVAL, pGM, indx);
        updatePsfMap(mapB, PSF_GMPCT, pGMpct, indx);
        updatePsfMap(mapB, PSF_VOLKG, pSVKg, indx);
        updatePsfMap(mapB, PSF_VOLLB, pSVLb, indx);
        updatePsfMap(mapB, PSF_VOLUN, pSVUn, indx);
        updatePsfMap(mapB, PSF_VOLGL, pSVGl, indx);
        updatePsfMap(mapB, PSF_VOLPT, pSVPt, indx);
    }
    
    private static void updatePsfMap(Map<String, Double[]> mapB,
                                     String keyB,
                                     Double val,
                                     Integer indx) {
        Double[] v = mapB.get(keyB);
        if (val != null) {v[indx] = val;}
    }
    
    private static Map<String, Double[]> getInitMapB() {
        Map<String, Double[]> mapB = new Map<String, Double[]>();
        Double[] va = new Double[ARRAY_SIZE];
        for (Integer i = 0; i < ARRAY_SIZE; i++) {va[i] = 0.0;}
        mapB.put(PSF_SAMNT, va.clone());
        mapB.put(PSF_GMVAL, va.clone());
        mapB.put(PSF_GMPCT, va.clone());
        mapB.put(PSF_VOLKG, va.clone());
        mapB.put(PSF_VOLLB, va.clone());
        mapB.put(PSF_VOLUN, va.clone());
        mapB.put(PSF_VOLGL, va.clone());
        mapB.put(PSF_VOLPT, va.clone());
        return mapB;
    }
    
    private static Rolling_Product_Sales_Info__c getRpsi(Product_Sales_Figure__c psf) {
        String k = getPsfKey(psf);
        Rolling_Product_Sales_Info__c rpsi = new Rolling_Product_Sales_Info__c();
        rpsi.Account__c = psf.Account__r.Id;
        rpsi.Material2__c = psf.Material2__r.Id;
        rpsi.Material2__r = psf.Material2__r;
        rpsi.Material2__r.Name = psf.Material2__r.Name;
        rpsi.Month_01__c = MONTH_01;
        rpsi.Key__c = k;
        rpsi.Name = rpsi.Month_01__c + DELIM + 
                    psf.Account__r.Account_Number__c + DELIM + 
                    psf.Material2__r.Material_Number__c;
        rpsi.CurrencyIsoCode = psf.CurrencyIsoCode;
        setLabels(rpsi);
        return rpsi;
    }
    
    private static void setLabels(Rolling_Product_Sales_Info__c rpsi) {
        String[] v = MONTH_LABELS;
        rpsi.Label_Month_01__c=v[01];
        rpsi.Label_Month_02__c=v[02];
        rpsi.Label_Month_03__c=v[03];
        rpsi.Label_Month_04__c=v[04];
        rpsi.Label_Month_05__c=v[05];
        rpsi.Label_Month_06__c=v[06];
        rpsi.Label_Month_07__c=v[07];
        rpsi.Label_Month_08__c=v[08];
        rpsi.Label_Month_09__c=v[09];
        rpsi.Label_Month_10__c=v[10];
        rpsi.Label_Month_11__c=v[11];
        rpsi.Label_Month_12__c=v[12];
        rpsi.Label_Month_13__c=v[13];
    }
    
    private static void setAmounts(Rolling_Product_Sales_Info__c rpsi, Double[] v) {
        rpsi.Amount_Month_01__c=v[01];
        rpsi.Amount_Month_02__c=v[02];
        rpsi.Amount_Month_03__c=v[03];
        rpsi.Amount_Month_04__c=v[04];
        rpsi.Amount_Month_05__c=v[05];
        rpsi.Amount_Month_06__c=v[06];
        rpsi.Amount_Month_07__c=v[07];
        rpsi.Amount_Month_08__c=v[08];
        rpsi.Amount_Month_09__c=v[09];
        rpsi.Amount_Month_10__c=v[10];
        rpsi.Amount_Month_11__c=v[11];
        rpsi.Amount_Month_12__c=v[12];
        rpsi.Amount_Month_13__c=v[13];
    }
    
    private static void setGMs(Rolling_Product_Sales_Info__c rpsi, Double[] v) {
        rpsi.GM_Month_01__c=v[01];
        rpsi.GM_Month_02__c=v[02];
        rpsi.GM_Month_03__c=v[03];
        rpsi.GM_Month_04__c=v[04];
        rpsi.GM_Month_05__c=v[05];
        rpsi.GM_Month_06__c=v[06];
        rpsi.GM_Month_07__c=v[07];
        rpsi.GM_Month_08__c=v[08];
        rpsi.GM_Month_09__c=v[09];
        rpsi.GM_Month_10__c=v[10];
        rpsi.GM_Month_11__c=v[11];
        rpsi.GM_Month_12__c=v[12];
        rpsi.GM_Month_13__c=v[13];
    }
    
    private static void setGMpcts(Rolling_Product_Sales_Info__c rpsi, Double[] v) {
        rpsi.GMpct_Month_01__c=v[01];
        rpsi.GMpct_Month_02__c=v[02];
        rpsi.GMpct_Month_03__c=v[03];
        rpsi.GMpct_Month_04__c=v[04];
        rpsi.GMpct_Month_05__c=v[05];
        rpsi.GMpct_Month_06__c=v[06];
        rpsi.GMpct_Month_07__c=v[07];
        rpsi.GMpct_Month_08__c=v[08];
        rpsi.GMpct_Month_09__c=v[09];
        rpsi.GMpct_Month_10__c=v[10];
        rpsi.GMpct_Month_11__c=v[11];
        rpsi.GMpct_Month_12__c=v[12];
        rpsi.GMpct_Month_13__c=v[13];
    }
    
    private static void setVolumeKgs(Rolling_Product_Sales_Info__c rpsi, Double[] v) {
        rpsi.Volume_in_KG_Month_01__c=v[01];
        rpsi.Volume_in_KG_Month_02__c=v[02];
        rpsi.Volume_in_KG_Month_03__c=v[03];
        rpsi.Volume_in_KG_Month_04__c=v[04];
        rpsi.Volume_in_KG_Month_05__c=v[05];
        rpsi.Volume_in_KG_Month_06__c=v[06];
        rpsi.Volume_in_KG_Month_07__c=v[07];
        rpsi.Volume_in_KG_Month_08__c=v[08];
        rpsi.Volume_in_KG_Month_09__c=v[09];
        rpsi.Volume_in_KG_Month_10__c=v[10];
        rpsi.Volume_in_KG_Month_11__c=v[11];
        rpsi.Volume_in_KG_Month_12__c=v[12];
        rpsi.Volume_in_KG_Month_13__c=v[13];
    }
    
    private static void setVolumeLbs(Rolling_Product_Sales_Info__c rpsi, Double[] v) {
        rpsi.Volume_in_LB_Month_01__c=v[01];
        rpsi.Volume_in_LB_Month_02__c=v[02];
        rpsi.Volume_in_LB_Month_03__c=v[03];
        rpsi.Volume_in_LB_Month_04__c=v[04];
        rpsi.Volume_in_LB_Month_05__c=v[05];
        rpsi.Volume_in_LB_Month_06__c=v[06];
        rpsi.Volume_in_LB_Month_07__c=v[07];
        rpsi.Volume_in_LB_Month_08__c=v[08];
        rpsi.Volume_in_LB_Month_09__c=v[09];
        rpsi.Volume_in_LB_Month_10__c=v[10];
        rpsi.Volume_in_LB_Month_11__c=v[11];
        rpsi.Volume_in_LB_Month_12__c=v[12];
        rpsi.Volume_in_LB_Month_13__c=v[13];
    }
    
    private static void setVolumeUns(Rolling_Product_Sales_Info__c rpsi, Double[] v) {
        rpsi.Volume_in_UN_Month_01__c=v[01];
        rpsi.Volume_in_UN_Month_02__c=v[02];
        rpsi.Volume_in_UN_Month_03__c=v[03];
        rpsi.Volume_in_UN_Month_04__c=v[04];
        rpsi.Volume_in_UN_Month_05__c=v[05];
        rpsi.Volume_in_UN_Month_06__c=v[06];
        rpsi.Volume_in_UN_Month_07__c=v[07];
        rpsi.Volume_in_UN_Month_08__c=v[08];
        rpsi.Volume_in_UN_Month_09__c=v[09];
        rpsi.Volume_in_UN_Month_10__c=v[10];
        rpsi.Volume_in_UN_Month_11__c=v[11];
        rpsi.Volume_in_UN_Month_12__c=v[12];
        rpsi.Volume_in_UN_Month_13__c=v[13];
    }
    
    private static void setVolumeGls(Rolling_Product_Sales_Info__c rpsi, Double[] v) {
        rpsi.Volume_in_GL_Month_01__c=v[01];
        rpsi.Volume_in_GL_Month_02__c=v[02];
        rpsi.Volume_in_GL_Month_03__c=v[03];
        rpsi.Volume_in_GL_Month_04__c=v[04];
        rpsi.Volume_in_GL_Month_05__c=v[05];
        rpsi.Volume_in_GL_Month_06__c=v[06];
        rpsi.Volume_in_GL_Month_07__c=v[07];
        rpsi.Volume_in_GL_Month_08__c=v[08];
        rpsi.Volume_in_GL_Month_09__c=v[09];
        rpsi.Volume_in_GL_Month_10__c=v[10];
        rpsi.Volume_in_GL_Month_11__c=v[11];
        rpsi.Volume_in_GL_Month_12__c=v[12];
        rpsi.Volume_in_GL_Month_13__c=v[13];
    }
    
    private static void setVolumePts(Rolling_Product_Sales_Info__c rpsi, Double[] v) {
        rpsi.Volume_in_PT_Month_01__c=v[01];
        rpsi.Volume_in_PT_Month_02__c=v[02];
        rpsi.Volume_in_PT_Month_03__c=v[03];
        rpsi.Volume_in_PT_Month_04__c=v[04];
        rpsi.Volume_in_PT_Month_05__c=v[05];
        rpsi.Volume_in_PT_Month_06__c=v[06];
        rpsi.Volume_in_PT_Month_07__c=v[07];
        rpsi.Volume_in_PT_Month_08__c=v[08];
        rpsi.Volume_in_PT_Month_09__c=v[09];
        rpsi.Volume_in_PT_Month_10__c=v[10];
        rpsi.Volume_in_PT_Month_11__c=v[11];
        rpsi.Volume_in_PT_Month_12__c=v[12];
        rpsi.Volume_in_PT_Month_13__c=v[13];
    }
    
/*
 **********************************************************
 Test Methods
 ********************************************************** 
 */    
 
    public static void insertTestPSF() {
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
        Account acc = new Account(Name = 'Test');
        insert acc;

        Material_Sales_Data2__c mat = new Material_Sales_Data2__c(Name = 'Test',
                                                                  Material_Number__c = 'Test',
                                                                  Sales_Org_Code__c = '1020',
                                                                  Dist_Channel_Code__c = '10',
                                                                  Record_Key__c = 'Test102010');

        insert mat;
        Product_Sales_Figure__c psf = new Product_Sales_Figure__c();
        psf.Account__c = acc.id;
        psf.CurrencyIsoCode = 'USD';
        psf.GM__c = 123.45;
        psf.GMpct__c = 12.34;
        psf.Key__c = 'Test';
        psf.Material2__c = mat.id;
        psf.Month_Year__c = START_DATE;
        psf.Sales_Amount__c = 123.45;
        psf.Sales_Volume__c = 123.45;
        psf.Sales_Volume_in_UNs__c = 10;
        psf.Sales_Volume_in_GALs__c = 10;
        psf.Sales_Volume_in_PTs__c = 10;
        psf.Sales_Volume_UOM__c = 'LB';
        insert psf;
        List<Rolling_Product_Sales_Info__c> rpsia = getRollingProductSalesInfo(acc.id, mat.Id, mat.Name);
        debug(''+rpsia);
    }

    static testMethod void test01() {
        Test.startTest();
        insertTestPSF();
    }

/*
    static testMethod void test02() {
        String accId = '0015000000F8lbC';// PUGH OIL CO INC
        getMaterialSelectOptions(accId);
    }    
//*/

}