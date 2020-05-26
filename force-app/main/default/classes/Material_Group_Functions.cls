public with sharing class Material_Group_Functions {

    private static String LANG_CODE = 'E';

/*
    public static Map<String, String> getCodeDescMap(Set<String> aset) {
        Map<String, String> amap = new Map<String, String>();
        for (List<Material_Group__c> alist : [select Material_Group_Code__c,
                                                     Material_Group_Description__c
                                                from Material_Group__c
                                               where Material_Group_Code__c in :aset
                                                 and Language_Code__c = :LANG_CODE
                                            ]) {
            for (Material_Group__c obj : alist) {
                amap.put(obj.Material_Group_Code__c, 
                         obj.Material_Group_Description__c);  
            }                                    
        }
        return amap;
    }
*/

    public static Map<String, Material_Group__c> getMaterialGroupMap(Set<String> aset) {
        Map<String, Material_Group__c> amap = new Map<String, Material_Group__c>();
        for (List<Material_Group__c> alist : [select Id, Material_Group_Code__c,
                                                     Material_Group_Description__c
                                                from Material_Group__c
                                               where Material_Group_Code__c in :aset
                                                 and Language_Code__c = :LANG_CODE
                                            ]) {
            for (Material_Group__c obj : alist) {
                amap.put(obj.Material_Group_Code__c, obj);  
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
        Material_Group__c obj = new Material_Group__c();
        obj.Material_Group_Code__c = code;
        obj.Material_Group_Description__c = 'ABCD';
        obj.Language_Code__c = LANG_CODE;
        insert obj;
        Set<String> aset = new Set<String> {code};
        getMaterialGroupMap(aset);
    }
    
}