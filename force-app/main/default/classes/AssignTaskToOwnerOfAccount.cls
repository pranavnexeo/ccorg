public with sharing class AssignTaskToOwnerOfAccount {
    
    Public Case ThisCase{get; set;}
    Public Account account{get; set;}
    Public Task task{get; set;}
    Public String Comments{get; set;}
    Public String TaskDescription{get; set;}
    public list<selectoption> options{get; set;}
    public string RelatedTo{get; set;}
    public boolean isAHWT{get; set;}
    public boolean isAD{get; set;}

    


public AssignTaskToOwnerOfAccount(ApexPages.StandardController sc){

   isAHWT = false;
   isAD = false;
   Map<String, ID> RTMap = RecordType_Functions.RetrieveRecordTypeNameMap('Task');
   Set<String> ADRT = new set<String>{'Distribution Customer', 'Distribution Prospect', 'Distribution Other'};
   Set<String> AHWTRT = new set<String>{'Water Prospect', 'Drew Customer', 'Drew Other Account'};
   
   
   ThisCase = (case)sc.getrecord();
   ThisCase = [select id, accountid, description, casenumber from Case where id = :thiscase.id];
   Account = [select id, ownerid, name, Owner_Name__c, RecordType.Name from Account where id = :ThisCase.accountid limit 1];
   String Status = apexpages.currentpage().getparameters().get('s');
   String Subject = apexpages.currentpage().getparameters().get('sub');
   String NotifyOwner = apexpages.currentpage().getparameters().get('no');
   RelatedTo = ThisCase.id;

   Task = new Task();
   Task.Activitydate = System.today();
   If(ADRT.contains(Account.RecordType.Name)){
       Task.RecordTypeID = RTMap.get('Distribution CSR Task');
       isAD = true;
   }
   If(AHWTRT.contains(Account.RecordType.Name)){
       Task.RecordTypeID = RTMap.get('Water Task');
       isAHWT = true;
   }
   
   options = new list<SelectOption>();
   options.add(New selectOption(ThisCase.id, 'Case: ' + ThisCase.casenumber));
   options.add(New selectOption(Account.id, 'Account: ' + Account.Name));
   
   
   if(status == null || status == ''){
       Status = 'Not Started';
   }
   Task.Status = Status;
   if(Subject != null && subject != ''){
     Task.Subject = Subject;
   } else{
     Task.Subject = 'Action Required on DZ! - ' + Account.Name;
   }
   if(NotifyOwner != null && NotifyOwner != ''){
     Task.Notify_Account_Owner__c = 'No';
   } else {
     Task.Notify_Account_Owner__c = 'Yes';
   }
   Task.WhatID = RelatedTo;
   Task.ownerid = Account.Ownerid;
   Task.Manager_Alert__C = 'No';
   Comments = '';
   Task.Description = 'DZ Info: ' + Account.Name + '\n\nCase Description: ';
   
   if(ThisCase.description != null){
   Task.Description += ThisCase.Description;
   }

}

public pagereference AssignTask(){
   
   Task.WhatId = RelatedTo;
   Task.Description = TaskDescription + '\n\n' + Task.Description;
   if(task.subject != null && task.subject != ''){
   
   Task_Functions.createtaskandsendemails(Account.ownerid, Task.WhatID , Task.subject, Task.Description, Account);
   return new pagereference('/' + ThisCase.id);
   } else{
   return null;
   }
} 

public pagereference Cancel(){
  return new pagereference('/' + ThisCase.id);
}




}