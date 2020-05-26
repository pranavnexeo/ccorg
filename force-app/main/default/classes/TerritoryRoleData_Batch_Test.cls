@isTest

Private Class TerritoryRoleData_Batch_Test{

    public testMethod static void testMyBatch(){
        
        List<SAP_Territory__c>terList = new List<SAP_Territory__c>();
        userRole ur = [SELECT id from userrole limit 1];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        Profile p1 = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles',UserName='ksbc@gorg.com', IsActive = true);
        insert u;
        
        User u1 = new User(Alias = 'standt', Email='xxx@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p1.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='jsnbcnbs@testorg.com', IsActive = true);
        insert u1;
        
         SAP_Seller__c s = new SAP_Seller__c(Name = 'test',user__c = u.id);
              insert s; 
         
         test.starttest();    
         SAP_Territory__c ST = new SAP_Territory__c(Name = 'test', ZS_Partner__c = s.id, YS_Partner__c = s.id);
         terList.add(ST);
             insert terList;
         
         test.stoptest();
         
         Role_Data__c rd = new Role_Data__c(type__c = 'Account',Data__c = ST.id,API_Field_Name__c = 'id',Role_Id__c = ur.id );
           insert rd;
           Role_Data__c rd2 = new Role_Data__c(type__c = 'Material');
           insert rd2;
           
            Role_Data__c rd1 = new Role_Data__c(type__c = 'Account',Data__c = ST.id,API_Field_Name__c = 'id');
           insert rd1;
            
                    
         TerritoryRoleData_Batch t1 = new TerritoryRoleData_Batch();
         ID idBatch = Database.executeBatch(t1);
         t1.execute(null,terList);

    }
}