public with sharing class UserSalesAreaFunctions {

    public static void processBeforeUpsert(List<User_Sales_Area__c> ulist) {
    	final String D = '-';
        Set<String> sapSalesAreas = getSapSalesAreas();
    	for (User_Sales_Area__c u : ulist) {
            String s = u.SalesOrgCode__c + u.DistChannelCode__c + u.DivisionCode__c;
            u.isValid__c = false;
            if (sapSalesAreas.contains(s)) {
                u.isValid__c = true;
            }
    		u.RecordKey__c = u.User__c + D +
    		                 u.RegionCode__c + D +
    		                 u.SalesOrgCode__c + D +
    		                 u.DistChannelCode__c + D +
    		                 u.DivisionCode__c;
    	}
    }
    
    private static Set<String> getSapSalesAreas() {
    	Set<String> s = new Set<String>();
    	for (SAP_Sales_Area__c sa : [select Record_Key__c
    	                               from SAP_Sales_Area__c
    	                              where Deleted__c = false
    	                            ]) {
    		s.add(sa.Record_Key__c);
    	}
    	return s;
    } 

	public static List<User_Sales_Area__c> getUserSalesAreas(Id userId) {
	  List<User_Sales_Area__c> results;
	  results = [Select DistChannelCode__c, DistChannel__c,
	                    DivisionCode__c, Division__c,
	                    RegionCode__c, Region__c,
	                    SalesOrgCode__c, SalesOrg__c,
	                    SAP_Country_Name__c,
	                    SAP_Distribution_Channel__c,
	                    SAP_Sales_Division__c,
	                    SAP_Sales_Org__c,
	                    UserName__c, User__c
	               From User_Sales_Area__c
	              where User__c = :userId
	                and isValid__c = true
	            ];
	  if (!results.isEmpty()) {
	      return results;
	  }
	  return null;                                                        
	}
  
}