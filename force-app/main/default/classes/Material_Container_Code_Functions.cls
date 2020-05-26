public with sharing class Material_Container_Code_Functions {

/*
    public static Map<String, String> getCodeDescMap(Set<String> aset) {
        Map<String, String> amap = new Map<String, String>();
        for (List<Material_Container_Code__c> alist : [select Material_Container_Code__c,
                                                              Material_Container_Code_Description__c
                                                         from Material_Container_Code__c
                                                        where Material_Container_Code__c in :aset     
                                                      ]) {
            for (Material_Container_Code__c obj : alist) {
                amap.put(obj.Material_Container_Code__c, 
                         obj.Material_Container_Code_Description__c);  
            }                                    
        }
        return amap;
    }
*/

    public static Map<String, Material_Container_Code__c> getMaterialContainerCodeMap(Set<String> aset) {
        Map<String, Material_Container_Code__c> amap = new Map<String, Material_Container_Code__c>();
        for (List<Material_Container_Code__c> alist : [select Id, Material_Container_Code__c,
                                                              Material_Container_Code_Description__c
                                                         from Material_Container_Code__c
                                                        where Material_Container_Code__c in :aset     
                                                      ]) {
            for (Material_Container_Code__c obj : alist) {
                amap.put(obj.Material_Container_Code__c, obj);  
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
        Material_Container_Code__c obj = new Material_Container_Code__c();
        obj.Material_Container_Code__c = code;
        obj.Material_Container_Code_Description__c = 'ABCD';
        insert obj;
        Set<String> aset = new Set<String> {code};
        //getCodeDescMap(aset);
        getMaterialContainerCodeMap(aset);
    }
    
}