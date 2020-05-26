global class RoleReportee_Batch implements Database.Batchable<SObject> {


global String q;

// Class Constructor - set query string
global RoleReportee_Batch() {
q = 'SELECT id, name from userrole';
}
// "Start" runs when the class in instanciated
global Database.QueryLocator start(Database.BatchableContext bcMain) {
return Database.getQueryLocator(q);
}

// "Execute" is what is being run as a separate process per batch
global void execute(Database.BatchableContext bcMain, List<UserRole> lstBatchRecords) {
  
  List<Role_Reportee__c> ReporteesToDelete = new List<Role_Reportee__c>();
  List<Role_Reportee__c> ReporteesToUpSert = new List<Role_Reportee__c>();
  
  for(UserRole r: lstBatchRecords)
  {  
     Set<Id> UserIds = RoleUtils.getRoleSubordinateUsersByRoleId(r.id);
     Set<Id> UsersReporting = new Set<Id>();
     List<Role_Reportee__c> Reportees = [select id, name, Role_Id__c, Role__c, user__c from Role_Reportee__c where Role_id__c  = :r.id];
     for(Role_Reportee__c rr:Reportees)
     {
       if(!UserIds.contains(rr.user__c))
         ReporteesToDelete.add(rr);
       else
       {
         UsersReporting.add(rr.user__c);
         rr.Role__c = r.name;
         rr.Role_id__c = r.id;
         ReporteestoUpsert.add(rr);     
       }
     }
     List<User> NewUsers = [Select id from User where id IN :Userids AND (NOT id IN :UsersReporting)];
     for(User u:NewUsers)
     {
        Role_Reportee__c newrr = new Role_Reportee__c();
        newrr.user__c = u.id;
        newrr.Role__c = r.name;
        newrr.role_id__c = r.id;
        ReporteesToUpsert.add(newrr);
     }
  }
    if(ReporteesToUpsert.size() > 0)
      upsert ReporteesToUpsert;
    if(ReporteesToDelete.size() > 0)
      Delete ReporteesToDelete;
}
// Finish the Batch Job
global void finish(Database.BatchableContext bcMain) {
// Optional - you can send an email to an admin with results
}
}