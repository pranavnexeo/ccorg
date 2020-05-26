@isTest
private class Schema_Services_Test {

    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>>>> ' + s);
    }

    static testMethod void test01() {
        List<String> list1 = new List<String>{'Account'};
        List<String> list2 = new List<String>{'Account:VI_Account_Type__c'};
        List<String> list3 = new List<String>{'Accoun2'};
        List<String> list4 = new List<String>{'Account:VI_Account_Typ2__c'};
        
        User u = [select id, Name from User where id = :userinfo.getuserid() limit 1];
        if (u == null) {return;}
        debug(''+u);
        Schema_Services.ReturnClass rc;
        System.runAs(u) {
            rc = Schema_Services.getObjectFieldPermissions(null);
            debug(''+rc);
            rc = Schema_Services.getObjectFieldPermissions(list1);
            debug(''+rc);
            rc = Schema_Services.getObjectFieldPermissions(list2);
            debug(''+rc);
            rc = Schema_Services.getObjectFieldPermissions(list3);
            debug(''+rc);
            rc = Schema_Services.getObjectFieldPermissions(list4);
            debug(''+rc);
        }
    }

}