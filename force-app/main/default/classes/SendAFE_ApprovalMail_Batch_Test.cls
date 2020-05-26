@isTest
//@isTest(SeeAllData=true)
private class SendAFE_ApprovalMail_Batch_Test{
     static Authorization_for_Expenditure__c AFE;
     //static Authorization_for_Expenditure__c AFE1;
     static Budget_Item__c BudItm;
     static Approval.Processresult Result;
     static User user;
     static User user1;
     static Category_Master__c cm;
  
  public static testMethod void testmybatch() {
    
            Test.startTest();
            Date myDate = Date.Today()+1;
            
            Profile ps = [select id from profile where name='System Administrator']; 
            
            user = new User(alias = 'DivS1', email='DivCo@testorg.com', 
            emailencodingkey='UTF-8', lastname='DivCoTest1', firstName ='DivAFECordinator',languagelocalekey='en_US', 
            localesidkey='en_US', profileid = ps.Id, 
            timezonesidkey='America/Los_Angeles', username='teghthyj44stDiv@testorg.com');
            
            insert user;
            
            user1 = new User(alias = 'DivS1', email='DivCo@testorg.com', 
            emailencodingkey='UTF-8', lastname='DivCoTest1', firstName ='DivAFECordinator',languagelocalekey='en_US', 
            localesidkey='en_US', profileid = ps.Id, 
            timezonesidkey='America/Los_Angeles', username='teghthyj44xstDiv@testorg.com',ManagerId = user.Id);
            
            insert user1;
            
            BudItm = new Budget_Item__c(Project_Title__c = 'Type1', Region__c='ALL', budget_year__c='2012', prority__c='Regulatory/Policy Compliance (A)',Capital_Appropriation__c = 1000,Old_Carryover_from_Prior_Years__c = 100,
            Old_Carryover_to_Next_Year__c=200,New_Carryover_to_Next_Year__c=120,Original_F_Y_Expenditures__c= 1111,Revised_F_Y_Expenditures__c=121);
            
            insert BudItm;
            
            //CustomSettings__c settings = new CustomSettings__c(Divisional_AFE_Coordinator__c = 'pball@nexeosolutions.com',AFE_Reminder_Email_From_Address__c = 'noReply@salesforce.com');
            //insert settings;
            
            /*AFE = new Authorization_for_Expenditure__c(Budget_Number__C=budItm.id,Status__c='New', type_of_project__c = 'Detailed Project', Origination_type__c='Original', AFE_Title__c = 'MytestMethod1',
            Hsse_impact__c = 'No',Local_currency__c='Pound',Exchange_rate__c=2,Local_currency_total_amount__c=100,State_Province_OLD__c='IT-ITALY', Target_completion_date__c= myDate , Cost_center_number__c='223e',Asset_Type_OLD__c='Buildings(4)',
            Usage_Codes_OLD__c='Replacement(6)',Levels_Of_Approval_Required__C='1');
            */
            //
            
             Authorization_for_Expenditure_CS__c settings = new Authorization_for_Expenditure_CS__c(Name='AFE C Level Approvers', AFE_C_Level_Approvers__c= 'David Bradley,Mike Farnell,Ross Crane');
             insert settings;
            
            
            cm = new Category_Master__c(Employee__c = user1.id, Limit__c=50000, CategoryDesc__c = 'Test Havoc', EmpId__c = '12345', EmpName__c = 'Test Havoc');
            insert cm;
            
            AFE = new Authorization_for_Expenditure__c(Budget_Number__C=budItm.id,Status__c='New', type_of_project__c = 'Detailed Project', Origination_type__c='Original', AFE_Title__c = 'MytestMethod1',
            Hsse_impact__c = 'No',Local_currency__c='US Dollar',Exchange_rate__c=2,Local_currency_total_amount__c=10000,State_Province_OLD__c='IT-ITALY', Target_completion_date__c= myDate , Cost_center_number__c='223e',Asset_Type_OLD__c='Buildings(4)',
            Usage_Codes_OLD__c='Replacement(6)',Levels_Of_Approval_Required__C='1', Approver1__c =user1.id, Approval_Submission_Requirements_Meet__c=true);
            
           
            insert AFE; 
      
      		//AFE1 = new Authorization_for_Expenditure__c(Budget_Number__C=budItm.id,Status__c='New', type_of_project__c = 'Detailed Project', Origination_type__c='Original', AFE_Title__c = 'MytestMethod1',
           // Hsse_impact__c = 'No',Local_currency__c='US Dollar',Exchange_rate__c=2,Local_currency_total_amount__c=150000,State_Province_OLD__c='IT-ITALY', Target_completion_date__c= myDate , Cost_center_number__c='223e',Asset_Type_OLD__c='Buildings(4)',
           // Usage_Codes_OLD__c='Replacement(6)',Levels_Of_Approval_Required__C='1', Approver1__c =user1.id, Approval_Submission_Requirements_Meet__c=true);
            
            //insert AFE1; 
      
            AFE_approvers__c approvers = new AFE_approvers__c(Authorization_for_Expenditure__c = AFE.Id,Approver_1__c = user.Id,Level__c = '1',Approver_2__c = user1.Id);
            
            insert approvers;
            
            Approval.ProcessSubmitRequest psr = new Approval.ProcessSubmitRequest();
            psr.setObjectId(AFE.Id);
            psr.setComments('Submitting');
            psr.setNextApproverIds(new Id[]{user1.Id});
           /* List<Id> newWorkItemIds = Approval.process(psr).getNewWorkitemIds();
            List<ProcessInstanceWorkitem> workitems = [Select Id, ProcessInstanceId, ProcessInstance.Status, ProcessInstance.TargetObjectId, ActorId, OriginalActorId, CreatedById, CreatedDate from ProcessInstanceWorkitem where Id In :newWorkItemIds];
            
            
            SendAFE_ApprovalMail_Batch  con = new SendAFE_ApprovalMail_Batch();
            Id batchId = Database.executeBatch(con);
            con.execute(null,workitems);    
            */
            Test.stopTest();
      }
}