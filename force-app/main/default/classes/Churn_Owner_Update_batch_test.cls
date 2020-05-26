@isTest
private class Churn_Owner_Update_batch_test{
    static testMethod void myUnitTest(){
    
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
   // Profile p1 = [SELECT Id FROM Profile WHERE Name='AD-Manager'];
    
    User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true);
             insert u;
    /*User u1 = new User(Alias = 'standt', Email='xxx@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
              TimeZoneSidKey='America/Los_Angeles', UserName='jsnbcnbs@testorg.com', IsActive = true);
              insert u1;*/
    
    Role_Reportee__c rr = new Role_Reportee__c(Role__c = 'VP Composites',User__c = u.id );
    Insert rr;
    
    Account a = new Account(Name = 'test11',type = 'Customer', OwnerId = u.id);
    insert a;
  
    SalesChurn__c sc2=new SalesChurn__c(Account_Number__c=a.id);
    
    
    List<SalesChurn__c> sc= new List<SalesChurn__c>();
    sc.add(sc2);
    insert sc;
    List<Task> tasklist= new List<Task>();
     Task tk= new Task();
        tk.Subject='Open';
        tk.WhatId=sc2.id;
        tk.Description='test';
        tk.ActivityDate=system.Today();
        tk.Status = 'In Progress';
        tk.Type='Churn';
        tasklist.add(tk);
        insert tasklist;
        
      string str = 'test';
     Database.executeBatch(new  Churn_Owner_Update_batch(str));
        Churn_Owner_Update_batch con=new Churn_Owner_Update_batch(str);
        con.execute(null,sc);
    }
    }