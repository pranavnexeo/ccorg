@istest
public class exportExcel_test{
    public static testMethod void testdata(){
    
    String matnum = '010000000123456789';
    String salesOrg = '1234';
    String distChan = '30';
    
    
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;

    
    Account acc = new Account(Name='TestAcc',type = 'Customer',site = 'sitekhjkj');
    insert acc;
    
    
    
    contact c = new contact(Accountid = acc.id, firstname = 'Me', lastname = 'Myself', phone = '999-999-9999', buying_role__c='Designer', Role__c='Manager', No_Email__c = True);
    insert c;
    
    List<Nexeo_Competitor__c> ReqSupplier = new List<Nexeo_Competitor__c>();
    Id RecordTypeIdNexeoCompetitorCompetitor = Schema.SObjectType.Nexeo_Competitor__c.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
    Nexeo_Competitor__c nc = new Nexeo_Competitor__c(Technical_Service_Representative__c = u.id,Product_Specialist__c = u.id,Product_Line_Manager__c = u.id,Call_Report__c = true,Supplies_To__c = 'Chemicals',Competitor_or_Supplier__c = 'Supplier',name = 'test',Status__c='Active',RecordTypeid=RecordTypeIdNexeoCompetitorCompetitor);
    insert nc; 
    ReqSupplier.add(nc);
    
    SupplierPageSetting__c sps = new SupplierPageSetting__c(Name = 'OpportunityOpenDate',Opportunity_Date_Range__c = date.parse('10/01/2016'));
    insert sps;
    SupplierPageSetting__c sps1 = new SupplierPageSetting__c(Name = 'OpportunityClosedDate',Opportunity_Date_Range__c = date.parse('10/01/2016'));
    insert sps1;
    Date DateRange = sps.Opportunity_Date_Range__c; 
    
    Material_Sales_Data2__c msd2 = new Material_Sales_Data2__c();
    msd2.Material_Number__c = matnum;
    msd2.Material_Base_Code__c = 'testdata12';
    msd2.Material_Base_Code_Desc__c = 'testingdata12';
    msd2.PH4_Supplier__c = 'phdetails';
    msd2.Division_Desc__c = 'chemical';
    msd2.Sales_Org_Code__c = salesOrg;
    msd2.Dist_Channel_Code__c = distChan;
    msd2.Record_Key__c = matnum + salesOrg + distChan;
    //msd2.Material_General_Data__c = mgd2.Id;
    insert msd2;
    
    List<Opportunity> oppl = new List<Opportunity>();    
    Opportunity opp = new Opportunity();
    opp.Customer_Prospect__c = acc.id;
    opp.accountid = acc.id;
    opp.ownerid=u.id;
    opp.Name = 'Test Opp';
    opp.CreatedDate=DateRange;
    opp.Award_Start_Date__c=null;
    opp.StageName = '1. Prospect';
    opp.Type = 'New Business';
    opp.Contact__c= c.id; 
    opp.Requested_Supplier__c = nc.id;
    //opp.Requested_Supplier__r.Name =nc.name;
    opp.Overview__c = 'testdata';
    opp.Annual_Usage__c = 24.23;
    opp.Target__c = true;
    opp.CloseDate = system.today()+10;
    opp.Potential_CM__c= 12.2;
    opp.SAP_Material__c = msd2.id;
    //opp.SAP_Material__r.Name = msd2.name;
    insert opp;
    oppl.add(opp);
    
    Opportunity_Call_Report__c crn = new Opportunity_Call_Report__c(Name='test',Opportunity__c=opp.id);
    insert crn;
    
    
    
    apexpages.currentpage().getparameters().put('supid', nc.id);

    exportExcel ee = new exportExcel();
     
    ee.isExcel = true;
    ee.isCsv  = false;
    
    exportExcel.wrapper ewrp = new exportExcel.wrapper();
    ewrp.Owner = 'david';
    ewrp.OwnerDM = 'Test';
    ewrp.Account_Type = 'Pros';
    ewrp.Opportunity_Name = 'testopp';
    ewrp.Stage_Name = '1. Prospect';
    ewrp.Opportunity_Overview = 'testoppdata';  
    ewrp.Target = 'Test1';
    ewrp.Call_Report_Date= 'today';
    ewrp.Potential_CM = 'testcm';
    ewrp.Annual_Volume = 'testvol';
    ewrp.Created_Date = '10/1/2015';  
    ewrp.Close_Date = '10/1/2016';
    ewrp.Account = 'testacc';
    ewrp.Requested_Supplier = 'testRS';  
    ewrp.SAP_Material = 'sampledata';
    ewrp.id = 'sampid';
    
   
    
   try{
        ee.exportToExcel();
        
    }catch(exception e){}
    
        
    
    }
     public static testMethod void testdata1(){
    
    String matnum = '010000000123456789';
    String salesOrg = '1234';
    String distChan = '30';
    
    
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;

    
    Account acc = new Account(Name='TestAcc',type = 'Customer',site = 'sitekhjkj');
    insert acc;
    
    
    
    contact c = new contact(Accountid = acc.id, firstname = 'Me', lastname = 'Myself', phone = '999-999-9999', buying_role__c='Designer', Role__c='Manager', No_Email__c = True);
    insert c;
    
    List<Nexeo_Competitor__c> ReqSupplier = new List<Nexeo_Competitor__c>();
    //Nexeo_Competitor__c nc = new Nexeo_Competitor__c(Technical_Service_Representative__c = u.id,Product_Specialist__c = u.id,Product_Line_Manager__c = u.id,Call_Report__c = true,Supplies_To__c = 'Chemicals',Competitor_or_Supplier__c = 'Supplier',name = 'test',Status__c='Active',RecordTypeid='012E0000000LH70');
    Id RecordTypeIdNexeoCompetitorCompetitor = Schema.SObjectType.Nexeo_Competitor__c.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
    Nexeo_Competitor__c nc = new Nexeo_Competitor__c(Technical_Service_Representative__c = u.id,Product_Specialist__c = u.id,Product_Line_Manager__c = u.id,Call_Report__c = true,Supplies_To__c = 'Chemicals',Competitor_or_Supplier__c = 'Supplier',name = 'test',Status__c='Active',RecordTypeid=RecordTypeIdNexeoCompetitorCompetitor);
    insert nc; 
    ReqSupplier.add(nc);
    
    SupplierPageSetting__c sps = new SupplierPageSetting__c(Name = 'OpportunityOpenDate',Opportunity_Date_Range__c = date.parse('10/01/2016'));
    insert sps;
    SupplierPageSetting__c sps1 = new SupplierPageSetting__c(Name = 'OpportunityClosedDate',Opportunity_Date_Range__c = date.parse('10/01/2016'));
    insert sps1;
    Date DateRange = sps.Opportunity_Date_Range__c; 
    
    Material_Sales_Data2__c msd2 = new Material_Sales_Data2__c();
    msd2.Material_Number__c = matnum;
    msd2.Material_Base_Code__c = 'testdata12';
    msd2.Material_Base_Code_Desc__c = 'testingdata12';
    msd2.PH4_Supplier__c = 'phdetails';
    msd2.Division_Desc__c = 'chemical';
    msd2.Sales_Org_Code__c = salesOrg;
    msd2.Dist_Channel_Code__c = distChan;
    msd2.Record_Key__c = matnum + salesOrg + distChan;
    //msd2.Material_General_Data__c = mgd2.Id;
    insert msd2;
    
    List<Opportunity> oppl = new List<Opportunity>();    
    
    Opportunity opp1 = new Opportunity();
    opp1.Customer_Prospect__c = acc.id;
    opp1.accountid = acc.id;
    opp1.ownerid=u.id;
    opp1.Name = 'Test Opp';
    opp1.CreatedDate=DateRange;
    opp1.Award_Start_Date__c=null;
    opp1.StageName = 'Closed - Won';
    opp1.Type = 'New Business';
    opp1.Contact__c= c.id; 
    opp1.Requested_Supplier__c = nc.id;
    //opp.Requested_Supplier__r.Name =nc.name;
    opp1.Overview__c = 'testdata';
    opp1.Annual_Usage__c = 24.23;
    opp1.Target__c = true;
    opp1.CloseDate = DateRange;
    opp1.Potential_CM__c= 12.2;
    opp1.SAP_Material__c = msd2.id;
    //opp.SAP_Material__r.Name = msd2.name;
    insert opp1;
    oppl.add(opp1);
    Opportunity_Call_Report__c crn = new Opportunity_Call_Report__c(Name='test',Opportunity__c=opp1.id);
    insert crn;
    
    
    
    apexpages.currentpage().getparameters().put('supid', nc.id);

    exportExcel ee = new exportExcel();
     
    ee.isExcel = true;
    ee.isCsv  = false;
    
    exportExcel.wrapper ewrp = new exportExcel.wrapper();
    ewrp.Owner = 'david';
    ewrp.OwnerDM = 'Test';
    ewrp.Account_Type = 'Pros';
    ewrp.Opportunity_Name = 'testopp';
    ewrp.Stage_Name = '1. Prospect';
    ewrp.Opportunity_Overview = 'testoppdata';  
    ewrp.Target = 'Test1';
    ewrp.Call_Report_Date= 'today';
    ewrp.Potential_CM = 'testcm';
    ewrp.Annual_Volume = 'testvol';
    ewrp.Created_Date = '10/1/2015';  
    ewrp.Close_Date = '10/1/2016';
    ewrp.Account = 'testacc';
    ewrp.Requested_Supplier = 'testRS';  
    ewrp.SAP_Material = 'sampledata';
    ewrp.id = 'sampid';
       
     try{
       
        ee.exportToExcel1();
    }catch(exception e){}
         
    
    }
}