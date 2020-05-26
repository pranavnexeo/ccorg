@isTest
Private class OpportunityExtensionArchway_Test{
static Opportunity opp;
    
    static testMethod void myUnitTest() {
       // test.starttest();
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
           try{     
        Account acc = new Account(Name='TestAcc',SAP_Sales_Office_Desc__c= 'ITALY',SAP_Sales_Group_Desc__c  = 'INSIDE',SAP_Sales_District_Desc__c='ADDITIVES',SAP_Division_Desc__c = 'Valvoline',SAP_City__c='Bng',SAP_State__c='kar',SAP_Zip_Code__c='345678',Type='Prospect',Approval_Status__c = 'Approved');
        insert acc;
        
        contact c = new contact(Accountid = acc.id, firstname = 'Me', lastname = 'Myself', phone = '999-999-9999', buying_role__c='Designer', Role__c='Manager', No_Email__c = True);
        insert c; 
        }
        catch(exception e){}
        Id RecordTypeId = Schema.SObjectType.Nexeo_Competitor__c.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
        Nexeo_Competitor__c nc = new Nexeo_Competitor__c(name = 'test',Status__c='Active',RecordTypeid=RecordTypeId);
        insert nc;
       // Nexeo_Competitor__c nc = new Nexeo_Competitor__c(name = 'test',Status__c='Active',RecordTypeid='012E0000000LH70');
       // insert nc;
        
       // opportunity op = new opportunity(name = 'Distribution Plastics',CurrencyIsoCode = 'AUD',Customer_Prospect__c = acc.id,Requested_Supplier__c = nc.id,Contact__c = c.id,CloseDate = system.today(),StageName = 'Concept');
       // insert op;
        
        Supplier_Contact__c scon = new Supplier_Contact__c(First_Name__c = 'test',Competitor_Supplier_or_OEM__c = nc.id);
        insert scon;
        
        
        
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
        
        insert msd2;
        
        Material_Base_Code__c base= new Material_Base_Code__c();
        base.Material_Base_Code_Description__c ='we113312';
        base.Material_Base_Code__c='12345';
        insert base;
        
        Map<String, Schema.RecordTypeInfo> RTMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();    

        opp = new Opportunity();
        //opp.Customer_Prospect__c = acc.id;
        //opp.accountid=acc.id;
        opp.RecordTypeId = RTMap.get('Distribution Chemicals').getrecordtypeid();
        opp.Name = 'Test Opp';
        opp.CloseDate=system.today();
        opp.Award_Start_Date__c=null;
        opp.StageName = '1. Prospect';
        opp.Type = 'New Business';
        opp.SAP_Material__c = msd2.id;  
        //opp.Contact__c= c.id; 
        opp.Material_base_Code__c = base.id;
        opp.Won_Lost_Comments__c='wwewrerwerwe';  
        opp.Market__c = 'Aerospace';
        opp.Requested_Supplier_PL__c = 'test';
        opp.Pricing_Approval_Status__c  = 'Approved';
        opp.Top_five_Opportunity__c = false;
        opp.Invalid_Duplicate__c = true;
        opp.Material_of_Interest__c = 'test12';
        opp.Opportunity_Owners_Business_Role__c = 'abc';
        opp.Probability = 30;
        opp.All_Sample_Materials__c = 'test test';
        opp.All_Call_Report_Notes__c = 'testing 123';
        List<Nexeo_Competitor__c> ReqSupplier = new List<Nexeo_Competitor__c>();
      //  try{
        insert opp;
       // }catch (exception e){
       // }
        
        Opportunity_Call_Report__c ocr = new Opportunity_Call_Report__c(Opportunity__c = opp.id,Supplier_Contact__c = scon.id,Employee__c = u.id);
        
        try{
        insert ocr;
        } catch(exception e){}
        
        SAP_Plant__c sp = new SAP_Plant__c(Street_Address__c = 'test',Carrier_Delivery_Hours_M_F__c ='test1');
        insert sp;
        
        Delivery_Cities__c dc = new Delivery_Cities__c(Wed__c= false,Fri__c = true,Mon__c= true,Thur__c= true,Tues__c= false,Freq__c= 'abc',SAP_Plant__c = sp.id,State__c = 'abc', Default_Plant__c = 'test2');
        insert dc;
        //test.stoptest();
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(opp);  
        test.starttest();
            
        OpportunityExtensionArchway OEA = new OpportunityExtensionArchway(sc);        
        ApexPages.currentPage().getParameters().put('churnid','test');
        OEA.fieldrequired();
        OEA.stagechanged();
        try{  
        OEA.Save();
        //OEA.cancel();
        } catch(exception e){}   
            
        test.stoptest();
    }
    static testMethod void myUnitTest1() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
            try{    
        Account acc = new Account(Name='TestAcc',SAP_Sales_Office_Desc__c= 'ITALY',SAP_Sales_Group_Desc__c  = 'INSIDE',SAP_Sales_District_Desc__c='ADDITIVES',SAP_Division_Desc__c = 'Valvoline',SAP_City__c='Bng',SAP_State__c='kar',SAP_Zip_Code__c='345678',Type='Prospect',Approval_Status__c = 'Approved');
        insert acc;
        
        contact c = new contact(Accountid = acc.id, firstname = 'Me', lastname = 'Myself', phone = '999-999-9999', buying_role__c='Designer', Role__c='Manager', No_Email__c = True);
        insert c; 
        }
        catch(exception e){}
       // Nexeo_Competitor__c nc = new Nexeo_Competitor__c(name = 'test',Status__c='Active',RecordTypeid='012E0000000LH70');
       // insert nc;
        
        Id RecordTypeId = Schema.SObjectType.Nexeo_Competitor__c.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
        Nexeo_Competitor__c nc = new Nexeo_Competitor__c(name = 'test',Status__c='Active',RecordTypeid=RecordTypeId);
        insert nc;
        
       // opportunity op = new opportunity(name = 'Distribution Plastics',CurrencyIsoCode = 'AUD',Customer_Prospect__c = acc.id,Requested_Supplier__c = nc.id,Contact__c = c.id,CloseDate = system.today(),StageName = 'Concept');
       // insert op;
        
        Supplier_Contact__c scon = new Supplier_Contact__c(First_Name__c = 'test',Competitor_Supplier_or_OEM__c = nc.id);
        insert scon;
        
        
        
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
        insert msd2;
        
        Material_Base_Code__c base= new Material_Base_Code__c();
        base.Material_Base_Code_Description__c ='we113312';
        base.Material_Base_Code__c='12345';
        insert base;
        
        Map<String, Schema.RecordTypeInfo> RTMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();    

        opp = new Opportunity();
        //opp.Customer_Prospect__c = acc.id;
       // opp.accountid=acc.id;
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
        opp.Pricing_Approval_Status__c  = 'Approved';
        opp.Top_five_Opportunity__c = false;
        opp.Invalid_Duplicate__c = true;
        opp.Material_of_Interest__c = 'test12';
        opp.Opportunity_Owners_Business_Role__c = 'abc';
        opp.Probability = 30;
        List<Nexeo_Competitor__c> ReqSupplier = new List<Nexeo_Competitor__c>();
        try{
        insert opp;
        }catch (exception e){
        }
        
        Opportunity_Call_Report__c ocr = new Opportunity_Call_Report__c(Opportunity__c = opp.id,Supplier_Contact__c = scon.id,Employee__c = u.id);
        insert ocr;
        
        SAP_Plant__c sp = new SAP_Plant__c(Street_Address__c = 'test',Carrier_Delivery_Hours_M_F__c ='test1');
        insert sp;
        
        Delivery_Cities__c dc = new Delivery_Cities__c(Wed__c= false,Fri__c = true,Mon__c= true,Thur__c= true,Tues__c= false,Freq__c= 'abc',SAP_Plant__c = sp.id,State__c = 'abc', Default_Plant__c = 'test2');
        insert dc;
        
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(opp);
        test.starttest();
        
        
        OpportunityExtensionArchway OEA = new OpportunityExtensionArchway(sc);
        ApexPages.currentPage().getParameters().put('churnid','test');
        OEA.cancel();
        //try{
        OEA.accountchanged();
        OEA.notreqd= true;
        OEA.quote = 'test';
        OEA.OEMId = 'test1';
        //}catch(exception e){}
        
        test.stoptest();
        }
        
        static testMethod void myUnitTest2() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
           try{     
        Account acc = new Account(Name='TestAcc',SAP_Sales_Office_Desc__c= 'ITALY',SAP_Sales_Group_Desc__c  = 'INSIDE',SAP_Sales_District_Desc__c='ADDITIVES',SAP_Division_Desc__c = 'Valvoline',SAP_City__c='Bng',SAP_State__c='kar',SAP_Zip_Code__c='345678',Type='Prospect',Approval_Status__c = 'Approved');
        insert acc;
        
        contact c = new contact(Accountid = acc.id, firstname = 'Me', lastname = 'Myself', phone = '999-999-9999', buying_role__c='Designer', Role__c='Manager', No_Email__c = True);
        insert c; 
        }
        catch(exception e){}
       // Nexeo_Competitor__c nc = new Nexeo_Competitor__c(name = 'test',Status__c='Active',RecordTypeid='012E0000000LH70');
       // insert nc;
       
        Id RecordTypeId = Schema.SObjectType.Nexeo_Competitor__c.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
        Nexeo_Competitor__c nc = new Nexeo_Competitor__c(name = 'test',Status__c='Active',RecordTypeid=RecordTypeId);
        insert nc;
        
        Supplier_Contact__c scon = new Supplier_Contact__c(First_Name__c = 'test',Competitor_Supplier_or_OEM__c = nc.id);
        insert scon;
                
        
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
        insert msd2;
        
        Material_Base_Code__c base= new Material_Base_Code__c();
        base.Material_Base_Code_Description__c ='we113312';
        base.Material_Base_Code__c='12345';
        insert base;
        
        Map<String, Schema.RecordTypeInfo> RTMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();    

        opp = new Opportunity();
        //opp.Customer_Prospect__c = acc.id;
        //opp.accountid=acc.id;
        opp.RecordTypeId = RTMap.get('Distribution Chemicals').getrecordtypeid();
        opp.Name = 'Test Opp';
        opp.CloseDate=system.today();
        opp.Award_Start_Date__c=null;
        opp.StageName = '1. Prospect';
        opp.Type = 'New Business';
        opp.SAP_Material__c = msd2.id;  
        //opp.Contact__c= c.id; 
        opp.Material_base_Code__c = base.id;
        opp.Won_Lost_Comments__c='wwewrerwerwe';  
        opp.Market__c = 'Aerospace';
        opp.Requested_Supplier_PL__c = 'test';
        opp.Pricing_Approval_Status__c  = 'Approved';
        opp.Top_five_Opportunity__c = false;
        opp.Invalid_Duplicate__c = true;
        opp.Material_of_Interest__c = 'test12';
        opp.Opportunity_Owners_Business_Role__c = 'abc';
        opp.Probability = 30;
        List<Nexeo_Competitor__c> ReqSupplier = new List<Nexeo_Competitor__c>();
        try{
        insert opp;
        }catch (exception e){
        }
        
        Opportunity_Call_Report__c ocr = new Opportunity_Call_Report__c(Opportunity__c = opp.id,Supplier_Contact__c = scon.id,Employee__c = u.id);
        insert ocr;
        
        SAP_Plant__c sp = new SAP_Plant__c(Street_Address__c = 'test',Carrier_Delivery_Hours_M_F__c ='test1');
        insert sp;
        
        Delivery_Cities__c dc = new Delivery_Cities__c(Wed__c= false,Fri__c = true,Mon__c= true,Thur__c= true,Tues__c= false,Freq__c= 'abc',SAP_Plant__c = sp.id,State__c = 'abc', Default_Plant__c = 'test2');
        insert dc;
        
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(opp);
        test.starttest();
        try{
        OpportunityExtensionArchway OEA = new OpportunityExtensionArchway(sc);
        ApexPages.currentPage().getParameters().put('churnid','test');
        OEA.getrenderplastics();
        OEA.getisplastics();
        OEA.getischemicals();
        OEA.getiscomposites();
        OEA.getOppId();
        OEA.getAccountId();
        OEA.getContactId();
        OEA.getAccountName();
        OEA.getMaterialId();
         //OEA.getSUBMITPRICING();
        OEA.getisstage1();
        OEA.getisstage2();
        OEA.getisstage3();
        OEA.getisstage4();
        OEA.getisclosed();
        OEA.getisquotevalue();
        }catch(exception e){}
         
        test.stoptest();
        }
}