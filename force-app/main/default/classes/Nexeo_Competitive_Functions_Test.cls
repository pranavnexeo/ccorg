@isTest
private class Nexeo_Competitive_Functions_Test {

static testMethod void myUnitTest() {
    	Map<String, SObject> testData = NexeoTestUtils_Test.initData();
        Test.startTest();
        Account acc = new Account(Name='TestAccount');
        insert acc;
        
        Nexeo_Competitor__c NC = new Nexeo_Competitor__c(Name='test');
        Nexeo_Competitor__c NC2 = new Nexeo_Competitor__c(Name='test');
        List<Nexeo_Competitor__c> ncs = new List<Nexeo_Competitor__c>();
        ncs.add(nc); ncs.add(nc2);
        insert ncs;
        
        List<Chemical_Competitive__c> CCList = new List<Chemical_Competitive__c>();
        Chemical_Competitive__c ccc = new Chemical_Competitive__c();
        ccc.Nexeo_Competitor__c = nc.Id;
        ccc.Account__c = acc.Id;
        cclist.add(ccc);
        insert cclist;
        
        List<Consumption__c> ConList = new List<Consumption__c>();
        Consumption__c c = new Consumption__c();
        c.Account_Name__c = acc.Id;
        c.Nexeo_Competitor__c = nc.Id;
        conlist.add(c);
        insert conlist;
        
        list<Plastics_Lost_Order__c> PLOList = new list<Plastics_Lost_Order__c>();
        Plastics_Lost_Order__c p = new Plastics_Lost_Order__c();
        p.Nexeo_Competitor__c = nc.Id;
        plolist.add(p);
        insert plolist;
        
        list<opportunity> OppList = new list<opportunity>();
        opportunity o = new opportunity();
        o.CloseDate = System.today();
        o.Name = 'Test';
        o.StageName = 'In Process';
        opplist.add(o);
        insert opplist;
        
        for(Chemical_Competitive__c cc:cclist){
           cc.Nexeo_Competitor__c = NC2.id;
        }
        update cclist;
        
        for(Consumption__c con:conlist){
          con.Nexeo_Competitor__C = NC2.id;
        }
        update conlist;
        
        for(Plastics_Lost_Order__c PLO:PLOList){
          PLO.Nexeo_Competitor__c = NC2.id;
        }
        update PLOList;
        
   
}

}