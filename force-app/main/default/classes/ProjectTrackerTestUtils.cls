@isTest
public with sharing class ProjectTrackerTestUtils {
    
    /**
	* Initialize test data and return a map of objects created
	*
	* @return Map of inserted objects
	*/
    public static Map<String, SObject> initData() { 
     	Map<String,SObject> resultMap = new Map<String,SObject>();
        //In order to prevent using hardcode ID
        Id RecordTypeIdProject = Schema.SObjectType.ART_Project__c.getRecordTypeInfosByName().get('Project').getRecordTypeId();
        Id RecordTypeIdWorkstream = Schema.SObjectType.ART_Project__c.getRecordTypeInfosByName().get('Workstream').getRecordTypeId();
        Id RecordTypeIdEnhancement = Schema.SObjectType.Enhancement__c.getRecordTypeInfosByName().get('Enhancement').getRecordTypeId();
        Id RecordTypeIdMaintenance = Schema.SObjectType.Enhancement__c.getRecordTypeInfosByName().get('Maintenance').getRecordTypeId();
        Id RecordTypeIdFDREnhancement = Schema.SObjectType.Functional_Design_Registration__c.getRecordTypeInfosByName().get('Enhancement').getRecordTypeId();
        Id RecordTypeIdFDRMaintenance = Schema.SObjectType.Functional_Design_Registration__c.getRecordTypeInfosByName().get('Maintenance').getRecordTypeId();
        Id RecordTypeIdFDRPS = Schema.SObjectType.Functional_Design_Registration__c.getRecordTypeInfosByName().get('Production Support').getRecordTypeId();
        
        Id RecordTypeIdWIQEnhancement = Schema.SObjectType.Work_Item__c.getRecordTypeInfosByName().get('Enhancement').getRecordTypeId();
        Id RecordTypeIdWIQMaintenance = Schema.SObjectType.Work_Item__c.getRecordTypeInfosByName().get('Maintenance').getRecordTypeId();
        Id RecordTypeIdWIQPS = Schema.SObjectType.Work_Item__c.getRecordTypeInfosByName().get('Production Support').getRecordTypeId();
        
       // List<SObject> customObjectIdList = [SELECT CustomObjectId FROM CustomObjectUserLicenseMetrics where CustomObjectName ='Functional_Design_Registration__c' LIMIT 1];

        List<OE_Custom_Seeting__c> listOfSettings = new List<OE_Custom_Seeting__c> ();
        OE_Custom_Seeting__c OESeeting1	= new OE_Custom_Seeting__c(	name = 'Day_of_week_FRM_review_date__c', Value__c ='wednesday'	);
        OE_Custom_Seeting__c OESeeting2	= new OE_Custom_Seeting__c(	name = 'FDR_PS_Type_Id_18__c', Value__c = RecordTypeIdFDRPS	);
        OE_Custom_Seeting__c OESeeting3	= new OE_Custom_Seeting__c(	name = 'Maintenance_Record_Type_Id_15__c', Value__c = String.valueOf(RecordTypeIdMaintenance).abbreviate(15)	);
        OE_Custom_Seeting__c OESeeting4	= new OE_Custom_Seeting__c(	name = 'Maintenance_Record_Type_Id_18__c', Value__c = RecordTypeIdMaintenance	);
        OE_Custom_Seeting__c OESeeting5	= new OE_Custom_Seeting__c(	name = 'Project_Record_Type_Id_15__c', Value__c = String.valueOf(RecordTypeIdProject).abbreviate(15)	);
        OE_Custom_Seeting__c OESeeting6	= new OE_Custom_Seeting__c(	name = 'Project_Record_Type_Id_18__c', Value__c = RecordTypeIdProject	);
        OE_Custom_Seeting__c OESeeting7	= new OE_Custom_Seeting__c(	name = 'Status_to_Validate_on_Project__c', Value__c ='6 - Complete,9 - Cancel'	);
        OE_Custom_Seeting__c OESeeting8	= new OE_Custom_Seeting__c(	name = 'WIQ_Entity_Id__c', Value__c ='01I44000000utxS'	);
        OE_Custom_Seeting__c OESeeting9	= new OE_Custom_Seeting__c(	name = 'Workstream_Record_Type_Id_15__c', Value__c = String.valueOf(RecordTypeIdWorkstream).abbreviate(15)	);
        OE_Custom_Seeting__c OESeeting10	= new OE_Custom_Seeting__c(	name = 'Workstream_Record_Type_Id_18__c', Value__c = RecordTypeIdWorkstream	);
        OE_Custom_Seeting__c OESeeting11	= new OE_Custom_Seeting__c(	name = 'Enhancement_Record_Type_Id_15__c', Value__c = String.valueOf(RecordTypeIdEnhancement).abbreviate(15) );
        OE_Custom_Seeting__c OESeeting12	= new OE_Custom_Seeting__c(	name = 'Enhancement_Record_Type_Id_18__c', Value__c = RecordTypeIdEnhancement	);
        
        OE_Custom_Seeting__c OESeeting13	= new OE_Custom_Seeting__c(	name = 'FDR_Enhancement_Record_Type_Id_15__c', Value__c = String.valueOf(RecordTypeIdFDREnhancement).abbreviate(15)	);
        OE_Custom_Seeting__c OESeeting14	= new OE_Custom_Seeting__c(	name = 'FDR_Enhancement_Record_Type_Id_18__c', Value__c = RecordTypeIdFDREnhancement	);
        OE_Custom_Seeting__c OESeeting15	= new OE_Custom_Seeting__c(	name = 'FDR_Entity_Id__c', Value__c ='01I44000000utxN'	);
        OE_Custom_Seeting__c OESeeting16	= new OE_Custom_Seeting__c(	name = 'FDR_Maintenance_Record_Type_Id_15__c', Value__c = String.valueOf(RecordTypeIdFDRMaintenance).abbreviate(15));
        OE_Custom_Seeting__c OESeeting17	= new OE_Custom_Seeting__c(	name = 'FDR_Maintenance_Record_Type_Id_18__c', Value__c = RecordTypeIdFDRMaintenance	);
        OE_Custom_Seeting__c OESeeting18	= new OE_Custom_Seeting__c(	name = 'FDR_PS_Type_Id_15__c', Value__c = String.valueOf(RecordTypeIdFDRPS).abbreviate(15)	);
        
        OE_Custom_Seeting__c OESeeting19	= new OE_Custom_Seeting__c(	name = 'Work_Item_Enhancement_Record_Type_Id15__c', Value__c = String.valueOf(RecordTypeIdWIQEnhancement).abbreviate(15)	);
        OE_Custom_Seeting__c OESeeting20	= new OE_Custom_Seeting__c(	name = 'Work_Item_Enhancement_Record_Type_Id18__c', Value__c = RecordTypeIdWIQEnhancement );
        OE_Custom_Seeting__c OESeeting21	= new OE_Custom_Seeting__c(	name = 'Work_Item_Maintenance_Record_Type_Id15__c', Value__c = String.valueOf(RecordTypeIdWIQMaintenance).abbreviate(15)	);
        OE_Custom_Seeting__c OESeeting22	= new OE_Custom_Seeting__c(	name = 'Work_Item_Maintenance_Record_Type_Id18__c', Value__c = RecordTypeIdWIQMaintenance);
        OE_Custom_Seeting__c OESeeting23	= new OE_Custom_Seeting__c(	name = 'Work_Item_PS_Record_Type_Id15__c', Value__c = String.valueOf(RecordTypeIdWIQPS).abbreviate(15)		);
        OE_Custom_Seeting__c OESeeting24	= new OE_Custom_Seeting__c(	name = 'Work_Item_PS_Record_Type_Id18__c', Value__c = RecordTypeIdWIQPS	);
        
        listOfSettings.add(	OESeeting1	);
        listOfSettings.add(	OESeeting2	);
        listOfSettings.add(	OESeeting3	);
        listOfSettings.add(	OESeeting4	);
        listOfSettings.add(	OESeeting5	);
        listOfSettings.add(	OESeeting6	);
        listOfSettings.add(	OESeeting7	);
        listOfSettings.add(	OESeeting8	);
        listOfSettings.add(	OESeeting9	);
        listOfSettings.add(	OESeeting10	);
        listOfSettings.add(	OESeeting11	);
        listOfSettings.add(	OESeeting12	);
        listOfSettings.add(	OESeeting13	);
        listOfSettings.add(	OESeeting14	);
        listOfSettings.add(	OESeeting15	);
        listOfSettings.add(	OESeeting16	);
        listOfSettings.add(	OESeeting17	);
        listOfSettings.add(	OESeeting18	);
        listOfSettings.add(	OESeeting19	);
        listOfSettings.add(	OESeeting20	);
        listOfSettings.add(	OESeeting21	);
        listOfSettings.add(	OESeeting22	);
        listOfSettings.add(	OESeeting23	);
        listOfSettings.add(	OESeeting24	);
        
        insert listOfSettings;

        
        //Create OE Cusom Settings

        Map<String, String> settings = new Map<String, String>();
        for(OE_Custom_Seeting__c thisValue: [SELECT Id,Value__c, Name FROM OE_Custom_Seeting__c]) {
            settings.put(thisValue.Name, thisValue.Value__c);
        }
        //Create Custom Settings
       // Project_Tracker__c projectTrackerCustomSettings = createProjectTrackerCustomSettings();
        //upsert projectTrackerCustomSettings; 
        
        //create project
        ART_Project__c project = createProject(settings);
        insert project;
        
        //Create workstream
        ART_Project__c  workstream = createWorkstream(settings, project);
        insert workstream;
        
        resultMap.put('project', project);
        resultMap.put('workstream', workstream);
      //  resultMap.put('projectTrackerCustomSettings', projectTrackerCustomSettings);
        
        return resultMap;
    }
    
    
    public static ART_Project__c createProject(Map<String, String> settings ) {
        Id RecordTypeIdProject = Schema.SObjectType.ART_Project__c.getRecordTypeInfosByName().get('Project').getRecordTypeId();
        ART_Project__c project = new ART_Project__c();
        project.Name = 'Test Project';
        project.AFE_Approved__c = 'Not Required';
        project.RecordTypeId = RecordTypeIdProject;
        return project;
    }
    
    public static ART_Project__c createWorkstream(Map<String, String> settings, ART_Project__c parent ) {
                Id RecordTypeIdProject = Schema.SObjectType.ART_Project__c.getRecordTypeInfosByName().get('Project').getRecordTypeId();

        ART_Project__c workstream = new ART_Project__c();
        workstream.Parent_Project__c = parent.Id;
        workstream.Name = 'Test Workstream';
        workstream.AFE_Approved__c = 'Not Required';
        workstream.RecordTypeId = RecordTypeIdProject;
        return workstream;
    }
    
    public static Project_Tracker__c createProjectTrackerCustomSettings() {
        Project_Tracker__c projectTrackerCustomSettings = new Project_Tracker__c();
        for ( RecordType projectRecordType : [SELECT Id, DeveloperName, SobjectType FROM RecordType 
                                              	WHERE   DeveloperName = 'project' OR 
                                              			DeveloperName = 'workstream' OR 
                                              			DeveloperName = 'enhancement' OR 
                                              			DeveloperName = 'maintenance' OR 
                                              DeveloperName LIKE '%Production_Support%']) {
              if(projectRecordType.SobjectType.toLowerCase().contains('art_project__c') && projectRecordType.DeveloperName.toLowerCase().contains('project'))  {
                  String idProject = String.valueOf(projectRecordType.Id);
                  projectTrackerCustomSettings.Project_Record_Type_Id_15__c = idProject.substring(0, 15);  
                  projectTrackerCustomSettings.Project_Record_Type_Id_18__c = idProject;
              } else if (projectRecordType.SobjectType.toLowerCase().contains('art_project__c') && projectRecordType.DeveloperName.toLowerCase().contains('workstream')) {
                	String idWorkstream = String.valueOf(projectRecordType.Id);
                  	projectTrackerCustomSettings.Workstream_Record_Type_Id_15__c = idWorkstream.substring(0, 15);  
                  	projectTrackerCustomSettings.Workstream_Record_Type_Id_18__c = idWorkstream;  
              }
                                                  
        }

        
        projectTrackerCustomSettings.Status_to_Validate_on_Project__c = '6 - Complete,9 - Cancel';
        projectTrackerCustomSettings.Day_of_week_FRM_review_date__c = 'wednesday';
        return projectTrackerCustomSettings;
    }

}