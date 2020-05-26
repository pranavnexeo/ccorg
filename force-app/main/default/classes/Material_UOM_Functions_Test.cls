@isTest
private class Material_UOM_Functions_Test {

    static String matnum = '000000000123456789';
    static String altUOM = 'XYZ';
    static Integer numer = 227;
    static Integer denom = 1;
    static Set<String> matnums = new Set<String>{matnum};
    static Set<String> altuoms = new Set<String>{altuom};
    static Set<String> uomCodes = new Set<String>{'KG', 'LB'};
//*
    static testMethod void test01() {
        Test.startTest();
        testUpsert_Material_UOM();
        Test.stopTest();
    }
//*/
    static testMethod void test02() {
        Test.startTest();
        Material_UOM_Functions.getExternalUOMCodes();
        Material_UOM_Functions.getGlobalUomConversionFactors(uomCodes);
        Map<String, Map<String, String>> cmap;
        Double ucf;
        altuoms = new Set<String>{'LB', 'TO'};
        cmap = Material_UOM_Functions.getUomConversionFactors(altuoms);
        ucf = Material_UOM_Functions.getUomConversionFactor('TO', 'KG', cmap);
        System.debug(ucf);
        ucf = Material_UOM_Functions.getUomConversionFactor('KG', 'LB', cmap);
        System.debug(ucf);
        ucf = Material_UOM_Functions.getUomConversionFactor('TO', 'LB', cmap);
        System.debug(ucf);
        Test.stopTest();
    }
    
    private static void testUpsert_Material_UOM() {

        Material_General_Data2__c mgd = new Material_General_Data2__c();
        mgd.Material_Number__c = matnum;
        insert mgd;
        
        SAP_UOM_Description__c uomd = new SAP_UOM_Description__c();
        uomd.Language_Code__c = 'E';
        uomd.UOM_Code__c = altUOM;
        insert uomd;
        
        SAP_UOM_Code__c uomc = new SAP_UOM_Code__c();
        uomc.UOM_Code__c = altUOM;
        uomc.ISO_Code__c = altUOM;
        uomc.Dimension_Key__c = 'MASS';
        uomc.SI_Unit_Conversion_Exponent__c = 0;
        uomc.SI_Unit_Conversion_Numerator__c = 100;
        uomc.SI_Unit_Conversion_Denominator__c = 10;
        insert uomc;

        Material_UOM__c muom = new Material_UOM__c();
        muom.Material_Number__c = matnum;
        muom.Alternative_UOM__c = altUOM;
        muom.Record_Key__c = matnum + altUOM;
        muom.Denominator__c = denom;
        muom.Numerator__c = numer;
        insert muom;

        Map<String, String> umap = new Map<String, String>(); 
        Material_UOM_Functions.setUOMCodeMap(umap, new List<SAP_UOM_Code__c>{uomc});

        Material_UOM2__c muom2 = Material_UOM_Functions.getMaterial_UOM2(muom, umap);
        List<Material_UOM2__c> alist = new List<Material_UOM2__c>{muom2};
        Material_UOM_Functions.upsert_Material_UOM2(alist);
        Material_UOM_Functions.getAltUoms(matnums);
        Material_UOM_Functions.getMaterialUoms(mgd.Id);
        Map<String, Map<String, String>> cmap;
        cmap = Material_UOM_Functions.getUomConversionFactors(matnums, altuoms);
        Double ucf = Material_UOM_Functions.getUomConversionFactor(matnum, 'KG', 'XYZ', cmap);
        System.debug(ucf);
        ucf = Material_UOM_Functions.getUomConversionFactor(matnum, 'XYZ', 'KG', cmap);
        System.debug(ucf);
    }
    
}