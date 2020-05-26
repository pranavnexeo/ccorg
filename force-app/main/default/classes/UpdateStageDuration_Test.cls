@isTest
private class UpdateStageDuration_Test {
       

static testMethod void myUnitTest1() {
    	Map<String, SObject> testData = NexeoTestUtils_Test.initData();
        Account a = new Account(Name = 'Test Acc');
        Insert a;
        Opportunity Opp = new Opportunity(Potential_CM__c = 12, Name = 'Test Opp', Accountid = a.id, stagename = 'open', closedate = system.today());
        Insert Opp;
        ES_Profile__c p = new ES_Profile__c(Opportunity__C = opp.id);
        insert p;
        ES_Profile__c p1 = new ES_Profile__c(Opportunity__C = opp.id,stage__c = 'Submitted to WMS');
        insert p1;
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=p.id;
        insert attach;
 
        
        p.stage__c = 'Submitted to WMS';
        p.recordtypeid = RecordType_Functions.LookupRecordTypeId('Submitted to WMS', 'ES_Profile__c');
        update p;

       
     }  
     
     static testMethod void myUnitTest2() {
        Map<String, SObject> testData = NexeoTestUtils_Test.initData();
        Account a = new Account(Name = 'TestAcc');
        Insert a;
        Opportunity Opp = new Opportunity(Potential_CM__c = 12, Name = 'Test Opp', Accountid = a.id, stagename = 'open', closedate = system.today());
        Insert Opp;
        ES_Profile__c p = new ES_Profile__c(Opportunity__C = opp.id);
        insert p;
        ES_Profile__c p1 = new ES_Profile__c(Opportunity__C = opp.id,stage__c = 'Profile Sent to Customer');
        insert p1;
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=p.id;
        insert attach;
 
        
        p.stage__c = 'Profile Sent to Customer';
        p.recordtypeid = RecordType_Functions.LookupRecordTypeId('Profile Sent to Customer', 'ES_Profile__c');
        update p;

       
     } 
     
     static testMethod void myUnitTest3() {
        Map<String, SObject> testData = NexeoTestUtils_Test.initData();
        Account a = new Account(Name = 'TestAcc12');
        Insert a;
        Opportunity Opp = new Opportunity(Potential_CM__c = 12, Name = 'TestOpp', Accountid = a.id, stagename = 'open', closedate = system.today());
        Insert Opp;
        ES_Profile__c p = new ES_Profile__c(Opportunity__C = opp.id);
        insert p;
        ES_Profile__c p1 = new ES_Profile__c(Opportunity__C = opp.id,stage__c = 'Substance Created');
        insert p1;
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=p.id;
        insert attach;
 
        
        p.stage__c = 'Substance Created';
        p.recordtypeid = RecordType_Functions.LookupRecordTypeId('Substance Created', 'ES_Profile__c');
        update p;

       
     } 
     
          static testMethod void myUnitTest4() {
        Map<String, SObject> testData = NexeoTestUtils_Test.initData();      
        Account a = new Account(Name = 'TestAcc1');
        Insert a;
        Opportunity Opp = new Opportunity(Potential_CM__c = 12, Name = 'TestOpp', Accountid = a.id, stagename = 'open', closedate = system.today());
        Insert Opp;
        ES_Profile__c p = new ES_Profile__c(Opportunity__C = opp.id);
        insert p;
        ES_Profile__c p1 = new ES_Profile__c(Opportunity__C = opp.id,stage__c = 'New Profile');
        insert p1;
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=p.id;
        insert attach;
 
        
        p.stage__c = 'New Profile';
        p.recordtypeid = RecordType_Functions.LookupRecordTypeId('New Profile', 'ES_Profile__c');
        update p;

       
     } 
     
          static testMethod void myUnitTest5() {
        Map<String, SObject> testData = NexeoTestUtils_Test.initData();      
        Account a = new Account(Name = 'TestAcc21');
        Insert a;
        Opportunity Opp = new Opportunity(Potential_CM__c = 12, Name = 'TestOpp12', Accountid = a.id, stagename = 'open', closedate = system.today());
        Insert Opp;
        ES_Profile__c p = new ES_Profile__c(Opportunity__C = opp.id);
        insert p;
        ES_Profile__c p1 = new ES_Profile__c(Opportunity__C = opp.id,stage__c = 'Submitted to TSDF');
        insert p1;
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=p.id;
        insert attach;
 
        
        p.stage__c = 'Submitted to TSDF';
        p.recordtypeid = RecordType_Functions.LookupRecordTypeId('Submitted to TSDF', 'ES_Profile__c');
        update p;

       
     } 
     
          static testMethod void myUnitTest6() {
        Map<String, SObject> testData = NexeoTestUtils_Test.initData();      
        Account a = new Account(Name = 'TestAcc12');
        Insert a;
        Opportunity Opp = new Opportunity(Potential_CM__c = 12, Name = 'TestOpp21', Accountid = a.id, stagename = 'open', closedate = system.today());
        Insert Opp;
        ES_Profile__c p = new ES_Profile__c(Opportunity__C = opp.id);
        insert p;
        ES_Profile__c p1 = new ES_Profile__c(Opportunity__C = opp.id,stage__c = 'Profile Approved');
        insert p1;
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=p.id;
        insert attach;
 
        
        p.stage__c = 'profile approved';
        p.recordtypeid = RecordType_Functions.LookupRecordTypeId('Profile Approved', 'ES_Profile__c');
        update p;

       
     } 
     
          static testMethod void myUnitTest7() {
        Map<String, SObject> testData = NexeoTestUtils_Test.initData();      
        Account a = new Account(Name = 'TestAcc12');
        Insert a;
        Opportunity Opp = new Opportunity(Potential_CM__c = 12, Name = 'TestOpp', Accountid = a.id, stagename = 'open', closedate = system.today());
        Insert Opp;
        ES_Profile__c p = new ES_Profile__c(Opportunity__C = opp.id);
        insert p;
        ES_Profile__c p1 = new ES_Profile__c(Opportunity__C = opp.id,stage__c = 'Pricing Approved');
        insert p1;
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=p.id;
        insert attach;
 
        
        p.stage__c = 'Pricing Approved';
        p.recordtypeid = RecordType_Functions.LookupRecordTypeId('Pricing Approved', 'ES_Profile__c');
        update p;

       
     } 
     
          static testMethod void myUnitTest8() {
        Map<String, SObject> testData = NexeoTestUtils_Test.initData();      
        Account a = new Account(Name = 'TestAcc12');
        Insert a;
        Opportunity Opp = new Opportunity(Potential_CM__c = 12, Name = 'TestOpp', Accountid = a.id, stagename = 'open', closedate = system.today());
        Insert Opp;
        ES_Profile__c p = new ES_Profile__c(Opportunity__C = opp.id);
        insert p;
        ES_Profile__c p1 = new ES_Profile__c(Opportunity__C = opp.id,stage__c = 'Material/Pricing Created');
        insert p1;
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=p.id;
        insert attach;
 
        
        p.stage__c = 'Material/Pricing Created';
        p.recordtypeid = RecordType_Functions.LookupRecordTypeId('Material/Pricing Created', 'ES_Profile__c');
        update p;

       
     } 
     
               static testMethod void myUnitTest9() {
        Map<String, SObject> testData = NexeoTestUtils_Test.initData();           
        Account a = new Account(Name = 'TestAcc12');
        Insert a;
        Opportunity Opp = new Opportunity(Potential_CM__c = 12, Name = 'TestOpp', Accountid = a.id, stagename = 'open', closedate = system.today());
        Insert Opp;
        ES_Profile__c p = new ES_Profile__c(Opportunity__C = opp.id);
        insert p;
        ES_Profile__c p1 = new ES_Profile__c(Opportunity__C = opp.id,stage__c = 'Material Added to CPI');
        insert p1;
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=p.id;
        insert attach;
 
        
        p.stage__c = 'Material Added to CPI';
        //p.recordtypeid = RecordType_Functions.LookupRecordTypeId('Material Added to CPI', 'ES_Profile__c');
        update p;

       
     }
     
               static testMethod void myUnitTest10() {
        Map<String, SObject> testData = NexeoTestUtils_Test.initData();           
        Account a = new Account(Name = 'TestAcc12');
        Insert a;
        Opportunity Opp = new Opportunity(Potential_CM__c = 12, Name = 'TestOpp', Accountid = a.id, stagename = 'open', closedate = system.today());
        Insert Opp;
        ES_Profile__c p = new ES_Profile__c(Opportunity__C = opp.id);
        insert p;
        ES_Profile__c p1 = new ES_Profile__c(Opportunity__C = opp.id,stage__c = 'Set-up Complete');
        insert p1;
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=p.id;
        insert attach;
 
        
        p.stage__c = 'Set-up Complete';
        p.recordtypeid = RecordType_Functions.LookupRecordTypeId('Set-up Complete', 'ES_Profile__c');
        update p;

       
     }
     
               static testMethod void myUnitTest11() {
        Map<String, SObject> testData = NexeoTestUtils_Test.initData();           
        Account a = new Account(Name = 'TestAcc12');
        Insert a;
        Opportunity Opp = new Opportunity(Potential_CM__c = 12, Name = 'TestOpp', Accountid = a.id, stagename = 'open', closedate = system.today());
        Insert Opp;
        ES_Profile__c p = new ES_Profile__c(Opportunity__C = opp.id);
        insert p;
        ES_Profile__c p1 = new ES_Profile__c(Opportunity__C = opp.id,stage__c = 'Material Setup in SAP');
        insert p1;
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=p.id;
        insert attach;
 
        
        p.stage__c = 'Material Setup in SAP';
        p.recordtypeid = RecordType_Functions.LookupRecordTypeId('Material Setup in SAP', 'ES_Profile__c');
        update p;

       
     }
     
               static testMethod void myUnitTest12() {
        Map<String, SObject> testData = NexeoTestUtils_Test.initData();           
        Account a = new Account(Name = 'TestAcc12');
        Insert a;
        Opportunity Opp = new Opportunity(Potential_CM__c = 12, Name = 'TestOpp', Accountid = a.id, stagename = 'open', closedate = system.today());
        Insert Opp;
        ES_Profile__c p = new ES_Profile__c(Opportunity__C = opp.id);
        insert p;
        ES_Profile__c p1 = new ES_Profile__c(Opportunity__C = opp.id,stage__c = 'Pricing Rejected');
        insert p1;
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=p.id;
        insert attach;
 
        
        p.stage__c = 'Pricing Rejected';
        p.recordtypeid = RecordType_Functions.LookupRecordTypeId('Pricing Rejected', 'ES_Profile__c');
        update p;

       
     }
     
               static testMethod void myUnitTest13() {
        Map<String, SObject> testData = NexeoTestUtils_Test.initData();           
        Account a = new Account(Name = 'TestAcc12');
        Insert a;
        Opportunity Opp = new Opportunity(Potential_CM__c = 12, Name = 'TestOpp', Accountid = a.id, stagename = 'open', closedate = system.today());
        Insert Opp;
        try{
        ES_Profile__c p = new ES_Profile__c(Opportunity__C = opp.id,stage__c = 'Profile Archived');
        insert p;
        //ES_Profile__c p1 = new ES_Profile__c(Opportunity__C = opp.id,stage__c = 'Profile Archived');
        //insert p1;
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=p.id;
        insert attach;
 
        
        p.stage__c = 'Profile Archived';
        p.recordtypeid = RecordType_Functions.LookupRecordTypeId('Profile Archived', 'ES_Profile__c');
        update p;
} catch(exception e){}
       
     }
     
          
    }