@isTest
private class AuthforExpAppSubReqMeet_Test {
    
    static Authorization_for_Expenditure__c AFE; 
    static Authorization_for_Expenditure__c AFE1; 
         static Budget_Item__c BudItm;
         static User user1;
   		 static User user;
    
    public static testMethod void testmybatch21() {
      
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
        
        List<User> approverUserList = [Select id from User Where Name = 'David Bradley'];
        User approveruser = null;
        if (approverUserList.isEmpty()) {
            approveruser = new User(alias = 'DivS1', email='DivCo@testorg.com', 
            emailencodingkey='UTF-8', lastname='Bradley', firstName ='David',languagelocalekey='en_US', 
            localesidkey='en_US', profileid = ps.Id, 
            timezonesidkey='America/Los_Angeles', username='teghthyj44xstDiv@testorg.com',ManagerId = user.Id);
            insert approveruser;
        } else {
            approveruser = approverUserList.get(0);
        }
              
        Date myDate = Date.Today()+1;
        
        Category_Master__c  ct = new Category_Master__c  (Category__c = '006', Employee__c = approveruser.id, Limit__c = 50000);
        insert ct;
        System.debug(ct);
        ct.Employee__c = approveruser.id;
        update ct;
        
         Authorization_for_Expenditure_CS__c settings = new Authorization_for_Expenditure_CS__c(Name='AFE C Level Approvers', AFE_C_Level_Approvers__c= 'David Bradley,Mike Farnell,Ross Crane,DivAFECordinator');
         insert settings;
        
        BudItm = new Budget_Item__c(Project_Title__c = 'Type1', Region__c='ALL', budget_year__c='2012', prority__c='Regulatory/Policy Compliance (A)',Capital_Appropriation__c = 1000,Old_Carryover_from_Prior_Years__c = 100,
            Old_Carryover_to_Next_Year__c=200,New_Carryover_to_Next_Year__c=120,Original_F_Y_Expenditures__c= 1111,Revised_F_Y_Expenditures__c=121);
            insert BudItm;    
        
        AFE = new Authorization_for_Expenditure__c(Budget_Number__C=budItm.id,Status__c='New', type_of_project__c = 'Detailed Project', Origination_type__c='Original', AFE_Title__c = 'MytestMethod1',
            Hsse_impact__c = 'No',Local_currency__c='US Dollar',Exchange_rate__c=2,Local_currency_total_amount__c=10000,State_Province_OLD__c='IT-ITALY', Target_completion_date__c= myDate , Cost_center_number__c='223e',Asset_Type_OLD__c='Buildings(4)',
            Usage_Codes_OLD__c='Replacement(6)',Levels_Of_Approval_Required__C='1', Approver1__c =approveruser.id, Approval_Submission_Requirements_Meet__c=true);
            AFE.Approver1__c = approveruser.id;
            AFE.Approver2__c = approveruser.id;
            AFE.Approver3__c = approveruser.id;
            AFE.Approver4__c = approveruser.id;
            AFE.Approver5__c = approveruser.id;
            AFE.Approver6__c = approveruser.id;
            AFE.Approver7__c = approveruser.id;
            AFE.Approver8__c = approveruser.id;
            AFE.Approver9__c = approveruser.id;
            AFE.Approver10__c = approveruser.id;
            AFE.Approver11__c = approveruser.id;
            AFE.Approver12__c = approveruser.id;
            AFE.Approver13__c = approveruser.id;
            AFE.Approver14__c = approveruser.id;
            AFE.Approver15__c = approveruser.id;
        	insert AFE; 
     
            AFE1 = new Authorization_for_Expenditure__c(Budget_Number__C=budItm.id,Status__c='New', type_of_project__c = 'Detailed Project', Origination_type__c='Original', AFE_Title__c = 'MytestMethod2',
            Hsse_impact__c = 'No',Local_currency__c='US Dollar',Exchange_rate__c=2,Local_currency_total_amount__c=1005000,State_Province_OLD__c='IT-ITALY', Target_completion_date__c= myDate , Cost_center_number__c='223e',Asset_Type_OLD__c='Buildings(4)',
            Usage_Codes_OLD__c='Replacement(6)',Levels_Of_Approval_Required__C='1', Approver1__c =approveruser.id, Approval_Submission_Requirements_Meet__c=true);
            AFE1.Approver1__c = approveruser.id;
            AFE1.Approver2__c = approveruser.id;
            AFE1.Approver3__c = approveruser.id;
            AFE1.Approver4__c = approveruser.id;
            AFE1.Approver5__c = approveruser.id;
            AFE1.Approver6__c = approveruser.id;
            AFE1.Approver7__c = approveruser.id;
            AFE1.Approver8__c = approveruser.id;
            AFE1.Approver9__c = approveruser.id;
            AFE1.Approver10__c = approveruser.id;
            AFE1.Approver11__c = approveruser.id;
            AFE1.Approver12__c = approveruser.id;
            AFE1.Approver13__c = approveruser.id;
            AFE1.Approver14__c = approveruser.id;
            AFE1.Approver15__c = approveruser.id;
        	insert AFE1; 
    		
    }
    
}