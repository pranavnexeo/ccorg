@isTest
private class SampleRequestSplitter_Test {

    static testMethod void myUnitTest() {
    
Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
    Test.startTest();
    Account TestAccount = new Account();
    TestAccount.Name = 'Test Account';
   // TestAccount.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Valvoline Customer','Account');
    TestAccount.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Customer','Account');
    insert TestAccount;
    Sample_Request__c TestSample1a  = new Sample_Request__c(Account__c= TestAccount.Id);
    insert TestSample1a;
    Contact TestContact = new Contact();
    TestContact.FirstName='Sana';
    TestContact.LastName = 'Test Contact';
    TestContact.AccountId = TestAccount.Id;
    TestContact.No_Email__c=true;
    insert TestContact;
    Id sampleMaterialRecordTypeId = RecordType_Functions.LookupRecordTypeId('Valvoline Material','Sample_Material__c');

    
    Sample_Material__c TestMaterial = new Sample_Material__c();
    TestMaterial.name = 'Test';
    TestMaterial.Sample_Quantity__c = 1;
    TestMaterial.Sample_UOM__c = 'Drum';
    TestMaterial.Date_Required_By__c = System.today();
    TestMaterial.Estimated_Sample_Value__c = 1;
    TestMaterial.Potential_Annual_Value__c = 1;
    TestMaterial.RecordTypeId = sampleMaterialRecordTypeId;
    TestMaterial.CurrencyIsoCode = 'USD';
    TestMaterial.Sample_Request__c = TestSample1a.id;
    insert TestMaterial;

    Sample_Material__c TestMaterial2 = new Sample_Material__c();
    TestMaterial2.name = 'Test 2';
    TestMaterial2.Sample_Quantity__c = 1;
    TestMaterial2.Sample_UOM__c = 'Drum';
    TestMaterial2.Date_Required_By__c = System.today();
    TestMaterial2.Estimated_Sample_Value__c = 1;
    TestMaterial2.Potential_Annual_Value__c = 1;
    TestMaterial2.RecordTypeId = sampleMaterialRecordTypeId;
    TestMaterial2.CurrencyIsoCode = 'USD';
    TestMaterial2.Sample_Request__c = TestSample1a.id;
    
    insert TestMaterial2;
    
    Sample_Material__c TestMaterial3 = new Sample_Material__c();
    TestMaterial3.name = 'Test 3';
    TestMaterial3.Sample_Quantity__c = 1;
    TestMaterial3.Sample_UOM__c = 'Drum';
    TestMaterial3.Date_Required_By__c = System.today();
    TestMaterial3.Estimated_Sample_Value__c = 1;
    TestMaterial3.Potential_Annual_Value__c = 1;
    TestMaterial3.RecordTypeId = sampleMaterialRecordTypeId;
    TestMaterial3.CurrencyIsoCode = 'USD';
    TestMaterial3.Sample_Request__c = TestSample1a.id;
    insert TestMaterial3;
    
    String result = '';
    PageReference page;
    Boolean BooleanSwitch = false;
    List <Contact> contactList;
    List <Sample_Material__c> materialList;
    Integer intNbr = 0;

    Sample_Request_Controller cls1 = new Sample_Request_Controller();  

    System.currentPageReference().getParameters().put('accountId',TestAccount.Id);
    
    cls1.init();
    cls1.init(); //Call a second time, so other logic is hit
  
    contactList = cls1.getContacts();
  
    cls1.setContactSelected('New Contact');
    result = cls1.getContactSelected();
    cls1.init();
    BooleanSwitch = cls1.getCreatingContact();

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
    
    cls1.setContactSelected(TestContact.Id);
    result = cls1.getContactSelected();
    cls1.init();
    BooleanSwitch = cls1.getCreatingContact();
    
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

    cls1.sampleMaterials.Add(TestMaterial);
    cls1.sampleMaterials.Add(TestMaterial2);
    cls1.Populate_SAP_Material_Numbers();
    cls1.samplerequest.contact__c = testcontact.id;
    cls1.populateShipToAddress_from_Contact();

    result = cls1.getNoApprovalProcessMessage();
    result = cls1.getApproverQueue();
    result = cls1.getApproverQueue2();
    result = cls1.getApproverQueue3();
    result = cls1.getBackupApproverQueue();
    result = cls1.getApproverQueueName();
    result = cls1.getApprovalRequirements();

    //page = cls1.saveAndSubmitForApproval();
    cls1.Save_Sample_Request_with_New_Opportunity();
    result = cls1.getSample_Request_Link();
    
    /****Sample Request Splitter Test *****/
    materialList = cls1.getSampleMaterials();
    
    ApexPages.standardsetcontroller ssc = new ApexPages.standardsetcontroller(MaterialList);
    List<Sample_Material__c> selected = new list<Sample_Material__c>();
    selected.add(MaterialList.get(0));
    ssc.setselected(selected);
    
    SampleRequestSplitter SRS = new SampleRequestSplitter(ssc);
    SRS.split();
    
    Test.stopTest();
    }
}