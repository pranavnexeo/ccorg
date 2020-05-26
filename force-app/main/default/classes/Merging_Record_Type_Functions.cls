public with sharing class Merging_Record_Type_Functions {

    public static Set<String> getMergingRecordTypes(String objectName) {
        Set<String> mrtSet = new Set<String>();
        List<Merging_Record_Type__c> mrtList = [select RecordType__c 
                                               from Merging_Record_Type__c 
                                              where ObjectName__c = :objectName];
        for (Merging_Record_Type__c mrt : mrtList) {
            String rectype = mrt.RecordType__c;
            System.debug('Record Type : '+rectype);
            mrtSet.add(rectype);
        }
        return mrtSet;
    }
    
/*
 **********************************************************
 Test Methods
 ********************************************************** 
 */    

    public static testMethod void testMe() {
        try {testGetMergingRecordTypes();} catch(Exception e) {}
    }
    
    private static void testGetMergingRecordTypes() {
    	String[] objectNames = new String[] {'AAAAAA', 'Account'};
    	for (String objectName : objectNames) {
        	integer i = [select count() from Merging_Record_Type__c where ObjectName__c = :objectName];
        	Set<String> s = getMergingRecordTypes(objectName);
        	System.debug(s.size()+':'+i);
    	    System.assertEquals(s.size(), i);
    	}
    }
    
}