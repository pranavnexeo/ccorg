@isTest
public class monthlyPlantHoursControllerTest{
public String Division='EH&S Manager';
static monthlyPlantHoursController ext;
//public String RecodeId; 
    public static testMethod void monthlyPlantHoursControllerTest() {
              
           
           Reporting_Category_Record__c rtr=new Reporting_Category_Record__c(Category__c='NA Southeast Region  ',Divisions__c='Nexeo Solutions',Groups__c='Supply Chain');
           insert rtr;    
            Site_Information__c  si= new Site_Information__c(Name='Test',Reporting_Category__c=rtr.id,Site_Departments__c='Office;Material Handler;Driver',Site_Areas__c='Public Roadways');
            insert si;
       Site_Information__c SiteInfoInsert=new Site_Information__c(Name='Corporate Incident-New Corporate Incident');
            insert SiteInfoInsert;
            Incident_Record__c incidentData =new Incident_Record__c(ACC_PSI_Override__c='No',Incident_Date__c=Datetime.now(),Nexeo_Location_Associated_with_incident__c=SiteInfoInsert.id,Elements_associated_with_this_Incident__c='Multiple Fatalities (employees / contractors)',Classification_of_injury__c='Fatality',Equipment_Damage_Costs_due_to_Incident__c=5000,Material_Loss_Costs_due_to_incident__c=5000,Additional_Labor_Cost_due_to_Incident__c=5000,Cleanup_Treatment_Costs__c=5000,Penalty_Fines__c=5000,Costs_to_Repair_etc_Non_Ashland_Assets__c=5000,Workers_Comp_Costs_including_Reserved__c=5000);      
            insert incidentData;
            Incident_Record__c incidentData1 =new Incident_Record__c(ACC_PSI_Override__c='Yes',Incident_Date__c=Datetime.now(),Nexeo_Location_Associated_with_incident__c=SiteInfoInsert.id,Equipment_Damage_Costs_due_to_Incident__c=5000,Material_Loss_Costs_due_to_incident__c=5000,Additional_Labor_Cost_due_to_Incident__c=5000,Cleanup_Treatment_Costs__c=5000,Penalty_Fines__c=5000,Costs_to_Repair_etc_Non_Ashland_Assets__c=5000,Workers_Comp_Costs_including_Reserved__c=5000,Classification_of_injury__c='Fatality');      
            insert incidentData1;
            
            Incident_Record__c incidentData2 =new Incident_Record__c(ACC_PSI_Override__c='Yes',Incident_Date__c=Datetime.now(),Nexeo_Location_Associated_with_incident__c=SiteInfoInsert.id,Equipment_Damage_Costs_due_to_Incident__c=5000,Material_Loss_Costs_due_to_incident__c=5000,Additional_Labor_Cost_due_to_Incident__c=5000,Cleanup_Treatment_Costs__c=5000,Penalty_Fines__c=5000,Costs_to_Repair_etc_Non_Ashland_Assets__c=5000,Workers_Comp_Costs_including_Reserved__c=5000,Classification_of_injury__c='Days Away from Work');      
            insert incidentData2;
            
            Incident_Record__c incidentData3 =new Incident_Record__c(ACC_PSI_Override__c='Yes',Incident_Date__c=Datetime.now(),Nexeo_Location_Associated_with_incident__c=SiteInfoInsert.id,Equipment_Damage_Costs_due_to_Incident__c=5000,Material_Loss_Costs_due_to_incident__c=5000,Additional_Labor_Cost_due_to_Incident__c=5000,Cleanup_Treatment_Costs__c=5000,Penalty_Fines__c=5000,Costs_to_Repair_etc_Non_Ashland_Assets__c=5000,Workers_Comp_Costs_including_Reserved__c=5000,Classification_of_injury__c='Medical Treatment beyond First Aid');      
            insert incidentData3;
            
            Incident_Record__c incidentData5 =new Incident_Record__c(ACC_PSI_Override__c='Yes',Incident_Date__c=Datetime.now(),Nexeo_Location_Associated_with_incident__c=SiteInfoInsert.id,Equipment_Damage_Costs_due_to_Incident__c=5000,Material_Loss_Costs_due_to_incident__c=5000,Additional_Labor_Cost_due_to_Incident__c=5000,Cleanup_Treatment_Costs__c=5000,Penalty_Fines__c=5000,Costs_to_Repair_etc_Non_Ashland_Assets__c=5000,Workers_Comp_Costs_including_Reserved__c=5000,Classification_of_injury__c='Restricted Work');      
            insert incidentData5;
            
             Incident_Record__c incidentData6 =new Incident_Record__c(ACC_PSI_Override__c='Yes',Incident_Date__c=Datetime.now(),Nexeo_Location_Associated_with_incident__c=SiteInfoInsert.id,Equipment_Damage_Costs_due_to_Incident__c=5000,Material_Loss_Costs_due_to_incident__c=5000,Additional_Labor_Cost_due_to_Incident__c=5000,Cleanup_Treatment_Costs__c=5000,Penalty_Fines__c=5000,Costs_to_Repair_etc_Non_Ashland_Assets__c=5000,Workers_Comp_Costs_including_Reserved__c=5000,Classification_of_injury__c='Off the job'); 
       
            insert incidentData6;
            
             Incident_Record__c incidentData4 =new Incident_Record__c(ACC_PSI_Override__c='Yes',Incident_Date__c=Datetime.now(),Nexeo_Location_Associated_with_incident__c=SiteInfoInsert.id,Equipment_Damage_Costs_due_to_Incident__c=5000,Material_Loss_Costs_due_to_incident__c=5000,Additional_Labor_Cost_due_to_Incident__c=5000,Cleanup_Treatment_Costs__c=5000,Penalty_Fines__c=5000,Costs_to_Repair_etc_Non_Ashland_Assets__c=5000,Workers_Comp_Costs_including_Reserved__c=5000,Classification_of_injury__c='Injury/Illness/Just Reporting');      
            insert incidentData4;
            
            Monthly_Plant_Hour__c mph=new Monthly_Plant_Hour__c(Reporting_Month__c='12',Man_hours__c=12,Reporting_Year__c='2012',Employee__c=10,Facility__c=si.id);
            insert mph;
            
            monthlyPlantHoursController con=new monthlyPlantHoursController();
            ApexPages.StandardController con1 = new ApexPages.StandardController(mph);
            con.ReportingMonth = 'test';
            con.ReportingYear = 'test1';
            con.RM = 'test2';
            con.RY = 'test3';
            con.getreportmonth();
            ext = new monthlyPlantHoursController(con1);
            con.getfacility();
            con.getreportyear();
            con.Incedentnumber();
            ext.Fatalitynumber();
            ext.Daysawayfromworknumber();
             ext.Medicalnumber();
             ext.Lostworknumber();
            ext.Employeenumber();
            ext.Employeepercent();
             ext.getCountry();
             ext.getState();
            ext.saveCustom();
    }
    }