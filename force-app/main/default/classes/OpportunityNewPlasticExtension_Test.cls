@isTest
public class OpportunityNewPlasticExtension_Test{
    
    static Account acc;
    static Opportunity opp;
    static Opportunity opp1;
    
    static testMethod void myUnitTest() {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution Customer').getRecordTypeId();
        Account acc = new Account(Name = 'Test',RecordtypeId=RecordTypeId,SAP_Sales_Org__c = 'Test', SAP_DivisionCode__c = 'Test', SAP_Industry_Key__c ='Test',HQ_Sales_Office__c = 'Test', SAP_SalesGroup__c = 'Test');
        insert acc;
        //acc = new Account(Name='TestAcc',SAP_City__c='Bng',SAP_State__c='kar',SAP_Zip_Code__c='345678',Type='Prospect');
        //insert acc;
        contact c = new contact(Accountid = acc.id, firstname = 'Me', lastname = 'Myself', phone = '999-999-9999', buying_role__c='Designer', Role__c='Manager', No_Email__c = True);
        insert c;  
        c.buying_role__c='Designer2';
        c.Role__c='Manager';
        update c; 
        
        SAP_Sales_Org__c soc = new SAP_Sales_Org__c();  
        soc.Language_Code__c='E';
        soc.Sales_Org_Code__c='1000';
        soc.Sales_Org_Description__c='twrerttr';
        insert soc; 
        Material_Sales_Data2__c msd2= new Material_Sales_Data2__c();
        Map<String, Schema.RecordTypeInfo> RTMap1 = Material_Sales_Data2__c.sObjectType.getDescribe().getRecordTypeInfosByName();
        msd2.Name='testmaterial';
        msd2.RecordTypeId=RTMap1.get('Distribution').getrecordtypeid();
        msd2.Material_Number__c='00000123G2';
        msd2.Dist_Channel_Code__c='32';
        msd2.Material_Base_Code__c = '12345';
        msd2.Material_Base_Code_Desc__c = 'testmaterial2';
        msd2.Record_Key__c='000008912371';
        msd2.Sales_Org_Code__c = '33';
        
        msd2.Division_Desc__c = '1000test';
        msd2.SalesOrg_Code__c = [select id from SAP_Sales_Org__c where Sales_Org_Code__c = '1000'limit 1].id;
        insert msd2;
        Material_Base_Code__c base= new Material_Base_Code__c();
        base.Material_Base_Code_Description__c ='we113312';
        base.Material_Base_Code__c='12345';
        insert base;
        
        Delivery_Cities__c DC = new Delivery_Cities__c();
        DC.Name='Washington';
        DC.Account__c=acc.id;
        insert DC;
        
        Map<String, Schema.RecordTypeInfo> RTMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();    
        opp = new Opportunity();
        opp.Customer_Prospect__c = acc.id;
        opp.accountid=acc.id;
        opp.RecordTypeId = RTMap.get('Distribution Chemicals').getrecordtypeid();
        opp.Name = 'Test Opp';
        opp.CloseDate=system.today();
        opp.Award_Start_Date__c=null;
        opp.StageName = '1. Prospect';
        opp.Type = 'New Business';
        opp.SAP_Material__c = msd2.id;  
        opp.Contact__c= c.id; 
        opp.Material_base_Code__c = base.id;
        opp.Won_Lost_Comments__c='wwewrerwerwe';  
        opp.Market__c = 'Aerospace';
        opp.Requested_Supplier_PL__c = 'test';
        List<Nexeo_Competitor__c> ReqSupplier = new List<Nexeo_Competitor__c>();
        
        insert opp;
        
        opportunityteammember otm = new opportunityteammember();
        otm.opportunityid = opp.id;
        otm.userid = UserInfo.getUserId();
        otm.teammemberrole = 'accountmanager';
        insert otm;
        
        opp1 = new Opportunity();
        opp1.Customer_Prospect__c = acc.id;
        opp1.RecordTypeId = RTMap.get('Distribution Plastics').getrecordtypeid();
        opp1.Name = 'Test Opp1';
        opp1.CloseDate=system.today();
        opp1.StageName = '4. Present';
        opp1.Type = 'New Business';
        //opp1.SAP_Material__c = msd2.id;  
        opp1.Contact__c= c.id; 
        //opp1.Material_base_Code__c = base.id; 
        opp1.Award_Start_Date__c=null;
        opp1.Won_Lost_Comments__c='wwewrerwerwww';   
        //insert opp1; 
        SalesChurn__c objSC = new SalesChurn__c();
        objSC.Account_Number__c =acc.id;
        objSC.Base_Code__c =base.id;
        objSC.ChurnOpportunity__c = opp.id;
        insert objSC;
        
        apexpages.currentpage().getparameters().put('churnid',objSC.id); 
        
        apexpages.currentpage().getparameters().put('id', opp.id);  
        apexpages.currentpage().getparameters().put('id', opp1.id);
        apexpages.currentpage().getparameters().put('aid', opp1.Customer_Prospect__c);
        apexpages.currentpage().getparameters().put('cid', opp1.Contact__c);
        
        ApexPages.standardController sc = new ApexPages.standardcontroller(opp);
        OpportunityNewPlasticExtension OppExt = new OpportunityNewPlasticExtension(sc);
        
        OppExt.Opp = opp;
        OppExt.Opp = opp1;
        
        OppExt.getIsStage1();
        opp.Type = 'Existing Business';
        opp.StageName = '1. Prospect';
        OppExt.notreqd=true;
        OppExt.quote='test';
        OppExt.OEMId='test1';
        try{
            OppExt.saveandsubmit();
        }catch(exception e){}
        
        Test.stopTest();
    } 
    static testMethod void myUnitTest1(){
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution Customer').getRecordTypeId();
        Account acc = new Account(Name = 'Test',RecordtypeId=RecordTypeId,SAP_Sales_Org__c = 'Test', SAP_DivisionCode__c = 'Test', SAP_Industry_Key__c ='Test',HQ_Sales_Office__c = 'Test', SAP_SalesGroup__c = 'Test');
        insert acc;
        
        //acc = new Account(Name='TestAcc',SAP_City__c='Bng',SAP_State__c='kar',SAP_Zip_Code__c='345678',Type='Prospect');
        //insert acc;
        contact c = new contact(Accountid = acc.id, firstname = 'Me', lastname = 'Myself', phone = '999-999-9999', buying_role__c='Designer', Role__c='Manager', No_Email__c = True);
        insert c;  
        c.buying_role__c='Designer2';
        c.Role__c='Manager';
        update c; 
        
        SAP_Sales_Org__c soc = new SAP_Sales_Org__c();  
        soc.Language_Code__c='E';
        soc.Sales_Org_Code__c='1000';
        soc.Sales_Org_Description__c='twrerttr';
        insert soc; 
        Material_Sales_Data2__c msd2= new Material_Sales_Data2__c();
        Map<String, Schema.RecordTypeInfo> RTMap1 = Material_Sales_Data2__c.sObjectType.getDescribe().getRecordTypeInfosByName();
        msd2.Name='testmaterial';
        msd2.RecordTypeId=RTMap1.get('Distribution').getrecordtypeid();
        msd2.Material_Number__c='00000123G2';
        msd2.Dist_Channel_Code__c='32';
        msd2.Material_Base_Code__c = '12345';
        msd2.Material_Base_Code_Desc__c = 'testmaterial2';
        msd2.Record_Key__c='000008912371';
        msd2.Sales_Org_Code__c = '33';
        
        msd2.Division_Desc__c = '1000test';
        msd2.SalesOrg_Code__c = [select id from SAP_Sales_Org__c where Sales_Org_Code__c = '1000'limit 1].id;
        insert msd2;
        Material_Base_Code__c base= new Material_Base_Code__c();
        base.Material_Base_Code_Description__c ='we113312';
        base.Material_Base_Code__c='12345';
        insert base;
        
        Delivery_Cities__c DC = new Delivery_Cities__c();
        DC.Name='Washington';
        DC.Account__c=acc.id;
        insert DC;
        
        Map<String, Schema.RecordTypeInfo> RTMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();    
        opp = new Opportunity();
        opp.Customer_Prospect__c = acc.id;
        opp.accountid=acc.id;
        opp.RecordTypeId = RTMap.get('Distribution Chemicals').getrecordtypeid();
        opp.Name = 'Test Opp';
        opp.CloseDate=system.today();
        opp.Award_Start_Date__c=null;
        opp.StageName = '1. Prospect';
        opp.Type = 'New Business';
        opp.SAP_Material__c = msd2.id;  
        opp.Contact__c= c.id; 
        opp.Material_base_Code__c = base.id;
        opp.Won_Lost_Comments__c='wwewrerwerwe';  
        opp.Market__c = 'Aerospace';
        opp.Requested_Supplier_PL__c = 'test';
        List<Nexeo_Competitor__c> ReqSupplier = new List<Nexeo_Competitor__c>();
        
        insert opp;
        
        opportunityteammember otm = new opportunityteammember();
        otm.opportunityid = opp.id;
        otm.userid = UserInfo.getUserId();
        otm.teammemberrole = 'accountmanager';
        insert otm;
        
        opp1 = new Opportunity();
        opp1.Customer_Prospect__c = acc.id;
        opp1.RecordTypeId = RTMap.get('Distribution Plastics').getrecordtypeid();
        opp1.Name = 'Test Opp1';
        opp1.CloseDate=system.today();
        opp1.StageName = '4. Present';
        opp1.Type = 'New Business';
        //opp1.SAP_Material__c = msd2.id;  
        opp1.Contact__c= c.id; 
        //opp1.Material_base_Code__c = base.id; 
        opp1.Award_Start_Date__c=null;
        opp1.Won_Lost_Comments__c='wwewrerwerwww';   
        //insert opp1; 
        SalesChurn__c objSC = new SalesChurn__c();
        objSC.Account_Number__c =acc.id;
        objSC.Base_Code__c =base.id;
        objSC.ChurnOpportunity__c = opp.id;
        insert objSC;
        
        apexpages.currentpage().getparameters().put('churnid',objSC.id); 
        apexpages.currentpage().getparameters().put('id', opp.id);  
        apexpages.currentpage().getparameters().put('id', opp1.id);
        apexpages.currentpage().getparameters().put('aid', opp1.Customer_Prospect__c);
        apexpages.currentpage().getparameters().put('cid', opp1.Contact__c);
        
        ApexPages.standardController sc = new ApexPages.standardcontroller(opp);
        OpportunityNewPlasticExtension OppExt = new OpportunityNewPlasticExtension(sc);
        
        OppExt.Opp = opp;
        OppExt.Opp = opp1;
        
        OppExt.getOppId();
        OppExt.getAccountId();
        OppExt.getContactId();
        OppExt.getAccountName();
        OppExt.getMaterialId();
        OppExt.accountchanged();
        OppExt.stageOnChange();
        try{
            OppExt.save();
        }catch(exception e){}
        
    }
    static testMethod void myUnitTest2(){
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution Customer').getRecordTypeId();
        Account acc = new Account(Name = 'Test',RecordtypeId=RecordTypeId,SAP_Sales_Org__c = 'Test', SAP_DivisionCode__c = 'Test', SAP_Industry_Key__c ='Test',HQ_Sales_Office__c = 'Test', SAP_SalesGroup__c = 'Test');
        insert acc;
        
        //acc = new Account(Name='TestAcc',SAP_City__c='Bng',SAP_State__c='kar',SAP_Zip_Code__c='345678',Type='Prospect');
        //insert acc;
        contact c = new contact(Accountid = acc.id, firstname = 'Me', lastname = 'Myself', phone = '999-999-9999', buying_role__c='Designer', Role__c='Manager', No_Email__c = True);
        insert c;  
        c.buying_role__c='Designer2';
        c.Role__c='Manager';
        update c; 
        
        SAP_Sales_Org__c soc = new SAP_Sales_Org__c();  
        soc.Language_Code__c='E';
        soc.Sales_Org_Code__c='1000';
        soc.Sales_Org_Description__c='twrerttr';
        insert soc; 
        Material_Sales_Data2__c msd2= new Material_Sales_Data2__c();
        Map<String, Schema.RecordTypeInfo> RTMap1 = Material_Sales_Data2__c.sObjectType.getDescribe().getRecordTypeInfosByName();
        msd2.Name='testmaterial';
        msd2.RecordTypeId=RTMap1.get('Distribution').getrecordtypeid();
        msd2.Material_Number__c='00000123G2';
        msd2.Dist_Channel_Code__c='32';
        msd2.Material_Base_Code__c = '12345';
        msd2.Material_Base_Code_Desc__c = 'testmaterial2';
        msd2.Record_Key__c='000008912371';
        msd2.Sales_Org_Code__c = '33';
        
        msd2.Division_Desc__c = '1000test';
        msd2.SalesOrg_Code__c = [select id from SAP_Sales_Org__c where Sales_Org_Code__c = '1000'limit 1].id;
        insert msd2;
        Material_Base_Code__c base= new Material_Base_Code__c();
        base.Material_Base_Code_Description__c ='we113312';
        base.Material_Base_Code__c='12345';
        insert base;
        
        Delivery_Cities__c DC = new Delivery_Cities__c();
        DC.Name='Washington';
        DC.Account__c=acc.id;
        insert DC;
        
        Map<String, Schema.RecordTypeInfo> RTMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();    
        opp = new Opportunity();
        opp.Customer_Prospect__c = acc.id;
        opp.accountid=acc.id;
        opp.RecordTypeId = RTMap.get('Distribution Chemicals').getrecordtypeid();
        opp.Name = 'Test Opp';
        opp.CloseDate=system.today();
        opp.Award_Start_Date__c=null;
        opp.StageName = '1. Prospect';
        opp.Type = 'New Business';
        opp.SAP_Material__c = msd2.id;  
        opp.Contact__c= c.id; 
        opp.Material_base_Code__c = base.id;
        opp.Won_Lost_Comments__c='wwewrerwerwe';  
        opp.Market__c = 'Aerospace';
        opp.Requested_Supplier_PL__c = 'test';
        List<Nexeo_Competitor__c> ReqSupplier = new List<Nexeo_Competitor__c>();
        
        insert opp;
        
        opportunityteammember otm = new opportunityteammember();
        otm.opportunityid = opp.id;
        otm.userid = UserInfo.getUserId();
        otm.teammemberrole = 'accountmanager';
        insert otm;
        
        opp1 = new Opportunity();
        opp1.Customer_Prospect__c = acc.id;
        opp1.RecordTypeId = RTMap.get('Distribution Plastics').getrecordtypeid();
        opp1.Name = 'Test Opp1';
        opp1.CloseDate=system.today();
        opp1.StageName = '4. Present';
        opp1.Type = 'New Business';
        //opp1.SAP_Material__c = msd2.id;  
        opp1.Contact__c= c.id; 
        //opp1.Material_base_Code__c = base.id; 
        opp1.Award_Start_Date__c=null;
        opp1.Won_Lost_Comments__c='wwewrerwerwww';   
        //insert opp1; 
        SalesChurn__c objSC = new SalesChurn__c();
        objSC.Account_Number__c =acc.id;
        objSC.Base_Code__c =base.id;
        objSC.ChurnOpportunity__c = opp.id;
        insert objSC;
        
        apexpages.currentpage().getparameters().put('churnid',objSC.id); 
        apexpages.currentpage().getparameters().put('id', opp.id);  
        apexpages.currentpage().getparameters().put('id', opp1.id);
        apexpages.currentpage().getparameters().put('aid', opp1.Customer_Prospect__c);
        apexpages.currentpage().getparameters().put('cid', opp1.Contact__c);
        
        ApexPages.standardController sc = new ApexPages.standardcontroller(opp);
        OpportunityNewPlasticExtension OppExt = new OpportunityNewPlasticExtension(sc);
        OppExt.showfull();
        
        OppExt.cancel();
        OppExt.ispilot = true;
        try{
            OppExt.submit();
        }catch(exception e){}
        
    }
    
    static testMethod void myUnitTest3(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
        Test.startTest();
        
        acc = new Account(Name='TestAcc',SAP_City__c='Bng',SAP_State__c='kar',SAP_Zip_Code__c='345678',Type='Prospect');
        insert acc;
        contact c = new contact(Accountid = acc.id, firstname = 'Me', lastname = 'Myself', phone = '999-999-9999', buying_role__c='Designer', Role__c='Manager', No_Email__c = True);
        insert c;  
        c.buying_role__c='Designer2';
        c.Role__c='Manager';
        update c; 
        
        SAP_Sales_Org__c soc = new SAP_Sales_Org__c();  
        soc.Language_Code__c='E';
        soc.Sales_Org_Code__c='1000';
        soc.Sales_Org_Description__c='twrerttr';
        insert soc; 
        Material_Sales_Data2__c msd2= new Material_Sales_Data2__c();
        Map<String, Schema.RecordTypeInfo> RTMap1 = Material_Sales_Data2__c.sObjectType.getDescribe().getRecordTypeInfosByName();
        msd2.Name='testmaterial';
        msd2.RecordTypeId=RTMap1.get('Distribution').getrecordtypeid();
        msd2.Material_Number__c='00000123G2';
        msd2.Dist_Channel_Code__c='32';
        msd2.Material_Base_Code__c = '12345';
        msd2.Material_Base_Code_Desc__c = 'testmaterial2';
        msd2.Record_Key__c='000008912371';
        msd2.Sales_Org_Code__c = '33';
        
        msd2.Division_Desc__c = '1000test';
        msd2.SalesOrg_Code__c = [select id from SAP_Sales_Org__c where Sales_Org_Code__c = '1000'limit 1].id;
        insert msd2;
        Material_Base_Code__c base= new Material_Base_Code__c();
        base.Material_Base_Code_Description__c ='we113312';
        base.Material_Base_Code__c='12345';
        insert base;
        
        Delivery_Cities__c DC = new Delivery_Cities__c();
        DC.Name='Washington';
        DC.Account__c=acc.id;
        insert DC;
        
        Map<String, Schema.RecordTypeInfo> RTMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();    
        opp = new Opportunity();
        opp.Customer_Prospect__c = acc.id;
        opp.accountid=acc.id;
        opp.RecordTypeId = RTMap.get('Distribution Chemicals').getrecordtypeid();
        opp.Name = 'Test Opp';
        opp.CloseDate=system.today();
        opp.Award_Start_Date__c=null;
        opp.StageName = '1. Prospect';
        opp.Type = 'New Business';
        opp.SAP_Material__c = msd2.id;  
        opp.Contact__c= c.id; 
        opp.Material_base_Code__c = base.id;
        opp.Won_Lost_Comments__c='wwewrerwerwe';  
        opp.Market__c = 'Aerospace';
        opp.Requested_Supplier_PL__c = 'test';
        List<Nexeo_Competitor__c> ReqSupplier = new List<Nexeo_Competitor__c>();
        
        insert opp;
        
        opportunityteammember otm = new opportunityteammember();
        otm.opportunityid = opp.id;
        otm.userid = UserInfo.getUserId();
        otm.teammemberrole = 'accountmanager';
        insert otm;
        
        opp1 = new Opportunity();
        opp1.Customer_Prospect__c = acc.id;
        opp1.RecordTypeId = RTMap.get('Distribution Plastics').getrecordtypeid();
        opp1.Name = 'Test Opp1';
        opp1.CloseDate=system.today();
        opp1.StageName = '4. Present';
        opp1.Type = 'New Business';
        opp1.Contact__c= c.id; 
        opp1.Award_Start_Date__c=null;
        opp1.Won_Lost_Comments__c='wwewrerwerwww';   
        SalesChurn__c objSC = new SalesChurn__c();
        objSC.Account_Number__c =acc.id;
        objSC.Base_Code__c =base.id;
        objSC.ChurnOpportunity__c = opp.id;
        insert objSC;
        
        apexpages.currentpage().getparameters().put('churnid',objSC.id); 
        apexpages.currentpage().getparameters().put('id', opp.id);  
        apexpages.currentpage().getparameters().put('id', opp1.id);
        apexpages.currentpage().getparameters().put('aid', opp1.Customer_Prospect__c);
        apexpages.currentpage().getparameters().put('cid', opp1.Contact__c);
        
        ApexPages.standardController sc = new ApexPages.standardcontroller(opp);
        OpportunityNewPlasticExtension OppExt = new OpportunityNewPlasticExtension(sc);
        
        OppExt.stagechanged();
        OppExt.getisquotevalue();
        OppExt.getrenderplastics();
        OppExt.getiscomposites();
        OppExt.getIsStage4();
        OppExt.getisClosed();
        OppExt.getIsStage2();
        OppExt.getIsStage3();
        OppExt.fieldrequired();
        oppExt.chageMarketval();
        oppExt.changeMarket();
        oppExt.getADE_Technical_Representative();
        oppExt.getTechnical_Representative();
        oppExt.getAuto_CAM();
        oppExt.getCAM_1();
        oppExt.getCAM_2();
        
    }
    static testMethod void myUnitTest4(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
        Test.startTest();
        
        acc = new Account(Name='TestAcc',SAP_City__c='Bng',SAP_State__c='kar',SAP_Zip_Code__c='345678',Type='Prospect');
        insert acc;
        contact c = new contact(Accountid = acc.id, firstname = 'Me', lastname = 'Myself', phone = '999-999-9999', buying_role__c='Designer', Role__c='Manager', No_Email__c = True);
        insert c;  
        c.buying_role__c='Designer2';
        c.Role__c='Manager';
        update c; 
        
        SAP_Sales_Org__c soc = new SAP_Sales_Org__c();  
        soc.Language_Code__c='E';
        soc.Sales_Org_Code__c='1000';
        soc.Sales_Org_Description__c='twrerttr';
        insert soc; 
        Material_Sales_Data2__c msd2= new Material_Sales_Data2__c();
        Map<String, Schema.RecordTypeInfo> RTMap1 = Material_Sales_Data2__c.sObjectType.getDescribe().getRecordTypeInfosByName();
        msd2.Name='testmaterial';
        msd2.RecordTypeId=RTMap1.get('Distribution').getrecordtypeid();
        msd2.Material_Number__c='00000123G2';
        msd2.Dist_Channel_Code__c='32';
        msd2.Material_Base_Code__c = '12345';
        msd2.Material_Base_Code_Desc__c = 'testmaterial2';
        msd2.Record_Key__c='000008912371';
        msd2.Sales_Org_Code__c = '33';
        
        msd2.Division_Desc__c = '1000test';
        msd2.SalesOrg_Code__c = [select id from SAP_Sales_Org__c where Sales_Org_Code__c = '1000'limit 1].id;
        insert msd2;
        Material_Base_Code__c base= new Material_Base_Code__c();
        base.Material_Base_Code_Description__c ='we113312';
        base.Material_Base_Code__c='12345';
        insert base;
        
        Delivery_Cities__c DC = new Delivery_Cities__c();
        DC.Name='Washington';
        DC.Account__c=acc.id;
        insert DC;
        
        Map<String, Schema.RecordTypeInfo> RTMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();    
        opp = new Opportunity();
        opp.Customer_Prospect__c = acc.id;
        opp.accountid=acc.id;
        opp.RecordTypeId = RTMap.get('Distribution Chemicals').getrecordtypeid();
        opp.Name = 'Test Opp';
        opp.CloseDate=system.today();
        opp.Award_Start_Date__c=null;
        opp.StageName = '1. Prospect';
        opp.Type = 'New Business';
        opp.SAP_Material__c = msd2.id;  
        opp.Contact__c= c.id; 
        opp.Material_base_Code__c = base.id;
        opp.Won_Lost_Comments__c='wwewrerwerwe';  
        opp.Market__c = 'Aerospace';
        opp.Requested_Supplier_PL__c = 'test';
        List<Nexeo_Competitor__c> ReqSupplier = new List<Nexeo_Competitor__c>();
        
        insert opp;
        
        opportunityteammember otm = new opportunityteammember();
        otm.opportunityid = opp.id;
        otm.userid = UserInfo.getUserId();
        otm.teammemberrole = 'accountmanager';
        insert otm;
        
        opp1 = new Opportunity();
        opp1.Customer_Prospect__c = acc.id;
        opp1.RecordTypeId = RTMap.get('Distribution Plastics').getrecordtypeid();
        opp1.Name = 'Test Opp1';
        opp1.CloseDate=system.today();
        opp1.StageName = '4. Present';
        opp1.Type = 'New Business';
        opp1.Contact__c= c.id; 
        opp1.Award_Start_Date__c=null;
        opp1.Won_Lost_Comments__c='wwewrerwerwww';   
        
        
        SalesChurn__c objSC = new SalesChurn__c();
        objSC.Account_Number__c =acc.id;
        objSC.Base_Code__c =base.id;
        objSC.ChurnOpportunity__c = opp.id;
        insert objSC;
        
        //apexpages.currentpage().getparameters().put('churnid',objSC.id); 
        apexpages.currentpage().getparameters().put('cf', opp1.id);  
        apexpages.currentpage().getparameters().put('id', opp1.id);
        apexpages.currentpage().getparameters().put('aid', opp1.Customer_Prospect__c);
        apexpages.currentpage().getparameters().put('cid', opp1.Contact__c);
        
        ApexPages.standardController sc = new ApexPages.standardcontroller(opp1);
        OpportunityNewPlasticExtension OppExt = new OpportunityNewPlasticExtension(sc);
        OppExt.Opp =opp1;
        try{
            OppExt.save();
        }catch(Exception e){}
        OppExt.stagechanged();
        OppExt.getisquotevalue();
        OppExt.getrenderplastics();
        OppExt.getiscomposites();
        OppExt.getIsStage4();
        OppExt.getisClosed();
        OppExt.getIsStage2();
        OppExt.getIsStage3();
        OppExt.fieldrequired();
        oppExt.chageMarketval();
        oppExt.changeMarket();
        oppExt.getADE_Technical_Representative();
        oppExt.getTechnical_Representative();
        oppExt.getAuto_CAM();
        oppExt.getCAM_1();
        oppExt.getCAM_2();
        
        opp1.T_Business_Type__c =null;
        OppExt.recordtypename ='Distribution Environmental Services';
        OppExt.Opp =opp1;
        try{
            OppExt.save();
        }catch(Exception e){}
        
        opp1.T_Business_Type__c ='New Business';
        opp1.Expiration_Date__c =null;
        OppExt.Opp =opp1;
        try{
            OppExt.save();
        }catch(Exception e){}
        
        opp1.T_Business_Type__c ='New Business';
        opp1.Market__c ='Automotive';
        OppExt.recordtypename ='Distribution Plastics';
        OppExt.Opp =opp1;
        try{
            OppExt.save();
        }catch(Exception e){}
        
        opp1.T_Business_Type__c ='New Business';
        opp1.Market__c ='Automotive';
        opp1.OEM_1__c ='test';
        OppExt.Opp =opp1;
        try{
            OppExt.save();
        }catch(Exception e){}
        
    }
    
    static testMethod void myUnitTest5(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
        Test.startTest();
        
        acc = new Account(Name='TestAcc',SAP_City__c='Bng',SAP_State__c='kar',SAP_Zip_Code__c='345678',Type='Prospect');
        insert acc;
        contact c = new contact(Accountid = acc.id, firstname = 'Me', lastname = 'Myself', phone = '999-999-9999', buying_role__c='Designer', Role__c='Manager', No_Email__c = True);
        insert c;  
        c.buying_role__c='Designer2';
        c.Role__c='Manager';
        update c; 
        
        SAP_Sales_Org__c soc = new SAP_Sales_Org__c();  
        soc.Language_Code__c='E';
        soc.Sales_Org_Code__c='1000';
        soc.Sales_Org_Description__c='twrerttr';
        insert soc; 
        Material_Sales_Data2__c msd2= new Material_Sales_Data2__c();
        Map<String, Schema.RecordTypeInfo> RTMap1 = Material_Sales_Data2__c.sObjectType.getDescribe().getRecordTypeInfosByName();
        msd2.Name='testmaterial';
        msd2.RecordTypeId=RTMap1.get('Distribution').getrecordtypeid();
        msd2.Material_Number__c='00000123G2';
        msd2.Dist_Channel_Code__c='32';
        msd2.Material_Base_Code__c = '12345';
        msd2.Material_Base_Code_Desc__c = 'testmaterial2';
        msd2.Record_Key__c='000008912371';
        msd2.Sales_Org_Code__c = '33';
        
        msd2.Division_Desc__c = '1000test';
        msd2.SalesOrg_Code__c = [select id from SAP_Sales_Org__c where Sales_Org_Code__c = '1000'limit 1].id;
        insert msd2;
        Material_Base_Code__c base= new Material_Base_Code__c();
        base.Material_Base_Code_Description__c ='we113312';
        base.Material_Base_Code__c='12345';
        insert base;
        
        Delivery_Cities__c DC = new Delivery_Cities__c();
        DC.Name='Washington';
        DC.Account__c=acc.id;
        insert DC;
        
        Map<String, Schema.RecordTypeInfo> RTMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();    
        opp = new Opportunity();
        opp.Customer_Prospect__c = acc.id;
        opp.accountid=acc.id;
        opp.RecordTypeId = RTMap.get('Distribution Chemicals').getrecordtypeid();
        opp.Name = 'Test Opp';
        opp.CloseDate=system.today();
        opp.Award_Start_Date__c=null;
        opp.StageName = '1. Prospect';
        opp.Type = 'New Business';
        opp.SAP_Material__c = msd2.id;  
        opp.Contact__c= c.id; 
        opp.Material_base_Code__c = base.id;
        opp.Won_Lost_Comments__c='wwewrerwerwe';  
        opp.Market__c = 'Aerospace';
        opp.Requested_Supplier_PL__c = 'test';
        
        insert opp;
        
        opportunityteammember otm = new opportunityteammember();
        otm.opportunityid = opp.id;
        otm.userid = UserInfo.getUserId();
        otm.teammemberrole = 'accountmanager';
        insert otm;
        
        apexpages.currentpage().getparameters().put('cf', opp.id);  
        apexpages.currentpage().getparameters().put('id', opp.id);
        apexpages.currentpage().getparameters().put('aid', opp.Customer_Prospect__c);
        apexpages.currentpage().getparameters().put('cid', opp.Contact__c);
        
        ApexPages.standardController sc = new ApexPages.standardcontroller(opp);
        OpportunityNewPlasticExtension OppExt = new OpportunityNewPlasticExtension(sc);
        
        opp.StageName ='Concept';
        OppExt.Opp =opp;
        try{
            OppExt.save();
        }catch(Exception e){}
        
        opp.StageName ='2. Qualify';
        opp.TAG_Opportunity__c = true;
        opp.TAG_Date__c = null;
        OppExt.Opp =opp;
        try{
            OppExt.save();
        }catch(Exception e){}
        
        opp.StageName ='2. Qualify';
        opp.TAG_Opportunity__c = false;
        opp.TAG_Date__c = System.today();
        OppExt.Opp =opp;
        try{
            OppExt.save();
        }catch(Exception e){}
        
        opp.StageName ='2. Qualify';
        opp.TAG_Opportunity__c = false;
        opp.TAG_Date__c = System.today();
        OppExt.Opp =opp;
        try{
            OppExt.save();
        }catch(Exception e){}
    }
    
    static testMethod void myUnitTest6(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
        Test.startTest();
        
        acc = new Account(Name='TestAcc',SAP_City__c='Bng',SAP_State__c='kar',SAP_Zip_Code__c='345678',Type='Prospect');
        insert acc;
        contact c = new contact(Accountid = acc.id, firstname = 'Me', lastname = 'Myself', phone = '999-999-9999', buying_role__c='Designer', Role__c='Manager', No_Email__c = True);
        insert c;  
        c.buying_role__c='Designer2';
        c.Role__c='Manager';
        update c; 
        
        SAP_Sales_Org__c soc = new SAP_Sales_Org__c();  
        soc.Language_Code__c='E';
        soc.Sales_Org_Code__c='1000';
        soc.Sales_Org_Description__c='twrerttr';
        insert soc; 
        Material_Sales_Data2__c msd2= new Material_Sales_Data2__c();
        Map<String, Schema.RecordTypeInfo> RTMap1 = Material_Sales_Data2__c.sObjectType.getDescribe().getRecordTypeInfosByName();
        msd2.Name='testmaterial';
        msd2.RecordTypeId=RTMap1.get('Distribution').getrecordtypeid();
        msd2.Material_Number__c='00000123G2';
        msd2.Dist_Channel_Code__c='32';
        msd2.Material_Base_Code__c = '12345';
        msd2.Material_Base_Code_Desc__c = 'testmaterial2';
        msd2.Record_Key__c='000008912371';
        msd2.Sales_Org_Code__c = '33';
        
        msd2.Division_Desc__c = '1000test';
        msd2.SalesOrg_Code__c = [select id from SAP_Sales_Org__c where Sales_Org_Code__c = '1000'limit 1].id;
        insert msd2;
        Material_Base_Code__c base= new Material_Base_Code__c();
        base.Material_Base_Code_Description__c ='we113312';
        base.Material_Base_Code__c='12345';
        insert base;
        
        Delivery_Cities__c DC = new Delivery_Cities__c();
        DC.Name='Washington';
        DC.Account__c=acc.id;
        insert DC;
        
        Map<String, Schema.RecordTypeInfo> RTMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();    
        opp = new Opportunity();
        opp.Customer_Prospect__c = acc.id;
        opp.accountid=acc.id;
        opp.RecordTypeId = RTMap.get('Distribution Environmental Services').getrecordtypeid();
        opp.Name = 'Test Opp';
        opp.CloseDate=system.today();
        opp.Award_Start_Date__c=null;
        opp.StageName = '1. Prospect';
        opp.Type = 'New Business';
        opp.SAP_Material__c = msd2.id;  
        opp.Contact__c= c.id; 
        opp.Material_base_Code__c = base.id;
        opp.Won_Lost_Comments__c='wwewrerwerwe';  
        opp.Market__c = 'Aerospace';
        opp.Requested_Supplier_PL__c = 'test';
        
        
        insert opp;
        
        opportunityteammember otm = new opportunityteammember();
        otm.opportunityid = opp.id;
        otm.userid = UserInfo.getUserId();
        otm.teammemberrole = 'accountmanager';
        insert otm;
        
        apexpages.currentpage().getparameters().put('cf', opp.id);  
        apexpages.currentpage().getparameters().put('id', opp.id);
        apexpages.currentpage().getparameters().put('aid', opp.Customer_Prospect__c);
        apexpages.currentpage().getparameters().put('cid', opp.Contact__c);
        
        ApexPages.standardController sc = new ApexPages.standardcontroller(opp);
        OpportunityNewPlasticExtension OppExt = new OpportunityNewPlasticExtension(sc);
          
        opp.T_Business_Type__c = null;
        opp.StageName ='2. Qualify';
        OppExt.Opp =opp;
        try{
            OppExt.save();
        }catch(Exception e){}
       
    }
    
    static testMethod void myUnitTest7(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
        Test.startTest();
        
        acc = new Account(Name='TestAcc',SAP_City__c='Bng',SAP_State__c='kar',SAP_Zip_Code__c='345678',Type='Prospect');
        insert acc;
        contact c = new contact(Accountid = acc.id, firstname = 'Me', lastname = 'Myself', phone = '999-999-9999', buying_role__c='Designer', Role__c='Manager', No_Email__c = True);
        insert c;  
        c.buying_role__c='Designer2';
        c.Role__c='Manager';
        update c; 
        
        SAP_Sales_Org__c soc = new SAP_Sales_Org__c();  
        soc.Language_Code__c='E';
        soc.Sales_Org_Code__c='1000';
        soc.Sales_Org_Description__c='twrerttr';
        insert soc; 
        Material_Sales_Data2__c msd2= new Material_Sales_Data2__c();
        Map<String, Schema.RecordTypeInfo> RTMap1 = Material_Sales_Data2__c.sObjectType.getDescribe().getRecordTypeInfosByName();
        msd2.Name='testmaterial';
        msd2.RecordTypeId=RTMap1.get('Distribution').getrecordtypeid();
        msd2.Material_Number__c='00000123G2';
        msd2.Dist_Channel_Code__c='32';
        msd2.Material_Base_Code__c = '12345';
        msd2.Material_Base_Code_Desc__c = 'testmaterial2';
        msd2.Record_Key__c='000008912371';
        msd2.Sales_Org_Code__c = '33';
        
        msd2.Division_Desc__c = '1000test';
        msd2.SalesOrg_Code__c = [select id from SAP_Sales_Org__c where Sales_Org_Code__c = '1000'limit 1].id;
        insert msd2;
        Material_Base_Code__c base= new Material_Base_Code__c();
        base.Material_Base_Code_Description__c ='we113312';
        base.Material_Base_Code__c='12345';
        insert base;
        
        Delivery_Cities__c DC = new Delivery_Cities__c();
        DC.Name='Washington';
        DC.Account__c=acc.id;
        insert DC;
        
        Map<String, Schema.RecordTypeInfo> RTMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();    
        opp = new Opportunity();
        opp.Customer_Prospect__c = acc.id;
        opp.accountid=acc.id;
        opp.RecordTypeId = RTMap.get('Distribution Plastics').getrecordtypeid();
        opp.Name = 'Test Opp';
        opp.CloseDate=system.today();
        opp.Award_Start_Date__c=null;
        opp.StageName = '1. Prospect';
        opp.Type = 'New Business';
        opp.SAP_Material__c = msd2.id;  
        opp.Contact__c= c.id; 
        opp.Material_base_Code__c = base.id;
        opp.Won_Lost_Comments__c='wwewrerwerwe';  
        opp.Market__c = 'Automotive';
        opp.Requested_Supplier_PL__c = 'test';
        
        
        insert opp;
        
        opportunityteammember otm = new opportunityteammember();
        otm.opportunityid = opp.id;
        otm.userid = UserInfo.getUserId();
        otm.teammemberrole = 'accountmanager';
        insert otm;
        
        apexpages.currentpage().getparameters().put('cf', opp.id);  
        apexpages.currentpage().getparameters().put('id', opp.id);
        apexpages.currentpage().getparameters().put('aid', opp.Customer_Prospect__c);
        apexpages.currentpage().getparameters().put('cid', opp.Contact__c);
        
        ApexPages.standardController sc = new ApexPages.standardcontroller(opp);
        OpportunityNewPlasticExtension OppExt = new OpportunityNewPlasticExtension(sc);
          
        opp.Submarket__c = 'AfterMarket';
        opp.StageName ='2. Qualify';
        opp.T_Reason_Won_Lost__c ='Availability';
        OppExt.Opp =opp;
        try{
            OppExt.save();
        }catch(Exception e){}
        
        opp.Submarket__c = 'Auto care';
        opp.StageName ='2. Qualify';
        opp.T_Reason_Won_Lost__c ='Availability';
        opp.OEM_1__c = '';
        opp.Automotive_Application__c = '';
        opp.Vehicle_US__c = '';
        opp.Part_Weight_kg__c = 11110.00;
        opp.Parts_Vehicle__c = 10000;
        OppExt.Opp =opp;
        try{
            OppExt.save();
        }catch(Exception e){}
       		
    }
    
    
    
}