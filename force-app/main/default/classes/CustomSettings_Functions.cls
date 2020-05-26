public with sharing class CustomSettings_Functions {

    private static final String CRNL = '\r\n';
    private static final CustomSettings__c CUSTOM_SETTINGS = CustomSettings__c.getOrgDefaults();
    
    public static Date getBW_Data_Start_Date() {
        Date sDate = null;
        if (CUSTOM_SETTINGS != null) {
            sDate = CUSTOM_SETTINGS.BW_Data_Start_Date__c;
        }
        if (sDate == null) {
            sDate = System.Today().addMonths(-1);
        }
        return sDate;
    }
    
    public static String getBW_Data_BatchSize() {
        String s = null;
        if (CUSTOM_SETTINGS != null) {
            s = CUSTOM_SETTINGS.BW_Data_BatchSize__c;
        }
        if (s == null || s.trim().length() == 0) {
            s = '200';
        }
        return s;
    }
    
    public static String getBW_Data_LastModified_DateTime() {
        DateTime sdt = null;
        if (CUSTOM_SETTINGS != null) {
            sdt = CUSTOM_SETTINGS.BW_Data_LastModified_DateTime__c;
        }
        if (sdt == null) {
            sdt = DateTime.now();
        }
        String s = sdt.format('yyyy-MM-dd HH:mm:ss.SSS');
        s = s.substring(0, 10) + 'T' + s.substring(11) + 'Z'; 
        return s;
    }
    
    public static Boolean getBW_Data_Updating() {
        if (CUSTOM_SETTINGS != null) {
            return CUSTOM_SETTINGS.BW_Data_Updating__c;
        }
        return false;
    }
    
/*
 **********************************************************
 Test Methods
 ********************************************************** 
 */    

    public static testMethod void testMe() {
        System.debug(''+getBW_Data_Start_Date());
        System.debug(''+getBW_Data_BatchSize());
        System.debug(''+getBW_Data_LastModified_DateTime());
        System.debug(''+getBW_Data_Updating());
    }
    
}