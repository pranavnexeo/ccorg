public class Opportunity_Functions {

    private static Map<String, OpportunityStage> smap = null;
    
    public static Map<String, OpportunityStage> getOpportunityStageMap() {
    	if (smap != null) {return smap;}
    	smap = new Map<String, OpportunityStage>();
    	List<OpportunityStage> slist = [select Id, 
                                               DefaultProbability,
    	                                       ForecastCategoryName, 
    	                                       ForecastCategory,
                                               MasterLabel,
                                               SortOrder
    	                                  from OpportunityStage
    	                                 where IsActive = true];
        if (slist != null && !slist.isEmpty()) {
        	for (OpportunityStage s : slist) {
        		smap.put(s.MasterLabel, s);
        	}
        }
        return smap;
    }
    
    static testMethod void test01() {
    	smap = getOpportunityStageMap();
    	System.debug(smap.size() + ' : ' + smap);
    }
}