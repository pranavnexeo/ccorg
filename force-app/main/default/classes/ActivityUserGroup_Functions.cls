public with sharing class ActivityUserGroup_Functions {

    private static final String DELIM = '-'; 
    private static final String SEMICOLON = ';'; 
    private static final String REGULAR_GROUP = 'Regular'; 
    
    private static Map<String, Activity_User_Group__c> recordMap = getActivityUserGroups();
    private static Map<String, List<String>> emailIdMap = new Map<String, List<String>>();
    
    private static Map<String, Activity_User_Group__c> getActivityUserGroups() {
    	Map<String, Activity_User_Group__c> amap = new Map<String, Activity_User_Group__c>();
    	List<Activity_User_Group__c> alist = [select Activity_Type__c,
    	                                             Development_Group__c,
    	                                             User_Public_Group__c
    	                                        from Activity_User_Group__c
    	                                     ];
        for (Activity_User_Group__c a : alist) {
            String aid = a.id;
            String mapKey = getRecordKey(a);
            System.debug(aid+':'+mapKey);
        	amap.put(mapKey, a);
        }    	                                     
        return amap;
    }
    
    private static String getRecordKey(Activity_User_Group__c a) {
    	return getRecordKey(a.Activity_Type__c, a.Development_Group__c);
    }
    
    private static String getRecordKey(String atype, String dgroup) {
        return atype + DELIM + dgroup;
    }
    
    public static void checkForDuplicate(Activity_User_Group__c[] aa) {
    	for (Activity_User_Group__c a : aa) {
            String aid = a.id;
            String mapKey = getRecordKey(a);
            System.debug(aid+':'+mapKey);
            if (recordMap.containsKey(mapKey)) {
            	Activity_User_Group__c b = recordMap.get(mapKey);
            	String bid = b.id;
                System.debug(bid);
            	if (aid == null || !bid.equals(aid)) {
                    a.addError(mapKey + ' already exists');
            	}
            } else {
            	recordMap.put(mapKey, a);
            }
    	}
    }
    
    public static List<String> getEmailIds(String atype, String dgroup) {
        String mapKey = getRecordKey(atype, dgroup);
        if (!recordMap.containsKey(mapKey)) {
            return null;
        }
        if (emailIdMap.containsKey(mapKey)) {
        	return emailIdMap.get(mapKey);
        }
        List<String> elist = getEmailIds(mapKey);
        emailIdMap.put(mapKey, elist);
    	return elist;
    }
    
    private static List<String> getEmailIds(String mapKey) {
        String[] names = getUserGroups(mapKey);
        List<User> ulist = [select email
                              from user
                             where id in (
                                   select userorgroupid 
                                     from groupmember 
                                    where group.Type = :REGULAR_GROUP 
                                      and group.Name in :names
                                   ) 
                           ];
        List<String> elist = new List<String>();
        for(User u : ulist) {
            elist.add(u.email);
        }
        return elist;
    }
    
    private static String[] getUserGroups(String mapKey) {
        Activity_User_Group__c a = recordMap.get(mapKey);
        String upg = a.User_Public_Group__c;
        String[] sa = upg.split(SEMICOLON);
        return sa;
    }
    
/*
 **********************************************************
 Test Methods
 ********************************************************** 
 */    

    public static testMethod void testMe() {
    	testCheckForDuplicate();
        testGetEmailIds();
    }
    
    private static void testCheckForDuplicate() {
    	List<Activity_User_Group__c> alist = new List<Activity_User_Group__c>();
        Activity_User_Group__c a = new Activity_User_Group__c();
        a.Activity_Type__c = 'Task';
        a.Development_Group__c = 'testGroup1';
        a.User_Public_Group__c = 'testGroup';
        Activity_User_Group__c b = new Activity_User_Group__c();
        b.Activity_Type__c = 'Task';
        b.Development_Group__c = 'testGroup2';
        b.User_Public_Group__c = 'testGroup';
        Activity_User_Group__c c = new Activity_User_Group__c();
        c.Activity_Type__c = 'Task';
        c.Development_Group__c = 'testGroup1';
        c.User_Public_Group__c = 'testGroup';
        insert a;
        insert b;
        // test for duplicate on new
        try {insert c;} catch (Exception e) {
            System.debug(e.getMessage());
        }
        // test for duplicate on update
        b.Development_Group__c = 'testGroup1';
        try {update b;} catch (Exception e) {
            System.debug(e.getMessage());
        }
        getActivityUserGroups();
    }
    
    private static void testGetEmailIds() {
        getEmailIds('Task', 'xxxxxx');
        List<Activity_User_Group__c> augs = recordMap.values();
        if (augs != null && !augs.isEmpty()) {
            Activity_User_Group__c a = augs[0];
            getEmailIds(a.Activity_Type__c, a.Development_Group__c);
        }
    }
}