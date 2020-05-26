@isTest
private class Case_Task_Hour_TestMethod {

    static testMethod void myUnitTest() {
     Test.startTest();
     

      List<Profile> pmIDs = [SELECT Id FROM Profile WHERE Name= 'System Administrator'];
      List<Profile> valIDs = [SELECT Id FROM Profile WHERE Name= 'System Administrator'];
      
      list<user> ulist = new list <user>();
      user u = new user(alias = 'standt', email='standarduser@testorg.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = pmIDs[0].Id, 
            timezonesidkey='America/Los_Angeles', username='supplierMain@testorg.com');
            ulist.add(u);
            insert ulist;
            
            List<BusinessHours> bhs=[select id from BusinessHours where IsActive=true limit 10];//IsDefault=true];
        system.debug('@@@'+bhs);
        system.debug(bhs);

            //bhs[0].name='America/Los_Angeles';
            
           // System.assert(bhs.size()==1);
        

      List<Group> pmQueue = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name LIKE 'PM%' AND Name != 'PM - CAST (LWR) Queue' AND Name != 'PM - Lead Queue' AND Name != 'PM - Castings Lead Queue'];
      Contact contact = new Contact(FirstName='Sana',LastName='Test', No_Email__c = True);
      insert contact;
        List<RecordType> pmCaseRecType = [Select Id From RecordType WHERE SobjectType = 'Case' AND (Name LIKE 'PM%' OR Name LIKE 'CP%' OR Name LIKE 'CAST%') AND isActive = true LIMIT 4];
        RecordType valCaseRecType = [Select Id From RecordType WHERE SobjectType = 'Case' AND Name LIKE 'Val%' AND isActive = true LIMIT 1];
        RecordType pmTaskRecType = [Select Id From RecordType WHERE SobjectType = 'Task' AND Name LIKE 'P.M.%' AND isActive = true LIMIT 1];
        RecordType valTaskRecType = [Select Id From RecordType WHERE SobjectType = 'Task' AND Name LIKE 'Val%' AND isActive = true LIMIT 1];

        
      final Integer TOTAL = 5;
      Integer j = 0;
      
      List<Case> cases = new List<Case>();
      List<Task> tasks = new List<Task>();
      
      Case c = new Case(Status='Not Started', OwnerId=userinfo.getuserid(), RecordTypeId=pmCaseRecType[0].Id);
      Case oldCase = new Case(Status='Not Started', OwnerId=userinfo.getuserid(), RecordTypeId=pmCaseRecType[0].Id,Last_Status_Change__c=system.today()-5);
      Case oldClosedCase = new Case(Status='Closed', OwnerId=userinfo.getuserid(), RecordTypeId=pmCaseRecType[0].Id);
      cases.add(c); cases.add(oldCase); cases.add(oldClosedCase);

      Task t = new Task(subject='Task Test', WhoId=contact.Id, status='Not Started', RecordTypeId=pmTaskRecType.Id);
      Task oldTask = new Task(subject='Task Test', WhoId=contact.Id, status='In Progress', RecordTypeId=pmTaskRecType.Id);
      tasks.add(t); tasks.add(oldTask);

      for (Integer i = 0; i < TOTAL; i++)  {
         if(j == 0)  {
            c = new Case(Status='Closed',Total_Hours__c=5,OwnerId=userinfo.getuserid(), RecordTypeId=pmCaseRecType[0].Id);
            cases.add(c);
            j = 1;
         }
         else if (j == 1) {
            c = new Case(Status='Working/Researching',Total_Hours__c=5,OwnerId=pmQueue[0].Id, RecordTypeId=pmCaseRecType[0].Id);
            cases.add(c);
            j = 2;
         }
         else {
            c = new Case(Status='On Hold',OwnerId=userinfo.getuserid(), RecordTypeId=pmCaseRecType[0].Id);
            cases.add(c);
            j = 0;
         }
      }
      c = new Case(Case_Time_In_Progress__c=null,Case_Time_Pending__c=null, Status='On Hold', RecordTypeId=valCaseRecType.Id);
      cases.add(c);
      insert(cases);

      for (Integer i = 0; i < TOTAL; i++)  {
         if (j == 0)  {
            t = new Task(subject='Task Test ' + i, WhatId=cases[0].Id, status='In Progress', Total_Hours__c=1, RecordTypeId=pmTaskRecType.Id, WhoId=contact.Id);
            j = 1;
         }
         else if (j == 1)  {
            t = new Task(subject='Task Test ' + i, WhatId=cases[1].Id, WhoId=contact.Id, status='Waiting on someone else', RecordTypeId=pmTaskRecType.Id);
            j = 2;
         }
         else if (j == 2)  {
            t = new Task(subject='Task Test ' + i, WhoId=contact.Id, status='Not Started', RecordTypeId=pmTaskRecType.Id);
            j = 3;
         }         
         else if (j == 3)  {
            t = new Task(subject='Task Test ' + i, WhatId=cases[1].Id, WhoId=contact.Id, status='Completed', Total_Hours__c=1, RecordTypeId=pmTaskRecType.Id);
            j = 4;
         }
         else  {
            t = new Task(subject='Task Test ' + i, WhatId=cases[0].Id, WhoId=contact.Id, status='Completed', Actual_Effort__c=5, Total_Hours__c=5, RecordTypeId=pmTaskRecType.Id);
            j = 0;
         }
         tasks.add(t);
      }
      t = new Task(subject='Task Test', WhatId=cases[1].Id, WhoId=contact.Id, status='Not Started', RecordTypeId=pmTaskRecType.Id, Notify_Account_Owner__C = 'No', manager_alert__c = 'No');
      tasks.add(t);

      t = new Task(subject='Task Test', WhatId=cases[0].Id, WhoId=contact.Id, status='Completed', Total_Hours__c=1, RecordTypeId=pmTaskRecType.Id, Notify_Account_Owner__C = 'No', manager_alert__c = 'No');
      tasks.add(t);
      insert (tasks);
      
      cases[0].Total_Hours__c = 5;
      cases[0].Status = 'Closed';
      cases[1].Status = 'Working/Researching';
      cases[2].Total_Hours__c = 3;      
      update(cases);
      cases[2].Total_Hours__c = null;    
      cases[2].Case_Time_Pending__c = 5.255;
      cases[2].Case_Time_In_Progress__c = 2.145;
      cases[0].Total_Hours__c = 15;      
      cases[2].Status = 'Closed';
      cases[3].Status = 'Escalated';

      oldCase.Total_Hours__c = 3;
      oldCase.Total_Task_Hours__c = 3;
      oldCase.Status = 'Waiting on Status';
      oldCase.OwnerId = userinfo.getuserid();
      update(cases);
      cases[3].Status = 'Closed';
      update cases;
      
      tasks[0].Status = 'Completed';
      tasks[1].Status = 'In Progress';
      tasks[2].Status = 'Waiting on Someone else';
      tasks[0].Total_Hours__c = 5;
      tasks[2].Total_Hours__c = 5;      
      tasks[TOTAL-1].Status = 'In Progress';
      tasks[TOTAL+1].Total_Hours__c = 5;      
      tasks[TOTAL+1].Status = 'Completed';
      update(tasks);      

      tasks[1].OwnerId = userinfo.getuserid();
      tasks[2].Status = 'Urgent';      
      tasks[3].WhatId = cases[0].Id;
      tasks[3].Status = 'Completed';
      tasks[3].Total_Hours__c = 5;
      tasks[0].Total_Hours__c = 0;
      tasks[0].Status = 'In Progress';
      tasks[TOTAL-1].WhatId = null;  
      oldTask.status = 'Urgent';   
      update(tasks);
    
    DateTime lastStatusChange = system.now()-20;
    string obj = 'test';
    string status = 'In Progress';
   task tk = new task();
     Case_Task_Hour_Functions.getTimeSinceLastChange(bhs[0].id, lastStatusChange);
     Case_Task_Hour_Functions.getCaseBusinessHoursID(ulist,bhs,c);
     Case_Task_Hour_Functions.getTaskBusinessHoursID(ulist,bhs,t);  
     Case_Task_Hour_Functions.getStatuses(obj,status);
     try{
     case cs = Case_Task_Hour_Functions.assignTimeToCase(ulist,bhs,oldcase,cases[0]);
     
     }
     Catch(exception e){}
     try{
     tk = Case_Task_Hour_Functions.assignTimeToTask(ulist,bhs,oldtask,tasks[0]);
     }
     catch(exception e){}
     
   }
}