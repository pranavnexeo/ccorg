public with sharing class Material_Description_Functions {

    private static String LANG_CODE = 'E';

/*
    public static Map<String, String> getCodeDescMap(Set<String> aset) {
        Map<String, String> amap = new Map<String, String>();
        for (List<Material_Description__c> alist : [select Material_Number__c,
                                                           Material_Description__c
                                                      from Material_Description__c
                                                     where Material_Number__c in :aset
                                                       and Language_Code__c = :LANG_CODE
                                                   ]) {
            for (Material_Description__c obj : alist) {
                amap.put(obj.Material_Number__c, 
                         obj.Material_Description__c);  
            }                                    
        }
        return amap;
    }
*/

    public static Map<String, Material_Description__c> getMaterialDescriptionMap(Set<String> aset) {
        Map<String, Material_Description__c> amap = new Map<String, Material_Description__c>();
        for (List<Material_Description__c> alist : [select Id, Material_Number__c,
                                                           Material_Description__c
                                                      from Material_Description__c
                                                     where Material_Number__c in :aset
                                                       and Language_Code__c = :LANG_CODE
                                                   ]) {
            for (Material_Description__c obj : alist) {
                amap.put(obj.Material_Number__c, obj);  
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
        Material_Description__c obj = new Material_Description__c();
        obj.Material_Number__c = code;
        obj.Material_Description__c = 'ABCD';
        obj.Language_Code__c = LANG_CODE;
        insert obj;
        Set<String> aset = new Set<String> {code};
        getMaterialDescriptionMap(aset);
    }
    
}