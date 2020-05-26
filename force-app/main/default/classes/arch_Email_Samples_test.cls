@isTest

public class arch_Email_Samples_test{

    public static testMethod void testMe(){
    
        List<Opportunity_Call_Report__c> OcrList = new List<Opportunity_Call_Report__c>();
    
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
       // account acc = new account(name = 'test1234');
       // insert acc;
       // contact cnt = new contact(LastName = 'test',phone= '1234567890',Role__c = 'Accounting',No_Email__c = true);
       // insert cnt;
       // Nexeo_Competitor__c nc = new Nexeo_Competitor__c(name = 'test',Status__c='Active',RecordTypeid='012E0000000LH70');
         Id RecordTypeId = Schema.SObjectType.Nexeo_Competitor__c.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
         Nexeo_Competitor__c nc = new Nexeo_Competitor__c(name = 'test',Status__c='Active',RecordTypeid=RecordTypeId);
        insert nc;
        opportunity op = new opportunity(name = 'test 23390',CurrencyIsoCode = 'AUD',Requested_Supplier__c = nc.id,CloseDate = system.today(),StageName = 'Concept');
        insert op;
        Supplier_Contact__c scon = new Supplier_Contact__c(First_Name__c = 'test',Competitor_Supplier_or_OEM__c = nc.id);
        insert scon;
        Opportunity_Call_Report__c ocr = new Opportunity_Call_Report__c(Opportunity__c = op.id,Supplier_Contact__c = scon.id,Employee__c = u.id);
        OcrList.add(ocr);
        insert OcrList;
        
        
        try{
        string NoteId = OcrList[0].id;
        arch_Email_Samples aes = new arch_Email_Samples();
        aes.getMaterials();
        }
        catch(exception e){}
    }
 }