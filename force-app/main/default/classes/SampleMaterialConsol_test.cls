@isTest

public class SampleMaterialConsol_test{

    public static testMethod void testMe2(){
        test.starttest();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
        account acc = new account(name = 'test1234');
        insert acc;
        contact cnt = new contact(LastName = 'test',Account = acc,phone= '1234567890',Role__c = 'Accounting',No_Email__c = true);
        insert cnt;
        //Nexeo_Competitor__c nc = new Nexeo_Competitor__c(name = 'test',Status__c='Active',RecordTypeid='012E0000000LH70');
        Id RecordTypeId = Schema.SObjectType.Nexeo_Competitor__c.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
        Nexeo_Competitor__c nc = new Nexeo_Competitor__c(name = 'test',Status__c='Active',RecordTypeid=RecordTypeId);
        insert nc;
        opportunity op = new opportunity(name = 'Distribution Plastics',CurrencyIsoCode = 'AUD',Customer_Prospect__c = acc.id,Requested_Supplier__c = nc.id,Contact__c = cnt.id,CloseDate = system.today(),StageName = 'Concept');
        insert op;
        
        list<Material_Sales_Data2__c> matList = new List<Material_Sales_Data2__c>();
        Material_Sales_Data2__c mat = new Material_Sales_Data2__c(Material_Number__c = '0000001',Name = 'Material-1',Dist_Channel_Code__c = '30',Record_Key__c = '0000001',Sales_Org_Code__c = '1000');
        matList.add(mat);
        Material_Sales_Data2__c mat1 = new Material_Sales_Data2__c(Material_Number__c = '0000002',Name = 'Material-2',Dist_Channel_Code__c = '30',Record_Key__c = '0000002',Sales_Org_Code__c = '1000');
        matList.add(mat1);
        insert matlist;
        Sample_Request__c sr = new Sample_Request__c(Account__c=acc.id,Opportunity__c=op.id);
        insert sr;
        List<Sample_Material__c> sm = new List<Sample_Material__c>();
        Sample_Material__c sme = new Sample_Material__c(name='test',Opportunity__c=op.id,SAP_Material_MSD2__c=matlist[0].id,Sample_Request__c=sr.id,Material_Status__c='Qualified');
        sm.add(sme);
        Sample_Material__c sme1 = new Sample_Material__c(name='test1',Opportunity__c=op.id,SAP_Material_MSD2__c=matlist[1].id,Sample_Request__c=sr.id);
        sm.add(sme1);
        insert sm;
        
        delete sm[1];
        test.stoptest();
    }
    
     public static testMethod void testMe(){
        test.starttest();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
        account acc = new account(name = 'test1234');
        insert acc;
        contact cnt = new contact(LastName = 'test',Account = acc,phone= '1234567890',Role__c = 'Accounting',No_Email__c = true);
        insert cnt;
        //Nexeo_Competitor__c nc = new Nexeo_Competitor__c(name = 'test',Status__c='Active',RecordTypeid='012E0000000LH70');
        Id RecordTypeId = Schema.SObjectType.Nexeo_Competitor__c.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
        Nexeo_Competitor__c nc = new Nexeo_Competitor__c(name = 'test',Status__c='Active',RecordTypeid=RecordTypeId);
        insert nc;
        opportunity op = new opportunity(name = 'Distribution Plastics',CurrencyIsoCode = 'AUD',Customer_Prospect__c = acc.id,Requested_Supplier__c = nc.id,Contact__c = cnt.id,CloseDate = system.today(),StageName = 'Concept');
        insert op;
        
        Material_Sales_Data2__c mat = new Material_Sales_Data2__c(Material_Number__c = '0000001',Name = 'Material-1',Dist_Channel_Code__c = '30',Record_Key__c = '0000001',Sales_Org_Code__c = '1000');
        
        insert mat;
        Sample_Request__c sr = new Sample_Request__c(Account__c=acc.id,Opportunity__c=op.id);
        insert sr;
        
        Sample_Material__c sme = new Sample_Material__c(name='test',Opportunity__c=op.id,SAP_Material_MSD2__c=mat.id,Sample_Request__c=sr.id,Material_Status__c='');
        
        insert sme;
        
        delete sme;
        test.stoptest();
    }
}