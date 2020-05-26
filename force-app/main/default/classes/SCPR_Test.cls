@isTest
public class SCPR_Test {
 static testMethod void TestMe() {
 
Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
        Account testAcct = new Account(Name='TestAccount');
        insert testAcct;
    
       // Id contractRecordTypeId = RecordType_Functions.LookupRecordTypeId('CDF','Contract');
        List<openactivity> oa = new List<openactivity>();
        List<activityhistory> ah = new List<activityhistory>();
        try {
        
            testAcct = [SELECT Id, Name,SAP_Industry_Key_Desc__c, SAP_Customer_Number__c, CIS_Prospect_Number__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_StreetSuppl3__c, 
                       SAP_City__c, SAP_State__c, SAP_Zip_Code__c, SAP_Country__c, OwnerID, Owner.Name, RecordTypeId, RecordType.Name, Type, SAP_Sales_Org__c, SAP_DivisionCode__c, 
                       (SELECT Id, Salutation, FirstName, LastName, WV_Contact_Status__c, Title, Phone, Fax, Email, OwnerId, Owner.Name, CreatedDate FROM Contacts ORDER BY LastName ASC, FirstName ASC, CreatedDate DESC),
                       //(SELECT Id, Subject, ActivityDate, Description, Status, Type, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Tasks ORDER BY ActivityDate DESC limit 100),
                       //(SELECT Id, StartDateTime, EndDateTime, ActivityDateTime, Subject, Description, Type, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Events WHERE IsChild = false ORDER BY StartDateTime DESC),
                       //(SELECT Id, Name, Amount, Probability, Competition__c, Target_Price__c, CloseDate, StageName, CurrencyIsoCode, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Opportunities ORDER BY CloseDate DESC),
                       (SELECT Id, Subject, OwnerId, Owner.Name, ActivityDate, Status, WhoId, Who.Name, WhatId, What.Name, Description from OpenActivities),
                       (SELECT Id, Subject, OwnerId, Owner.Name, ActivityDate, Status, WhoId, Who.Name, WhatId, What.Name, Description from ActivityHistories limit 100)
                       //(SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contracts WHERE RecordTypeId = '012300000000a6U' ORDER BY EndDate DESC),
                       //(SELECT Id, Name, Material_Summary__c , Material__r.Name, Status__c, CreatedDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM SampleRequest_to_Account__r WHERE Sample_State__c = 'Active'),
                       //(SELECT Id, Name, secondary_volume__c, description__c, product_group__c, SAP_Material__c, distribution_volume__c, comments__c, competitor_volume__c, container__c, current_supplier_producer_other__c, family__c, family_other__c,  offsite_waste_management__c, onsite_waste_Management__c, price__c, product_tradename__c, product_Type__c, Related_Account_Name__c, segment_Class__c, Source_Code__c, Source_description__c, sum_all_Volumes__c, technology_activity__c, Tons_Generated__c, Tons_Managed_Onsite__c, tons_managed_Offsite__c, type__c, waste_form_code__c, Waste_form_Description__c,  application__c, direct_volume__c, Material__c, Ashland_Material_in_Use__c, Status__c, CreatedDate, Annual_Usage_Volume__c, Product_Group_FAMILY__c, Market__c, Technology__c, Annual_Usage_T_Y__c,  distributor__c, Annual_Volume__c, Unit_of_Measure__c, Current_Supplier_Producer__c, channel_To_Market__c, base_code_Other__c, product_description__c, MFI__c, CreatedById, Distribution__c, of_Filler_Content_or_Comonomer__c, agent_area__c, CreatedBy.Name FROM Consumptions__r WHERE Status__c = 'Active' ORDER BY SAP_Material__r.name ),
                       //(SELECT Id, Name, CreatedById, CreatedBy.Name, Title__c, Reason_for_Visit__c, Date__c, Date_of_Call__c, Start_Date__c, End_Date__c, Discussion__C, purpose__c from CallReports__r),
                       //(Select id, ShipTo_Desc__c, Material__c, Ordered_Qty__c, Goods_Issue_Date2__c, Reason_Rejected_Code__c, Reason_Rejected_Desc__c, Requested_Delivery_Date2__c, Expected_Ship_Date2__c, Created_Date2__c, Customer_PO_Number__c, Sales_Order_Number__c, Ordered_Qty_in_LB__c, Unit_Price_per_LB__c, Plant_Desc__c from Open_Orders_ShipTo__r ORDER BY Expected_Ship_Date2__c DESC limit 225 ),
                       //(select id, Name, Customer_Name__r.name, Contract_Type__c, Effective_Date__c, Expiration_Date__c, Comments__c, Status__c from Business_Contracts__r)
                    FROM Account limit 1];
                   
        String accountid = testacct.id;      
        //Added by Annes on 21 oct 2011
/*        List<Task> lstTask=[SELECT Id, Subject, ActivityDate, Description, Status, Type, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Task where AccountId = :accountId ORDER BY ActivityDate DESC limit 100];
        
        List<Event> lstevent =[SELECT Id, StartDateTime, EndDateTime, ActivityDateTime, Subject, Description, Type, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Event WHERE IsChild = false and AccountId = :accountId ORDER BY StartDateTime DESC];
        List<Opportunity> lstopp= [SELECT Id, Name, Amount, Probability, Competition__c, Target_Price__c, CloseDate, StageName, CurrencyIsoCode, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Opportunity where AccountId = :accountId ORDER BY CloseDate DESC];
        List<Contract> lstcontract=[SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract WHERE AccountId = :accountId ORDER BY EndDate DESC];
        List<Sample_Request__c> lstsmplrqst=[SELECT Id, Name, Material_Summary__c , Material__r.Name, Status__c, CreatedDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Sample_Request__c WHERE Account__c = :accountId and Sample_State__c = 'Active'];
        //lstconsumption= [SELECT Id,Name,Material__c,Market__c,Product_Group_FAMILY__c,MFI__c,Product_Description__c,Description__c,Current_Supplier_Producer__c,Status__c,Annual_Usage_Volume__c,Technology__c,Product_Group__c,SAP_Material__c,Base_Code_Other__c,Distribution_Volume__c,Direct_Volume__c,Secondary_Volume__c,Annual_Volume__c,Unit_of_Measure__c,Distributor__c FROM Consumption__c WHERE Account_Name__c = :accountId and Status__c = 'Active' ORDER BY SAP_Material__r.name LIMIT 450];
        List<Consumption__c> lstconsumption = new List<consumption__c>();
        List<Call_Report__c> lstcallreport = [SELECT Id, Name, CreatedById, CreatedBy.Name, Title__c, Reason_for_Visit__c, Date__c, Date_of_Call__c, Start_Date__c, End_Date__c, Discussion__C, purpose__c from Call_Report__c where Account__c = :accountId];
        List<Open_Orders__c> lstopenorder= [Select id, ShipTo_Desc__c, Material__c, Ordered_Qty__c, Goods_Issue_Date2__c, Reason_Rejected_Code__c, Reason_Rejected_Desc__c, Requested_Delivery_Date2__c, Expected_Ship_Date2__c, Created_Date2__c, Customer_PO_Number__c, Sales_Order_Number__c, Ordered_Qty_in_LB__c, Unit_Price_per_LB__c, Plant_Desc__c from Open_Orders__c where ShipTo__c = :accountid ORDER BY Expected_Ship_Date2__c DESC limit 225];
        List<Business_Contract__c> lstbuscontract= [select id, Name, Customer_Name__r.name, Contract_Type__c, Effective_Date__c, Expiration_Date__c, Comments__c, Status__c from Business_Contract__c where Account_Owner__c = :accountid];
        //End Added by Annes      */      
                    
        } catch(Exception e) {}
        
        if (testAcct == null) {return;} 
        
        //apexpages.currentpage().getparameters().put('fid', '00lP0000000QrJC');
        Contact testContact = new Contact();
        testContact.FirstName= 'Chandra';
        testContact.Lastname = 'Test';
        testContact.WV_Contact_Status__c = 'Active';
        testContact.AccountId = testAcct.id;
        testContact.No_Email__c=false;
        testContact.Email='abc@gmail.com';
        insert testContact;
        
        Contact testContact2 = new Contact();
        testContact2.FirstName= 'Chandra';
        testContact2.Lastname = 'Last Name Test';
        testContact2.WV_Contact_Status__c = 'Inactive';
        testContact2.AccountId = testAcct.id;
        testContact2.No_Email__c=true;
        insert testContact2;

        Task testTask = new Task();
        testTask.Whatid = testAcct.Id;
        testTask.Type = 'Email';
        testTask.Description = 'Test';
        testTask.ActivityDate = System.today();
        insert testTask;

        Date Yesterday = System.today().addDays(-1);

        Task testTask2 = new Task();
        testTask2.Whatid = testAcct.Id;
        testTask2.Type = 'Email';
        testTask2.Description = 'Test';
        testTask2.ActivityDate = Yesterday;
        insert testTask2;

        Date Tomorrow = System.today().addDays(-1);

        Task testTask3 = new Task();
        testTask3.Whatid = testAcct.Id;
        testTask3.Type = 'Email';
        testTask3.Description = 'Test';
        testTask3.ActivityDate = Tomorrow;
        insert testTask3;

        Event testEvent = new Event();
        testEvent.Whatid = testAcct.Id;
        testEvent.Type = 'Email';
        testEvent.Total_Hours__c = 1;
        testEvent.DurationInMinutes = 59;
        testEvent.ActivityDateTime = DateTime.newInstance(System.today().year(),System.today().month(),System.today().day(), 0, 0, 0);
        testEvent.StartDateTime = DateTime.newInstance(System.today().year(),System.today().month(),System.today().day(), 0, 0, 0);
        testEvent.EndDateTime = DateTime.newInstance(System.today().year(),System.today().month(),System.today().day(), 0, 59, 0);
        testEvent.Description = 'Test';
        insert testEvent;
     
        Account_Sales_Summary__c testSalesSummary = new Account_Sales_Summary__c();
        testSalesSummary.Account__c = testAcct.Id; 
        testSalesSummary.Date_Range_Label__c = 'FYTD/PFYTD'; 
        testSalesSummary.Current_Fiscal_Beginning_Period__c = Date.parse('10/01/2017');
        testSalesSummary.Current_Fiscal_Ending_Period__c = Date.parse('10/01/2017');
        testSalesSummary.Current_Fiscal_Net_Revenue__c = 55935.42;
        testSalesSummary.Current_Fiscal_Quantity_KGs__c = 6702.0 ;
        testSalesSummary.Current_Fiscal_Quantity_LBs__c =   14776.0;
        testSalesSummary.Current_FYTD_Begin_Date__c =   Date.parse('10/01/2017');
        testSalesSummary.Current_FYTD_End_Date__c =     Date.parse('10/31/2017');
        testSalesSummary.Previous_Fiscal_Beginning_Period__c = Date.parse('10/01/2016');
        testSalesSummary.Previous_Fiscal_Ending_Period__c = Date.parse('10/01/2016');
        testSalesSummary.Previous_Fiscal_Net_Revenue__c =   2769767.5;
        testSalesSummary.Previous_Fiscal_Quantity_KGs__c =  636807.0;
        testSalesSummary.Previous_Fiscal_Quantity_LBs__c = 1403919.0;
        testSalesSummary.Previous_FYTD_Begin_Date__c = Date.parse('10/01/2016');
        testSalesSummary.Previous_FYTD_End_Date__c = Date.parse('10/31/2016');
        testSalesSummary.Sales_Org__c   = '1000';
        testSalesSummary.Key__c = '000013120810003031FYTD/PFYTD';
        insert testSalesSummary;
     
        
        ApexPages.StandardController sc = new ApexPages.StandardController(testAcct);
        SCPR cls = new SCPR(sc);
        cls.getAccount();
 
        cls.getContacts_Desc();           
        
        cls.getOpenActivities_Desc();
        
        cls.getCallReports_Desc();
        
        cls.getOppStage_Desc();
        cls.styleNumber(19.23);
        cls.styleNumber(3.14159);
        cls.styleNumber(4);
        cls.format_Amount(12.34,'test');
        
        cls.getCDFStatus_Desc();

        cls.toggleContacts_ShowInactive();
        cls.toggleOpenActivities_FullComments();
        cls.toggleCallReports_FullComments();
        cls.toggleCallReports_LimittoOwner();

        cls.getCallReports_Desc(); 
        cls.getCallReports();
      
 

        cls.toggleCallReports_LimittoOwner();
        
        List<SelectOption> testSelectOption1 = cls.getCallReports_LastXDays_items();
        
        List<SelectOption> testSelectOption2 = cls.getOpportunities_Stage_items();
        
        List<SelectOption> testSelectOption3 = cls.getOpenActivities_NextXDays_items();
        
        List<SelectOption> testSelectOption4 = cls.getStatus();
     
        cls.truncateValue('This is a commnet',  'CallReports');
        cls.truncateValue('This is a commnet with a lot of letters, this is really awesome, great people, good place, 2018', 'OpenActivities');
        cls.Activities_Desc();
        cls.getOpenOrder_Desc();
        cls.getOrderHistory_Desc();
        cls.getSampleRequest_Desc();
        cls.getCnct_Desc();
        cls.getClosedActivities_Desc();
        cls.backToAccount();
        cls.Printable_View();
        cls.reRenderSR();
        cls.reRendercon();
        cls.reRenderbuscon();
        cls.reRenderOA();
        cls.reRenderCA();
        cls.reRenderCL();
        cls.reRenderCR();
        cls.reRenderOpp();
        cls.reRenderOO();
        cls.reRenderCSP();
        cls.reRenderOH();
     
        List<SelectOption> testSelectOption5 = cls.getOpenOrders_NextXDays_items();
        List<SelectOption> testSelectOption6 = cls.getSampleRequest_LastXDays_items();
        List<SelectOption> testSelectOption7 = cls.getContactsActStat_items();
        List<SelectOption> testSelectOption8 = cls.getOpenActivities_NextXDays_items();
        List<SelectOption> testSelectOption9 = cls.getClosedActivities_NextXDays_items();
        List<SelectOption> testSelectOption10 = cls.getCall_Reports_LastXDays_items();
        List<SelectOption> testSelectOption11 = cls.getBusinessContracts_items();
        List<SelectOption> testSelectOption12 = cls.getOrderHistory_items();
     
        cls.countCSP = 4;
        cls.isCSP = true;
        
        cls.lstopenactivity = oa;
        cls.lstacthistory = ah;
        cls.volumeLBUp = false;
        cls.volumeLBDown= false;
        cls.volumeKGUp= false;
        cls.volumeKGDown= false;
        cls.AmountUp= false;
        cls.AmountDown= false;
        cls.Currncy = 'USD';
        cls.AmountDiff = 12.34;
        cls.CFYTD_Amount = 12.23;
        cls.PFYTD_Amount = 10.32;
        cls.CFYTD_VolumeKG= 3.14159;
        cls.CFYTD_VolumeLB= 3.14156;
        cls.PFYTD_VolumeKG= 3.14176;
        cls.PFYTD_VolumeLB= 3.14156;

        
        cls.getCSP_Desc();
        cls.toggleCall_Reports_LimittoOwner();
        cls.toggleClosedActivities_FullComments();
        cls.getAccountAddress();
        cls.getAccountDetailSection_Header();
        cls.getStatus();
        cls.determineAccountType();
        cls.getisCustomer();
        cls.getisProspect();
         
        cls.sortByName();
    
        
        cls.selectedStatus = 'Not Include';
        cls.sortByName();
        cls.filterByStatus();
        cls.selectedStatus = 'Draft';
        cls.sortByName();
        cls.filterByStatus();
        cls.selectedStatus = 'In Approval Process';
        cls.sortByName();
         cls.filterByStatus();
        cls.selectedStatus = 'Rejected';
        cls.sortByName();
        cls.filterByStatus();
        cls.selectedStatus = 'Activated';
        cls.sortByName();
        cls.filterByStatus();
        cls.selectedStatus = 'Expired/Canceled';
        cls.sortByName();
        cls.filterByStatus();
     
        cls.countName = 13;
     
        cls.selectedStatus = 'All';
        cls.sortByName();
        cls.filterByStatus();
        cls.countName = 15;
        cls.selectedStatus = 'Draft';
        cls.sortByName();
        cls.filterByStatus();
        cls.countName = 17;
        cls.selectedStatus = 'In Approval Process';
        cls.sortByName();
        cls.filterByStatus();
        cls.sortByStatus();
        cls.countName = 19;
        cls.selectedStatus = 'Rejected';
        cls.sortByName();
        cls.filterByStatus();
        cls.sortByStatus();
        cls.countName = 21;
        cls.selectedStatus = 'Activated';
        cls.sortByName();
        cls.filterByStatus();
        cls.sortByStatus();
        cls.countName = 23;
        cls.selectedStatus = 'Expired/Canceled';
        cls.sortByName();
        cls.filterByStatus();
     
        cls.sortByStatus();
        
        cls.getContactstoDisplay();
     
        cls.ContactsActStat = 'Active';
        cls.getContactstoDisplay();
     
        cls.ContactsActStat = 'Inactive';
        cls.getContactstoDisplay();
         
        cls.ContactsActStat = '5';
        cls.getContactstoDisplay();

     
        try{
        cls.getAccountTeam_items();
        }catch(exception e){}
        cls.getPRT_CSP_LastXDays_items();
        cls.getCall_Report_notes_LastXDays_items();
        try{
        cls.getCSPtoDisplay();
        }catch(exception e){}
        try{
        cls.getOrderHistorytoDisplay();
        }catch(exception e){}
        try{
        cls.refresh();
        }catch(exception e){}
        //Test.stopTest();
        
}
    
    static testMethod void TestMe2() {
    
Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
        Account testAcct = new Account(Name='TestAccount');
        insert testAcct;
        
        Opportunity opp = new Opportunity();
        opp.AccountId = testAcct.Id; 
        opp.StageName = 'Open';
        opp.Name = 'Great Opp';
        opp.CloseDate = Date.today().addDays(10);
        insert opp;
        
        Test.setCurrentPageReference(new PageReference('Page.SCPR')); 
        System.currentPageReference().getParameters().put('c_si', 'true');
        System.currentPageReference().getParameters().put('oa_fc', 'true');
        System.currentPageReference().getParameters().put('oa_nxd', 'true');
        System.currentPageReference().getParameters().put('cr_fc', 'true');

        System.currentPageReference().getParameters().put('cr_lxd', 'true');
        System.currentPageReference().getParameters().put('opp_stage', 'true');
        System.currentPageReference().getParameters().put('cr_lto', 'true');
        System.currentPageReference().getParameters().put('c_r_lto', 'true'); 
        System.currentPageReference().getParameters().put('Op_Order_NXdays', 'true');
        
        System.currentPageReference().getParameters().put('ca_fc', 'true');
        System.currentPageReference().getParameters().put('rn_sr', 'true');
        System.currentPageReference().getParameters().put('rn_OA', 'true');
        System.currentPageReference().getParameters().put('rn_CL', 'true'); 
        System.currentPageReference().getParameters().put('rn_OPP', 'true');
        
        System.currentPageReference().getParameters().put('rn_OO', 'true');
        System.currentPageReference().getParameters().put('rn_CSP', 'true');
        System.currentPageReference().getParameters().put('rn_con', 'true');
        
        System.currentPageReference().getParameters().put('rn_buscon', 'true');
        System.currentPageReference().getParameters().put('rn_OH', 'true');
        System.currentPageReference().getParameters().put('dwnld_exl', 'true');
        System.currentPageReference().getParameters().put('rn_CA', 'true');
  
        
        ApexPages.StandardController sc = new ApexPages.StandardController(testAcct);
        SCPR cls = new SCPR(sc);
        
             cls.getContacts_Count();
             cls.getOpportunities_Count();
             cls.getContracts_Count();
             cls.getInactiveContacts_Count();
             cls.getSample_Requests_Count();
             cls.getConsumption_Count();
             cls.getCallReports_Count();
             cls.getCall_Reports_Count();
            
            cls.Opportunities_Stage = 'All';
            cls.getOpportunities();
          
             cls.Opportunities_Stage = 'Open';
             cls.getOpportunities();
         
             cls.Opportunities_Stage = 'Hold';
             cls.getOpportunities();
         
             cls.Opportunities_Stage = 'Closed';
             cls.getOpportunities();  
         
             cls.Opportunities_Stage = 'None';
             cls.getOpportunities(); 
         
             cls.Opportunities_Stage = 'Not Include';
             cls.getOpportunities(); 
             cls.getCall_Reports();

    }
    
    static testMethod void TestMe3() {
    
Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
        Account testAcct = new Account(Name='TestAccount');
        insert testAcct;
                    
        Business_Contract__c businessContract = new Business_Contract__c();
        businessContract.Status__c = 'Activated';
        businessContract.Customer_Name__c = testAcct.Id;
        insert businessContract;
        
        Business_Contract__c businessContract2 = new Business_Contract__c();
        businessContract2.Status__c = 'Not Activated';
        businessContract2.Customer_Name__c = testAcct.Id;
        insert businessContract2;
        
        Sample_Request__c sampleRequest = new Sample_Request__c();
        sampleRequest.Account__c =  testAcct.Id;
        insert sampleRequest;
        
        Sample_Material__c sampleMaterial = new Sample_Material__c();
        sampleMaterial.Sample_Request__c = sampleRequest.Id;
        insert sampleMaterial;
                       
        
        ApexPages.StandardController sc = new ApexPages.StandardController(testAcct);
        SCPR cls = new SCPR(sc);
        
        cls.BusinessContracts = 'Not Include';
        cls.getBusContactstoDisplay();
          
        cls.BusinessContracts = 'Active';
        cls.getBusContactstoDisplay();
        
        cls.BusinessContracts = 'Inactive';
        cls.getBusContactstoDisplay();
        
        cls.SampleRequest_lastXdays = 'All';
        cls.getSampleRequest();
        
        cls.SampleRequest_lastXdays = 'Draft';
        cls.getSampleRequest();
            
        cls.SampleRequest_lastXdays = 'In Approval Process';
        cls.getSampleRequest();
            
        cls.SampleRequest_lastXdays = 'Approved';
        cls.getSampleRequest();
            
        cls.SampleRequest_lastXdays = 'Waiting for Order Creation';
        cls.getSampleRequest();
            
        cls.SampleRequest_lastXdays = 'Order Created for Sample Request';
        cls.getSampleRequest();
            
        cls.SampleRequest_lastXdays = 'Request Completed';
        cls.getSampleRequest();
            
        cls.SampleRequest_lastXdays = 'Rejected';
        cls.getSampleRequest();
         
    }   
    
    static testMethod void TestMe4() {
    
Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
        Account testAcct = new Account(Name='TestAccount');
        insert testAcct;
        
        Open_Orders__c openOrder = new Open_Orders__c();
        openOrder.ShipTo__c = testAcct.Id;
        openOrder.Key__c = '0003160273000020';
        openOrder.Line_Item_Number__c = '0020';
        openOrder.Sales_Order_Number__c = '0003160273';
        insert openOrder;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(testAcct);
        SCPR cls = new SCPR(sc);
        
        cls.OpenOrders_NextXDays = 'Not Include';
        cls.getOpenOrders();
        
        cls.OpenOrders_NextXDays = 'All Open';
        cls.getOpenOrders();
        
        cls.OpenOrders_NextXDays = '30';
        cls.getOpenOrders();
        
        cls.ContactsActStat = 'All';
        cls.getCnct_Desc();
            
        cls.ContactsActStat = 'Active';
        cls.getCnct_Desc();
            

            
    }
    
    
    static testMethod void TestMe5() {
    
Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
        Account testAcct = new Account(Name='TestAccount');
        insert testAcct;
         
        //lstPRT = [select id,Type__c,Name,SAP_Material__r.name,Price__c,Requested_Effective_Date__c,Requested_Expiration_Date__c,PLM__c,Approver__r.name from Price_Request_Transaction__c where Ship_To__c =: accountid];
        //
        Price_Request_Transaction__c prt = new Price_Request_Transaction__c();
        prt.Ship_To__c = testAcct.Id;
        prt.Type__C = 'CSP';
        insert prt;
        
        Price_Request_Transaction__c prt2 = new Price_Request_Transaction__c();
        prt2.Ship_To__c = testAcct.Id;
        insert prt2;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(testAcct);
        SCPR cls = new SCPR(sc);
        
        
        cls.getCSPtoDisplay();
        
        cls.ClosedActivities_NextXDays = 'Not Include';
        cls.getcloseActivities();
        
        cls.ClosedActivities_NextXDays = '30';
        cls.getcloseActivities();
        
        
        cls.getOpenActivities();
        
            
    }
}