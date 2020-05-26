@isTest
public class AuthorizationforExpenditureApprovalTest {
    
        static Authorization_for_Expenditure__c AFE;
    static Authorization_for_Expenditure__c AFE1;
    static Authorization_for_Expenditure__c AFE2;
    static Authorization_for_Expenditure__c AFE3;
    static AFE_approvers__c afeApr;
    static AFE_approvers__c afeApr1;
    static Budget_Item__c BudItm;
    static Approval.Processresult Result;
    static User Approver1;
    static User DivAFECordinator;
    static User user1;
     
    public static testMethod void testMyController() {
     
        System.debug('@@@@@@*****Starting of INIT*******@@@@');
        
        Date myDate = Date.Today()+1;
        String idd = ' '; 
        String Appidd = ' ';
 
        
        Profile ps = [select id from profile where name='System Administrator']; 
            DivAFECordinator = new User(alias = 'DivS1', email='DivCo@testorg.com', 
            emailencodingkey='UTF-8', lastname='DivCoTest1', firstName ='DivAFECordinator',languagelocalekey='en_US', 
            localesidkey='en_US', profileid = ps.Id, 
            timezonesidkey='America/Los_Angeles', username='testDiv@testorg.com');
            insert DivAFECordinator;
            
            Approver1 = new User(alias = 'DivS2', email='appr1@testorg.com', 
            emailencodingkey='UTF-8', lastname='DivCoTest2', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = ps.Id, 
            timezonesidkey='America/Los_Angeles', username='appr1@testorg.com');
            insert Approver1;
            
            user1 = new User(alias = 'DivS3', email='user21@testorg.com', 
            emailencodingkey='UTF-8', lastname='DivCoTest34', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = ps.Id, 
            timezonesidkey='America/Los_Angeles', username='user21@testorg.com');
            insert user1;

            
            List<User> id = [Select ID from User where UserName='testDiv@testorg.com' limit 1];
            for(User sa : id){
                 idd = sa.ID;
            }
        System.runAs(DivAFECordinator) {
                    	Category_Master__c cm = new Category_Master__c(Employee__c = idd, Category__c = '006', Limit__c =  1000000000);
        	insert cm;
            
            BudItm = new Budget_Item__c(Project_Title__c = 'Type1', Region__c='ALL', budget_year__c='2012', prority__c='Regulatory/Policy Compliance (A)',Capital_Appropriation__c = 1000,Old_Carryover_from_Prior_Years__c = 100,
        Old_Carryover_to_Next_Year__c=200,New_Carryover_to_Next_Year__c=120,Original_F_Y_Expenditures__c= 1111,Revised_F_Y_Expenditures__c=121);
        insert BudItm;
        
        Authorization_for_Expenditure_CS__c settings = new Authorization_for_Expenditure_CS__c(Name='AFE C Level Approvers', AFE_C_Level_Approvers__c= 'David Bradley,Mike Farnell,Ross Crane,DivAFECordinator DivCoTest1, Jordi Armengol');
             insert settings;
        
        AFE = new Authorization_for_Expenditure__c(Budget_Number__C=budItm.id,Status__c='Approved', type_of_project__c = 'Detailed Project', Origination_type__c='Original', AFE_Title__c = 'MytestMethod1',
        Hsse_impact__c = 'No',Local_currency__c='Pound',Exchange_rate__c=2,Local_currency_total_amount__c=1000000,State_Province_OLD__c='IT-ITALY', Target_completion_date__c= myDate , Cost_center_number__c='223e',Asset_Type_OLD__c='Buildings(4)',
      Usage_Codes_OLD__c='Replacement(6)',Division_AFE_Coordinator__c = idd,Levels_Of_Approval_Required__C='1',Approver1__c = idd, Approval_Status__c = 'New');
        insert AFE;
        
        AFE1 = new Authorization_for_Expenditure__c(Budget_Number__C=budItm.id, Status__c='Pending Approval',type_of_project__c = 'Detailed Project', Origination_type__c='Supplement', AFE_for_Suppliment__c=AFE.id, AFE_Title__c = 'MytestMethod1',
        Hsse_impact__c = 'No',Local_currency__c='Pound',Exchange_rate__c=1,Local_currency_total_amount__c=10000000,State_Province_OLD__c='IT-ITALY', Target_completion_date__c= myDate , Cost_center_number__c='223e',Asset_Type_OLD__c='Buildings(4)',
        Usage_Codes_OLD__c='Replacement(6)',Division_AFE_Coordinator__c = idd,Levels_Of_Approval_Required__C='1',Approver1__c = idd,AFE_Class1__c='Budgeted');
           
            AFE1.Approval_Status__c = 'New';
            AFE1.Approver1__c = idd;
                AFE1.Approver2__c= idd;
                AFE1.Approver3__c= idd;
                AFE1.Approver4__c= idd;
                AFE1.Approver5__c= idd;
                AFE1.Approver6__c= idd;
                AFE1.Approver7__c= idd;
                AFE1.Approver8__c= idd;
                AFE1.Approver9__c= idd;
                AFE1.Approver10__c= idd;
            AFE1.Approver11__c= idd;
            AFE1.Approver12__c= idd;
            AFE1.Approver13__c= idd;
            AFE1.Approver14__c= idd;
            AFE1.Approver15__c= idd;
        insert AFE1;
            
            
                   Authorization_for_Expenditure__c AFE4 = new Authorization_for_Expenditure__c(Budget_Number__C=budItm.id,Status__c='Approved', type_of_project__c = 'Detailed Project', Origination_type__c='Original', AFE_Title__c = 'MytestMethod1',
        Hsse_impact__c = 'No',Local_currency__c='Pound',Exchange_rate__c=2,Local_currency_total_amount__c=100,State_Province_OLD__c='IT-ITALY', Target_completion_date__c= myDate , Cost_center_number__c='223e',Asset_Type_OLD__c='Buildings(4)',
      Usage_Codes_OLD__c='Replacement(6)',Division_AFE_Coordinator__c = idd,Levels_Of_Approval_Required__C='1',Approver1__c = idd, Approval_Status__c = 'New');
        insert AFE4;
            
                    AFE2 = new Authorization_for_Expenditure__c(Budget_Number__C=budItm.id, Status__c='Pending Approval',type_of_project__c = 'Detailed Project', Origination_type__c='Supplement', AFE_for_Suppliment__c=AFE4.id, AFE_Title__c = 'MytestMethod1',
        Hsse_impact__c = 'No',Local_currency__c='Pound',Exchange_rate__c=1,Local_currency_total_amount__c=1000,State_Province_OLD__c='IT-ITALY', Target_completion_date__c= myDate , Cost_center_number__c='223e',Asset_Type_OLD__c='Buildings(4)',
        Usage_Codes_OLD__c='Replacement(6)',Division_AFE_Coordinator__c = idd,Levels_Of_Approval_Required__C='1',Approver1__c = idd,AFE_Class1__c='Budgeted');
           
            AFE2.Approval_Status__c = 'New';
            AFE2.Approver1__c = idd;
                AFE2.Approver2__c= idd;
                AFE2.Approver3__c= idd;
                AFE2.Approver4__c= idd;
                AFE2.Approver5__c= idd;
                AFE2.Approver6__c= idd;
                AFE2.Approver7__c= idd;
                AFE2.Approver8__c= idd;
                AFE2.Approver9__c= idd;
                AFE2.Approver10__c= idd;
            AFE2.Approver11__c= idd;
            AFE2.Approver12__c= idd;
            AFE2.Approver13__c= idd;
            AFE2.Approver14__c= idd;
            AFE2.Approver15__c= idd;
        insert AFE2;


        }
        
            
           }
    
        public static testMethod void testMyController2() {
     
        System.debug('@@@@@@*****Starting of INIT*******@@@@');
        
        Date myDate = Date.Today()+1;
        String idd = ' '; 
        String Appidd = ' ';
 
        
        Profile ps = [select id from profile where name='System Administrator']; 
            DivAFECordinator = new User(alias = 'DivS1', email='DivCo@testorg.com', 
            emailencodingkey='UTF-8', lastname='DivCoTest1', firstName ='DivAFECordinator',languagelocalekey='en_US', 
            localesidkey='en_US', profileid = ps.Id, 
            timezonesidkey='America/Los_Angeles', username='DivAFECordinator@testorg.com');
            insert DivAFECordinator;
            
            idd = DivAFECordinator.Id;
        System.runAs(DivAFECordinator) {
                    	Category_Master__c cm = new Category_Master__c(Employee__c = idd, Category__c = '006', Limit__c =  1000000000, EmpId__c = idd);
        	insert cm;
            
            BudItm = new Budget_Item__c(Project_Title__c = 'Type1', Region__c='ALL', budget_year__c='2012', prority__c='Regulatory/Policy Compliance (A)',Capital_Appropriation__c = 1000,Old_Carryover_from_Prior_Years__c = 100,
        Old_Carryover_to_Next_Year__c=200,New_Carryover_to_Next_Year__c=120,Original_F_Y_Expenditures__c= 1111,Revised_F_Y_Expenditures__c=121);
        insert BudItm;
        
        Authorization_for_Expenditure_CS__c settings = new Authorization_for_Expenditure_CS__c(Name='AFE C Level Approvers', AFE_C_Level_Approvers__c= 'DivAFECordinator DivCoTest1');
             insert settings;
            
            
                   Authorization_for_Expenditure__c AFE4 = new Authorization_for_Expenditure__c(Budget_Number__C=budItm.id,Status__c='Approved', type_of_project__c = 'Detailed Project', Origination_type__c='Original', AFE_Title__c = 'MytestMethod1',
        Hsse_impact__c = 'No',Local_currency__c='Pound',Exchange_rate__c=2,Local_currency_total_amount__c=100,State_Province_OLD__c='IT-ITALY', Target_completion_date__c= myDate , Cost_center_number__c='223e',Asset_Type_OLD__c='Buildings(4)',
      Usage_Codes_OLD__c='Replacement(6)',Division_AFE_Coordinator__c = idd,Levels_Of_Approval_Required__C='1',Approver1__c = idd, Approval_Status__c = 'New');
        insert AFE4;
                    AFE = new Authorization_for_Expenditure__c(Budget_Number__C=budItm.id,Status__c='Approved', type_of_project__c = 'Detailed Project', Origination_type__c='Original', AFE_Title__c = 'MytestMethod1',
        Hsse_impact__c = 'No',Local_currency__c='Pound',Exchange_rate__c=2,Local_currency_total_amount__c=1000000,State_Province_OLD__c='IT-ITALY', Target_completion_date__c= myDate , Cost_center_number__c='223e',Asset_Type_OLD__c='Buildings(4)',
      Usage_Codes_OLD__c='Replacement(6)',Division_AFE_Coordinator__c = idd,Levels_Of_Approval_Required__C='1',Approver1__c = idd, Approval_Status__c = 'New');
        insert AFE;
                    AFE2 = new Authorization_for_Expenditure__c(Budget_Number__C=budItm.id, Status__c='Pending Approval',type_of_project__c = 'Detailed Project', Origination_type__c='Supplement', AFE_for_Suppliment__c=AFE.id, AFE_Title__c = 'MytestMethod1',
        Hsse_impact__c = 'No',Local_currency__c='Pound',Exchange_rate__c=1,Local_currency_total_amount__c=1000,State_Province_OLD__c='IT-ITALY', Target_completion_date__c= myDate , Cost_center_number__c='223e',Asset_Type_OLD__c='Buildings(4)',
        Usage_Codes_OLD__c='Replacement(6)',Division_AFE_Coordinator__c = idd,Levels_Of_Approval_Required__C='1',Approver1__c = idd,AFE_Class1__c='Budgeted');
           
            AFE2.Approval_Status__c = 'New';
            AFE2.Approver1__c = idd;
                AFE2.Approver2__c= idd;
                AFE2.Approver3__c= idd;
                AFE2.Approver4__c= idd;
                AFE2.Approver5__c= idd;
                AFE2.Approver6__c= idd;
                AFE2.Approver7__c= idd;
                AFE2.Approver8__c= idd;
                AFE2.Approver9__c= idd;
                AFE2.Approver10__c= idd;
            AFE2.Approver11__c= idd;
            AFE2.Approver12__c= idd;
            AFE2.Approver13__c= idd;
            AFE2.Approver14__c= idd;
            AFE2.Approver15__c= idd;
        insert AFE2;


        }
        
            
           }

}