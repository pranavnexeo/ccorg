/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
//@isTest(SeeAllData=true)
private class TestAFECreation {

    static Authorization_for_Expenditure__c AFE;
    static Authorization_for_Expenditure__c AFE1;
    static AFE_approvers__c afeApr;
    static Budget_Item__c BudItm;
    static Approval.Processresult Result;
    static User Approver1;
    static User DivAFECordinator;
    static User user1;
    static void init() {
    
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
            
            /*List<User> appID = [Select ID from User where UserName='appr1@testorg.com' limit 1];
            for(User saa : appID){
                 App1 = saa.ID;
            }*/
            
        BudItm = new Budget_Item__c(Project_Title__c = 'Type1', Region__c='ALL', budget_year__c='2012', prority__c='Regulatory/Policy Compliance (A)',Capital_Appropriation__c = 1000,Old_Carryover_from_Prior_Years__c = 100,
        Old_Carryover_to_Next_Year__c=200,New_Carryover_to_Next_Year__c=120,Original_F_Y_Expenditures__c= 1111,Revised_F_Y_Expenditures__c=121);
        insert BudItm;
        
        Authorization_for_Expenditure_CS__c settings = new Authorization_for_Expenditure_CS__c(Name='AFE C Level Approvers', AFE_C_Level_Approvers__c= 'David Bradley,Mike Farnell,Ross Crane');
             insert settings;
            
        
        AFE = new Authorization_for_Expenditure__c(Budget_Number__C=budItm.id,Status__c='Approved', type_of_project__c = 'Detailed Project', Origination_type__c='Original', AFE_Title__c = 'MytestMethod1',
        Hsse_impact__c = 'No',Local_currency__c='Pound',Exchange_rate__c=2,Local_currency_total_amount__c=100,State_Province_OLD__c='IT-ITALY', Target_completion_date__c= myDate , Cost_center_number__c='223e',Asset_Type_OLD__c='Buildings(4)',
      Usage_Codes_OLD__c='Replacement(6)',Division_AFE_Coordinator__c = idd,Levels_Of_Approval_Required__C='1',Approver1__c = idd);
        insert AFE;
        
        AFE1 = new Authorization_for_Expenditure__c(Budget_Number__C=budItm.id, type_of_project__c = 'Detailed Project', Origination_type__c='Supplement', AFE_for_Suppliment__c=AFE.id, AFE_Title__c = 'MytestMethod1',
        Hsse_impact__c = 'No',Local_currency__c='Pound',Exchange_rate__c=2,Local_currency_total_amount__c=100,State_Province_OLD__c='IT-ITALY', Target_completion_date__c= myDate , Cost_center_number__c='223e',Asset_Type_OLD__c='Buildings(4)',
        Usage_Codes_OLD__c='Replacement(6)',Division_AFE_Coordinator__c = idd,Levels_Of_Approval_Required__C='1',Approver1__c = idd, Approval_Submission_Requirements_Meet__c=true);
        insert AFE1;
        System.Debug('@@@@@*****AFEE IDDD*****@@@@@@'+AFE1.Id);
         afeApr = new AFE_approvers__c(Approver_1__c=idd, Level__c = '1', Key__c = idd, Authorization_for_Expenditure__c = AFE1.Id);
         insert afeApr;
         afeApr = new AFE_approvers__c(Approver_1__c=idd, Level__c = '2', Key__c = idd, Authorization_for_Expenditure__c = AFE1.Id);
         insert afeApr;
           }
           
       
          /*  static testMethod void myUnitTest1(){
                System.Debug('@@@@@*****inside MyUnitest before rnuAs');
                init();
                System.runAs(User1){
                
                System.Debug('@@@@@*****After Calling INIT');
                Test.startTest(); 
                Result = TestSubmit.submitForApproval('comments', AFE1.Id);
               TestSubmit.doApproval('comments', AFE1.Id);
                    TestSubmit.doApproval('comments1', AFE1.Id);
                AFE1.Approval_Level__c = 1;
                update AFE1;
               TestSubmit.doRejection('REjected', AFE1.Id);
                Test.stopTest();
            
            }
            
           
            
           } */
           
          static testMethod void myUnitTest2(){
            init();
            
            System.runAs(user1){
            Test.startTest(); 
            TestSubmit.doApproval('comments', AFE1.Id);
            AFE1.Approval_Level__c = 1;
            update AFE1;
            TestSubmit.doApproval('comments1', AFE1.Id);
            AFE1.Approval_Level__c = 2;
            AFE1.Approval_Status__c = 'Submitted';
            update AFE1;
            Test.stopTest();
                        TestSubmit.doRejection('Rejected', AFE1.Id);
         
           
            }
            }
           
           static testMethod void myUnitDoRej(){
            init();
            
            System.runAs(user1){
            
            
            AFE1.Status__c = 'Rejected';
            update AFE1;
            TestSubmit.doRejection('REjected', AFE1.Id);
            TestSubmit.doRejection('Rejected', AFE1.Id);
           
            }
            }
          static testMethod void myUnitTest(){
            init();
            System.runAs(Approver1){
            TestSubmit.doRejection('Appr1', AFE1.Id);
            }
         }      
    
       static testMethod void myUnitTest3(){
            init();
            
            System.runAs(user1){
            Test.startTest(); 
            TestSubmit.doApproval('comments', AFE1.Id);
            AFE1.Approval_Level__c = 1;
            update AFE1;
            TestSubmit.doApproval('comments1', AFE1.Id);
            AFE1.Approval_Level__c = null;
            AFE1.Approval_Status__c = 'Submitted';
            update AFE1;
            Test.stopTest();
                      
         
           
            }
            }
    
       static testMethod void myUnitTest4(){
            init();
            
            System.runAs(user1){
            Test.startTest(); 
            TestSubmit.doApproval('comments', AFE1.Id);
            AFE1.Approval_Level__c = 1;
                AFE1.Approval_Status__c = 'Submitted';
            update AFE1;
            TestSubmit.doApproval('comments1', AFE1.Id);
            AFE1.Approval_Level__c = 2;
            AFE1.Approval_Status__c = 'Submitted';
            update AFE1;
            Test.stopTest();
                      
         
           
            }
            }
           
}