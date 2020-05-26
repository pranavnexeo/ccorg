@isTest
public class OppArchwayChemicalsController_Test{
    
    public static testMethod void testMe(){
     test.starttest();
     try{
     Account acc = new Account(Name='TestAcc',SAP_City__c='Bng',SAP_State__c='kar',SAP_Zip_Code__c='345678',Type='Prospect');
        insert acc;
        
        contact c = new contact( firstname = 'Me', lastname = 'Myself', phone = '999-999-9999', buying_role__c='Designer', Role__c='Manager', No_Email__c = True);
        insert c;  
        c.buying_role__c='Designer2';
        c.Role__c='Manager';
        update c; 
        }
        catch(exception e){} 
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
      //  opp.Customer_Prospect__c = acc.id;
      //  opp.accountid=acc.id;
        opp.RecordTypeId = RTMap.get('Distribution Chemicals').getrecordtypeid();
        opp.Name = 'Test Opp';
        opp.CloseDate=system.today();
        opp.Award_Start_Date__c=null;
        opp.StageName = '1. Prospect';
        opp.Type = 'New Business';
        opp.SAP_Material__c = msd2.id;  
       // opp.Contact__c= c.id; 
        opp.Material_base_Code__c = base.id;
        opp.Won_Lost_Comments__c='wwewrerwerwe';  
        opp.Market__c = 'Aerospace';
        opp.Requested_Supplier_PL__c = 'test';
        List<Nexeo_Competitor__c> ReqSupplier = new List<Nexeo_Competitor__c>();
     
        insert opp;

        ApexPages.standardController sc = new ApexPages.standardcontroller(opp);
        OpportunityArchwayChemicalsController op= new OpportunityArchwayChemicalsController(sc);
        op.changeStageName();
        op.showPopup();
        op.Subtitle='Test Opp';
        op.firstSave = true;
        op.oppid = opp.id;
        
        try{
        op.createcontact();
        //op.Subtitle();
       // op.contacts.clear();
      // op.populateContact();
       }catch(exception e){}
       op.closePopup();
       op.customSave();
       op.contacts.clear();
      op.populateContact();
      // op.populateContact();
        op.makeTargetRequired();
       
    test.stoptest();
    
    }
    
    public static testMethod void testMe1(){
     test.starttest();
     try{
     Account acc = new Account(Name='TestAcc',SAP_City__c='Bng',SAP_State__c='kar',SAP_Zip_Code__c='345678',Type='Prospect');
        insert acc;
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
        opp.Contact__c= c.id; 
        opp.Material_base_Code__c = base.id;
        opp.Won_Lost_Comments__c='wwewrerwerwe';  
        opp.Market__c = 'Aerospace';
        opp.Requested_Supplier_PL__c = 'test';
        List<Nexeo_Competitor__c> ReqSupplier = new List<Nexeo_Competitor__c>();
     
        insert opp;

        ApexPages.standardController sc = new ApexPages.standardcontroller(opp);
        OpportunityArchwayChemicalsController op= new OpportunityArchwayChemicalsController(sc);
        //op.selectedcontact = 'test';
        //op.CloneRec = 'No';
        //op.oppCloned = opp;
        op.recTypeId = opp.recordtypeid;
       // op.customSave();
        
        }
        catch(exception e){}
    test.stoptest();
    
    }
    
        public static testMethod void testMe2(){
     test.starttest();
     try{
     Account acc = new Account(Name='TestAcc',SAP_City__c='Bng',SAP_State__c='kar',SAP_Zip_Code__c='345678',Type='Prospect');
        insert acc;
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
        opp.Contact__c= c.id; 
        opp.Material_base_Code__c = base.id;
        opp.Won_Lost_Comments__c='wwewrerwerwe';  
        opp.Market__c = 'Aerospace';
        opp.Requested_Supplier_PL__c = 'test';
        opp.Target__c = true;
        List<Nexeo_Competitor__c> ReqSupplier = new List<Nexeo_Competitor__c>();
     
        insert opp;

        ApexPages.standardController sc = new ApexPages.standardcontroller(opp);
        OpportunityArchwayChemicalsController op= new OpportunityArchwayChemicalsController(sc);
        op.selectedcontact = 'test';
        op.CloneRec = 'No';
        op.oppCloned = opp;
       // op.populateContact();
       // op.makeTargetRequired();
        //op.customSave();
       // op.closePopup();
        op.recTypeId = opp.recordtypeid;
        
        }
        catch(exception e){}
    test.stoptest();
    
    }
}