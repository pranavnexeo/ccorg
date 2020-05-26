@isTest
Public class Sample_Request_Controller_Test {

    static testMethod void myUnitTest1() {
    
Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
  
    Test.startTest();
   
    Account TestAccount = new Account();
    TestAccount.Name = 'Test Account';
    TestAccount.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Customer','Account');
    insert TestAccount;
    Opportunity opp = new Opportunity(Potential_CM__c =12,Country__c='Canada',accountid = TestAccount.id, Name='12345',StageName='close-won',CloseDate=system.today());
    insert opp;
    Sample_Request__c TestSample1a  = new Sample_Request__c(Account__c= TestAccount.Id);
    insert TestSample1a;
    Contact TestContact = new Contact();
    TestContact.FirstName='Sana';
    TestContact.LastName = 'Test Contact';
    TestContact.AccountId = TestAccount.Id;
    TestContact.No_Email__c=true;
    insert TestContact;

    /*Opportunity TestOpportunity = new Opportunity();
    TestOpportunity.Name = 'Test Opp';
    TestOpportunity.AccountId = TestAccount.id;
    TestOpportunity.StageName = 'New';
    TestOpportunity.CloseDate = System.today();
    TestOpportunity.Potential_CM__c = 12; 
    insert TestOpportunity;*/
    
    Id sampleMaterialRecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Material','Sample_Material__c');

    RecordType_Relationship__c rtr1 = new RecordType_Relationship__c();
    rtr1.Child_RecordTypeId__c = sampleMaterialRecordTypeId;
    rtr1.Parent_RecordTypeId__c = TestAccount.RecordTypeId;
    rtr1.Relationship_Name__c = 'Account to Sample Material';
    insert rtr1;
    
    Sample_Material__c TestMaterial = new Sample_Material__c();
    TestMaterial.name = 'Test';
    TestMaterial.Sample_Quantity__c = 1;
    TestMaterial.Sample_UOM__c = 'Drum';
    TestMaterial.Date_Required_By__c = System.today();
    TestMaterial.Estimated_Sample_Value__c = 1;
    TestMaterial.Potential_Annual_Value__c = 1;
    TestMaterial.RecordTypeId = sampleMaterialRecordTypeId;

    
    Sample_Material__c TestMaterial2 = new Sample_Material__c();
    TestMaterial2.name = 'Test 2';
    TestMaterial2.Sample_Quantity__c = 1;
    TestMaterial2.Sample_UOM__c = 'Drum';
    TestMaterial2.Date_Required_By__c = System.today();
    TestMaterial2.Estimated_Sample_Value__c = 1;
    TestMaterial2.Potential_Annual_Value__c = 1;
    TestMaterial2.RecordTypeId = sampleMaterialRecordTypeId;
  
    Sample_Material__c TestMaterial3 = new Sample_Material__c();
    TestMaterial3.name = 'Test 3';
    TestMaterial3.Sample_Quantity__c = 1;
    TestMaterial3.Sample_UOM__c = 'Drum';
    TestMaterial3.Date_Required_By__c = System.today();
    TestMaterial3.Estimated_Sample_Value__c = 1;
    TestMaterial3.Potential_Annual_Value__c = 1;
    TestMaterial3.RecordTypeId = sampleMaterialRecordTypeId;
  
    String result = '';
    PageReference page;
    Boolean BooleanSwitch = false;
    List <Contact> contactList;
    List <Sample_Material__c> materialList;
    Integer intNbr = 0;
    
    ApexPages.StandardController con = new ApexPages.StandardController(TestSample1a);
    Sample_Request_Controller cls = new Sample_Request_Controller(con);  


    Sample_Request_Controller cls1 = new Sample_Request_Controller();  

    System.currentPageReference().getParameters().put('accountId',TestAccount.Id);
    

    Sample_Request_Controller cls2 = new Sample_Request_Controller();  

    System.currentPageReference().getParameters().put('contactId',TestContact.Id);
    try{
    cls2.Reassign_CSR_Associated_with_Sample_Request();
    
   cls2.init();
   cls2.init(); 
   }catch(exception e){}
  
    BooleanSwitch = cls2.getGotAccount();
    BooleanSwitch = cls2.getGotContact();
    BooleanSwitch = cls2.getGotOpportunity();
    
    
    
    //Sample_Request_Controller cls3 = new Sample_Request_Controller();  
     
   // System.currentPageReference().getParameters().put('oppId',TestOpportunity.Id);
    
    
    
    /*
    cls3.init();
    cls3.init(); 

    BooleanSwitch = cls3.getGotAccount();
    BooleanSwitch = cls3.getGotContact();
    BooleanSwitch = cls3.getGotOpportunity();

    materialList = cls3.getSampleMaterials();
    cls3.AddNewMaterial();
    cls3.RemoveMaterial();
    cls3.ClearMaterialGrid();
  
    //page = cls3.saveAndSubmitForApproval();

    //cls1.performApprovalProcessing();
    result = cls1.getErrorMessage();
    
    cls1.sampleMaterial_All.Ship_From_Location__c = 'abc';
    cls1.sampleMaterial_All.Estimated_Ship_Date__c = System.today();
    cls1.sampleMaterial_All.Estimated_Arrival_Date__c = System.today();
    cls1.sampleMaterial_All.Actual_Ship_Date__c = System.today();
    cls1.sampleMaterial_All.Shipping_Carrier__c = 'abc';
    cls1.sampleMaterial_All.Tracking_Air_Bill__c = 'abc';

    
    Sample_Material__c mtl1 = cls1.getsampleMaterial_All();
    page = cls1.Save_Sample_Request();
    page = cls1.Cancel_Save();
    cls1.ApplyChangesToAllMaterials();
    
    cls1.init_Assign_a_Different_Coordinator();
    page = cls1.Assign_a_Different_Coordinator();
    
    //***********************************************4
    
    result = cls1.getAccountType();
    result = cls1.getCSR_Responsible_for_Order_Entry_Label();
    result = cls1.getSAP_Order_Number_Label();
    result = cls1.getCSRAlreadyAssignedtoEnterOrderMessage();
    intNbr = cls1.getSampleNotesSize();
    List<Note> notes = cls1.getsampleNotes();
    cls1.setNoteToCSR('Test');
    result = cls1.getNoteToCSR();
    cls1.init_Assign_Task_to_CSR_to_Enter_Order();
    BooleanSwitch = cls1.Assign_Task_to_CSR_to_Enter_Order_Valid();
    String userId = [SELECT Id FROM User LIMIT 1].Id;
    result = cls1.retrieveEmailAddressfromUserId(userId);
    page = cls1.AssignTasktoCSRtoEnterOrder();
    
    cls1.init_Cancel_Request() ;
    page = cls1.Cancel_Sample_Request();
    
    List<Sample_Material__c> mtls = cls1.getSampleMaterials_toDelete();
    cls1.init_Delete_Materials();
    page = cls1.Delete_Materials();
    
    cls1.sampleMaterials.Add(TestMaterial3);
    cls1.init_Edit_Materials();
    page = cls1.Edit_Materials_Save();
    
    cls1.init_Enter_Actual_Shipping_Information();
    BooleanSwitch = cls1.Actual_Shipping_Information_Valid();
    page = cls1.Save_Actual_Shipping_Information();
    BooleanSwitch = cls1.getRenderMarkSampleCompletedCheckbox();
    
    result = cls1.getShowMaterials();
    result = cls1.getCSR_Found_on_Account();
    result = cls1.getSampleRequestOrderEntered();
    cls1.setSampleRequestOrderEntered('true');
    result = cls1.getProspectAccountInformation();
    result = cls1.getMaterialSpecificInstructions();
    cls1.init_Enter_Order_Information();
    BooleanSwitch = cls1.Order_Entry_by_Coordinator_Valid();
    cls1.ToggleShowMaterials();
    page = cls1.Save_Order_Information_Coordinator();
    
    cls1.sampleRequest.CSR_Responsible_for_Order_Entry__c = [SELECT Id FROM User LIMIT 1].Id;
    cls1.sampleRequest.Sample_Coordinator__c = [SELECT Id FROM User LIMIT 1].Id;
    
    BooleanSwitch = cls1.Order_Entry_by_CSR_Valid();
    page = cls1.Save_Order_Information_CSR();
    page = cls1.Reassign_CSR_Associated_with_Sample_Request();
    BooleanSwitch = cls1.getAllow_CSR_to_Take_OrderEntry_Responsibility();
    BooleanSwitch = cls1.getRenderSampleNotes();
    cls1.init_Place_Request_On_Hold();
    page = cls1.Place_Sample_Request_On_Hold();
    result = cls1.getStreet();
    cls1.setStreet('street');
    result = cls1.getCity();
    cls1.setCity('City');
    result = cls1.getState();
    cls1.setState('State');
    result = cls1.getPostalCode();
    cls1.setPostalCode('PostalCode');
    result = cls1.getCountry();
    cls1.setCountry('Country');
    result = cls1.getShowUpdateAddressInformation();
    cls1.getAddressChangeError();
    
    
    */
    Test.stopTest();
    }
    static testMethod void myUnitTest2() {
    
Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
        
    Test.startTest();
   
    Account TestAccount = new Account();
    TestAccount.Name = 'Test Account';
    TestAccount.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Customer','Account');
    insert TestAccount;
    Opportunity opp = new Opportunity(Potential_CM__c =12,Country__c='Canada',accountid = TestAccount.id, Name='12345',StageName='close-won',CloseDate=system.today());
    insert opp;
    Sample_Request__c TestSample1a  = new Sample_Request__c(Account__c= TestAccount.Id);
    insert TestSample1a;
    Contact TestContact = new Contact();
    TestContact.FirstName='Sana';
    TestContact.LastName = 'Test Contact';
    TestContact.AccountId = TestAccount.Id;
    TestContact.No_Email__c=true;
    insert TestContact;

    /*Opportunity TestOpportunity = new Opportunity();
    TestOpportunity.Name = 'Test Opp';
    TestOpportunity.AccountId = TestAccount.id;
    TestOpportunity.StageName = 'New';
    TestOpportunity.CloseDate = System.today();
    TestOpportunity.Potential_CM__c = 12; 
    insert TestOpportunity;*/
    
    Id sampleMaterialRecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Material','Sample_Material__c');

    RecordType_Relationship__c rtr1 = new RecordType_Relationship__c();
    rtr1.Child_RecordTypeId__c = sampleMaterialRecordTypeId;
    rtr1.Parent_RecordTypeId__c = TestAccount.RecordTypeId;
    rtr1.Relationship_Name__c = 'Account to Sample Material';
    insert rtr1;
    
    Sample_Material__c TestMaterial = new Sample_Material__c();
    TestMaterial.name = 'Test';
    TestMaterial.Sample_Quantity__c = 1;
    TestMaterial.Sample_UOM__c = 'Drum';
    TestMaterial.Date_Required_By__c = System.today();
    TestMaterial.Estimated_Sample_Value__c = 1;
    TestMaterial.Potential_Annual_Value__c = 1;
    TestMaterial.RecordTypeId = sampleMaterialRecordTypeId;

    
    Sample_Material__c TestMaterial2 = new Sample_Material__c();
    TestMaterial2.name = 'Test 2';
    TestMaterial2.Sample_Quantity__c = 1;
    TestMaterial2.Sample_UOM__c = 'Drum';
    TestMaterial2.Date_Required_By__c = System.today();
    TestMaterial2.Estimated_Sample_Value__c = 1;
    TestMaterial2.Potential_Annual_Value__c = 1;
    TestMaterial2.RecordTypeId = sampleMaterialRecordTypeId;
  
    Sample_Material__c TestMaterial3 = new Sample_Material__c();
    TestMaterial3.name = 'Test 3';
    TestMaterial3.Sample_Quantity__c = 1;
    TestMaterial3.Sample_UOM__c = 'Drum';
    TestMaterial3.Date_Required_By__c = System.today();
    TestMaterial3.Estimated_Sample_Value__c = 1;
    TestMaterial3.Potential_Annual_Value__c = 1;
    TestMaterial3.RecordTypeId = sampleMaterialRecordTypeId;
  
    String result = '';
    PageReference page;
    Boolean BooleanSwitch = false;
    List <Contact> contactList;
    List <Sample_Material__c> materialList;
    Integer intNbr = 0;

    ApexPages.StandardController con = new ApexPages.StandardController(TestSample1a);
    Sample_Request_Controller cls = new Sample_Request_Controller(con);  
     //******************************************2
        cls.hasOpportunity = true;
    cls.emailcsrgroupbox = false;
    cls.initAquarius();
    cls.CancelAddressChanges();
    cls.SaveAddressChanges();
    cls.UpdateAddressInformation_Button();
    cls.getAddressChangeError();
    cls.getShowUpdateAddressInformation();
    cls.setCountry('test');
    cls.getCountry();
    cls.init_Enter_Order_Information_CSR();
    cls.getRenderSampleNotes();
    cls.getShowMaterials();
    cls.getCSR_Found_on_Account();
    cls.getsampleNotes();
    cls.getSampleNotesSize();
    cls.Save_Actual_Shipping_Information();
    cls.Actual_Shipping_Information_Valid();
    cls.init_Enter_Actual_Shipping_Information();
    cls.getSampleRequestCompleted();
    cls.setSampleRequestCompleted('test1');
    cls.getRenderMarkSampleCompletedCheckbox();
    try{
    cls.Edit_Materials_Save();
    }catch(exception e){}
    cls.Delete_Materials();
    cls.init_Delete_Materials();
    cls.getSampleMaterials_toDelete();
    cls.Cancel_Sample_Request();
    cls.Cancel_Request_Valid();
    cls.init_Cancel_Request();
    cls.AssignTasktoCSRtoEnterOrder();
    try{
    cls.retrieveEmailAddressfromUserId('tsetid');
    }catch(exception e){}
    cls.Assign_Task_to_CSR_to_Enter_Order_Valid();
    cls.init_Assign_Task_to_CSR_to_Enter_Order();
    cls.getCSRAlreadyAssignedtoEnterOrderMessage();
    cls.getSAP_Order_Number_Label();
    cls.getCSR_Responsible_for_Order_Entry_Label();
    cls.getAccountType();
    cls.setNoteToCSR('testing');
    cls.getNoteToCSR();
    cls.Assign_a_Different_Coordinator();
    cls.init_Assign_a_Different_Coordinator();
    cls.ApplyChangesToAllMaterials();
    cls.Cancel_Save();
    cls.Save_Sample_Request();
    cls.getSample_Request_Link();
    cls.getsampleMaterial_All();
    cls.getErrorMessage();
    //cls.performApprovalProcessing();
    cls.getApprovalRequirements();
    cls.getApproverQueueName();
    cls.getBackupApproverQueue();
    
    
    
    Test.stopTest();
    }
    static testMethod void myUnitTest3() {
    
Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
    Test.startTest();
   
    Account TestAccount = new Account();
    TestAccount.Name = 'Test Account';
    TestAccount.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Customer','Account');
    insert TestAccount;
    Opportunity opp = new Opportunity(Potential_CM__c =12,Country__c='Canada',accountid = TestAccount.id, Name='12345',StageName='close-won',CloseDate=system.today());
    insert opp;
    Sample_Request__c TestSample1a  = new Sample_Request__c(Account__c= TestAccount.Id);
    insert TestSample1a;
    Contact TestContact = new Contact();
    TestContact.FirstName='Sana';
    TestContact.LastName = 'Test Contact';
    TestContact.AccountId = TestAccount.Id;
    TestContact.No_Email__c=true;
    insert TestContact;

    /*Opportunity TestOpportunity = new Opportunity();
    TestOpportunity.Name = 'Test Opp';
    TestOpportunity.AccountId = TestAccount.id;
    TestOpportunity.StageName = 'New';
    TestOpportunity.CloseDate = System.today();
    TestOpportunity.Potential_CM__c = 12; 
    insert TestOpportunity;*/
    
    Id sampleMaterialRecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Material','Sample_Material__c');

    RecordType_Relationship__c rtr1 = new RecordType_Relationship__c();
    rtr1.Child_RecordTypeId__c = sampleMaterialRecordTypeId;
    rtr1.Parent_RecordTypeId__c = TestAccount.RecordTypeId;
    rtr1.Relationship_Name__c = 'Account to Sample Material';
    insert rtr1;
    
    Sample_Material__c TestMaterial = new Sample_Material__c();
    TestMaterial.name = 'Test';
    TestMaterial.Sample_Quantity__c = 1;
    TestMaterial.Sample_UOM__c = 'Drum';
    TestMaterial.Date_Required_By__c = System.today();
    TestMaterial.Estimated_Sample_Value__c = 1;
    TestMaterial.Potential_Annual_Value__c = 1;
    TestMaterial.RecordTypeId = sampleMaterialRecordTypeId;

    
    Sample_Material__c TestMaterial2 = new Sample_Material__c();
    TestMaterial2.name = 'Test 2';
    TestMaterial2.Sample_Quantity__c = 1;
    TestMaterial2.Sample_UOM__c = 'Drum';
    TestMaterial2.Date_Required_By__c = System.today();
    TestMaterial2.Estimated_Sample_Value__c = 1;
    TestMaterial2.Potential_Annual_Value__c = 1;
    TestMaterial2.RecordTypeId = sampleMaterialRecordTypeId;
  
    Sample_Material__c TestMaterial3 = new Sample_Material__c();
    TestMaterial3.name = 'Test 3';
    TestMaterial3.Sample_Quantity__c = 1;
    TestMaterial3.Sample_UOM__c = 'Drum';
    TestMaterial3.Date_Required_By__c = System.today();
    TestMaterial3.Estimated_Sample_Value__c = 1;
    TestMaterial3.Potential_Annual_Value__c = 1;
    TestMaterial3.RecordTypeId = sampleMaterialRecordTypeId;
  
    String result = '';
    PageReference page;
    Boolean BooleanSwitch = false;
    List <Contact> contactList;
    List <Sample_Material__c> materialList;
    Integer intNbr = 0;
    Sample_Request_Controller cls1 = new Sample_Request_Controller();  

    System.currentPageReference().getParameters().put('accountId',TestAccount.Id);
    // cls1.init();
    cls1.init(); //Call a second time, so other logic is hit
    cls1.getApproverQueue2();
    try{
    cls1.saveAndSubmitForApproval();
    }catch(exception e){}
    cls1.getRenderPMCastingsProductLine();
    cls1.getRenderAHWTProductLine();
    cls1.getRenderProductLine();
    cls1.setOpportunitySelected('test');
    
    
    contactList = cls1.getContacts();
    cls1.sampleMaterials.Add(TestMaterial);
    Sample_Request_Controller cls2 = new Sample_Request_Controller();  

    System.currentPageReference().getParameters().put('contactId',TestContact.Id);
  /*  
    try{
    materialList = cls2.getSampleMaterials();
    cls2.AddNewMaterial();
    cls2.RemoveMaterial();
    cls2.ClearMaterialGrid();
    }catch(exception e){
     }

    try{
     page = cls2.saveAndSubmitForApproval();
     }catch(exception e){
     }
    */
    test.stoptest();
    }
    static testMethod void myUnitTest4() {
    
Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
    Test.startTest();
    Account TestAccount = new Account();
    TestAccount.Name = 'Test Account';
    TestAccount.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Customer','Account');
    insert TestAccount;
    Opportunity opp = new Opportunity(Potential_CM__c =12,Country__c='Canada',accountid = TestAccount.id, Name='12345',StageName='close-won',CloseDate=system.today());
    insert opp;
    Sample_Request__c TestSample1a  = new Sample_Request__c(Account__c= TestAccount.Id);
    insert TestSample1a;
    Contact TestContact = new Contact();
    TestContact.FirstName='Sana';
    TestContact.LastName = 'Test Contact';
    TestContact.AccountId = TestAccount.Id;
    TestContact.No_Email__c=true;
    insert TestContact;

    /*Opportunity TestOpportunity = new Opportunity();
    TestOpportunity.Name = 'Test Opp';
    TestOpportunity.AccountId = TestAccount.id;
    TestOpportunity.StageName = 'New';
    TestOpportunity.CloseDate = System.today();
    TestOpportunity.Potential_CM__c = 12; 
    insert TestOpportunity;*/
    
    Id sampleMaterialRecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Material','Sample_Material__c');

    RecordType_Relationship__c rtr1 = new RecordType_Relationship__c();
    rtr1.Child_RecordTypeId__c = sampleMaterialRecordTypeId;
    rtr1.Parent_RecordTypeId__c = TestAccount.RecordTypeId;
    rtr1.Relationship_Name__c = 'Account to Sample Material';
    insert rtr1;
    
    Sample_Material__c TestMaterial = new Sample_Material__c();
    TestMaterial.name = 'Test';
    TestMaterial.Sample_Quantity__c = 1;
    TestMaterial.Sample_UOM__c = 'Drum';
    TestMaterial.Date_Required_By__c = System.today();
    TestMaterial.Estimated_Sample_Value__c = 1;
    TestMaterial.Potential_Annual_Value__c = 1;
    TestMaterial.RecordTypeId = sampleMaterialRecordTypeId;

    
    Sample_Material__c TestMaterial2 = new Sample_Material__c();
    TestMaterial2.name = 'Test 2';
    TestMaterial2.Sample_Quantity__c = 1;
    TestMaterial2.Sample_UOM__c = 'Drum';
    TestMaterial2.Date_Required_By__c = System.today();
    TestMaterial2.Estimated_Sample_Value__c = 1;
    TestMaterial2.Potential_Annual_Value__c = 1;
    TestMaterial2.RecordTypeId = sampleMaterialRecordTypeId;
  
    Sample_Material__c TestMaterial3 = new Sample_Material__c();
    TestMaterial3.name = 'Test 3';
    TestMaterial3.Sample_Quantity__c = 1;
    TestMaterial3.Sample_UOM__c = 'Drum';
    TestMaterial3.Date_Required_By__c = System.today();
    TestMaterial3.Estimated_Sample_Value__c = 1;
    TestMaterial3.Potential_Annual_Value__c = 1;
    TestMaterial3.RecordTypeId = sampleMaterialRecordTypeId;
  
    String result = '';
    PageReference page;
    Boolean BooleanSwitch = false;
    List <Contact> contactList;
    List <Sample_Material__c> materialList;
    Integer intNbr = 0;
    
    ApexPages.StandardController con = new ApexPages.StandardController(TestSample1a);
    Sample_Request_Controller cls = new Sample_Request_Controller(con);  


    Sample_Request_Controller cls1 = new Sample_Request_Controller();  

    System.currentPageReference().getParameters().put('accountId',TestAccount.Id);
    
   
    
    cls1.setContactSelected(TestContact.Id);
    result = cls1.getContactSelected();
    test.stoptest();
    }
        static testMethod void myUnitTest5() {
        
Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
    Test.startTest();
   
    Account TestAccount = new Account();
    TestAccount.Name = 'Test Account';
    TestAccount.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Customer','Account');
    insert TestAccount;
    Opportunity opp = new Opportunity(Potential_CM__c =12,Country__c='Canada',accountid = TestAccount.id, Name='12345',StageName='close-won',CloseDate=system.today());
    insert opp;
    Sample_Request__c TestSample1a  = new Sample_Request__c(Account__c= TestAccount.Id);
    insert TestSample1a;
    Contact TestContact = new Contact();
    TestContact.FirstName='Sana';
    TestContact.LastName = 'Test Contact';
    TestContact.AccountId = TestAccount.Id;
    TestContact.No_Email__c=true;
    insert TestContact;

    /*Opportunity TestOpportunity = new Opportunity();
    TestOpportunity.Name = 'Test Opp';
    TestOpportunity.AccountId = TestAccount.id;
    TestOpportunity.StageName = 'New';
    TestOpportunity.CloseDate = System.today();
    TestOpportunity.Potential_CM__c = 12; 
    insert TestOpportunity;*/
    
    Id sampleMaterialRecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Material','Sample_Material__c');

    RecordType_Relationship__c rtr1 = new RecordType_Relationship__c();
    rtr1.Child_RecordTypeId__c = sampleMaterialRecordTypeId;
    rtr1.Parent_RecordTypeId__c = TestAccount.RecordTypeId;
    rtr1.Relationship_Name__c = 'Account to Sample Material';
    insert rtr1;
    
    Sample_Material__c TestMaterial = new Sample_Material__c();
    TestMaterial.name = 'Test';
    TestMaterial.Sample_Quantity__c = 1;
    TestMaterial.Sample_UOM__c = 'Drum';
    TestMaterial.Date_Required_By__c = System.today();
    TestMaterial.Estimated_Sample_Value__c = 1;
    TestMaterial.Potential_Annual_Value__c = 1;
    TestMaterial.RecordTypeId = sampleMaterialRecordTypeId;

    
    Sample_Material__c TestMaterial2 = new Sample_Material__c();
    TestMaterial2.name = 'Test 2';
    TestMaterial2.Sample_Quantity__c = 1;
    TestMaterial2.Sample_UOM__c = 'Drum';
    TestMaterial2.Date_Required_By__c = System.today();
    TestMaterial2.Estimated_Sample_Value__c = 1;
    TestMaterial2.Potential_Annual_Value__c = 1;
    TestMaterial2.RecordTypeId = sampleMaterialRecordTypeId;
  
    Sample_Material__c TestMaterial3 = new Sample_Material__c();
    TestMaterial3.name = 'Test 3';
    TestMaterial3.Sample_Quantity__c = 1;
    TestMaterial3.Sample_UOM__c = 'Drum';
    TestMaterial3.Date_Required_By__c = System.today();
    TestMaterial3.Estimated_Sample_Value__c = 1;
    TestMaterial3.Potential_Annual_Value__c = 1;
    TestMaterial3.RecordTypeId = sampleMaterialRecordTypeId;
  
    String result = '';
    PageReference page;
    Boolean BooleanSwitch = false;
    List <Contact> contactList;
    List <Sample_Material__c> materialList;
    Integer intNbr = 0;
    Sample_Request_Controller cls1 = new Sample_Request_Controller();  

    System.currentPageReference().getParameters().put('accountId',TestAccount.Id);
     //cls1.init();
    cls1.init(); //Call a second time, so other logic is hit
    
    contactList = cls1.getContacts();
    cls1.sampleMaterials.Add(TestMaterial);
    cls1.sampleMaterials.Add(TestMaterial2);
    
    test.stoptest();
    
    }
    static testMethod void myUnitTest6() {
    
Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
    Test.startTest();
   
    Account TestAccount = new Account();
    TestAccount.Name = 'Test Account';
    TestAccount.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Customer','Account');
    insert TestAccount;
    Opportunity opp = new Opportunity(Potential_CM__c =12,Country__c='Canada',accountid = TestAccount.id, Name='12345',StageName='close-won',CloseDate=system.today());
    insert opp;
    Sample_Request__c TestSample1a  = new Sample_Request__c(Account__c= TestAccount.Id);
    insert TestSample1a;
    Contact TestContact = new Contact();
    TestContact.FirstName='Sana';
    TestContact.LastName = 'Test Contact';
    TestContact.AccountId = TestAccount.Id;
    TestContact.No_Email__c=true;
    insert TestContact;

    /*Opportunity TestOpportunity = new Opportunity();
    TestOpportunity.Name = 'Test Opp';
    TestOpportunity.AccountId = TestAccount.id;
    TestOpportunity.StageName = 'New';
    TestOpportunity.CloseDate = System.today();
    TestOpportunity.Potential_CM__c = 12; 
    insert TestOpportunity;*/
    
    Id sampleMaterialRecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Material','Sample_Material__c');

    RecordType_Relationship__c rtr1 = new RecordType_Relationship__c();
    rtr1.Child_RecordTypeId__c = sampleMaterialRecordTypeId;
    rtr1.Parent_RecordTypeId__c = TestAccount.RecordTypeId;
    rtr1.Relationship_Name__c = 'Account to Sample Material';
    insert rtr1;
    
    Sample_Material__c TestMaterial = new Sample_Material__c();
    TestMaterial.name = 'Test';
    TestMaterial.Sample_Quantity__c = 1;
    TestMaterial.Sample_UOM__c = 'Drum';
    TestMaterial.Date_Required_By__c = System.today();
    TestMaterial.Estimated_Sample_Value__c = 1;
    TestMaterial.Potential_Annual_Value__c = 1;
    TestMaterial.RecordTypeId = sampleMaterialRecordTypeId;

    
    Sample_Material__c TestMaterial2 = new Sample_Material__c();
    TestMaterial2.name = 'Test 2';
    TestMaterial2.Sample_Quantity__c = 1;
    TestMaterial2.Sample_UOM__c = 'Drum';
    TestMaterial2.Date_Required_By__c = System.today();
    TestMaterial2.Estimated_Sample_Value__c = 1;
    TestMaterial2.Potential_Annual_Value__c = 1;
    TestMaterial2.RecordTypeId = sampleMaterialRecordTypeId;
  
    Sample_Material__c TestMaterial3 = new Sample_Material__c();
    TestMaterial3.name = 'Test 3';
    TestMaterial3.Sample_Quantity__c = 1;
    TestMaterial3.Sample_UOM__c = 'Drum';
    TestMaterial3.Date_Required_By__c = System.today();
    TestMaterial3.Estimated_Sample_Value__c = 1;
    TestMaterial3.Potential_Annual_Value__c = 1;
    TestMaterial3.RecordTypeId = sampleMaterialRecordTypeId;
  
    String result = '';
    PageReference page;
    Boolean BooleanSwitch = false;
    List <Contact> contactList;
    List <Sample_Material__c> materialList;
    Integer intNbr = 0;
    Sample_Request_Controller cls1 = new Sample_Request_Controller();  
     
    System.currentPageReference().getParameters().put('accountId',TestAccount.Id);
        cls1.init();
    BooleanSwitch = cls1.getCreatingContact();
    //cls1.setOpportunitySelected(TestOpportunity.Id);
    result = cls1.getOpportunitySelected();
    result = cls1.getAlreadyHaveOpportunityMessage();
    intNbr = cls1.getOpportunityRelatedtoParentAccount_Count();
    cls1.getOpportunities();
    
    cls1.init();

    BooleanSwitch = cls1.getEnableDisable_AccountAddressButton();
    BooleanSwitch = cls1.getEnableDisable_ContactAddressButton();
    result = cls1.getStyle_AccountAddressButton();
    result = cls1.getStyle_ContactAddressButton();

    BooleanSwitch = cls1.gethideshow_AddressManualEntry();
    BooleanSwitch = cls1.gethideshow_AddressManualEntry_Account();
    BooleanSwitch = cls1.gethideshow_AddressManualEntry_Contact();
    BooleanSwitch = cls1.gethideshow_AddressSection();
    cls1.populateShipToAddress_Manually(); 
    result = cls1.getAccountAddress();
    result = cls1.getSampleRequestAddress();
    cls1.populateShipToAddress_from_Account();
    result = cls1.getContactAddress();
    test.stoptest();
    }
    static testMethod void myUnitTest7() {
    
Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
    Test.startTest();
   
    Account TestAccount = new Account();
    TestAccount.Name = 'Test Account';
    TestAccount.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Customer','Account');
    insert TestAccount;
    Opportunity opp = new Opportunity(Potential_CM__c =12,Country__c='Canada',accountid = TestAccount.id, Name='12345',StageName='close-won',CloseDate=system.today());
    insert opp;
    Sample_Request__c TestSample1a  = new Sample_Request__c(Account__c= TestAccount.Id);
    insert TestSample1a;
    Contact TestContact = new Contact();
    TestContact.FirstName='Sana';
    TestContact.LastName = 'Test Contact';
    TestContact.AccountId = TestAccount.Id;
    TestContact.No_Email__c=true;
    insert TestContact;

    /*Opportunity TestOpportunity = new Opportunity();
    TestOpportunity.Name = 'Test Opp';
    TestOpportunity.AccountId = TestAccount.id;
    TestOpportunity.StageName = 'New';
    TestOpportunity.CloseDate = System.today();
    TestOpportunity.Potential_CM__c = 12; 
    insert TestOpportunity;*/
    
    Id sampleMaterialRecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Material','Sample_Material__c');

    RecordType_Relationship__c rtr1 = new RecordType_Relationship__c();
    rtr1.Child_RecordTypeId__c = sampleMaterialRecordTypeId;
    rtr1.Parent_RecordTypeId__c = TestAccount.RecordTypeId;
    rtr1.Relationship_Name__c = 'Account to Sample Material';
    insert rtr1;
    
    Sample_Material__c TestMaterial = new Sample_Material__c();
    TestMaterial.name = 'Test';
    TestMaterial.Sample_Quantity__c = 1;
    TestMaterial.Sample_UOM__c = 'Drum';
    TestMaterial.Date_Required_By__c = System.today();
    TestMaterial.Estimated_Sample_Value__c = 1;
    TestMaterial.Potential_Annual_Value__c = 1;
    TestMaterial.RecordTypeId = sampleMaterialRecordTypeId;

    
    Sample_Material__c TestMaterial2 = new Sample_Material__c();
    TestMaterial2.name = 'Test 2';
    TestMaterial2.Sample_Quantity__c = 1;
    TestMaterial2.Sample_UOM__c = 'Drum';
    TestMaterial2.Date_Required_By__c = System.today();
    TestMaterial2.Estimated_Sample_Value__c = 1;
    TestMaterial2.Potential_Annual_Value__c = 1;
    TestMaterial2.RecordTypeId = sampleMaterialRecordTypeId;
  
    Sample_Material__c TestMaterial3 = new Sample_Material__c();
    TestMaterial3.name = 'Test 3';
    TestMaterial3.Sample_Quantity__c = 1;
    TestMaterial3.Sample_UOM__c = 'Drum';
    TestMaterial3.Date_Required_By__c = System.today();
    TestMaterial3.Estimated_Sample_Value__c = 1;
    TestMaterial3.Potential_Annual_Value__c = 1;
    TestMaterial3.RecordTypeId = sampleMaterialRecordTypeId;
  
    String result = '';
    PageReference page;
    Boolean BooleanSwitch = false;
    List <Contact> contactList;
    List <Sample_Material__c> materialList;
    Integer intNbr = 0;
    Sample_Request_Controller cls1 = new Sample_Request_Controller();  

    System.currentPageReference().getParameters().put('accountId',TestAccount.Id);
        //cls1.init();
        BooleanSwitch = cls1.getRenderTectyl();
    BooleanSwitch = cls1.getRenderADCompound();
    BooleanSwitch = cls1.getRenderProductDevelopment();
    BooleanSwitch = cls1.getRenderASTSamples();
    BooleanSwitch = cls1.getRenderGeneralMaterialQuestions();
    BooleanSwitch = cls1.getRenderOakCreek();

    cls1.setContactSelected('New Contact');
    result = cls1.getContactSelected();
    cls1.init();
    
    cls1.sampleRequest.Contact_First_Name__c = 'Test';
    cls1.sampleRequest.Contact_Last_Name__c = 'Test';

    BooleanSwitch = cls1.getGotAccount();
    BooleanSwitch = cls1.getGotContact();
    BooleanSwitch = cls1.getGotOpportunity();

    materialList = cls1.getSampleMaterials();

    cls1.sampleMaterials.Add(TestMaterial);

    cls1.AddNewMaterial();
    cls1.RemoveMaterial();
    cls1.ClearMaterialGrid();
    page = cls1.step1();
    page = cls1.step2A();
    page = cls1.step3();
    page = cls1.step4();
    page = cls1.step5();
    result = cls1.getNoApprovalProcessMessage();
    result = cls1.getApproverQueue();
    test.stoptest();
   }
   static testMethod void myUnitTest8() {
   
Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
    Test.startTest();
   
    Account TestAccount = new Account();
    TestAccount.Name = 'Test Account';
    TestAccount.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Customer','Account');
    insert TestAccount;
    Opportunity opp = new Opportunity(Potential_CM__c =12,Country__c='Canada',accountid = TestAccount.id, Name='12345',StageName='close-won',CloseDate=system.today());
    insert opp;
    Sample_Request__c TestSample1a  = new Sample_Request__c(Account__c= TestAccount.Id);
    insert TestSample1a;
    Contact TestContact = new Contact();
    TestContact.FirstName='Sana';
    TestContact.LastName = 'Test Contact';
    TestContact.AccountId = TestAccount.Id;
    TestContact.No_Email__c=true;
    insert TestContact;

    /*Opportunity TestOpportunity = new Opportunity();
    TestOpportunity.Name = 'Test Opp';
    TestOpportunity.AccountId = TestAccount.id;
    TestOpportunity.StageName = 'New';
    TestOpportunity.CloseDate = System.today();
    TestOpportunity.Potential_CM__c = 12; 
    insert TestOpportunity;*/
    
    Id sampleMaterialRecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Material','Sample_Material__c');

    RecordType_Relationship__c rtr1 = new RecordType_Relationship__c();
    rtr1.Child_RecordTypeId__c = sampleMaterialRecordTypeId;
    rtr1.Parent_RecordTypeId__c = TestAccount.RecordTypeId;
    rtr1.Relationship_Name__c = 'Account to Sample Material';
    insert rtr1;
    
    Sample_Material__c TestMaterial = new Sample_Material__c();
    TestMaterial.name = 'Test';
    TestMaterial.Sample_Quantity__c = 1;
    TestMaterial.Sample_UOM__c = 'Drum';
    TestMaterial.Date_Required_By__c = System.today();
    TestMaterial.Estimated_Sample_Value__c = 1;
    TestMaterial.Potential_Annual_Value__c = 1;
    TestMaterial.RecordTypeId = sampleMaterialRecordTypeId;

    
    Sample_Material__c TestMaterial2 = new Sample_Material__c();
    TestMaterial2.name = 'Test 2';
    TestMaterial2.Sample_Quantity__c = 1;
    TestMaterial2.Sample_UOM__c = 'Drum';
    TestMaterial2.Date_Required_By__c = System.today();
    TestMaterial2.Estimated_Sample_Value__c = 1;
    TestMaterial2.Potential_Annual_Value__c = 1;
    TestMaterial2.RecordTypeId = sampleMaterialRecordTypeId;
  
    Sample_Material__c TestMaterial3 = new Sample_Material__c();
    TestMaterial3.name = 'Test 3';
    TestMaterial3.Sample_Quantity__c = 1;
    TestMaterial3.Sample_UOM__c = 'Drum';
    TestMaterial3.Date_Required_By__c = System.today();
    TestMaterial3.Estimated_Sample_Value__c = 1;
    TestMaterial3.Potential_Annual_Value__c = 1;
    TestMaterial3.RecordTypeId = sampleMaterialRecordTypeId;
  
    String result = '';
    PageReference page;
    Boolean BooleanSwitch = false;
    List <Contact> contactList;
    List <Sample_Material__c> materialList;
    Integer intNbr = 0;
    Sample_Request_Controller cls1 = new Sample_Request_Controller();  

    System.currentPageReference().getParameters().put('accountId',TestAccount.Id);
    //result = cls1.getApproverQueue2();
    try{
    result = cls1.getApproverQueue3();
    result = cls1.getBackupApproverQueue();
    result = cls1.getApproverQueueName();
    result = cls1.getApprovalRequirements();
    //*******************************************3
    //page = cls1.saveAndSubmitForApproval();
    //cls1.Save_Sample_Request_with_New_Opportunity();
    result = cls1.getSample_Request_Link();
    }catch(exception e){
     }
    test.stoptest();
    }
    static testMethod void myUnitTest9() {
    
Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
    Test.startTest();
   
    Account TestAccount = new Account();
    TestAccount.Name = 'Test Account';
    TestAccount.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Customer','Account');
    insert TestAccount;
    Opportunity opp = new Opportunity(Potential_CM__c =12,Country__c='Canada',accountid = TestAccount.id, Name='12345',StageName='close-won',CloseDate=system.today());
    insert opp;
    Sample_Request__c TestSample1a  = new Sample_Request__c(Account__c= TestAccount.Id);
    insert TestSample1a;
    Contact TestContact = new Contact();
    TestContact.FirstName='Sana';
    TestContact.LastName = 'Test Contact';
    TestContact.AccountId = TestAccount.Id;
    TestContact.No_Email__c=true;
    insert TestContact;

    /*Opportunity TestOpportunity = new Opportunity();
    TestOpportunity.Name = 'Test Opp';
    TestOpportunity.AccountId = TestAccount.id;
    TestOpportunity.StageName = 'New';
    TestOpportunity.CloseDate = System.today();
    TestOpportunity.Potential_CM__c = 12; 
    insert TestOpportunity;*/
    
    Id sampleMaterialRecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Material','Sample_Material__c');

    RecordType_Relationship__c rtr1 = new RecordType_Relationship__c();
    rtr1.Child_RecordTypeId__c = sampleMaterialRecordTypeId;
    rtr1.Parent_RecordTypeId__c = TestAccount.RecordTypeId;
    rtr1.Relationship_Name__c = 'Account to Sample Material';
    insert rtr1;
    
    Sample_Material__c TestMaterial = new Sample_Material__c();
    TestMaterial.name = 'Test';
    TestMaterial.Sample_Quantity__c = 1;
    TestMaterial.Sample_UOM__c = 'Drum';
    TestMaterial.Date_Required_By__c = System.today();
    TestMaterial.Estimated_Sample_Value__c = 1;
    TestMaterial.Potential_Annual_Value__c = 1;
    TestMaterial.RecordTypeId = sampleMaterialRecordTypeId;

    
    Sample_Material__c TestMaterial2 = new Sample_Material__c();
    TestMaterial2.name = 'Test 2';
    TestMaterial2.Sample_Quantity__c = 1;
    TestMaterial2.Sample_UOM__c = 'Drum';
    TestMaterial2.Date_Required_By__c = System.today();
    TestMaterial2.Estimated_Sample_Value__c = 1;
    TestMaterial2.Potential_Annual_Value__c = 1;
    TestMaterial2.RecordTypeId = sampleMaterialRecordTypeId;
  
    Sample_Material__c TestMaterial3 = new Sample_Material__c();
    TestMaterial3.name = 'Test 3';
    TestMaterial3.Sample_Quantity__c = 1;
    TestMaterial3.Sample_UOM__c = 'Drum';
    TestMaterial3.Date_Required_By__c = System.today();
    TestMaterial3.Estimated_Sample_Value__c = 1;
    TestMaterial3.Potential_Annual_Value__c = 1;
    TestMaterial3.RecordTypeId = sampleMaterialRecordTypeId;
  
    String result = '';
    PageReference page;
    Boolean BooleanSwitch = false;
    List <Contact> contactList;
    List <Sample_Material__c> materialList;
    Integer intNbr = 0;
    //Sample_Request_Controller cls1 = new Sample_Request_Controller();  
    //System.currentPageReference().getParameters().put('accountId',TestAccount.Id);
    //cls1.setContactSelected('New Contact');
    //result = cls1.getContactSelected();
    //cls1.init();
    //BooleanSwitch = cls1.getCreatingContact();

    //BooleanSwitch = cls1.getEnableDisable_AccountAddressButton();
    //BooleanSwitch = cls1.getEnableDisable_ContactAddressButton();
    //result = cls1.getStyle_AccountAddressButton();
    //result = cls1.getStyle_ContactAddressButton();
    
    //BooleanSwitch = cls1.gethideshow_AddressManualEntry();
    //BooleanSwitch = cls1.gethideshow_AddressManualEntry_Account();
    //BooleanSwitch = cls1.gethideshow_AddressManualEntry_Contact();
    //BooleanSwitch = cls1.gethideshow_AddressSection();
    //cls1.populateShipToAddress_Manually(); 
    //result = cls1.getAccountAddress();
    //result = cls1.getSampleRequestAddress();
    //cls1.populateShipToAddress_from_Account();
    //result = cls1.getContactAddress();
    
    ApexPages.StandardController con = new ApexPages.StandardController(TestSample1a);
    Sample_Request_Controller cls = new Sample_Request_Controller(con);  
    
    
    cls.getSampleRequestOrderEntered();
    cls.setSampleRequestOrderEntered('id');
    cls.getProspectAccountInformation();
    cls.getMaterialSpecificInstructions();
    cls.getEnterOrderInformationPageTitle();
    cls.getRenderMarkOrderCreatedCheckbox();
    cls.init_Enter_Order_Information();
    cls.Order_Entry_by_Coordinator_Valid();
    cls.ToggleShowMaterials();
    cls.Save_Order_Information_Coordinator();
    cls.getAllow_CSR_to_Take_OrderEntry_Responsibility();
    
    
    
     //******************************************2
    
   
    
    
    result = cls.getValidationErrorMessage();

    BooleanSwitch = cls.getGotAccount();
    BooleanSwitch = cls.getGotContact();
    BooleanSwitch = cls.getGotOpportunity();
    cls.getAccount();
    cls.getContact();
    cls.getOpportunity();
    cls.Place_Sample_Request_On_Hold();
    cls.Place_Request_On_Hold_Valid();
    cls.init_Place_Request_On_Hold();
    cls.Save_Order_Information_CSR();
    
    Sample_Request__c sr = cls.getSampleRequest();
    Account a = cls.getAccount();
    materialList = cls.getSampleMaterials();
    //UOM_Conversion_Functions.setRouteForApprovalFlags('Distribution Customer', sr, materiallist);
    cls.getContact();
    cls.getOpportunity();
    cls.Step2A_Valid();

    cls.setNoteToSampleCoordinator('xyz');
    result = cls.getNoteToSampleCoordinator();
    
    cls.populate_PM_CAST_Largest_Product_Line_Value_on_Sample();
    cls.getAccountAddressEntry();
    cls.getContactAddressEntry();
    cls.getManualAddressEntry();
    cls.getRenderperSampleCost();
    cls.getRenderperLineItemCost();
    cls.renderemailcsrgroupbox = true;
    cls.step2C();
    cls.Save_Sample_Request_with_New_Opportunity();
    /*cls.getRenderProductLine();
    cls.getRenderAHWTProductLine();
    cls.getRenderPMCastingsProductLine();

    //cls.Step2B_Valid();
    cls.performApprovalProcessing();
    cls.getErrorMessage();
    cls.getsampleMaterial_All();
    //cls.Save_Sample_Request();
    cls.Cancel_Save();
    cls.ApplyChangesToAllMaterials();
    cls.init_Assign_a_Different_Coordinator();
    //cls.Assign_a_Different_Coordinator();
    cls.getNoteToCSR();
    cls.setNoteToCSR('NoteCSR');
    cls.getAccountType();
    cls.getCSR_Responsible_for_Order_Entry_Label();
    cls.getSAP_Order_Number_Label();
    cls.getCSRAlreadyAssignedtoEnterOrderMessage();
    //cls.init_Assign_Task_to_CSR_to_Enter_Order();
    //cls.Assign_Task_to_CSR_to_Enter_Order_Valid();
    cls.retrieveEmailAddressfromUserId('005E0000000Zv8N');
    cls.AssignTasktoCSRtoEnterOrder();
    cls.init_Cancel_Request();
    cls.Cancel_Request_Valid();
    cls.Cancel_Sample_Request();
    cls.getSampleMaterials_toDelete();
    cls.init_Delete_Materials();
    cls.Delete_Materials();
    cls.init_Edit_Materials();
    //cls.Edit_Materials_Save();
    cls.getSampleRequestCompleted();
    cls.setSampleRequestCompleted('valuein');
    cls.getRenderMarkSampleCompletedCheckbox();
    cls.init_Enter_Actual_Shipping_Information();
    //cls.Actual_Shipping_Information_Valid();
    //cls.Save_Actual_Shipping_Information();
    cls.getSampleNotesSize();
    cls.getsampleNotes();
    cls.getRenderSampleNotes();
    cls.getShowMaterials();
    cls.getCSR_Found_on_Account();

    cls.getCountry();
    cls.setCountry('country');
    cls.getShowUpdateAddressInformation();
    cls.getAddressChangeError();
    cls.UpdateAddressInformation_Button();*/
    test.stoptest();
    }
    static testMethod void myUnitTest10() {
    
Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
    Test.startTest();
   
    Account TestAccount = new Account();
    TestAccount.Name = 'Test Account';
    TestAccount.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Customer','Account');
    insert TestAccount;
    Opportunity opp = new Opportunity(Potential_CM__c =12,Country__c='Canada',accountid = TestAccount.id, Name='12345',StageName='close-won',CloseDate=system.today());
    insert opp;
    Sample_Request__c TestSample1a  = new Sample_Request__c(Account__c= TestAccount.Id);
    insert TestSample1a;
    Contact TestContact = new Contact();
    TestContact.FirstName='Sana';
    TestContact.LastName = 'Test Contact';
    TestContact.AccountId = TestAccount.Id;
    TestContact.No_Email__c=true;
    insert TestContact;

    /*Opportunity TestOpportunity = new Opportunity();
    TestOpportunity.Name = 'Test Opp';
    TestOpportunity.AccountId = TestAccount.id;
    TestOpportunity.StageName = 'New';
    TestOpportunity.CloseDate = System.today();
    TestOpportunity.Potential_CM__c = 12; 
    insert TestOpportunity;*/
    
    Id sampleMaterialRecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Material','Sample_Material__c');

    RecordType_Relationship__c rtr1 = new RecordType_Relationship__c();
    rtr1.Child_RecordTypeId__c = sampleMaterialRecordTypeId;
    rtr1.Parent_RecordTypeId__c = TestAccount.RecordTypeId;
    rtr1.Relationship_Name__c = 'Account to Sample Material';
    insert rtr1;
    
    Sample_Material__c TestMaterial = new Sample_Material__c();
    TestMaterial.name = 'Test';
    TestMaterial.Sample_Quantity__c = 1;
    TestMaterial.Sample_UOM__c = 'Drum';
    TestMaterial.Date_Required_By__c = System.today();
    TestMaterial.Estimated_Sample_Value__c = 1;
    TestMaterial.Potential_Annual_Value__c = 1;
    TestMaterial.RecordTypeId = sampleMaterialRecordTypeId;

    
    Sample_Material__c TestMaterial2 = new Sample_Material__c();
    TestMaterial2.name = 'Test 2';
    TestMaterial2.Sample_Quantity__c = 1;
    TestMaterial2.Sample_UOM__c = 'Drum';
    TestMaterial2.Date_Required_By__c = System.today();
    TestMaterial2.Estimated_Sample_Value__c = 1;
    TestMaterial2.Potential_Annual_Value__c = 1;
    TestMaterial2.RecordTypeId = sampleMaterialRecordTypeId;
  
    Sample_Material__c TestMaterial3 = new Sample_Material__c();
    TestMaterial3.name = 'Test 3';
    TestMaterial3.Sample_Quantity__c = 1;
    TestMaterial3.Sample_UOM__c = 'Drum';
    TestMaterial3.Date_Required_By__c = System.today();
    TestMaterial3.Estimated_Sample_Value__c = 1;
    TestMaterial3.Potential_Annual_Value__c = 1;
    TestMaterial3.RecordTypeId = sampleMaterialRecordTypeId;
  
    String result = '';
    PageReference page;
    Boolean BooleanSwitch = false;
    List <Contact> contactList;
    List <Sample_Material__c> materialList;
    Integer intNbr = 0;
    Sample_Request_Controller cls1 = new Sample_Request_Controller();  
    System.currentPageReference().getParameters().put('accountId',TestAccount.Id);
    cls1.Populate_SAP_Material_Numbers();
    try{
        cls1.samplerequest.contact__c = testcontact.id;
    }catch(exception e){
     }
    cls1.populateShipToAddress_from_Contact();
    test.stoptest();
    }
    static testMethod void myUnitTest11() {
    
Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
    Test.startTest();
   
    Account TestAccount = new Account();
    TestAccount.Name = 'Test Account';
    TestAccount.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Customer','Account');
    insert TestAccount;
    Opportunity opp = new Opportunity(Potential_CM__c =12,Country__c='Canada',accountid = TestAccount.id, Name='12345',StageName='close-won',CloseDate=system.today());
    insert opp;
    Sample_Request__c TestSample1a  = new Sample_Request__c(Account__c= TestAccount.Id);
    insert TestSample1a;
    Contact TestContact = new Contact();
    TestContact.FirstName='Sana';
    TestContact.LastName = 'Test Contact';
    TestContact.AccountId = TestAccount.Id;
    TestContact.No_Email__c=true;
    insert TestContact;

    /*Opportunity TestOpportunity = new Opportunity();
    TestOpportunity.Name = 'Test Opp';
    TestOpportunity.AccountId = TestAccount.id;
    TestOpportunity.StageName = 'New';
    TestOpportunity.CloseDate = System.today();
    TestOpportunity.Potential_CM__c = 12; 
    insert TestOpportunity;*/
    
    Id sampleMaterialRecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Material','Sample_Material__c');

    RecordType_Relationship__c rtr1 = new RecordType_Relationship__c();
    rtr1.Child_RecordTypeId__c = sampleMaterialRecordTypeId;
    rtr1.Parent_RecordTypeId__c = TestAccount.RecordTypeId;
    rtr1.Relationship_Name__c = 'Account to Sample Material';
    insert rtr1;
    
    Sample_Material__c TestMaterial = new Sample_Material__c();
    TestMaterial.name = 'Test';
    TestMaterial.Sample_Quantity__c = 1;
    TestMaterial.Sample_UOM__c = 'Drum';
    TestMaterial.Date_Required_By__c = System.today();
    TestMaterial.Estimated_Sample_Value__c = 1;
    TestMaterial.Potential_Annual_Value__c = 1;
    TestMaterial.RecordTypeId = sampleMaterialRecordTypeId;

    
    Sample_Material__c TestMaterial2 = new Sample_Material__c();
    TestMaterial2.name = 'Test 2';
    TestMaterial2.Sample_Quantity__c = 1;
    TestMaterial2.Sample_UOM__c = 'Drum';
    TestMaterial2.Date_Required_By__c = System.today();
    TestMaterial2.Estimated_Sample_Value__c = 1;
    TestMaterial2.Potential_Annual_Value__c = 1;
    TestMaterial2.RecordTypeId = sampleMaterialRecordTypeId;
  
    Sample_Material__c TestMaterial3 = new Sample_Material__c();
    TestMaterial3.name = 'Test 3';
    TestMaterial3.Sample_Quantity__c = 1;
    TestMaterial3.Sample_UOM__c = 'Drum';
    TestMaterial3.Date_Required_By__c = System.today();
    TestMaterial3.Estimated_Sample_Value__c = 1;
    TestMaterial3.Potential_Annual_Value__c = 1;
    TestMaterial3.RecordTypeId = sampleMaterialRecordTypeId;
  
    String result = '';
    PageReference page;
    Boolean BooleanSwitch = false;
    List <Contact> contactList;
    List <Sample_Material__c> materialList;
    Integer intNbr = 0;
    ApexPages.StandardController con = new ApexPages.StandardController(TestSample1a);
    Sample_Request_Controller cls = new Sample_Request_Controller(con);  
    //cls.init_Enter_Order_Information_CSR();
    cls.getStreet();
    cls.setStreet('street');
    cls.getCity();
    cls.setCity('city');
    cls.getState();
    cls.setState('state');
    cls.getPostalCode();
    cls.setPostalCode('1234');
    cls.getUomSelectOptions();
    test.stoptest();
    }
    /*static testMethod void myUnitTest12() {
    Test.startTest();
   
    Account TestAccount = new Account();
    TestAccount.Name = 'Test Account';
    TestAccount.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Customer','Account');
    insert TestAccount;
    Opportunity opp = new Opportunity(Potential_CM__c =12,Country__c='Canada',accountid = TestAccount.id, Name='12345',StageName='close-won',CloseDate=system.today());
    insert opp;
    Sample_Request__c TestSample1a  = new Sample_Request__c(Account__c= TestAccount.Id);
    insert TestSample1a;
    Contact TestContact = new Contact();
    TestContact.FirstName='Sana';
    TestContact.LastName = 'Test Contact';
    TestContact.AccountId = TestAccount.Id;
    TestContact.No_Email__c=true;
    insert TestContact;

    Opportunity TestOpportunity = new Opportunity();
    TestOpportunity.Name = 'Test Opp';
    TestOpportunity.AccountId = TestAccount.id;
    TestOpportunity.StageName = 'New';
    TestOpportunity.CloseDate = System.today();
    TestOpportunity.Potential_CM__c = 12; 
    insert TestOpportunity;
    
    Id sampleMaterialRecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Material','Sample_Material__c');

    RecordType_Relationship__c rtr1 = new RecordType_Relationship__c();
    rtr1.Child_RecordTypeId__c = sampleMaterialRecordTypeId;
    rtr1.Parent_RecordTypeId__c = TestAccount.RecordTypeId;
    rtr1.Relationship_Name__c = 'Account to Sample Material';
    insert rtr1;
    
    Sample_Material__c TestMaterial = new Sample_Material__c();
    TestMaterial.name = 'Test';
    TestMaterial.Sample_Quantity__c = 1;
    TestMaterial.Sample_UOM__c = 'Drum';
    TestMaterial.Date_Required_By__c = System.today();
    TestMaterial.Estimated_Sample_Value__c = 1;
    TestMaterial.Potential_Annual_Value__c = 1;
    TestMaterial.RecordTypeId = sampleMaterialRecordTypeId;

    
    Sample_Material__c TestMaterial2 = new Sample_Material__c();
    TestMaterial2.name = 'Test 2';
    TestMaterial2.Sample_Quantity__c = 1;
    TestMaterial2.Sample_UOM__c = 'Drum';
    TestMaterial2.Date_Required_By__c = System.today();
    TestMaterial2.Estimated_Sample_Value__c = 1;
    TestMaterial2.Potential_Annual_Value__c = 1;
    TestMaterial2.RecordTypeId = sampleMaterialRecordTypeId;
  
    Sample_Material__c TestMaterial3 = new Sample_Material__c();
    TestMaterial3.name = 'Test 3';
    TestMaterial3.Sample_Quantity__c = 1;
    TestMaterial3.Sample_UOM__c = 'Drum';
    TestMaterial3.Date_Required_By__c = System.today();
    TestMaterial3.Estimated_Sample_Value__c = 1;
    TestMaterial3.Potential_Annual_Value__c = 1;
    TestMaterial3.RecordTypeId = sampleMaterialRecordTypeId;
  
    String result = '';
    PageReference page;
    Boolean BooleanSwitch = false;
    List <Contact> contactList;
    List <Sample_Material__c> materialList;
    Integer intNbr = 0;
    ApexPages.StandardController con = new ApexPages.StandardController(TestSample1a);
    Sample_Request_Controller cls = new Sample_Request_Controller(con);
    //cls.getUomSelectOptions();
    cls.SaveAddressChanges();
    //cls.saveAndSubmitForApproval();
    //cls.performApprovalProcessing();
    //cls.Save_Sample_Request();
    cls.Assign_a_Different_Coordinator();
    //cls.getAccountType();
    cls.init_Assign_Task_to_CSR_to_Enter_Order();
    //cls.Assign_Task_to_CSR_to_Enter_Order_Valid();
    //cls.AssignTasktoCSRtoEnterOrder();
    //cls.Edit_Materials_Save();
    cls.Actual_Shipping_Information_Valid();
    cls.Save_Actual_Shipping_Information();
    //cls.Order_Entry_by_Coordinator_Valid();
    test.stoptest();
    }*/
}