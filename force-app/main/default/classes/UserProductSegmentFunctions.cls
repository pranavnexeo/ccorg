public with sharing class UserProductSegmentFunctions {

    public static void processBeforeUpsert(List<User_Product_Segment__c> ulist) {
        final String D = '-';
        Set<String> pset = getProductSegmentCodes(ulist);
        Map<String, String> pmap = Product_Hierarchy_Functions.getProductSegmentMap(pset);
        for (User_Product_Segment__c u : ulist) {
            u.RecordKey__c = u.User__c + D +
                             u.Product_Segment_Code__c;
            if (pmap != null && pmap.containsKey(u.Product_Segment_Code__c)) {
            	u.Product_Segment__c = pmap.get(u.Product_Segment_Code__c);
                System.debug(u.Product_Segment__c);
            }
        }
    }
    
    private static Set<String> getProductSegmentCodes(List<User_Product_Segment__c> ulist) {
    	Set<String> aset = new Set<String>();
        for (User_Product_Segment__c u : ulist) {
            aset.add(u.Product_Segment_Code__c);
        }
        return aset;
    }
    
    public static List<User_Product_Segment__c> getUserProductSegments(Id userId) {
      List<User_Product_Segment__c> results;
      results = [Select Product_Segment_Code__c, Product_Segment__c,
                        UserName__c, User__c
                   From User_Product_Segment__c
                  where User__c = :userId
                ];
      if (!results.isEmpty()) {
          return results;
      }
      return null;                                                        
    }
  
}