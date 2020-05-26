public with sharing class Audit_Log_Functions {
	/*
    public static Audit_Log__c createAuditLog(String objectName,
                                              String recordType,
                                              String objectId,
                                              String auditNote1,
                                              String auditNote2) {
        Audit_Log__c al = new Audit_Log__c();
        al.Audit_Note1__c = auditNote1;
        al.Audit_Note2__c = auditNote2;
        al.Object_ID__c = objectId;
        al.Object_Name__c = objectName;
        al.Record_Type__c = recordType;
        return al;
    }
    
    public static Audit_Log__c createLogForDeleted(String objectName,
                                                   String recordType,
                                                   String objectId,
                                                   String auditNote2) {
        return createAuditLog(objectName, recordType, objectId, 'Deleted', auditNote2);
    }
    
    public static void insertAuditLogs(List<Audit_Log__c> logs) {
        if (logs != null && !logs.isEmpty()) {
            try {insert logs;} catch(Exception e) {
                ApexPages.addMessages(e);
            }
        } 
    }*/

/*
 **********************************************************
 Test Methods
 ********************************************************** 
 */    

    public static testMethod void testMe() {
        try {testInsertAuditLogs();} catch(Exception e) {}
    }
    
    private static void testInsertAuditLogs() {
        /*
    	String objectName = 'Test Account';
        String recordType = 'Test Prospect';
        String objectId   = 'ObjectId';
        String auditNote2 = 'Test Notes2';
    	Audit_Log__c a1 = createLogForDeleted(objectName, recordType, objectId, auditNote2);
    	List<Audit_Log__c> logs = new List<Audit_Log__c>{a1, a1};
    	insertAuditLogs(logs);
		*/
    }
    
}