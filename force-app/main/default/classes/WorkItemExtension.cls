/**
* Description: In order to support custom functionalities on the Work Item page
* Date: 29 / 1 / 2018
* Developer: Ignacio Gonzalez
*/
public class WorkItemExtension {

     //the record on the current page
    private Work_Item__c WorkItemrecord;
    private Work_Item__c WorkItemViewRecord;
    public String targetGoLiveIncident {get; set;}
    public String targetGoLiveEnhancement {get; set;}
    public String frmRepresentative {get; set;}
    private final String fdrId;
    private ApexPages.StandardController currentController;
    public Map<String, String> OECustomSettings{get; set;} 
    
    public WorkItemExtension(ApexPages.StandardController stdController) {
        //get current record from the page
        currentController = stdController;
        this.WorkItemrecord = (Work_Item__c)stdController.getRecord();
        this.WorkItemViewRecord = (Work_Item__c)stdController.getRecord();
        fdrId = ApexPages.currentPage().getParameters().get('functionaldesing');
        
        //Get settings from Project tracker 
		// retrieve settings from OE Tool 
        OECustomSettings = new Map<String, String>();
        for(OE_Custom_Seeting__c thisValue: [SELECT Id,Value__c, Name FROM OE_Custom_Seeting__c]) {
            OECustomSettings.put(thisValue.Name, thisValue.Value__c);
        }
       
        
        if (String.isNotEmpty(WorkItemrecord.Id)) {
            WorkItemrecord = [SELECT ID, FRM_Representative__r.Full_Name__c,Primary_Business_Contact__r.Full_Name__c,
                              Actual_Development_Completion_Date__c, Assigned_Technical_Resource__c, Classification__c,
                              Estimate_Development_Completion_Date__c, FRM_Representative__c, Functional_Design_Registration__c, 
                              Functional_Team__c, Description__c, Enhancement_Number__c, Improvement_Number__c, Incident_ID_Form__c,
                              Incident_ID__c, Incident_Owner_Form__c, Incident_Owner__c, In_Scope__c, Investigation_Prototype__c,
                              Link_to_Sharepoint__c, Primary_Business_Contact_FIM__c, Primary_Business_Contact__c, Priority__c,
                              Project__c, Record_Type_Name__c, Requestor__c, Resource_Hours__c, Review_Date__c, Status__c, Status_Description__c,
                              Status_Description_Date__c, Target_Go_live_Date_Form__c, Target_Go_live_Date__c, Target_Go_Live_Date_For_Incident_Form__c,
                              Target_Go_Live_Date_For_Incident__c, Target_Go_live_Quarter_Form__c,Target_Go_live_Quarter__c,   
                              Technical_Owner__c, Technology__c, UTN__c  
                              FROM Work_Item__c WHERE Id =: WorkItemrecord.Id];
            if (null != WorkItemrecord.Target_Go_Live_Date_For_Incident_Form__c) {
                targetGoLiveIncident = WorkItemrecord.Target_Go_Live_Date_For_Incident_Form__c.format();
			} else if (null != WorkItemrecord.Target_Go_live_Date__c) {
               targetGoLiveEnhancement = WorkItemrecord.Target_Go_live_Date__c.format();         
            }
            
            if (String.isNotBlank(WorkItemrecord.FRM_Representative__c)) {
                frmRepresentative = WorkItemrecord.FRM_Representative__r.Full_Name__c;
            } else {
                frmRepresentative = '';
            }
        }
        
        
        if (String.isNotEmpty(fdrId)) {
            WorkItemrecord.Functional_Design_Registration__c = fdrId;
			Functional_Design_Registration__c fdrParent = [SELECT Id, RecordType.Name, RecordTypeId FROM Functional_Design_Registration__c WHERE Id =: WorkItemrecord.Functional_Design_Registration__c ];            
        	
            if (fdrParent.RecordTypeId == OECustomSettings.get('FDR_Enhancement_Record_Type_Id_18__c')) {
                WorkItemrecord.RecordTypeId = OECustomSettings.get('Work_Item_Enhancement_Record_Type_Id18__c');
            } else if (fdrParent.RecordTypeId == OECustomSettings.get('FDR_Maintenance_Record_Type_Id_18__c'))  {
                WorkItemrecord.RecordTypeId = OECustomSettings.get('Work_Item_Maintenance_Record_Type_Id18__c');
            } else if (fdrParent.RecordTypeId == OECustomSettings.get('FDR_PS_Type_Id_18__c'))  {
                WorkItemrecord.RecordTypeId = OECustomSettings.get('Work_Item_PS_Record_Type_Id18__c');
                
            }
        
        }
        
        if (!Test.isRunningTest()) {
                  
            if (String.isEmpty(WorkItemrecord.RecordTypeId)) {
                //find all  record types
                List<Schema.RecordTypeInfo> infos = Schema.SObjectType.Work_Item__c.RecordTypeInfos;
                Id defaultRecordTypeId;
                
                //check each one
                for (Schema.RecordTypeInfo info : infos) {
                  if (info.DefaultRecordTypeMapping) {
                    defaultRecordTypeId = info.RecordTypeId;
                  }
                }
                System.debug(' defaultRecordTypeId ' + defaultRecordTypeId);
                WorkItemrecord.RecordTypeId = defaultRecordTypeId;
            }   
        }
        
    }
    
    public PageReference save() {  
        
        if (String.isEmpty(WorkItemrecord.Id)) {
            
            if (String.isNotEmpty(WorkItemrecord.Functional_Design_Registration__c) ) {

                Functional_Design_Registration__c FDRParent = [SELECT Id, RecordTypeId, OE_Enhancement_Number__c  FROM 
                                                              Functional_Design_Registration__c WHERE Id =: WorkItemrecord.Functional_Design_Registration__c];

                //Validate that the FDR is of the same type of the Work Item 
                WorkItemrecord.Enhancement_Number__c = 	FDRParent.OE_Enhancement_Number__c;
				             
            } 
            upsert WorkItemrecord;
            
            PageReference detailPage = new PageReference('/' + WorkItemrecord.Id);
        	return detailPage;
        } else {

           return currentController.save();
        } 

    }
    
    public PageReference cancel() { 
        if (String.isNotBlank(fdrId)) {
            PageReference detailPage = new PageReference('/' + fdrId);
        	return detailPage;
        } else {
            return currentController.cancel();
        }
    }
    
    public PageReference validateUserPermissions() {
        if (!Schema.sObjectType.Work_Item__c.isCreateable()) { 
        	String currEnhacementId = ApexPages.currentPage().getParameters().get('functionaldesing');
            if (String.isNotEmpty(currEnhacementId)) {
                PageReference detailPage = new PageReference('/apex/InsufficientPrivilegesOE');
                detailPage.setRedirect(true);
                return detailPage;
            } else {
                return null;
            }
        } else {
            return null;
        }

    }     
    
    
}