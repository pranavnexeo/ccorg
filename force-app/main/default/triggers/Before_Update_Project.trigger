trigger Before_Update_Project on ART_Project__c (before update) {
  /*List<Project_Status_Log__c> logs = new List<Project_Status_Log__c>();
    
  for(ART_Project__c p:trigger.new){
    if(p.Project_Status__c != trigger.oldmap.get(p.id).Project_Status__c)
    {
      DateTime dt = p.lastmodifieddate;
      if(p.Status_Last_Modified__c != null)
        dt = p.Status_Last_Modified__c;
      Project_Status_Log__c log = new Project_Status_Log__c( 
         Status__c = trigger.oldmap.get(p.id).Project_Status__c,
         Date_Entered_Status__c = dt,
         Date_Exited_Status__c = system.now(),
         Days_In_Status__c = ((system.now().getTime() - dt.getTime()) / (1000 * 60 * 60 * 24)),
         Project__c = p.id);
        logs.add(log);
        Recursive_Check.setAlreadyRan();

      p.Status_Last_Modified__c = system.now();
    }
  }
  if(logs.size() > 0)
    insert logs;*/
     // retrieve settings from OE Tool 
    Map<String, String> settings = new Map<String, String>();
    for(OE_Custom_Seeting__c thisValue: [SELECT Id,Value__c, Name FROM OE_Custom_Seeting__c]) {
        settings.put(thisValue.Name, thisValue.Value__c);
    }
    List<String> statusToValidate = settings.get('Status_to_Validate_on_Project__c').split(',');
    Map<Id, ART_Project__c> projectsToCheck = new Map<Id, ART_Project__c>();
    Set<ART_Project__c> projectsThatCannotbeClosed = new Set<ART_Project__c>();
    for(ART_Project__c p:trigger.new){ 
        if (statusToValidate.contains(p.Project_Status__c)) {
                projectsToCheck.put(p.Id, p);
        }
    }
    
    //First Check workstream
    for (Enhancement__c improvement: [SELECT Id, Project__c,Project_Status__c FROM Enhancement__c WHERE Project__c IN : projectsToCheck.keySet()]) {
            if (!statusToValidate.contains(improvement.Project_Status__c)) {
                ART_Project__c p = projectsToCheck.get(improvement.Project__c);
                projectsThatCannotbeClosed.add(p);
            }
    }
    //Second Check for Improvements
    for (ART_Project__c workstream: [SELECT Id, Parent_Project__c,Project_Status__c FROM ART_Project__c WHERE Parent_Project__c IN: projectsToCheck.keySet() ]) {
            if (!statusToValidate.contains(workstream.Project_Status__c)) {
                ART_Project__c p = projectsToCheck.get(workstream.Parent_Project__c);
                projectsThatCannotbeClosed.add(p);
            }
    }
    
    //show error
   for (ART_Project__c project: projectsThatCannotbeClosed) {
       project.addError('As this Project/Workstream has realted workstreams or improvemnts with status open you can not mark this Project with the status: [' + project.Project_Status__c + ']');
    }
}