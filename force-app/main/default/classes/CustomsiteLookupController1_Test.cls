@isTest

public class CustomsiteLookupController1_Test{

      public static testMethod void testMe(){
       Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
                 TimeZoneSidKey='America/Los_Angeles', UserName='hjvvbvh@gorg.com', IsActive = true);
        insert u;
        
      Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution Customer').getRecordTypeId();
   Account acc = new Account(Name = 'Test',RecordtypeId=RecordTypeId,SAP_Sales_Org__c = 'Test', SAP_DivisionCode__c = 'Test', SAP_Industry_Key__c ='Test',HQ_Sales_Office__c = 'Test', SAP_SalesGroup__c = 'Test');
   insert acc;
              
     // account acc = new Account(Name='TestAcc*',Type='Prospect',SAP_Division_Desc__c='Nexeo Chem');
        //insert acc;  
       
        
        Site_Information__c si = new Site_Information__c (EH_S_Manager__c = u.id,Include_in_monthly_plant_hour_report__c = 'Yes', Reporting_Location__c = 'adxvgfd', Site_Departments__c = 'Office',Site_Shifts__c = 'asfd');
        insert si;
        
        Incident_Approver__c ia = new Incident_Approver__c(Division__c = 'Relibility Contact Name',Relibility_Contact_Name__c = 'Yes',Person_Responsible_for_Root_Cause__c = 'Yes',Report_Plan_Approver__c = 'Yes',Select_Person_For_Follow_Up__c = 'Yes',Approver__c = u.id,Site_Information__c = si.id);
        insert ia;
        
        Incident_Record__c ir = new Incident_Record__c(ACC_PSI_Override__c = 'Yes',Additional_Information_to_be_supplied__c= 'Yes',Any_Violations_Nonconformance_Alleged__c = 'ashg',Incident_Date__c = date.today(),Nexeo_Location_Associated_with_incident__c = si.id);
        insert ir;
        
         PageReference pageRef = Page.customlookupforsiteinfo;
         Test.setCurrentPage(pageRef);
         apexpages.currentpage().getparameters().put('siteid',si.id);
         apexpages.currentpage().getparameters().put('txt','PersonswhocanperformRootCause');
         apexpages.currentpage().getparameters().put('sitename','test');
         //ApexPages.standardcontroller sc = new ApexPages.standardcontroller();
         //CustomsiteLookupController1 CR = new CustomsiteLookupController1(sc);
         ApexPages.standardcontroller sc = new ApexPages.standardcontroller(ir);
         
         CustomsiteLookupController1 CR = new CustomsiteLookupController1(sc);
         CR.searchString = 'test';
         //apexpages.currentpage().getparameters().put('lksrch',acc.Name);
         apexpages.currentpage().getparameters().put('siteid',si.id);
         cr.searchString =acc.Name;    
         pagereference pr = cr.search();
         cr.getFormTag();
         cr.getTextBox();
   }
       public static testMethod void testMe2(){
       Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
                 TimeZoneSidKey='America/Los_Angeles', UserName='hjvvbvh@gorg.com', IsActive = true);
        insert u;
        
       Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution Customer').getRecordTypeId();
   Account acc = new Account(Name = 'Test',RecordtypeId=RecordTypeId,SAP_Sales_Org__c = 'Test', SAP_DivisionCode__c = 'Test', SAP_Industry_Key__c ='Test',HQ_Sales_Office__c = 'Test', SAP_SalesGroup__c = 'Test');
   insert acc;
              
     // account acc = new Account(Name='TestAcc*',Type='Prospect',SAP_Division_Desc__c='Nexeo Chem');
       // insert acc;  
         
        Site_Information__c si = new Site_Information__c (EH_S_Manager__c = u.id,Include_in_monthly_plant_hour_report__c = 'Yes', Reporting_Location__c = 'adxvgfd', Site_Departments__c = 'Office',Site_Shifts__c = 'asfd');
        insert si;
        
        Incident_Approver__c ia = new Incident_Approver__c(Division__c = 'Relibility Contact Name',Relibility_Contact_Name__c = 'Yes',Person_Responsible_for_Root_Cause__c = 'Yes',Report_Plan_Approver__c = 'Yes',Select_Person_For_Follow_Up__c = 'Yes',Approver__c = u.id,Site_Information__c = si.id);
        insert ia;
        
        Incident_Record__c ir = new Incident_Record__c(ACC_PSI_Override__c = 'Yes',Additional_Information_to_be_supplied__c= 'Yes',Any_Violations_Nonconformance_Alleged__c = 'ashg',Incident_Date__c = date.today(),Nexeo_Location_Associated_with_incident__c = si.id);
        insert ir;
        
         PageReference pageRef = Page.customlookupforsiteinfo;
         Test.setCurrentPage(pageRef);
         apexpages.currentpage().getparameters().put('siteid',si.id);
         apexpages.currentpage().getparameters().put('txt','Personswhocanfinalize');
         apexpages.currentpage().getparameters().put('sitename','test');
         ApexPages.standardcontroller sc = new ApexPages.standardcontroller(ir);
         
         CustomsiteLookupController1 CR = new CustomsiteLookupController1(sc);
         CR.searchString = 'test';
         //apexpages.currentpage().getparameters().put('lksrch',acc.Name);
         apexpages.currentpage().getparameters().put('siteid',si.id);
         cr.searchString =acc.Name;    
         pagereference pr = cr.search();
         cr.getFormTag();
         cr.getTextBox();
   }
   public static testMethod void testMe3(){
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
                 TimeZoneSidKey='America/Los_Angeles', UserName='hjvvbvh@gorg.com', IsActive = true);
        insert u;
   Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution Customer').getRecordTypeId();
   Account acc = new Account(Name = 'Test',RecordtypeId=RecordTypeId,SAP_Sales_Org__c = 'Test', SAP_DivisionCode__c = 'Test', SAP_Industry_Key__c ='Test',HQ_Sales_Office__c = 'Test', SAP_SalesGroup__c = 'Test');
   insert acc;
              
      //account acc = new Account(Name='TestAcc*',Type='Prospect',SAP_Division_Desc__c='Nexeo Chem');
        //insert acc;  
      
        Site_Information__c si = new Site_Information__c (EH_S_Manager__c = u.id,Include_in_monthly_plant_hour_report__c = 'Yes', Reporting_Location__c = 'adxvgfd', Site_Departments__c = 'Office',Site_Shifts__c = 'asfd');
        insert si;
        
        Incident_Approver__c ia = new Incident_Approver__c(Division__c = 'Relibility Contact Name',Relibility_Contact_Name__c = 'Yes',Person_Responsible_for_Root_Cause__c = 'Yes',Report_Plan_Approver__c = 'Yes',Select_Person_For_Follow_Up__c = 'Yes',Approver__c = u.id,Site_Information__c = si.id);
        insert ia;
        
        Incident_Record__c ir = new Incident_Record__c(ACC_PSI_Override__c = 'Yes',Additional_Information_to_be_supplied__c= 'Yes',Any_Violations_Nonconformance_Alleged__c = 'ashg',Incident_Date__c = date.today(),Nexeo_Location_Associated_with_incident__c = si.id);
        insert ir;
        
         PageReference pageRef = Page.customlookupforsiteinfo;
         Test.setCurrentPage(pageRef);
         apexpages.currentpage().getparameters().put('siteid',si.id);
         apexpages.currentpage().getparameters().put('txt','PersonswhocaninitiateaReliability');
         apexpages.currentpage().getparameters().put('sitename','test');
         ApexPages.standardcontroller sc = new ApexPages.standardcontroller(ir);
         
         CustomsiteLookupController1 CR = new CustomsiteLookupController1(sc);
         CR.searchString = 'test';
         //apexpages.currentpage().getparameters().put('lksrch',acc.Name);
         apexpages.currentpage().getparameters().put('siteid',si.id);
         cr.searchString =acc.Name;    
         pagereference pr = cr.search();
         cr.getFormTag();
         cr.getTextBox();
   }
   public static testMethod void testMe4(){
   Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
                 TimeZoneSidKey='America/Los_Angeles', UserName='hjvvbvh@gorg.com', IsActive = true);
        insert u;
   Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution Customer').getRecordTypeId();
   Account acc = new Account(Name = 'Test',RecordtypeId=RecordTypeId,SAP_Sales_Org__c = 'Test', SAP_DivisionCode__c = 'Test', SAP_Industry_Key__c ='Test',HQ_Sales_Office__c = 'Test', SAP_SalesGroup__c = 'Test');
   insert acc;
              
     // account acc = new Account(Name='TestAcc*',Type='Prospect',SAP_Division_Desc__c='Nexeo Chem');
        //insert acc;  
        
        Site_Information__c si = new Site_Information__c (EH_S_Manager__c = u.id,Include_in_monthly_plant_hour_report__c = 'Yes', Reporting_Location__c = 'adxvgfd', Site_Departments__c = 'Office',Site_Shifts__c = 'asfd');
        insert si;
        
        Incident_Approver__c ia = new Incident_Approver__c(Division__c = 'Relibility Contact Name',Relibility_Contact_Name__c = 'Yes',Person_Responsible_for_Root_Cause__c = 'Yes',Report_Plan_Approver__c = 'Yes',Select_Person_For_Follow_Up__c = 'Yes',Approver__c = u.id,Site_Information__c = si.id);
        insert ia;
        
        Incident_Record__c ir = new Incident_Record__c(ACC_PSI_Override__c = 'Yes',Additional_Information_to_be_supplied__c= 'Yes',Any_Violations_Nonconformance_Alleged__c = 'ashg',Incident_Date__c = date.today(),Nexeo_Location_Associated_with_incident__c = si.id);
        insert ir;
        
         PageReference pageRef = Page.customlookupforsiteinfo;
         Test.setCurrentPage(pageRef);
         apexpages.currentpage().getparameters().put('siteid',si.id);
         apexpages.currentpage().getparameters().put('txt','Personswhocaninitiatetranslateprovide');
         apexpages.currentpage().getparameters().put('sitename','test');
         ApexPages.standardcontroller sc = new ApexPages.standardcontroller(ir);
         
         CustomsiteLookupController1 CR = new CustomsiteLookupController1(sc);
         CR.searchString = 'test';
         //apexpages.currentpage().getparameters().put('lksrch',acc.Name);
         apexpages.currentpage().getparameters().put('siteid',si.id);
         cr.searchString =acc.Name;    
         pagereference pr = cr.search();
         cr.getFormTag();
         cr.getTextBox();
   }
   public static testMethod void testMe5(){
   Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
                 TimeZoneSidKey='America/Los_Angeles', UserName='hjvvbvh@gorg.com', IsActive = true);
        insert u;
   
       Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution Customer').getRecordTypeId();
   Account acc = new Account(Name = 'Test',RecordtypeId=RecordTypeId,SAP_Sales_Org__c = 'Test', SAP_DivisionCode__c = 'Test', SAP_Industry_Key__c ='Test',HQ_Sales_Office__c = 'Test', SAP_SalesGroup__c = 'Test');
   insert acc;       
      //account acc = new Account(Name='TestAcc*',Type='Prospect',SAP_Division_Desc__c='Nexeo Chem');
       // insert acc;  
        
        Site_Information__c si = new Site_Information__c (EH_S_Manager__c = u.id,Include_in_monthly_plant_hour_report__c = 'Yes', Reporting_Location__c = 'adxvgfd', Site_Departments__c = 'Office',Site_Shifts__c = 'asfd');
        insert si;
        
        Incident_Approver__c ia = new Incident_Approver__c(Division__c = 'Relibility Contact Name',Relibility_Contact_Name__c = 'Yes',Person_Responsible_for_Root_Cause__c = 'Yes',Report_Plan_Approver__c = 'Yes',Select_Person_For_Follow_Up__c = 'Yes',Approver__c = u.id,Site_Information__c = si.id);
        insert ia;
        
        Incident_Record__c ir = new Incident_Record__c(ACC_PSI_Override__c = 'Yes',Additional_Information_to_be_supplied__c= 'Yes',Any_Violations_Nonconformance_Alleged__c = 'ashg',Incident_Date__c = date.today(),Nexeo_Location_Associated_with_incident__c = si.id);
        insert ir;
        
         PageReference pageRef = Page.customlookupforsiteinfo;
         Test.setCurrentPage(pageRef);
         apexpages.currentpage().getparameters().put('siteid',si.id);
         apexpages.currentpage().getparameters().put('txt','PersonswhocanperformRootCause');
         apexpages.currentpage().getparameters().put('sitename','test');
         //ApexPages.standardcontroller sc = new ApexPages.standardcontroller();
         //CustomsiteLookupController1 CR = new CustomsiteLookupController1(sc);
         ApexPages.standardcontroller sc = new ApexPages.standardcontroller(ir);
         
         CustomsiteLookupController1 CR = new CustomsiteLookupController1();
         CR.searchString = 'test';
         //apexpages.currentpage().getparameters().put('lksrch',acc.Name);
         apexpages.currentpage().getparameters().put('siteid',si.id);
         cr.searchString =acc.Name;    
         pagereference pr = cr.search();
         cr.getFormTag();
         cr.getTextBox();
   }
   
}