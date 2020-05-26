/**
* Description: In order to support custom functionalities on the Functional Design Registration page
* Date: 12 / 28 / 2017
* Developer: Ignacio Gonzalez
*/
public without sharing class FDRExtension {
	
    //the record on the current page
    private final Functional_Design_Registration__c FDRrecord;
    private final String enhacementId;
    private ApexPages.StandardController currentController;
    public Map<String, String> OECustomSettings{get; set;} 
    
    public FDRExtension(ApexPages.StandardController stdController) {
        //if (!Schema.sObjectType.Functional_Design_Registration__c.isCreateable()) {
           // redirect to inssuficient permissions 
        //} else {
            currentController = stdController;
            //get current record from the page
            this.FDRrecord = (Functional_Design_Registration__c)stdController.getRecord();
            
            enhacementId = ApexPages.currentPage().getParameters().get('enhancement');
            if (String.isNotEmpty(enhacementId)) {
                FDRrecord.OE_Enhancement_Number__c = enhacementId;
            }
            
            //Get settings from Project tracker 
                 // retrieve settings from OE Tool 
            OECustomSettings = new Map<String, String>();
            for(OE_Custom_Seeting__c thisValue: [SELECT Id,Value__c, Name FROM OE_Custom_Seeting__c]) {
                OECustomSettings.put(thisValue.Name, thisValue.Value__c);
            }
            String dayToVerify = OECustomSettings.get('Day_of_week_FRM_review_date__c').toLowerCase();
            
            //Only if new record make the FRM Representative current user
            if (String.isEmpty(FDRrecord.UTN__c)) {
                
                Datetime dt = DateTime.newInstance(Date.today(), Time.newInstance(0, 0, 0, 0));
                String dayOfWeek = dt.format('EEEE').toLowerCase();
                if (dayOfWeek == dayToVerify) {
                    System.debug('Equals');
                    dt = dt.addDays(1);
                    dayOfWeek = dt.format('EEEE').toLowerCase();
                }
    
                while (dayOfWeek != dayToVerify) {
                    dt = dt.addDays(1);
                    dayOfWeek = dt.format('EEEE').toLowerCase();
                }
                Integer d = dt.day();
                Integer mo = dt.month();
                Integer yr = dt.year();
                
                Date FRMReviewDate = Date.newInstance(yr, mo, d);
                FDRrecord.FRM_Representative__c = UserInfo.getUserId();
                FDRrecord.FRM_Review_Date__c = FRMReviewDate;
            }
           
            //In order to make the FDR owner equals to the enhancemente Primary Busines Contact
            if (null != FDRrecord.OE_Enhancement_Number__c && String.isEmpty(FDRrecord.UTN__c)) {
                //get Primary Business Contact from Enhancement
                Enhancement__c enhancementParent = [SELECT Id, User_Contact__c, Applicable_Technology_Team__c, RecordType.Name, BSM__c, Technical_Owner__c, IT_Owner__c,
                                                    Risk__c FROM Enhancement__c WHERE Id =: FDRrecord.OE_Enhancement_Number__c ];
                
                if (String.isNotEmpty(enhancementParent.User_Contact__c)) {
                      
                      FDRrecord.Technology__c = enhancementParent.Applicable_Technology_Team__c;
                      FDRrecord.Primary_Business_Contact__c = enhancementParent.User_Contact__c;
                }
                
                if (String.isNotEmpty(enhancementParent.IT_Owner__c)) {
                    FDRrecord.Functional_Team__c = enhancementParent.IT_Owner__c;
                }
                
                if (String.isNotEmpty(enhancementParent.Risk__c)) {
                    FDRrecord.Risk_Assessment__c = enhancementParent.Risk__c;
                }
                
                if (enhancementParent.RecordType.Name.contains('Enhan')) {
                    FDRrecord.RecordTypeId = OECustomSettings.get('FDR_Enhancement_Record_Type_Id_18__c');
                    //FDRrecord.OwnerId = enhancementParent.BSM__c;
                } else {
                    FDRrecord.RecordTypeId = OECustomSettings.get('FDR_Maintenance_Record_Type_Id_18__c');
                    //FDRrecord.OwnerId = enhancementParent.Technical_Owner__c;
                }
            } 
          
            if (String.isEmpty(FDRrecord.RecordTypeId)) {
                //find all  record types
                List<Schema.RecordTypeInfo> infos = Schema.SObjectType.Functional_Design_Registration__c.RecordTypeInfos;
                Id defaultRecordTypeId;
                
                //check each one
                for (Schema.RecordTypeInfo info : infos) {
                  if (info.DefaultRecordTypeMapping) {
                    defaultRecordTypeId = info.RecordTypeId;
                  }
                }
                System.debug(' defaultRecordTypeId ' + defaultRecordTypeId);
                FDRrecord.RecordTypeId = defaultRecordTypeId;
            } 
       // }
    }
    
    public PageReference cancel() {
        if (String.isNotEmpty(enhacementId)) {
            PageReference detailPage = new PageReference('/' + enhacementId);
        	return detailPage;
        } else {
            return currentController.cancel();
        }
    }
    
    public PageReference validateUserPermissions() {
        if (!Schema.sObjectType.Functional_Design_Registration__c.isCreateable()) { 
        	String currEnhacementId = ApexPages.currentPage().getParameters().get('enhancement');
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