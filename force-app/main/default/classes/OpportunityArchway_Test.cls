@isTest
public class OpportunityArchway_Test{
    
    public static testMethod void testMe(){
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
   Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution Customer').getRecordTypeId();
   Account acc = new Account(Name = 'Test',RecordtypeId=RecordTypeId,SAP_Sales_Org__c = 'Test', SAP_DivisionCode__c = 'Test', SAP_Industry_Key__c ='Test',HQ_Sales_Office__c = 'Test', SAP_SalesGroup__c = 'Test');
   insert acc;
   
        //Account acc = new Account(Name='TestAcc',SAP_City__c='Bng',SAP_State__c='kar',SAP_Zip_Code__c='345678',Type='Prospect');
        //insert acc;
        contact c = new contact(Accountid = acc.id, firstname = 'Me', lastname = 'Myself', phone = '999-999-9999', buying_role__c='Designer', Role__c='Manager', No_Email__c = True);
        insert c;  
        c.buying_role__c='Designer2';
        c.Role__c='Manager';
        update c; 
        
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
        try{
        msd2.SalesOrg_Code__c = [select id from SAP_Sales_Org__c where Sales_Org_Code__c = '1000'limit 1].id;
        }catch(exception e){}
        insert msd2;
        
        Material_Base_Code__c base= new Material_Base_Code__c();
        base.Material_Base_Code_Description__c ='we113312';
        base.Material_Base_Code__c='12345';
        insert base;
        Map<String, Schema.RecordTypeInfo> RTMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();    

        Opportunity opp = new Opportunity();
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
        
        ApexPages.standardController sc = new ApexPages.standardcontroller(opp);
         OpportunityArchway op= new OpportunityArchway(sc);
         op.toggledisplayactionstaken();
         op.accountchanged();
         op.refreshcontact();
         op.getiscontactvalid();
         op.getOpportunity(opp.id);
         op.salesorder = 'test';
         op.subtitle='test1';
         op.isApprover = true;
         op.isSubmitted = true;
         op.displayrequestmoreinfoerror = true;
         try{
         op.createcontact();
         } catch(exception e){}
         op.selectedcontact='Old';
   
    }
    
     public static testMethod void testMe1(){
     Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
   Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution Customer').getRecordTypeId();
   Account acc = new Account(Name = 'Test',RecordtypeId=RecordTypeId,SAP_Sales_Org__c = 'Test', SAP_DivisionCode__c = 'Test', SAP_Industry_Key__c ='Test',HQ_Sales_Office__c = 'Test', SAP_SalesGroup__c = 'Test');
   insert acc;
   
        //Account acc = new Account(Name='TestAcc',SAP_City__c='Bng',SAP_State__c='kar',SAP_Zip_Code__c='345678',Type='Prospect');
        //insert acc;
        contact c = new contact(Accountid = acc.id, firstname = 'Me', lastname = 'Myself', phone = '999-999-9999', buying_role__c='Designer', Role__c='Manager', No_Email__c = True);
        insert c;  
        c.buying_role__c='Designer2';
        c.Role__c='Manager';
        update c; 
        
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
        //msd2.SalesOrg_Code__c = [select id from SAP_Sales_Org__c where Sales_Org_Code__c = '1000'limit 1].id;
        insert msd2;
        
        Material_Base_Code__c base= new Material_Base_Code__c();
        base.Material_Base_Code_Description__c ='we113312';
        base.Material_Base_Code__c='12345';
        insert base;
        Map<String, Schema.RecordTypeInfo> RTMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();    

        Opportunity opp = new Opportunity();
        opp.Customer_Prospect__c = acc.id;
        opp.accountid=acc.id;
        opp.RecordTypeId = RTMap.get('Distribution Chemicals').getrecordtypeid();
        opp.Name = 'Test Opp';
        opp.CloseDate=system.today();
        opp.Award_Start_Date__c=null;
        opp.StageName = '1. Prospect';
        opp.Type = 'New Business';
        opp.SAP_Material__c = msd2.id;  
        //opp.Contact__c= 'New'; 
        opp.Material_base_Code__c = base.id;
        opp.Won_Lost_Comments__c='wwewrerwerwe';  
        opp.Market__c = 'Aerospace';
        opp.Requested_Supplier_PL__c = 'test';
        List<Nexeo_Competitor__c> ReqSupplier = new List<Nexeo_Competitor__c>();

        insert opp;
        
        ApexPages.standardController sc = new ApexPages.standardcontroller(opp);
         OpportunityArchway op= new OpportunityArchway(sc);
         op.selectedcontact='New';
         op.toggledisplayactionstaken();
         op.accountchanged();
         op.refreshcontact();
         op.getOpportunity(opp.id);
   
    }
}