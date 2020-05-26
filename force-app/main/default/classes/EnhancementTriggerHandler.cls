public with sharing class EnhancementTriggerHandler {
    
  private boolean m_isExecuting = false;
  private integer BatchSize = 0;

  public EnhancementTriggerHandler(boolean isExecuting, integer size){
    m_isExecuting = isExecuting;
    BatchSize = size;
  }
    
  public void OnBeforeInsert(Enhancement__c[] newRecords){
    Project_Tracker__c customSetting = Project_Tracker__c.getInstance();
    List<Id> listProject = new List<Id>();
    Map<Id, List<Enhancement__c>> enhancementMap = new Map<Id, List<Enhancement__c>>();
    for(Enhancement__c newRecord : newRecords){
        if (newRecord.Project__c != null) {
            listProject.add(newRecord.Project__c);
            
            if (enhancementMap.containsKey(newRecord.Project__c)) {
                List<Enhancement__c> currentList = enhancementMap.get(newRecord.Project__c);
                enhancementMap.put(newRecord.Project__c, currentList);
            } else {
                List<Enhancement__c> newList = new List<Enhancement__c>();
                newList.add(newRecord);
                enhancementMap.put(newRecord.Project__c, newList);
            }
        }
    }
    
    System.debug('listProject ' +  listProject);
    List<Enhancement__c> enhancementsToShowError = new List<Enhancement__c>();
    for (ART_Project__c workstream:[SELECT Id, Parent_Project__c From ART_Project__c Where Parent_Project__c IN: listProject]) {
		enhancementsToShowError.addAll(enhancementMap.get(workstream.Parent_Project__c));
    }
    System.debug('enhancementsToShowError ' + enhancementsToShowError);
      if (!enhancementsToShowError.isEmpty()) {
          for (Enhancement__c enhToShowError:enhancementsToShowError) {
              enhToShowError.Project__c.addError('As this Project already has realted workstreams, you cannot use it as the Project for this Improvement, please choose a new project or workstream');
          }
      }
      
  }
    
  public void OnBeforeUpdate(Enhancement__c[] oldRecords, Enhancement__c[] updatedRecords, Map<ID, Enhancement__c> recordMap){
          Project_Tracker__c customSetting = Project_Tracker__c.getInstance();
    List<Id> listProject = new List<Id>();
    Map<Id, List<Enhancement__c>> enhancementMap = new Map<Id, List<Enhancement__c>>();
    for(Integer i = 0; i < updatedRecords.size(); i ++){
        Enhancement__c newRecord = updatedRecords[i];
        Enhancement__c oldRecord = oldRecords[i];
        if (newRecord.Project__c != null && newRecord.Project__c != oldRecord.Project__c) {
            listProject.add(newRecord.Project__c);
            
            if (enhancementMap.containsKey(newRecord.Project__c)) {
                List<Enhancement__c> currentList = enhancementMap.get(newRecord.Project__c);
                enhancementMap.put(newRecord.Project__c, currentList);
            } else {
                List<Enhancement__c> newList = new List<Enhancement__c>();
                newList.add(newRecord);
                enhancementMap.put(newRecord.Project__c, newList);
            }
        }
    }
    
    System.debug('listProject ' +  listProject);
    List<Enhancement__c> enhancementsToShowError = new List<Enhancement__c>();
    for (ART_Project__c workstream:[SELECT Id, Parent_Project__c From ART_Project__c Where Parent_Project__c IN: listProject]) {
		 System.debug('here ');
        enhancementsToShowError.addAll(enhancementMap.get(workstream.Parent_Project__c));
    }
    System.debug('enhancementsToShowError ' + enhancementsToShowError);
      if (!enhancementsToShowError.isEmpty()) {
          for (Enhancement__c enhToShowError:enhancementsToShowError) {
              enhToShowError.Project__c.addError('As this project already has realted workstreams, you cannot use it as the Project for this improvment, please choose a new project or workstream');
          }
      }
  }
  
  /*
   * Verify if Project or Workstream are empty 
   * */  /*
  private void validateProjectWorkstremEmpty(Enhancement__c newRecord){
      if (newRecord.Project__c == null && newRecord.Workstream__c == null) {
           newRecord.addError('Please, populate either Project or Workstream for this Enhancement');
      }
        
  } */

}