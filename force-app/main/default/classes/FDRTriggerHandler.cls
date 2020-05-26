/* 
* Description: Handler class for Trigger on Functional_Design_Registration__c
* Date: 10 / 10 / 2017
* Developer: Ignacio Gonzalez
*/
public without sharing class FDRTriggerHandler {
    
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;

    public FDRTriggerHandler(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }

    /**
     * Method that is going to handle the after Update event
     * 
     * */
    public void handleAfterUpdate(Functional_Design_Registration__c[] oldRecords, 
                                    Functional_Design_Registration__c[] updatedRecords, 
                                    Map<Id, Functional_Design_Registration__c> recordMap) {
         // retrieve settings from OE Tool 
        Map<String, String> settings = new Map<String, String>();
        for(OE_Custom_Seeting__c thisValue: [SELECT Id,Value__c, Name FROM OE_Custom_Seeting__c]) {
            settings.put(thisValue.Name, thisValue.Value__c);
        }                                
        Map<Id, List<ContentDocumentLink>> contentRelatedToFDR = new Map<Id, List<ContentDocumentLink >>();
        List<ContentDocumentLink> filesToShare = new List<ContentDocumentLink>();
        Map<Id, Functional_Design_Registration__c> fDRThatCanBeParent = new Map<Id,Functional_Design_Registration__c>();
        //to store all the WIQ realted to the FDRs
        Map<Id, Set<String>> wIQs = new Map<Id, Set<String>>();
        //List of Work_Item__c that can be created for each tech
        List<Work_Item__c> wIQForAllPossbleTech = new List<Work_Item__c>();
        for (Work_Item__c wiq : [SELECT Id, Technology__c, Functional_Design_Registration__c FROM  Work_Item__c Where Functional_Design_Registration__c IN : recordMap.keySet()]) {
             Set<String> wiqList = wIQs.get(wiq.Functional_Design_Registration__c);
             if (null == wiqList) {
                 wiqList = new Set<String>();
             }
             wiqList.add(wiq.Technology__c.toUpperCase());
             wIQs.put(wiq.Functional_Design_Registration__c, wiqList);
        }
        //Iterate over the old records in order to identify if there is an update on Status
        for (Integer i = 0; i < oldRecords.size(); i++) {
            //We are going to verify is the Status has changed to Approved
            if (oldRecords[i].Status__c != updatedRecords[i].Status__c
                && updatedRecords[i].Status__c.contains(Label.FDR_Approved)) {
                    fDRThatCanBeParent.put(updatedRecords[i].Id,updatedRecords[i]);
            }                               
        }
                                        
        //Get all the files realted to the parents
        for (Functional_Design_Registration__c possibleParent : fDRThatCanBeParent.values()) {
            List<ContentDocumentLink> fDRFiles = [SELECT ContentDocumentId,Id,LinkedEntityId,ShareType,Visibility FROM ContentDocumentLink WHERE LinkedEntityId =: possibleParent.Id];
            contentRelatedToFDR.put(possibleParent.Id, fDRFiles);
        }
                                        
        //Iterate over FDR list of parents
        for (Functional_Design_Registration__c possibleParent : fDRThatCanBeParent.values()) {
             //get the list of WIQs related to this parent
             Set<String> listOfCreatedTechWI = wIQs.get(possibleParent.Id);
             //If empty we will have to create all the WIQ realted otherwise we only have to create
             //the missing technologies
             List<String> selectedTech = possibleParent.Technology__c.split(';');
             if (null != listOfCreatedTechWI){
                 for (String techValue:selectedTech){
                     if (!listOfCreatedTechWI.contains(techValue.toUpperCase())){
                         wIQForAllPossbleTech.add(createWIQ(possibleParent, techValue, settings));
                     }             
                 }
             } else {
                 for (String techValue:selectedTech){ 
                        wIQForAllPossbleTech.add(createWIQ(possibleParent, techValue, settings));
                 }           
             }
        }
                                        
        if (wIQForAllPossbleTech.size() > 0) {
            insert wIQForAllPossbleTech;
        }
                                        
        // In order to share FDR Files we are going to use the id from created wi
        for (Work_Item__c wi :wIQForAllPossbleTech) {
             List<ContentDocumentLink> contentThatCanBeShare = contentRelatedToFDR.get(wi.Functional_Design_Registration__c);
             for (ContentDocumentLink file : contentThatCanBeShare) {
                    ContentDocumentLink contentToInsert = new ContentDocumentLink(ContentDocumentId = file.ContentDocumentId,LinkedEntityId = wi.Id,ShareType = file.ShareType,Visibility = file.Visibility);
                    filesToShare.add(contentToInsert); 
             }
        }
                                        
       //we are going to proceed to share the files with the wi entries
       if (filesToShare.size() > 0) {
           // If a file cannot be share we are going to ignore it
           Database.SaveResult[] srList = Database.insert(filesToShare, false);
           for (Database.SaveResult sr : srList) { 
                if (!sr.isSuccess()) {
                    // Operation failed, so get all errors                
                    for (Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Fields that affected this error: ' + err.getFields());
                    }
                }
           }
       }
    }
    
    // In order to create a Work item for a tech value
    private Work_Item__c createWIQ(Functional_Design_Registration__c parent, String techValue, 
                                   Map<String, String> settings) {
        Work_Item__c wi = new Work_Item__c();
        wi.Technology__c = techValue;
        wi.Functional_Design_Registration__c = parent.Id;
        wi.Name = parent.Name;
        wi.UTN__c = parent.UTN__c;
        wi.Incident_ID__c = parent.Incident_ID__c;
        wi.Enhancement_Number__c = parent.OE_Enhancement_Number__c;
        //wi.Primary_Business_Contact_FIM__c = parent.Primary_Business_Contact_FIM__c;
        wi.FRM_Representative__c = parent.FRM_Representative__c;
        wi.Target_Go_live_Date__c = parent.Target_Go_Live_Date__c;
        wi.Target_Go_live_Quarter__c = parent.Target_Go_Live_Quarter__c;
        wi.Functional_Team__c = parent.Functional_Team__c;
        if (parent.RecordTypeId == settings.get('FDR_Maintenance_Record_Type_Id_15__c')
            || parent.RecordTypeId == settings.get('FDR_Maintenance_Record_Type_Id_18__c')) {
            wi.RecordTypeId = settings.get('Work_Item_Maintenance_Record_Type_Id18__c');
        } else if (parent.RecordTypeId == settings.get('FDR_PS_Type_Id_15__c') 
                    || parent.RecordTypeId == settings.get('FDR_PS_Type_Id_18__c')) {
                    wi.RecordTypeId = settings.get('Work_Item_PS_Record_Type_Id18__c');
        }  else {
                    wi.RecordTypeId = settings.get('Work_Item_Enhancement_Record_Type_Id18__c');
        }               
        return wi;
    }
    
    public void OnAfterInsert(Functional_Design_Registration__c[] newRecords){
        List<Id> enhancementsToUpdateID = new List<Id>();
        for (Integer i = 0; i < newRecords.size(); i++) {
            if (String.isNotBlank(newRecords[i].OE_Enhancement_Number__c)) {
                enhancementsToUpdateID.add(newRecords[i].OE_Enhancement_Number__c);
            }	         
        }
        
        if(!enhancementsToUpdateID.isEmpty()) {
            List<Enhancement__c> enhancementsToUpdate = [SELECT Id,Related_FDR__c FROM Enhancement__c WHERE Id in :enhancementsToUpdateID];
            for (Enhancement__c currentEnh:enhancementsToUpdate) {
                currentEnh.Related_FDR__c +=1;
            }
            if (!enhancementsToUpdate.isEmpty()) {
                update enhancementsToUpdate;
            }
        }
  	}
    
    public void OnAfterDelete(Functional_Design_Registration__c[] deletedRecords, Map<ID, Functional_Design_Registration__c> recordMap){
        List<Id> enhancementsToUpdateID = new List<Id>();
        for (Integer i = 0; i < deletedRecords.size(); i++) {
            if (String.isNotBlank(deletedRecords[i].OE_Enhancement_Number__c)) {
                enhancementsToUpdateID.add(deletedRecords[i].OE_Enhancement_Number__c);
            }	         
        }
        
        if(!enhancementsToUpdateID.isEmpty()) {
            List<Enhancement__c> enhancementsToUpdate = [SELECT Id,Related_FDR__c FROM Enhancement__c WHERE Id in :enhancementsToUpdateID];
            for (Enhancement__c currentEnh:enhancementsToUpdate) {
                currentEnh.Related_FDR__c -=1;
            }
            if (!enhancementsToUpdate.isEmpty()) {
                update enhancementsToUpdate;
            }
        }
  	}	
}