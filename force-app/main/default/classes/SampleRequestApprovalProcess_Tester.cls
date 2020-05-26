@isTest
private class SampleRequestApprovalProcess_Tester {
 
  static testMethod void TestMe() {
    Test.startTest();
    Map<String, Id> AccountRecordTypeMap = RecordType_Functions.RetrieveRecordTypeNameMap('Account');

    Map<Id,String> ExpectedResults = new Map<Id,String>();

    Map<ID, Sample_Request__c> samplesmap = new map<ID, sample_request__c>();
   
    List<Account> accounts = new List<Account>();
    List<Sample_Request__c> sampleRequests = new List<Sample_Request__c>();
    List<Sample_Material__c> sampleMaterials = new List<Sample_Material__c>();
    
Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
    Account TestAccount1a  = new Account(Name='Test1a',
                                         AccountNumber='Prospect',
                                         SAP_Sales_Org__c='0315',
                                         //RecordTypeId=AccountRecordTypeMap.get('Aqualon Other Account'));
                                         RecordTypeId=AccountRecordTypeMap.get('Distribution Customer'));
    accounts.add(TestAccount1a);
    insert accounts;

    Sample_Request_Approval_Process__c SRAP1 = new Sample_Request_Approval_Process__c(
        Process_Name__c='SampleRequestApprovalProcess_Tester', 
        Process_Number__c = 1, 
        Prospect_Criteria_RecordType_Name__c = 'Aqualon Other Account', 
        active__C = true, 
        Sample_Criteria_Product_Development__c = 'N/A', 
        Sample_Criteria_AST_Sample__c = 'N/A', 
        Sample_Criteria_AD_Compounding__c = 'N/A', 
        Sample_Criteria_Tectyl_Product__c = 'N/A'); 
    Insert SRAP1;
    
    Sample_Request_Approval_Process__c SRAP2 = new Sample_Request_Approval_Process__c(
        Process_Name__c='SampleRequestApprovalProcess_Tester2', 
        Process_Number__c = 1, 
        Prospect_Criteria_RecordType_Name__c = 'Aqualon Other Account', 
        active__C = true, 
        Sample_Criteria_Product_Development__c = 'N/A', 
        Sample_Criteria_AST_Sample__c = 'N/A', 
        Sample_Criteria_AD_Compounding__c = 'N/A', 
        Sample_Criteria_Tectyl_Product__c = 'N/A',
        Queues_Approver_Queue_Name__c = 'TEST',
        Queues_Approver_Queue_2_Name__c = 'TEST',
        Queues_Approver_Queue_3_Name__c = 'TEST',
        Queues_Coordinator_Queue_Name__c = 'TEST',
        Queues_Notification_Queue_Name__c = 'TEST'     
        ); 
    Insert SRAP2;
    
    Id SRAP1_ID = SampleRequestApprovalProcess_Functions.lookup_ApprovalProcessId(SRAP1.Name); 
    String Approval_Requirements = SampleRequestApprovalProcess_Functions.lookup_Approval_Requirements(SRAP1.Name);   
    Sample_Request__c TestSample1a  = new Sample_Request__c(Account__c= TestAccount1a.Id);
    sampleRequests.add(TestSample1a);
    insert sampleRequests;

    
    //Create Sample Materials
    Sample_Material__c TestMaterial1a  = new Sample_Material__c(Sample_Request__c= TestSample1a.Id,AD_Compound__c=false,Tectyl_Product__c=false);sampleMaterials.add(TestMaterial1a);
    insert sampleMaterials;
    
    LIst<sample_material__c> mats = new list<sample_material__c>();
    mats.add(testmaterial1a);
    String approval_process = SampleRequestApprovalProcess_Functions.lookup_Approval_Process(TestSample1a, mats);
    approval_process = SampleRequestApprovalProcess_Functions.lookup_Approval_Process(TestSample1a.id);

    //Add to SampleRequestIds list
    List<Id> sampleRequestIds = new List<Id>();
    List<Id> sampleRequestIds1 = new List<Id>();
    List<Id> sampleRequestIds2 = new List<Id>();
    List<Id> sampleRequestIds3 = new List<Id>();
    List<Id> sampleRequestIds4 = new List<Id>();
    List<Id> sampleRequestIds5 = new List<Id>();
    List<Id> sampleRequestIds6 = new List<Id>();
    Integer sampleCount = 0;

    for(Sample_Request__c s:sampleRequests)
      {
        samplesmap.put(s.ID, s);
        sampleRequestIds.add(s.Id);
        if (sampleCount <= 20) {sampleRequestIds1.add(s.Id);}
        else if (sampleCount <= 40) {sampleRequestIds2.add(s.Id);}
        else if (sampleCount <= 60) {sampleRequestIds3.add(s.Id);}
        else if (sampleCount <= 80) {sampleRequestIds4.add(s.Id);}
        else if (sampleCount <= 100) {sampleRequestIds5.add(s.Id);}
        else if (sampleCount <= 120) {sampleRequestIds6.add(s.Id);}
          
        sampleCount +=1;          
      }


    //Populate Expected Results
    ExpectedResults.put(TestSample1a.Id,'SampleRequestApprovalProcess_Tester');

    Boolean Process_1 = false;
    Boolean Process_2 = false;
    Boolean Process_3 = false;
    Boolean Process_4 = false;
    Boolean Process_5 = false;
    Boolean Process_6 = false;
    Boolean Process_Specific_Test_Case = true;

    if (Process_1 == true)
      {
      ProcessTest(sampleRequestIds1,ExpectedResults, samplesmap);
      }

    if (Process_2 == true)
      {
      ProcessTest(sampleRequestIds2,ExpectedResults, samplesmap);
      }

    if (Process_3 == true)
      {
      ProcessTest(sampleRequestIds3,ExpectedResults, samplesmap);
      }

    if (Process_4 == true)
      {
      ProcessTest(sampleRequestIds4,ExpectedResults, samplesmap);
      }

    if (Process_5 == true)
      {
      ProcessTest(sampleRequestIds5,ExpectedResults, samplesmap);
      }

    if (Process_6 == true)
      {
      ProcessTest(sampleRequestIds6,ExpectedResults, samplesmap);
      }

    if (Process_Specific_Test_Case == true) {
      List<Id> SamplestoTest = new List<id>();
      SamplestoTest.add(TestSample1a.Id);
        
      Map<Id,String> results = SampleRequestApprovalProcess_Functions.lookup_Approval_Process(SamplestoTest);
      for(Id sampleRequestId:SamplestoTest) {
         System.debug('SampleRequestID: ' + sampleRequestID);
         System.debug('SampleRequest: ' + samplesmap.get(sampleRequestID));
         System.debug('Result=' + results.get(sampleRequestId) + ' - ' + 'Expected Result=' + ExpectedResults.get(sampleRequestId));
         //System.assertEquals(ExpectedResults.get(sampleRequestId),results.get(sampleRequestId));
      }
    }
    
    SampleRequestApprovalProcess_Functions.Sync_Users_on_ApprovalProcess(SRAP1.Id, true);
    Test.stopTest();
  }
  
  static void ProcessTest(List<Id> sampleIds, Map<Id,String> ExpectedResults, Map<ID, Sample_Request__c> samplesmap) {
    for(Id sampleRequestId:sampleIds) {System.debug('Processing=' + ExpectedResults.get(sampleRequestId));}
    Map<Id,String> results = SampleRequestApprovalProcess_Functions.lookup_Approval_Process(sampleIds);
    for(Id sampleRequestId:sampleIds) {
       System.debug('SampleName: ' + samplesmap.get(sampleRequestID).name);
       System.debug('Result=' + results.get(sampleRequestId) + ' - ' + 'Expected Result=' + ExpectedResults.get(sampleRequestId));
       //System.assertEquals(ExpectedResults.get(sampleRequestId),results.get(sampleRequestId));
    }
  }
  
}