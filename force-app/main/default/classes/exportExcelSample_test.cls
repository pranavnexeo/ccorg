@istest
public class exportExcelSample_test{
    public static testMethod void testdata(){  
    
   
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;

    
    Account acc = new Account(Name='TestAcc',type = 'Distribution Customer',site = 'sitekhjkj');
    insert acc;
    
    //Nexeo_Competitor__c nc = new Nexeo_Competitor__c(Technical_Service_Representative__c = u.id,Product_Specialist__c = u.id,Product_Line_Manager__c = u.id,Call_Report__c = true,Supplies_To__c = 'Chemicals',Competitor_or_Supplier__c = 'Supplier',name = 'test',Status__c='Active',RecordTypeid='012E0000000LH70');
    Id RecordTypeIdNexeoCompetitorCompetitor = Schema.SObjectType.Nexeo_Competitor__c.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
    Nexeo_Competitor__c nc = new Nexeo_Competitor__c(Technical_Service_Representative__c = u.id,Product_Specialist__c = u.id,Product_Line_Manager__c = u.id,Call_Report__c = true,Supplies_To__c = 'Chemicals',Competitor_or_Supplier__c = 'Supplier',name = 'test',Status__c='Active',RecordTypeid=RecordTypeIdNexeoCompetitorCompetitor);
    insert nc; 
    
    Opportunity opp = new Opportunity();
    opp.Customer_Prospect__c = acc.id;
    opp.accountid = acc.id;
    opp.Name = 'Test Opp';
    opp.CloseDate=system.today();
    opp.Award_Start_Date__c=null;
    opp.StageName = 'Closed';
    opp.Type = 'New Business';
    //opp.Contact__c= c.id; 
    opp.Requested_Supplier__c = nc.id;
    opp.Overview__c = 'testdata';
    opp.Annual_Usage__c = 24.23;
    insert opp;
    
    List<Sample_Request__c> srl = new List<Sample_Request__c>();
    Sample_Request__c SR = new Sample_Request__c(CreatedDate = system.today(),Account__c = acc.id,Opportunity__c = opp.id,Status__c = 'Approved',Supplier__c = nc.id);
    insert SR;
    srl.add(SR);
    List<Sample_Material__c> srlm = new List<Sample_Material__c>();
    Sample_Material__c SM = new Sample_Material__c(Sample_Request__c=SR.id);
    insert SM;
     srlm.add(Sm);
    
    
     apexpages.currentpage().getparameters().put('supid', nc.id);
    
    exportExcelSample ees = new exportExcelSample();
    try{
    ees.exportToExcelSample();
      }catch(exception e){}
      
    ees.isExcel = true;
    ees.isCsv  = true;
    
    exportExcelSample.wrapper ewrp = new exportExcelSample.wrapper();
    ewrp.Sampleid = 'sampid';
    ewrp.SampleName= 'Test';
    ewrp.SampleOpp = 'Pros';
    ewrp.SampleAccount = 'testacc';
    ewrp.OwnerName = 'david';
    ewrp.CreatedDate = 'today';  
    ewrp.Status = 'Test1';
    ewrp.Supplier = 'testsupp';
    
    }
}