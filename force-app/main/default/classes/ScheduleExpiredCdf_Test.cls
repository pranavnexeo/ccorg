@isTest
public class ScheduleExpiredCdf_Test {
    
    public static testMethod void expiredCdfDeleteTest() {
		List<Contract> cotlist = new List<Contract>();
        List<Contract> updlist = new List<Contract>();
        
        String plant = '0004';
        String matnum = '000000000123456789';
        Map<String, SObject> testData = NexeoTestUtils_Test.initData();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
       
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
                 TimeZoneSidKey='America/Los_Angeles', UserName='hjvvbvh@gorg.com', IsActive = true);
        insert u;
        
              
        Account a = new Account(Name = 'test11',type = 'Customer', OwnerId = u.id, SAP_Sales_Org__c  = '1000');
        insert a;
        
        SAP_Plant__c sp = new SAP_Plant__c();
        sp.Plant_Code__c = plant;
        insert sp;     
       
        SAP_Purchasing_Group__c spg = new SAP_Purchasing_Group__c (Purchasing_Group_Code__c = '123', Name = 'test', User__c = u.id);
        insert spg;
        
        Material_Plant2__c mp2 = new Material_Plant2__c(Record_Key__c = matnum+plant, Material_Number__c = matnum,Planned_Delivery_Time__c= '3', Plant_Code__c = plant, SalesOrg_Code__c = '1000', SAP_Purchasing_Analyst__c = spg.id);
        system.debug('mp2: ' + mp2);
        insert mp2;
        
        Material_Sales_Data2__c mm = new Material_Sales_Data2__c(Name = 'test material', Material_Number__c = matnum, Dist_Channel_Code__c = '30',Sales_Org_Code__c = '1000',Record_Key__c = '123456789012345');
        system.debug('mm:' +mm);
        insert mm;
        
        Contract cot = new Contract(StartDate = system.today().addYears(-3), status = 'Draft',ContractTerm = 1, Buyer_Comments__c = 'New contract creation',OwnerExpirationNotice = '120',AccountId = a.id, OwnerId = u.id,Quantity_1__c = 1234.123, Stocking_Unit__c = 'BAGS',Ashland_Supplier__c = 'Acidchem', SAP_Material__c = mm.id  );
        cotlist.add(cot);
        insert cotlist;
        
        //cot.StartDate = system.today().addYears(-3);
        cot.Status = 'Expired';
        updlist.add(cot);
        update updlist;
        
        
        String CRON_EXP = '0 0 0 15 3 ? *';
        String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP, new Schedule_Expired_Cdf_Delete());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression);
		System.assertEquals(0, ct.TimesTriggered);
        
        expiredCdfDelete b = new expiredCdfDelete();
        database.executebatch(b,200);

        
    }   
}