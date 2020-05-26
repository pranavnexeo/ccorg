public with sharing class DebugLog_Functions {

    private static Map<String, DebugLogConfig__c> dlcMap = DebugLogConfig__c.getAll();
    
    public static void logMessage(String className,
                                  String methodName, 
                                  String msg) {
        if (msg == null || msg.trim().length() == 0) {
        	return;
        }
        saveMessages(className, methodName, new Set<String>{msg});
    }
    
    public static void logMessages(String className,
                                   String methodName, 
                                   Set<String> msgs) {
        saveMessages(className, methodName, msgs);
    }
    
    private static boolean isLogEnabled(String className,
                                        String methodName,
                                        Map<String, DebugLogConfig__c> dMap) {
        String key = className + '.' + methodName;
        DebugLogConfig__c dlc = new DebugLogConfig__c();                                        	
    	if (dMap.containsKey(key)) {
    	   dlc = dMap.get(key);
    	} else if (dMap.containsKey(className)) {
           dlc = dMap.get(className);
    	}
    	return dlc.Active__c; 
    }
    
    private static void saveMessages(String className,
                                     String methodName, 
                                     Set<String> msgs) {
        saveMessages(className, methodName, msgs, dlcMap);
    }
    
    private static void saveMessage(String className,
                                    String methodName, 
                                    String msg,
                                    Map<String, DebugLogConfig__c> dMap) {
        saveMessages(className, methodName, new Set<String>{msg}, dMap);
    }
    
    private static void saveMessages(String className,
                                     String methodName, 
                                     Set<String> msgs,
                                     Map<String, DebugLogConfig__c> dMap) {
        if (msgs.isEmpty() || !isLogEnabled(className, methodName, dMap)) {
            return;
        }
        Integer recs = [select count() from DebugLog__c];
        List<DebugLog__c> logs = new List<DebugLog__c>();
        DebugLog__c log;
        for (String msg : msgs) {
            log = new DebugLog__c();
            log.ApexMethod__c = '***** debug log full *****';
            log.Message01__c = '***** debug log full *****';
            if (++recs > 9990) {
            	// limit the debug log object to 9990 records
                logs.add(log);
                break;
            }
            log.ApexMethod__c = className + '.' + methodName;
            log.Message01__c = msg;
            logs.add(log);
        }
        if (!logs.isEmpty()) {
            insert logs;
        }
    }

/*    
    public static void logInsertErrors(String className,
                                       String methodName,
                                       List<Database.Saveresult> srs) {
        saveMessages(className, methodName, getInsertErrors(srs));
    }
    
    public static void logUpsertErrors(String className,
                                       String methodName,
                                       List<Database.Upsertresult> urs) {
        saveMessages(className, methodName, getUpsertErrors(urs));
    }
    
    private static Set<String> getInsertErrors(List<Database.Saveresult> srs) {
        Set<String> msgs = new Set<String>();
        for (Database.Saveresult sr : srs) {
            if(!sr.isSuccess()) {
                List<Database.Error> des = sr.getErrors();
                for(Database.Error de : des) {
                    msgs.add(de.getMessage());
                }
            }
        }
        return msgs;
    }
    
    private static Set<String> getUpsertErrors(List<Database.Upsertresult> urs) {
        Set<String> msgs = new Set<String>();
        for (Database.Upsertresult ur : urs) {
            if(!ur.isSuccess()) {
                List<Database.Error> des = ur.getErrors();
                for(Database.Error de : des) {
                    msgs.add(de.getMessage());
                }
            }
        }
        return msgs;
    }
*/
    
/*
 **********************************************************
 Test Methods
 ********************************************************** 
 */    

    public static testMethod void testMe() {
        testLogMessages();
    }
    
    private static void testLogMessages() {
    	Map<String, DebugLogConfig__c> dMap = new Map<String, DebugLogConfig__c>();
    	DebugLogConfig__c dlc = new DebugLogConfig__c();
    	dlc.Active__c = true;
    	dlc.Name = 'testClass';
    	dMap.put(dlc.Name, dlc);
    	dlc.Name = 'testClass.testMethod';
        dMap.put(dlc.Name, dlc);
    	
        Set<String> msgs = new Set<String>();
        msgs.add('Message 1');
        msgs.add('Message 2');
        msgs.add('Message 3');
        logMessages('testClass',
                    'testMethod', msgs);
        saveMessages('testClass',
                     'testMethod', msgs, dMap);
        saveMessage('testClass',
                    'testMethod', 'testMessage', dMap);
        logMessage('testClass',
                   'testMethod', 'testMessage');
        
    }
    
}