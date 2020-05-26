public with sharing class ObjectPrefixFunctions {

    public static String getObjectKeyPrefix(String objName) {
        Map<String, String> omap = getObjectNamePrefixMap();
        if (omap != null && omap.containsKey(objName)) {
            String op = omap.get(objName);
            return op;
        }
        return null;
    }
    
    public static Map<String, String> getObjectPrefixNameMap() {
        Map<String, String> amap = new Map<String, String>();
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        List<Schema.SObjectType> tlist = gd.values();
        for(Schema.SObjectType t : tlist) {
            Schema.DescribeSObjectResult r = t.getDescribe();
            if (r.getKeyPrefix() != null) {
                amap.put(r.getKeyPrefix(), r.getName());
            }
        }
        return amap;
    }
    
    public static Map<String, String> getObjectNamePrefixMap() {
        Map<String, String> amap = new Map<String, String>();
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        List<Schema.SObjectType> tlist = gd.values();
        for(Schema.SObjectType t : tlist) {
            Schema.DescribeSObjectResult r = t.getDescribe();
            if (r.getKeyPrefix() != null) {
                amap.put(r.getName(), r.getKeyPrefix());
            }
        }
        return amap;
    }
    
    static testMethod void testMe() {
    	getObjectPrefixNameMap();
    	getObjectKeyPrefix('User');
        getObjectKeyPrefix('xyz');
    }
    
}