@isTest
public class incidentrecordTest {
public String Division='EH&S Manager';
//public String RecodeId; 
    public static testMethod void testMyController() {
       // PageReference pageRef = Page.success;
        //Test.setCurrentPage(pageRef);
        
            Site_Information__c SiteInfoInsert=new Site_Information__c(Name='Corporate Incident-New Corporate Incident');
            insert SiteInfoInsert;
            Incident_Record__c incidentData =new Incident_Record__c(ACC_PSI_Override__c='No',Incident_Date__c=Datetime.now(),Nexeo_Location_Associated_with_incident__c=SiteInfoInsert.id,Elements_associated_with_this_Incident__c='Multiple Fatalities (employees / contractors)',Classification_of_injury__c='Fatality',Equipment_Damage_Costs_due_to_Incident__c=5000,Material_Loss_Costs_due_to_incident__c=5000,Additional_Labor_Cost_due_to_Incident__c=5000,Cleanup_Treatment_Costs__c=5000,Penalty_Fines__c=5000,Costs_to_Repair_etc_Non_Ashland_Assets__c=5000,Workers_Comp_Costs_including_Reserved__c=5000);      
            insert incidentData;
            Incident_Record__c incidentData1 =new Incident_Record__c(ACC_PSI_Override__c='Yes',Incident_Date__c=Datetime.now(),Nexeo_Location_Associated_with_incident__c=SiteInfoInsert.id,Equipment_Damage_Costs_due_to_Incident__c=5000,Material_Loss_Costs_due_to_incident__c=5000,Additional_Labor_Cost_due_to_Incident__c=5000,Cleanup_Treatment_Costs__c=5000,Penalty_Fines__c=5000,Costs_to_Repair_etc_Non_Ashland_Assets__c=5000,Workers_Comp_Costs_including_Reserved__c=5000);      
            insert incidentData1;
            Incident_Approver__c incidentApprover1 = new Incident_Approver__c(Division__c='EH&S Manager Backups',Site_Information__c=SiteInfoInsert.id);
            insert incidentApprover1;
            Incident_Approver__c incidentApprover2 = new Incident_Approver__c(Division__c='EH&S Manager',Site_Information__c=SiteInfoInsert.id);
            insert incidentApprover2;
            Incident_Approver__c incidentApprover3 = new Incident_Approver__c(Division__c='Persons who translate/provide follow-up information',Site_Information__c=SiteInfoInsert.id);
            insert incidentApprover3;
            Incident_Approver__c incidentApprover4 = new Incident_Approver__c(Division__c='Persons who can perform Root Cause Analysis',Site_Information__c=SiteInfoInsert.id);
            insert incidentApprover4;
            Incident_Approver__c incidentApprover5 = new Incident_Approver__c(Division__c='Persons who can initiate a Reliability Incident',Site_Information__c=SiteInfoInsert.id);
            insert incidentApprover5;
            Incident_Approver__c incidentApprover6 = new Incident_Approver__c(Division__c='Persons who can finalize and/or close incidents',Site_Information__c=SiteInfoInsert.id);
            insert incidentApprover6;
            Incident_Approver__c incidentApprover7 = new Incident_Approver__c(Division__c='Site Distribution',Site_Information__c=SiteInfoInsert.id);
            insert incidentApprover7;
        
              
        ApexPages.currentPage().getParameters().put('id', incidentData.Id);
        incidentrecordApprovalExtension controller = new incidentrecordApprovalExtension ();
        string s = controller.toemailaddress;
        try{
        Id RecodeId=incidentData.Id; 
        incidentrecordApprovalExtension.getSendingEmail(s,'test',RecodeId);
        }catch(exception e){}
        ApexPages.StandardController sc = new ApexPages.StandardController(incidentData );
        incidentrecordApprovalExtension controller12 = new incidentrecordApprovalExtension (sc);
        
        IncidentreportForm controller1 = new IncidentreportForm ();
        //String nextPage = controller.save().getUrl();

        // Verify that page fails without parameters 
    
        //System.assertEquals('/apex/failure?error=noParam', nextPage);

        // Add parameters to page URL 
    
     
      
        // Instantiate a new controller with all parameters in the page 
        controller1.getDisplayECC();
        controller = new incidentrecordApprovalExtension (); 
        /*controller.toemailaddress('lastname');
        controller.setFirstName('firstname');
        controller.setCompany('acme');*/
        controller.getEHSManager();
        controller.getEHSManagerBackups();
        controller.getPersonswhotranslate();
        controller.getPersonswhotranslateName();
        controller.getinitiateReliabilityIncident();
        controller.getperformRootCauseAnalysis();
        controller.getperformRootCauseAnalysisName();
        controller.getfinalizecloseincidents();
        controller.getfinalizecloseincidentsName();
        controller.getSiteDistribution();
       // controller.getSendingEmail();
        controller.gettotal();
        controller.getlevel();
        
       
        ApexPages.currentPage().getParameters().put('id', incidentData1.Id);
        incidentrecordApprovalExtension controller4 = new incidentrecordApprovalExtension ();
        controller4.gettotal();
        controller4.getlevel();
        
       // nextPage = controller.save().getUrl();

        // Verify that the success page displays 
    
        //System.assertEquals('/apex/success', nextPage);
        //Lead[] leads = [select id, email from lead where Company = 'acme'];
        //System.assertEquals('firstlast@acme.com', leads[0].email);
    }
    }