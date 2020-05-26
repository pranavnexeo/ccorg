public with sharing class Material_Type_Functions {
	
	private static String LANG_CODE = 'E';

/*
    public static Map<String, String> getCodeDescMap(Set<String> aset) {
        Map<String, String> amap = new Map<String, String>();
        for (List<Material_Type__c> alist : [select Material_Type_Code__c,
                                                    Material_Type_Description__c
                                               from Material_Type__c
                                              where Material_Type_Code__c in :aset
                                                and Language_Code__c = :LANG_CODE
                                            ]) {
            for (Material_Type__c obj : alist) {
                amap.put(obj.Material_Type_Code__c, 
                         obj.Material_Type_Description__c);  
            }                                    
        }
        return amap;
    }
*/

    public static Map<String, Material_Type__c> getMaterialTypeMap(Set<String> aset) {
        Map<String, Material_Type__c> amap = new Map<String, Material_Type__c>();
        for (List<Material_Type__c> alist : [select Id, Material_Type_Code__c,
                                                    Material_Type_Description__c
                                               from Material_Type__c
                                              where Material_Type_Code__c in :aset
                                                and Language_Code__c = :LANG_CODE
                                            ]) {
            for (Material_Type__c obj : alist) {
                amap.put(obj.Material_Type_Code__c, obj);  
            }                                    
        }
        return amap;
    }

/*
 **********************************************************
 Test Methods
 ********************************************************** 
 */    

    public static testMethod void testMe() {
        testGetCodeDescMap();
    }
    
    private static void testGetCodeDescMap() {
        String code = '1234';
        Material_Type__c obj = new Material_Type__c();
        obj.Material_Type_Code__c = code;
        obj.Material_Type_Description__c = 'ABCD';
        obj.Language_Code__c = LANG_CODE;
        insert obj;
        Set<String> aset = new Set<String> {code};
        getMaterialTypeMap(aset);
    }
    
}