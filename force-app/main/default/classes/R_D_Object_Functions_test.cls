//LAB Project
//Sample Analysis Requests
//Contains unit test method
//@Rajeev
//Test class for trigger "Update_R_D_OwnerAndCheckHistory"
//Test class for "R_D_Object_Functions" class
@isTest
private class R_D_Object_Functions_test{
    
    static testmethod void R_D_Object_Functions_Method(){
        Map<String, SObject> testData = NexeoTestUtils_Test.initData();
        Map<String,Schema.RecordTypeInfo> rtMap = Schema.SObjectType.R_D_Requests__c.getRecordTypeInfosByName();
        
        Account acc = new Account(Name = 'Test');
            insert acc;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
                 TimeZoneSidKey='America/Los_Angeles', UserName='saxsvskjv2bh77gfdhddc@gorg.com', IsActive = true);
            insert u;  
        
        R_D_Requests__c rdr = new R_D_Requests__c(Customer__c = acc.id, Requestor__c = u.id, Stage__c = 'Stage 0 - Initiate',RecordtypeId = rtMap.get('Customer – Stage 0 Concept').getrecordtypeid());
            insert rdr;
        
        
        /*Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitrequest();
        app.setObjectId(rdr.Id);
        app.setComments('Submitting request for approval.');
        Approval.ProcessResult result = Approval.process(app);*/
    }
    
    
    //Test method for "RDEditController" class
    //@LAB Project
    static testmethod void RDEditController_Method(){
    Map<String, SObject> testData = NexeoTestUtils_Test.initData();    
    Map<String,Schema.RecordTypeInfo> rtMap = Schema.SObjectType.R_D_Requests__c.getRecordTypeInfosByName();
    Account acc = new Account(Name = 'Test');
            insert acc;
        
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
    User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
               TimeZoneSidKey='America/Los_Angeles', UserName='sax4rffsvskjv2bh77gfdhddc@gorg.com', IsActive = true);
               insert u; 
    Pagereference p1;
    Pagereference p2;
    Pagereference p3;
    Pagereference p4;
    Pagereference p5;
    Pagereference p6;
    Pagereference p7;
    Pagereference p8;
    Pagereference p9;
    Pagereference p10;
    Pagereference p11;
    Pagereference p12;
    Pagereference p13;
    Pagereference p14;
    Pagereference p15;
    Pagereference p16;
    Pagereference p17;
    Pagereference p18;         
    List<R_D_Requests__c> records = new List<R_D_Requests__c>();    
    R_D_Requests__c rdr1 = new R_D_Requests__c(Customer__c = acc.id, Requestor__c = u.id, Stage__c = 'Stage 0 - Concept',RecordtypeId = rtMap.get('Customer – Stage 0 Concept').getrecordtypeid());
                           //insert rdr1;
    R_D_Requests__c rdr2 = new R_D_Requests__c(Customer__c = acc.id, Requestor__c = u.id, Stage__c = 'Stage 0 - Concept',RecordtypeId = rtMap.get('Customer – Stage 0 Pending Approval').getrecordtypeid());
                           //insert rdr2; 
    R_D_Requests__c rdr3 = new R_D_Requests__c(Customer__c = acc.id, Requestor__c = u.id, Stage__c = 'Stage 0 - Concept',RecordtypeId = rtMap.get('Customer – Stage 1 Pending Approval').getrecordtypeid());
                           //insert rdr3;
    R_D_Requests__c rdr4 = new R_D_Requests__c(Customer__c = acc.id, Requestor__c = u.id, Stage__c = 'Stage 0 - Concept',RecordtypeId = rtMap.get('Customer – Stage 1 Scope').getrecordtypeid());
                           //insert rdr4;
    R_D_Requests__c rdr5 = new R_D_Requests__c(Customer__c = acc.id, Requestor__c = u.id, Stage__c = 'Stage 0 - Concept',RecordtypeId = rtMap.get('Customer – Stage 2 In Process').getrecordtypeid());
                           //insert rdr5;
    R_D_Requests__c rdr6 = new R_D_Requests__c(Customer__c = acc.id, Requestor__c = u.id, Stage__c = 'Stage 0 - Concept',RecordtypeId = rtMap.get('Customer – Stage 2 Pending Approval').getrecordtypeid());
                           //insert rdr6;
    R_D_Requests__c rdr7 = new R_D_Requests__c(Customer__c = acc.id, Requestor__c = u.id, Stage__c = 'Stage 0 - Concept',RecordtypeId = rtMap.get('Customer – Stage 3 Closed Complete').getrecordtypeid());
                           //insert rdr7;
    R_D_Requests__c rdr8 = new R_D_Requests__c(Customer__c = acc.id, Requestor__c = u.id, Stage__c = 'Stage 0 - Concept',RecordtypeId = rtMap.get('Customer – Stage 4 Closed Dead').getrecordtypeid());
                           //insert rdr8;
    R_D_Requests__c rdr9 = new R_D_Requests__c(Customer__c = acc.id, Requestor__c = u.id, Stage__c = 'Stage 0 - Concept',RecordtypeId = rtMap.get('Innovation – Stage 0 Concept').getrecordtypeid());
                           //insert rdr9;
    R_D_Requests__c rdr10 = new R_D_Requests__c(Customer__c = acc.id, Requestor__c = u.id, Stage__c = 'Stage 0 - Concept',RecordtypeId = rtMap.get('Innovation – Stage 0 Pending Approval').getrecordtypeid());
                           //insert rdr10;
    R_D_Requests__c rdr11 = new R_D_Requests__c(Customer__c = acc.id, Requestor__c = u.id, Stage__c = 'Stage 0 - Concept',RecordtypeId = rtMap.get('Innovation – Stage 1 Market Research').getrecordtypeid());
                           //insert rdr11;
    R_D_Requests__c rdr12 = new R_D_Requests__c(Customer__c = acc.id, Requestor__c = u.id, Stage__c = 'Stage 0 - Concept',RecordtypeId = rtMap.get('Innovation – Stage 1 Pending Approval').getrecordtypeid());
                           //insert rdr12;
    R_D_Requests__c rdr13 = new R_D_Requests__c(Customer__c = acc.id, Requestor__c = u.id, Stage__c = 'Stage 0 - Concept',RecordtypeId = rtMap.get('Innovation – Stage 2 Pending Approval').getrecordtypeid());
                           //insert rdr13;                       
    R_D_Requests__c rdr14 = new R_D_Requests__c(Customer__c = acc.id, Requestor__c = u.id, Stage__c = 'Stage 0 - Concept',RecordtypeId = rtMap.get('Innovation – Stage 2 Product Development').getrecordtypeid());
                           //insert rdr14;
    R_D_Requests__c rdr15 = new R_D_Requests__c(Customer__c = acc.id, Requestor__c = u.id, Stage__c = 'Stage 0 - Concept',RecordtypeId = rtMap.get('Innovation – Stage 3 Pending Approval').getrecordtypeid());
                           //insert rdr15;                                                                                            
    R_D_Requests__c rdr16 = new R_D_Requests__c(Customer__c = acc.id, Requestor__c = u.id, Stage__c = 'Stage 0 - Concept',RecordtypeId = rtMap.get('Innovation – Stage 3 Pre-Launch').getrecordtypeid());
                           //insert rdr16;
    R_D_Requests__c rdr17 = new R_D_Requests__c(Customer__c = acc.id, Requestor__c = u.id, Stage__c = 'Stage 0 - Concept',RecordtypeId = rtMap.get('Innovation – Stage 4 Dead').getrecordtypeid());
                           //insert rdr17;
    R_D_Requests__c rdr18 = new R_D_Requests__c(Customer__c = acc.id, Requestor__c = u.id, Stage__c = 'Stage 0 - Concept',RecordtypeId = rtMap.get('Innovation – Stage 4 Launch').getrecordtypeid());
                           //insert rdr18; 
    records.add(rdr1);
    records.add(rdr2);
    records.add(rdr3);
    records.add(rdr4);
    records.add(rdr5);
    records.add(rdr6);
    records.add(rdr7);
    records.add(rdr8);
    records.add(rdr9);
    records.add(rdr10);
    records.add(rdr11);
    records.add(rdr12);
    records.add(rdr13);
    records.add(rdr14);
    records.add(rdr15);
    records.add(rdr16);
    records.add(rdr17);
    records.add(rdr18);
    
    insert records;                                             
    Apexpages.currentpage().getparameters().put('id',records[0].id);
    Apexpages.currentpage().getparameters().put('RecordType',records[0].recordtypeid);                                             
    Apexpages.currentpage().getparameters().put('edit','true');
    Apexpages.currentpage().getparameters().put('edit','false');
    Apexpages.currentpage().getparameters().put('Clone','Yes');
    ApexPages.standardcontroller sc1 = new ApexPages.standardcontroller(records[0]);
    RDEditController RD1 = new RDEditController(sc1);
    
    p1 = RD1.redirectToEditPage();
    p1 = RD1.redirectToNewPage();
    p1 = RD1.redirectToClonePage();
    
    Apexpages.currentpage().getparameters().put('id',records[1].id);
    Apexpages.currentpage().getparameters().put('RecordType',records[1].recordtypeid); 
    Apexpages.currentpage().getparameters().put('edit','true');
    Apexpages.currentpage().getparameters().put('edit','false');
    Apexpages.currentpage().getparameters().put('Clone','Yes');
    ApexPages.standardcontroller sc2 = new ApexPages.standardcontroller(records[1]);
    RDEditController RD2 = new RDEditController(sc2);
    
    p2 = RD2.redirectToEditPage();
    p2 = RD2.redirectToNewPage();
    p2 = RD2.redirectToClonePage();
    
    Apexpages.currentpage().getparameters().put('id',records[2].id);
    Apexpages.currentpage().getparameters().put('RecordType',records[2].recordtypeid); 
    Apexpages.currentpage().getparameters().put('edit','true');
    Apexpages.currentpage().getparameters().put('edit','false');
    Apexpages.currentpage().getparameters().put('Clone','Yes');
    ApexPages.standardcontroller sc3 = new ApexPages.standardcontroller(records[2]);
    RDEditController RD3 = new RDEditController(sc3);
    
    p3 = RD3.redirectToEditPage();
    p3 = RD3.redirectToNewPage();
    p3 = RD3.redirectToClonePage();
    
    Apexpages.currentpage().getparameters().put('id',records[3].id);
    Apexpages.currentpage().getparameters().put('RecordType',records[3].recordtypeid); 
    Apexpages.currentpage().getparameters().put('edit','true');
    Apexpages.currentpage().getparameters().put('edit','false');
    Apexpages.currentpage().getparameters().put('Clone','Yes');
    ApexPages.standardcontroller sc4 = new ApexPages.standardcontroller(records[3]);
    RDEditController RD4 = new RDEditController(sc4);
    
    p4 = RD4.redirectToEditPage();
    p4 = RD4.redirectToNewPage();
    p4 = RD4.redirectToClonePage();
    
    Apexpages.currentpage().getparameters().put('id',records[4].id);
    Apexpages.currentpage().getparameters().put('RecordType',records[4].recordtypeid); 
    Apexpages.currentpage().getparameters().put('edit','true');
    Apexpages.currentpage().getparameters().put('edit','false');
    Apexpages.currentpage().getparameters().put('Clone','Yes');
    ApexPages.standardcontroller sc5 = new ApexPages.standardcontroller(records[4]);
    RDEditController RD5 = new RDEditController(sc5);
    
    p5 = RD5.redirectToEditPage();
    p5 = RD5.redirectToNewPage();
    p5 = RD5.redirectToClonePage();
    
    Apexpages.currentpage().getparameters().put('id',records[5].id);
    Apexpages.currentpage().getparameters().put('RecordType',records[5].recordtypeid); 
    Apexpages.currentpage().getparameters().put('edit','true');
    Apexpages.currentpage().getparameters().put('edit','false');
    Apexpages.currentpage().getparameters().put('Clone','Yes');
    ApexPages.standardcontroller sc6 = new ApexPages.standardcontroller(records[5]);
    RDEditController RD6 = new RDEditController(sc6);
    
    p6 = RD6.redirectToEditPage();
    p6 = RD6.redirectToNewPage();
    p6 = RD6.redirectToClonePage();
    
    Apexpages.currentpage().getparameters().put('id',records[6].id);
    Apexpages.currentpage().getparameters().put('RecordType',records[6].recordtypeid); 
    Apexpages.currentpage().getparameters().put('edit','true');
    Apexpages.currentpage().getparameters().put('edit','false');
    Apexpages.currentpage().getparameters().put('Clone','Yes');
    ApexPages.standardcontroller sc7 = new ApexPages.standardcontroller(records[6]);
    RDEditController RD7 = new RDEditController(sc7);
    
    p7 = RD7.redirectToEditPage();
    p7 = RD7.redirectToNewPage();
    p7 = RD7.redirectToClonePage();
    
    Apexpages.currentpage().getparameters().put('id',records[7].id);
    Apexpages.currentpage().getparameters().put('RecordType',records[7].recordtypeid); 
    Apexpages.currentpage().getparameters().put('edit','true');
    Apexpages.currentpage().getparameters().put('edit','false');
    Apexpages.currentpage().getparameters().put('Clone','Yes');
    ApexPages.standardcontroller sc8 = new ApexPages.standardcontroller(records[7]);
    RDEditController RD8 = new RDEditController(sc8);
    
    p8 = RD8.redirectToEditPage();
    p8 = RD8.redirectToNewPage();
    p8 = RD8.redirectToClonePage();
    
    Apexpages.currentpage().getparameters().put('id',records[8].id);
    Apexpages.currentpage().getparameters().put('RecordType',records[8].recordtypeid); 
    Apexpages.currentpage().getparameters().put('edit','true');
    Apexpages.currentpage().getparameters().put('edit','false');
    Apexpages.currentpage().getparameters().put('Clone','Yes');
    ApexPages.standardcontroller sc9 = new ApexPages.standardcontroller(records[8]);
    RDEditController RD9 = new RDEditController(sc9);
    
    p9 = RD9.redirectToEditPage();
    p9 = RD9.redirectToNewPage();
    p9 = RD9.redirectToClonePage();
    
    Apexpages.currentpage().getparameters().put('id',records[9].id);
    Apexpages.currentpage().getparameters().put('RecordType',records[9].recordtypeid); 
    Apexpages.currentpage().getparameters().put('edit','true');
    Apexpages.currentpage().getparameters().put('edit','false');
    Apexpages.currentpage().getparameters().put('Clone','Yes');
    ApexPages.standardcontroller sc10 = new ApexPages.standardcontroller(records[9]);
    RDEditController RD10 = new RDEditController(sc10);
    
    p10 = RD10.redirectToEditPage();
    p10 = RD10.redirectToNewPage();
    p10 = RD10.redirectToClonePage();
    
    Apexpages.currentpage().getparameters().put('id',records[10].id);
    Apexpages.currentpage().getparameters().put('RecordType',records[10].recordtypeid); 
    Apexpages.currentpage().getparameters().put('edit','true');
    Apexpages.currentpage().getparameters().put('edit','false');
    Apexpages.currentpage().getparameters().put('Clone','Yes');
    ApexPages.standardcontroller sc11 = new ApexPages.standardcontroller(records[10]);
    RDEditController RD11 = new RDEditController(sc11);
    
    p11 = RD11.redirectToEditPage();
    p11 = RD11.redirectToNewPage();
    p11 = RD11.redirectToClonePage();
    
    Apexpages.currentpage().getparameters().put('id',records[11].id);
    Apexpages.currentpage().getparameters().put('RecordType',records[11].recordtypeid); 
    Apexpages.currentpage().getparameters().put('edit','true');
    Apexpages.currentpage().getparameters().put('edit','false');
    Apexpages.currentpage().getparameters().put('Clone','Yes');
    ApexPages.standardcontroller sc12 = new ApexPages.standardcontroller(records[11]);
    RDEditController RD12 = new RDEditController(sc12);
    
    p12 = RD12.redirectToEditPage();
    p12 = RD12.redirectToNewPage();
    p12 = RD12.redirectToClonePage();
    
    Apexpages.currentpage().getparameters().put('id',records[12].id);
    Apexpages.currentpage().getparameters().put('RecordType',records[12].recordtypeid); 
    Apexpages.currentpage().getparameters().put('edit','true');
    Apexpages.currentpage().getparameters().put('edit','false');
    Apexpages.currentpage().getparameters().put('Clone','Yes');
    ApexPages.standardcontroller sc13 = new ApexPages.standardcontroller(records[12]);
    RDEditController RD13 = new RDEditController(sc13);
    
    p13 = RD13.redirectToEditPage();
    p13 = RD13.redirectToNewPage();
    p13 = RD13.redirectToClonePage();
    
    Apexpages.currentpage().getparameters().put('id',records[13].id);
    Apexpages.currentpage().getparameters().put('RecordType',records[13].recordtypeid); 
    Apexpages.currentpage().getparameters().put('edit','true');
    Apexpages.currentpage().getparameters().put('edit','false');
    Apexpages.currentpage().getparameters().put('Clone','Yes');
    ApexPages.standardcontroller sc14 = new ApexPages.standardcontroller(records[13]);
    RDEditController RD14 = new RDEditController(sc14);
    
    p14 = RD14.redirectToEditPage();
    p14 = RD14.redirectToNewPage();
    p14 = RD14.redirectToClonePage();
    
    Apexpages.currentpage().getparameters().put('id',records[14].id);
    Apexpages.currentpage().getparameters().put('RecordType',records[14].recordtypeid); 
    Apexpages.currentpage().getparameters().put('edit','true');
    Apexpages.currentpage().getparameters().put('edit','false');
    Apexpages.currentpage().getparameters().put('Clone','Yes');
    ApexPages.standardcontroller sc15 = new ApexPages.standardcontroller(records[14]);
    RDEditController RD15 = new RDEditController(sc15);
    
    p15 = RD15.redirectToEditPage();
    p15 = RD15.redirectToNewPage();
    p15 = RD15.redirectToClonePage();
    
    Apexpages.currentpage().getparameters().put('id',records[15].id);
    Apexpages.currentpage().getparameters().put('RecordType',records[15].recordtypeid); 
    Apexpages.currentpage().getparameters().put('edit','true');
    Apexpages.currentpage().getparameters().put('edit','false');
    Apexpages.currentpage().getparameters().put('Clone','Yes');
    ApexPages.standardcontroller sc16 = new ApexPages.standardcontroller(records[15]);
    RDEditController RD16 = new RDEditController(sc16);
    
    p16 = RD16.redirectToEditPage();
    p16 = RD16.redirectToNewPage();
    p16 = RD16.redirectToClonePage();
    
    Apexpages.currentpage().getparameters().put('id',records[16].id);
    Apexpages.currentpage().getparameters().put('RecordType',records[16].recordtypeid); 
    Apexpages.currentpage().getparameters().put('edit','true');
    Apexpages.currentpage().getparameters().put('edit','false');
    Apexpages.currentpage().getparameters().put('Clone','Yes');
    ApexPages.standardcontroller sc17 = new ApexPages.standardcontroller(records[16]);
    RDEditController RD17 = new RDEditController(sc17);
    
    p17 = RD17.redirectToEditPage();
    p17 = RD17.redirectToNewPage();
    p17 = RD17.redirectToClonePage();
    
    Apexpages.currentpage().getparameters().put('id',records[17].id);
    Apexpages.currentpage().getparameters().put('RecordType',records[17].recordtypeid); 
    Apexpages.currentpage().getparameters().put('edit','true');
    Apexpages.currentpage().getparameters().put('edit','false');
    Apexpages.currentpage().getparameters().put('Clone','Yes');
    ApexPages.standardcontroller sc18 = new ApexPages.standardcontroller(records[17]);
    RDEditController RD18 = new RDEditController(sc18);
    
    p18 = RD18.redirectToEditPage();
    p18 = RD18.redirectToNewPage();
    p18 = RD18.redirectToClonePage();
   
     
    }
    
    static testmethod void RDExtensionController_Method(){
   	Map<String, SObject> testData = NexeoTestUtils_Test.initData();     
    Map<String,Schema.RecordTypeInfo> rtMap = Schema.SObjectType.R_D_Requests__c.getRecordTypeInfosByName();
    Map<String,Schema.RecordTypeInfo> rtMapOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName();
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
    Test.startTest();
    User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
                 TimeZoneSidKey='America/Los_Angeles', UserName='saxsv123skjv2bh77gfdhddc@gorg.com', IsActive = true);
    
            insert u; 
    Account acc = new Account(Name = 'Test');
    insert acc;    
    
    R_D_Requests__c rdr1 = new R_D_Requests__c(Customer__c = acc.id, Requestor__c = u.id, Stage__c = 'Stage 0 - Concept',RecordtypeId = rtMap.get('Customer – Stage 0 Concept').getrecordtypeid());
    insert rdr1;
    
    R_D_Requests__c rdr2 = new R_D_Requests__c(Customer__c = acc.id, Requestor__c = u.id, Stage__c = 'Stage 0 - Concept',RecordtypeId = rtMap.get('Customer – Stage 0 Concept').getrecordtypeid());
    insert rdr2;
    
    R_D_Requests__c myrecclone = new R_D_Requests__c();
    
    Material_Base_Code__c msd2 = new Material_Base_Code__c(Material_Base_Code__c = 'BASECODE-147804',Material_Base_Code_Description__c= 'EASTMAN 168 PLASTICIZER');
    insert msd2;
    
    R_D_Material__c rdm = new R_D_Material__c(Base_code__c = msd2.id,Request__c = rdr1.id);
    insert rdm;  
    Material_Sales_Data2__c material = new Material_Sales_Data2__c(Name = 'Test',Material_Number__c = '1234567890',Dist_Channel_Code__c = '30',Sales_Org_Code__c = '1000',Record_Key__c = '4224242344');
    insert material;
    
    Opportunity opp = new Opportunity(Name = 'TestOpp',SAP_Material__c = material.Id,StageName = '1. Prospect',CloseDate = System.today()+10,AccountId = acc.id,CurrencyIsoCode = 'USD',RecordtypeId = rtMapOpp.get('Distribution Chemicals').getrecordtypeid());
    insert opp;
    Test.stopTest();
    Integer count = 1;
    
    ApexPages.currentPage().getParameters().put('edit','true');
    ApexPages.currentPage().getParameters().put('isEdit','false');
    ApexPages.currentPage().getParameters().put('Customer','Customer');
    ApexPages.currentPage().getParameters().put('Innovation','Innovation');
    ApexPages.currentPage().getParameters().put('Clone','No');
    //ApexPages.currentPage().getParameters().put('Clone','Yes');
    ApexPages.currentPage().getParameters().put('makerequired','true');

    String pageName = Apexpages.currentPage().getUrl();

    List<RDExtensionController.innerClass> lstInner = new List<RDExtensionController.innerClass>();
    lstInner.add(new RDExtensionController.innerClass(1,rdm));
    
    myrecclone = rdr1.Clone(false,true);
    ApexPages.standardcontroller sc = new ApexPages.standardcontroller(rdr1);
    RDExtensionController RD = new RDExtensionController(sc);
    
    ApexPages.standardcontroller sc1 = new ApexPages.standardcontroller(myrecclone);
    RDExtensionController RD1 = new RDExtensionController(sc);
    RD.pageName = 'Customer&Innovation';
    RD.myRecCloned = rdr2;
    lstInner[0].acct.Request__c = rdr2.Id;
    RD.add();
    RD.addMore();
    RD.MakeRequired();
    RD.del();
    RD.customSave();
    ApexPages.currentPage().getParameters().put('OppId',opp.id);
    RD.populateDetails(String.valueOf(opp.id));
    System.assert(lstInner.size()>0);
    
    }
    
    //Test method for "RD_Page_Banner" class
    static testmethod void RD_Page_Banner_Method(){
    Map<String, SObject> testData = NexeoTestUtils_Test.initData();    
    List<R_D_Requests__c> rdlist = new List<R_D_Requests__c>();
    Map<String,Schema.RecordTypeInfo> rtMap = Schema.SObjectType.R_D_Requests__c.getRecordTypeInfosByName();
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
    User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
                 TimeZoneSidKey='America/Los_Angeles', UserName='saxsvdcf123skjv2bh77gfdhddc@gorg.com', IsActive = true);
                 insert u; 
    
    Account acc = new Account(Name = 'Test');
    insert acc;    
    
    R_D_Requests__c rdr1 = new R_D_Requests__c(Customer__c = acc.id, Requestor__c = u.id, Stage__c = 'Stage 0 - Concept',RecordtypeId = rtMap.get('Innovation – Stage 1 Market Research').getrecordtypeid());
    R_D_Requests__c rdr2 = new R_D_Requests__c(Customer__c = acc.id, Requestor__c = u.id, Stage__c = 'Stage 0 - Concept',RecordtypeId = rtMap.get('Innovation – Stage 2 Product Development').getrecordtypeid());
    R_D_Requests__c rdr3 = new R_D_Requests__c(Customer__c = acc.id, Requestor__c = u.id, Stage__c = 'Stage 0 - Concept',RecordtypeId = rtMap.get('Innovation – Stage 3 Pre-Launch').getrecordtypeid());
    R_D_Requests__c rdr4 = new R_D_Requests__c(Customer__c = acc.id, Requestor__c = u.id, Stage__c = 'Stage 0 - Concept',RecordtypeId = rtMap.get('Innovation – Stage 2 Product Development').getrecordtypeid());
    R_D_Requests__c rdr5 = new R_D_Requests__c(Customer__c = acc.id, Requestor__c = u.id, Stage__c = 'Stage 0 - Concept',RecordtypeId = rtMap.get('Customer – Stage 2 In Process').getrecordtypeid());
    
    test.startTest();

    insert rdr1;
    insert rdr2;
    insert rdr3;
    insert rdr4;
    insert rdr5;
    
    test.stopTest();

    ApexPages.standardcontroller sc1 = new ApexPages.standardcontroller(rdr1);
    RD_Page_Banner RD1 = new RD_Page_Banner(sc1);
    RD1.setMessages();
    
    ApexPages.standardcontroller sc2 = new ApexPages.standardcontroller(rdr2);
    RD_Page_Banner RD2 = new RD_Page_Banner(sc2);
    RD2.setMessages();
    
    ApexPages.standardcontroller sc3 = new ApexPages.standardcontroller(rdr3);
    RD_Page_Banner RD3 = new RD_Page_Banner(sc3);
    RD3.setMessages();
    
    ApexPages.standardcontroller sc4 = new ApexPages.standardcontroller(rdr4);
    RD_Page_Banner RD4 = new RD_Page_Banner(sc4);
    RD4.setMessages();
    
    ApexPages.standardcontroller sc5 = new ApexPages.standardcontroller(rdr5);
    RD_Page_Banner RD5 = new RD_Page_Banner(sc5);
    RD5.setMessages();
    }
}