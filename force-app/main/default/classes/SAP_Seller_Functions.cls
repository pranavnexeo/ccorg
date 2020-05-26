public with sharing class SAP_Seller_Functions {

    private static Integer MAX_RECS = 10000;
    
    private static void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>> ' + s);
    }
    
     public static void processAfterUpsert(List<SAP_Seller__c> ssa, Map<Id,SAP_Seller__c> ssaid) {
        //debug(''+ssa);
        Set<Id> userIds = new Set<Id>();
        for (SAP_Seller__c ss : ssa) {
            userIds.add(ss.User__c);
        }
        for(SAP_Seller__c ss:ssaid.values()){
            UserIds.add(ss.User__c);
        }
        updateUserSapSellerNumbers(userIds);
    } 
    
    public static void updateUserSapSellerNumbers(Set<Id> userIds) {
        Map<String, String> umap = getSapSellerNumbers(userIds);
        String userId;
        for (List<User> usrs : [select Id, SAP_Cust_Num__c 
                                  from User
                                 where
                                 Id in :userIds
                               ]) {
            //debug('Users Size : '+usrs.size());
            for (User u : usrs) {
                userId = u.Id;
                u.SAP_Cust_Num__c = '';
                if (umap.containsKey(userId)) {
                    u.SAP_Cust_Num__c = umap.get(userId);
                    //debug('User : '+u);
                }
            }
            update usrs;
        }
    }
    
    private static Map<String, String> getSapSellerNumbers(Set<Id> userIds) {
        Map<String, Set<String>> amap = new Map<String, Set<String>>();
        Set<String> nums;
        String userId;
        for (SAP_Seller__c ss : [select Name, User__c
                                   from SAP_Seller__c
                                  where User__c in :userIds
                                ]) {
            userId = ss.User__c;
            if (!amap.containsKey(userId)) {
                nums = new Set<String>();
                amap.put(userId, nums);
            } else {
                nums = amap.get(userId);
            }
            nums.add(ss.Name);
        }
        //debug('SapSellerNumberMapSize : '+amap.size());
        Map<String, String> bmap = new Map<String, String>();
        Set<String> kset = amap.keySet();
        for (String k : kset) {
            nums = amap.get(k);
            bmap.put(k, getString(nums));
        }
        //debug('SapSellerNumberMapSize : '+bmap.size());
        return bmap;
    }
    
    private static String getString(Set<String> ss) {
        List<String> alist = new List<String>();
        alist.addAll(ss);
        String s = '', t;
        for (Integer i = 0; i < alist.size();i++) {
            t = alist.get(i);
            if (t != null && t.trim().length() > 0) {
                if (i > 0) {s += ',';}
                s += t;
            }
        }
        if (s.length() > 255) {s = s.substring(0, 255);}
        return s;
    }
    
    public static void deleteInactiveSellerRecords() {
        for (List<SAP_Seller__c> ss : [
            select Id from SAP_Seller__c 
             where User__r.isActive = false
             limit :MAX_RECS
            ]) {
            debug('Inactive Seller Records : '+ ss.size());
            delete ss;
        }
    }
    
    static testMethod void test01() {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      User u2 = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true);
          insert u2;
        List<SAP_Seller__c> ssa; User u; SAP_Seller__c ss;
                  SAP_Seller__c ss1 = new SAP_Seller__c(name = 'test',User__c = u2.id);
          insert ss1;
        ssa = [select Name, User__c from SAP_Seller__c where User__r.isActive = true limit 2];
        processAfterUpsert(ssa, new Map<Id, SAP_Seller__c>());
        u = [select Id, SAP_Cust_Num__c from User where lastname = 'User' limit 1];
        ss = new SAP_Seller__c(Name = '0000123456', User__c = u.Id);
        insert ss;
        u = [select Id, SAP_Cust_Num__c from User where lastname = 'User' limit 1];
        debug('after insert : '+u);
        delete ss;
        u = [select Id, SAP_Cust_Num__c from User where lastname = 'User' limit 1];
        debug('after delete : '+u);
        MAX_RECS = 10;
        deleteInactiveSellerRecords();
        SAP_Seller_Functions.getString(new Set<String>{'1', '3'});
    }
}