/*
*Batch class for AFE Approval
*Sends email to approvers for requests pending for more than 3 days
*/
global class SendAFE_ApprovalMail_Batch implements Database.Batchable<SObject>{
  global string q;

  
  global SendAFE_ApprovalMail_Batch (){
   // q = 'SELECT Id, ProcessInstanceId, ProcessInstance.TargetObjectId, StepStatus FROM ProcessInstanceStep where ProcessInstance.TargetObject.Type = \'Authorization_For_Expediture__c\' and StepStatus = \'Pending\'';
      q = 'Select p.Id, p.ProcessInstanceId, p.ProcessInstance.Status, p.ProcessInstance.TargetObjectId, p.ActorId, p.OriginalActorId, p.CreatedById, p.CreatedDate from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObject.Type = \'Authorization_for_Expenditure__c\' order by p.Actor.Name';

  }

/*Start method*/
global Database.QueryLocator start(Database.BatchableContext bcMain){
  
  return Database.getQueryLocator(q);
 } 
 
/*Execute Method*/
global void execute(Database.BatchableContext bcMain, List<ProcessInstanceWorkItem> items){
      
       /*Initialize Variables*/
       
       Set<Id> approverIds = new Set<Id>(); // Set of Approver Ids
       Set<Id> ObjectIds = new Set<Id>(); //Set of Record Ids
       Map<Id,List<ProcessInstanceWorkItem>> ItemsByUser = new Map<Id,List<ProcessInstanceWorkItem>>(); //Init map to get List of ProcessInstanceWorkItemby Approver
 
     for(ProcessInstanceWorkItem item: Items)
         ObjectIds.add(item.ProcessInstance.TargetObjectid); //Add TargetObjectIds  
     
     Map<Id,Authorization_for_Expenditure__c> AFEMap = new Map<Id,Authorization_for_Expenditure__c>([SELECT Id, AFE__c, Name, AFE_Title__c, Link__c, createdby.name, createdby.email FROM Authorization_for_Expenditure__c WHERE Id in :ObjectIds and status__c = 'Pending Approval' ]);
     
     for(ProcessInstanceWorkItem item: Items){   
          if(AFEMap.containskey(item.ProcessInstance.TargetObjectid))
          {
              approverIds.add(item.ActorId); //Add Approver to Set of Approver Ids
               if(ItemsByUser.keyset().contains(item.ActorId)){ //If Approver has a list already in the map, get them
                List<ProcessInstanceWorkItem> newItems = ItemsByUser.get(item.ActorId);
                 newItems.add(item);
                  ItemsByUser.put(item.ActorId,newItems); //Replace updated list in the approver Map
                 }       
               else{
                  ItemsByUser.put(item.ActorId,new List<ProcessInstanceWorkItem>{item});
              } 
          }
     } // End For Loop

       Map<Id,User> userMap = new Map<Id,User>([SELECT Id,Email, ManagerId, name FROM User where Id in: ApproverIds]);
       List<Messaging.SingleEmailMessage> theEmails = new List<Messaging.SingleEmailMessage>();

       //Build one email per Approver 
    set<string> userlist = new set<string>();       
    for(User u : UserMap.Values()){
        String message = 'The following  AFE requires your approval.  Please click on the link to open the AFE document in Salesforce.com.';
        message += '<br/><br/><table><tr><th>AFE Number</th><th>Title</th><th>Days Awaiting Approval</th><th>Created By</th><th>Link</th></tr>';
        
      for(ProcessInstanceWorkItem item: ItemsByUser.get(u.id)){
             Authorization_For_Expenditure__c AFE = AFEMap.get(item.processinstance.targetobjectid);
              message += '<tr><td>' + AFE.Name + '</td><td>' + AFE.AFE_Title__c + '</td><td>' + item.createdDate.date().daysBetween(system.today()) + '</td>';
              message += '<td><a href="mailto:' + AFE.createdby.email + '" target="_top">' + AFE.createdby.name + '<a></td><td>' + AFE.Link__c + '</td></tr>';     
         }     
         message = message +'</table><br/><br/>';
  
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSubject('AFE Review & Approval Notice');
        mail.setHtmlBody(message);
        mail.setToAddresses(new String[] {u.email});
        CustomSettings__c settings = customsettings__c.getorgdefaults();
        if(settings.AFE_Reminder_Email_From_Address__c != null)
          mail.setReplyTo(settings.AFE_Reminder_Email_From_Address__c);
        mail.setSenderDisplayName('Nexeo AFE Approvals Admin');
        theEmails.add(mail);
        userlist.add(u.name);
        }
     system.debug('Emails size: ' + theEmails.size());
     system.debug('users: ' + userlist);
     
     
     if(theEmails.size() > 0 && Test.isrunningtest() == false)
        Messaging.sendEmail(theEmails);
       
  } 
//Finish Method
global void finish(Database.BatchableContext bc){
   AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:bc.getJobId()];   
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {a.CreatedBy.Email});
        mail.setReplyTo('nexeosfdcsolutions@nexeosolutions.com');
        mail.setSenderDisplayName('Batch Processing');
        mail.setSubject('Batch Process Id: '+a.Id+' '+a.Status);
        mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures. '  );
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });       

  }             
}