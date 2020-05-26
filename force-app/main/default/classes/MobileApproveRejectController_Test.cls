/**
* Test Class to cover code from MobileApproveRejectController 
* 
*/
@IsTest private class MobileApproveRejectController_Test
{  
  /**
  * Constructor
  */ 
  public static testMethod void MobileApproveRejectController_Test()
  {
    Test.startTest();
    Map<String, Id> RTMap = RecordType_Functions.RetrieveRecordTypeNameMap('Account');
        
   /* Account TestAccount1a  = new Account(Name='Test1a',
            AccountNumber='Prospect',
            SAP_Sales_Org__c='0315',
            //RecordTypeId=RTMap.get('Aqualon Other Account'));
            RecordTypeId=RTMap.get('Distribution Customer'));
    insert TestAccount1a;*/
    
    Profile profile = [select id from profile where name='System Administrator'];
    User U = new User(alias = 'standt', email='standarduser@testorg.com', 
            emailencodingkey='UTF-8', lastname='Nexeo_Integration User', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = profile.Id, 
            timezonesidkey='America/Los_Angeles', username='supplierMain@testorg.com',nexPrice_Disregard_Hierarchy__c=True);
        
    insert U;
     Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution Customer').getRecordTypeId();
   Account TestAccount1a = new Account(Name = 'Test',RecordtypeId=RecordTypeId,SAP_Sales_Org__c = 'Test', SAP_DivisionCode__c = 'Test', SAP_Industry_Key__c ='Test',HQ_Sales_Office__c = 'Test', SAP_SalesGroup__c = 'Test');
   insert TestAccount1a;
    
    /*ProcessInstance pi = new ProcessInstance(Status = 'Approved', TargetObjectId = TestAccount1a.id);
    insert pi;
    ProcessInstanceWorkitem wi = new ProcessInstanceWorkitem(ActorId = U.id, OriginalActorId = U.id, ProcessInstanceId = pi.id);
    List<ProcessInstanceWorkitem> Workitem = new List<ProcessInstanceWorkitem>();
    Workitem.add(wi);*/
    
    Sample_Request_Approval_Process__c SRAP1 = new Sample_Request_Approval_Process__c(Process_Name__c='SampleRequestApprovalProcess_Tester', Process_Number__c = 1, Prospect_Criteria_RecordType_Name__c = 'Aqualon Other Account', active__C = true, Sample_Criteria_Product_Development__c = 'N/A', Sample_Criteria_AST_Sample__c = 'N/A', Sample_Criteria_AD_Compounding__c = 'N/A', Sample_Criteria_Tectyl_Product__c = 'N/A'); 
    insert SRAP1;

    Sample_Request__c sr  = new Sample_Request__c(Account__c= TestAccount1a.Id);
    insert sr;

    Approval.ProcessWorkitemRequest req;
    req = new Approval.ProcessWorkitemRequest();
    req.setComments('Submitting for Approval.');
     req.setAction('Approve');
    req.setWorkitemId(sr.Id);
    try{
    Approval.ProcessResult result = Approval.process(req);
    }catch(exception e){}
    //PageReference pageRef = Page.MyPage;
   // Test.setCurrentPage(pageRef);  
    Account ac = new Account(name = 'Target_ID');
    insert ac;
    ApexPages.currentpage().getParameters().put('id', TestAccount1a.id);
    
    MobileApproveRejectController MARC = new MobileApproveRejectController();
    MARC.comments = 'test';
    string s = MARC.formattedObjectDetail;
    List<List<String>> s1 = MARC.lisfDetailFields;
    
    //MARC.Target_ID = System.currentPageReference().getParameters().put('id', sr.id);
    System.debug('---target id---'+MARC.Target_ID);
    MARC.rejectworkitem();

    req = new Approval.ProcessWorkitemRequest();
    req.setComments('Submitting for Approval.');
  
    //req.setObjectId(sr.Id);
    //result = Approval.process(req);
    MARC.approveworkitem();
    
    
    }
}