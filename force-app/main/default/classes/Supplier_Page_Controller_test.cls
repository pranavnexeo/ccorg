@istest
public class Supplier_Page_Controller_test{
    public static testMethod void testSupplier_Page_Controller(){
    
    String matnum = '010000000123456789';
    String salesOrg = '1234';
    String distChan = '30';
    
    
    //User u = [select id, managerid from user where id = :userinfo.getuserid() limit 1];
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
       // insert u;
    
    Account acc = new Account(Name='TestAcc',type = 'Distribution Customer',site = 'sitekhjkj');
    insert acc;
    
    contact c = new contact(Accountid = acc.id, firstname = 'Me', lastname = 'Myself', phone = '999-999-9999', buying_role__c='Designer', Role__c='Manager', No_Email__c = True);
    insert c;
    
    List<Nexeo_Competitor__c> ReqSupplier = new List<Nexeo_Competitor__c>();
    //Nexeo_Competitor__c nc = new Nexeo_Competitor__c(Technical_Service_Representative__c = u.id,Product_Specialist__c = u.id,Product_Line_Manager__c = u.id,Call_Report__c = true,Supplies_To__c = 'Chemicals',Competitor_or_Supplier__c = 'Supplier',name = 'test',Status__c='Active',RecordTypeid='012E0000000LH70');
     Id RecordTypeIdNexeoCompetitorCompetitor = Schema.SObjectType.Nexeo_Competitor__c.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
     Nexeo_Competitor__c nc = new Nexeo_Competitor__c(Technical_Service_Representative__c = u.id,Product_Specialist__c = u.id,Product_Line_Manager__c = u.id,Call_Report__c = true,Supplies_To__c = 'Chemicals',Competitor_or_Supplier__c = 'Supplier',name = 'test',Status__c='Active',RecordTypeid=RecordTypeIdNexeoCompetitorCompetitor);
    insert nc; 
    ReqSupplier.add(nc);
    
    Supplier_Contact__c scon = new Supplier_Contact__c();
    scon.Competitor_Supplier_or_OEM__c = nc.id;
    insert scon;
    
    SupplierPageSetting__c sps = new SupplierPageSetting__c(Name = 'OpportunityOpenDate',Opportunity_Date_Range__c = date.parse('10/01/2016'));
    insert sps;
    SupplierPageSetting__c sps1 = new SupplierPageSetting__c(Name = 'OpportunityClosedDate',Opportunity_Date_Range__c = date.parse('10/01/2016'));
    insert sps1;
    Date DateRange = sps.Opportunity_Date_Range__c; 
    
    List<Opportunity> oppl = new List<Opportunity>();    
    Opportunity opp = new Opportunity();
    opp.Customer_Prospect__c = acc.id;
    opp.accountid = acc.id;
    opp.Name = 'Test Opp';
    opp.CloseDate=system.today();
    opp.Award_Start_Date__c=null;
    opp.StageName = 'Closed - Won';
    opp.Type = 'New Business';
    opp.Contact__c= c.id; 
    opp.Requested_Supplier__c = nc.id;
    opp.Overview__c = 'testdata';
    opp.Annual_Usage__c = 24.23;
    insert opp;
    oppl.add(opp);
    
      
        
    Material_General_Data2__c mgd2 = new Material_General_Data2__c();
    mgd2.Material_Number__c = matnum;
    insert mgd2;
    
    List<Material_Sales_Data2__c> msdl = new List<Material_Sales_Data2__c>();
    Material_Sales_Data2__c msd2 = new Material_Sales_Data2__c();
    msd2.Material_Number__c = matnum;
    msd2.Material_Base_Code__c = 'testdata12';
    msd2.Material_Base_Code_Desc__c = 'testingdata12';
    msd2.PH4_Supplier__c = 'phdetails';
    msd2.Division_Desc__c = 'chemical';
    msd2.Sales_Org_Code__c = salesOrg;
    msd2.Dist_Channel_Code__c = distChan;
    msd2.Record_Key__c = matnum + salesOrg + distChan;
    msd2.Material_General_Data__c = mgd2.Id;
    insert msd2;
    msdl.add(msd2);
    
    List<formData> fdatalst = new List<formData>(); 
    formData fdata1 = new formData();
    formData fdata2 = new formData();
    formData fdata3 = new formData();
    fdata1.name='SearchBy';
    fdata1.value='Supplier';
    fdata2.name='SearchBy';
    fdata2.value='SupplierContact';
    fdata3.name='SearchBy';
    fdata3.value='SAPMaterial';
    
    fdatalst.add(fdata1);
    //fdatalst.add(fdata2);
    //fdatalst.add(fdata3);
    
     
    List<String> id = new List<String>();  
    id.add(scon.id);
    string q='';
    
    Supplier_Page_Controller spc = new Supplier_Page_Controller();
    Supplier_Page_Controller.getDateFormat();
    Supplier_Page_Controller.getRecordsToDisplaySupplier('testdata');
    Supplier_Page_Controller.getRecordsToDisplayAttachment('testdata2');
    Supplier_Page_Controller.getRecordsToDisplaySupplierContact('test');
    Supplier_Page_Controller.getRecordsToDisplaySampleMaterial(nc.id);
    Supplier_Page_Controller.getRecordsToDisplayProduct(nc.id);
    Supplier_Page_Controller.getSingleOptions('SupplierContact',id,'Test','Supplier_Contact__c','First_Name__c, Last_Name__c','','Id','1');
    Supplier_Page_Controller.getAllRecords();
    Supplier_Page_Controller.getData(fdatalst);
    Supplier_Page_Controller.getRecordsToDisplayClose(nc.id);
          
    }
    
    public static testMethod void testmethod1(){
    
    String matnum = '010000000123456789';
    String salesOrg = '1234';
    String distChan = '30';
    
    //User u = [select id, managerid from user where id = :userinfo.getuserid() limit 1];
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        //insert u;
    
    Account acc = new Account(Name='TestAcc',type = 'Distribution Customer',site = 'sitekhjkj');
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
    
    List<Opportunity> oppl = new List<Opportunity>();    
    Opportunity opp = new Opportunity();
    opp.Customer_Prospect__c = acc.id;
    opp.accountid = acc.id;
    opp.Name = 'Test Opp';
    opp.CloseDate=system.today();
    opp.Award_Start_Date__c=null;
    opp.StageName = '1. Prospect';
    opp.Type = 'New Business';
    opp.Contact__c= c.id; 
    opp.Requested_Supplier__c = nc.id;
    opp.Overview__c = 'testdata';
    opp.Annual_Usage__c = 24.23;
    insert opp;
    oppl.add(opp);
    
      
        
    Material_General_Data2__c mgd2 = new Material_General_Data2__c();
    mgd2.Material_Number__c = matnum;
    insert mgd2;
    
    List<Material_Sales_Data2__c> msdl = new List<Material_Sales_Data2__c>();
    Material_Sales_Data2__c msd2 = new Material_Sales_Data2__c();
    msd2.Material_Number__c = matnum;
    msd2.Material_Base_Code__c = 'testdata12';
    msd2.Material_Base_Code_Desc__c = 'testingdata12';
    msd2.PH4_Supplier__c = 'phdetails';
    msd2.Division_Desc__c = 'chemical';
    msd2.Sales_Org_Code__c = salesOrg;
    msd2.Dist_Channel_Code__c = distChan;
    msd2.Record_Key__c = matnum + salesOrg + distChan;
    msd2.Material_General_Data__c = mgd2.Id;
    insert msd2;
    msdl.add(msd2);
    
    List<String> id = new List<String>();  
    List<formData> fdatalst = new List<formData>(); 
    
    formData fdata = new formData();
    fdata.name='SearchBy';
    fdata.value='SupplierContact';
    fdatalst.add(fdata);    
    
    Supplier_Page_Controller spc = new Supplier_Page_Controller();
    Supplier_Page_Controller.getDateFormat();
    Supplier_Page_Controller.getRecordsToDisplaySupplier(nc.id);
    Supplier_Page_Controller.getRecordsToDisplayAttachment(nc.id);
    Supplier_Page_Controller.getRecordsToDisplaySupplierContact(nc.id);
    Supplier_Page_Controller.getRecordsToDisplaySampleMaterial(nc.id);    
    Supplier_Page_Controller.getSDSDocument(msd2.id,nc.id);
    Supplier_Page_Controller.getRecordsToDisplayEmail(nc.id);
    Supplier_Page_Controller.getRecordsToDisplay(nc.id);
    Supplier_Page_Controller.deleteDocuments();
    //Supplier_Page_Controller.getData(fdatalst);
    
    try{
   
    
    }catch(exception e){}
    
      
    }
 }