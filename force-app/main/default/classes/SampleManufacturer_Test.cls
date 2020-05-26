@isTest
    private class SampleManufacturer_Test {
        public static testMethod void testSampleManufacturer() {
        
Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
        account acc = new account(name = 'test');
        insert acc;
        //ApexPages.StandardSetController sc = new ApexPages.StandardSetController(acc); 
        SampleManufacturer a = new SampleManufacturer(null);
        a.next();
       // ApexPages.StandardSetController sc = new ApexPages.StandardSetController(acc);
       // SampleManufacturer sm = new SampleManufacturer(sc);
        //sm.next();
        
        }
    }