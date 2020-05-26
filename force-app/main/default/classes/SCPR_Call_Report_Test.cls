@isTest
    private class SCPR_Call_Report_Test {
        public static testMethod void testSCPR_Call_Report() {
        
Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
            account acc = new Account(name = 'test');
            insert acc;
            SCPR_Call_Report scr = new SCPR_Call_Report(acc.id,acc.id,'test',system.now(),'test1','test2','test3');
            //scr.discussion = 'test';
            SCPR_Call_Report scr1 = new SCPR_Call_Report(acc.id,acc.id,'test',system.now(),'test1','test2');
        }
    }