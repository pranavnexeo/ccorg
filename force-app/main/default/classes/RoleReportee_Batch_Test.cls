@isTest
private class RoleReportee_Batch_Test {

  public static testMethod void testthisbatch() {
    Profile profile = [select id from profile where name='System Administrator'];
    User user = new User(alias = 'standt', email='standarduser@testorg.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = profile.Id,Price_Coord_Region__c='US', 
            timezonesidkey='America/Los_Angeles', username='supplierMain@testorg.com');
    insert user;
    UserRole ur = new UserRole(DeveloperName = 'Test', Name = 'Test');
    insert ur;
    List<UserRole>lstBatchRecords = new List<UserRole>();
    lstBatchRecords.add(ur);
    Role_Reportee__c rc = new Role_Reportee__c(Role_id__c = ur.id, Role__c = 'GBS Support',user__c = user.id);
    List<Role_Reportee__c> Reportees = new List<Role_Reportee__c>();
    Reportees.add(rc);
    RoleReportee_Batch clsBatchSync = new RoleReportee_Batch();
    ID idBatch = Database.executeBatch(clsBatchSync,1);
    clsBatchSync.execute(null,lstBatchRecords);
    clsBatchSync.finish(null);
    clsBatchSync.start(null);
    System.abortJob(idBatch);
     
  }
}