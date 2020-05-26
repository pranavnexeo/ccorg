//@isTest(SeeAllData=true)
@isTest
private class AFECreateTest {

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
            BudItm = new Budget_Item__c(Project_Title__c = 'Type1', Region__c='ALL', budget_year__c='2012', prority__c='Regulatory/Policy Compliance (A)',Capital_Appropriation__c = 1000,Old_Carryover_from_Prior_Years__c = 100,
        Old_Carryover_to_Next_Year__c=200,New_Carryover_to_Next_Year__c=120,Original_F_Y_Expenditures__c= 1111,Revised_F_Y_Expenditures__c=121);
        insert BudItm;
        
        Authorization_for_Expenditure_CS__c settings = new Authorization_for_Expenditure_CS__c(Name='AFE C Level Approvers', AFE_C_Level_Approvers__c= 'David Bradley,Mike Farnell,Ross Crane');
             insert settings;
        
        AFE = new Authorization_for_Expenditure__c(Budget_Number__C=budItm.id,Status__c='Approved', type_of_project__c = 'Detailed Project', Origination_type__c='Original', AFE_Title__c = 'MytestMethod1',
        Hsse_impact__c = 'No',Local_currency__c='Pound',Exchange_rate__c=2,Local_currency_total_amount__c=100,State_Province_OLD__c='IT-ITALY', Target_completion_date__c= myDate , Cost_center_number__c='223e',Asset_Type_OLD__c='Buildings(4)',
      Usage_Codes_OLD__c='Replacement(6)',Division_AFE_Coordinator__c = idd,Levels_Of_Approval_Required__C='1',Approver1__c = idd);
        insert AFE;
        
        AFE1 = new Authorization_for_Expenditure__c(Budget_Number__C=budItm.id, Status__c='Pending Approval',type_of_project__c = 'Detailed Project', Origination_type__c='Supplement', AFE_for_Suppliment__c=AFE.id, AFE_Title__c = 'MytestMethod1',
        Hsse_impact__c = 'No',Local_currency__c='Pound',Exchange_rate__c=2,Local_currency_total_amount__c=100,State_Province_OLD__c='IT-ITALY', Target_completion_date__c= myDate , Cost_center_number__c='223e',Asset_Type_OLD__c='Buildings(4)',
        Usage_Codes_OLD__c='Replacement(6)',Division_AFE_Coordinator__c = idd,Levels_Of_Approval_Required__C='1',Approver1__c = idd,AFE_Class1__c='Budgeted');
        insert AFE1;
        System.Debug('@@@@@*****AFEE IDDD*****@@@@@@'+AFE1.Id);
         afeApr = new AFE_approvers__c(Approver_1__c=idd, Level__c = '1', Key__c = idd, Authorization_for_Expenditure__c = AFE.Id);
         insert afeApr;
         afeApr1 = new AFE_approvers__c(Approver_1__c=idd, Level__c = '2', Key__c = idd, Authorization_for_Expenditure__c = AFE1.Id);
         insert afeApr1;
         
         AFE2 = new Authorization_for_Expenditure__c(Budget_Number__C=budItm.id, type_of_project__c = 'Detailed Project', Origination_type__c='Supplement', AFE_for_Suppliment__c=AFE.id, AFE_Title__c = 'MytestMethod1',
        Hsse_impact__c = 'No',Local_currency__c='Pound',Exchange_rate__c=2,Local_currency_total_amount__c=100,State_Province_OLD__c='IT-ITALY', Target_completion_date__c= myDate , Cost_center_number__c='223e',Asset_Type_OLD__c='Buildings(4)',
        Usage_Codes_OLD__c='Replacement(6)',Division_AFE_Coordinator__c = idd,Levels_Of_Approval_Required__C='1',Approver1__c = idd,Status__c = 'Approved');
        insert AFE2;
         
        AFE3 = new Authorization_for_Expenditure__c(Approval_Status__c = 'New', Budget_Number__C=budItm.id, Status__c='Pending Approval',type_of_project__c = 'Detailed Project', Origination_type__c='Supplement', AFE_for_Suppliment__c=AFE.id, AFE_Title__c = 'MytestMethod1',
        Hsse_impact__c = 'No',Local_currency__c='Pound',Exchange_rate__c=2,Local_currency_total_amount__c=100,State_Province_OLD__c='IT-ITALY', Target_completion_date__c= myDate , Cost_center_number__c='223e',Asset_Type_OLD__c='Buildings(4)',
        Usage_Codes_OLD__c='Replacement(6)',Division_AFE_Coordinator__c = idd,Levels_Of_Approval_Required__C='1',Approver1__c = idd,AFE_Class1__c='Budgeted');
        insert AFE3;
        
            /*List<User> appID = [Select ID from User where UserName='appr1@testorg.com' limit 1];
            for(User saa : appID){
                 App1 = saa.ID;
            }*/
             PageReference pageRef = new PageReference('/apex/AFEEditPage');
        Test.setCurrentPage(pageRef);
        AFENewExtension  controller1 = new AFENewExtension();
            ApexPages.currentPage().getParameters().put('id', AFE.Id);
            ApexPages.currentPage().getParameters().put('AfeSup', AFE1.Id);
            ApexPages.currentPage().getParameters().put('BudgetItem', BudItm.Id);
            AFENewExtension  controller = new AFENewExtension(new ApexPages.StandardController(new Authorization_for_Expenditure__c()));
            controller.getSupNumRec();
           pageRef =controller.saveSupplement();
           controller.saveAttachment(AFE2.id);
           Blob filebody  ;String fileName = 'ABC';Id parent = AFE2.id;
           controller.createAttachmentObject(filebody,fileName,parent);
            controller.getNumRecord();
            controller.closePopup();
            controller.showPopup();
            controller.saveRecord();
            controller.saveAFEapprovers();
            controller.populateApproverMapforEdit();
            controller.setChangeField();
            controller.previousCounterSet();
            controller.calculatePriorFields(BudItm.id);
            List<SelectOption> abc = controller.getLevels();
            controller.nextCounterSet();
            controller.checkIsBlank();
            controller.clearApproversFields();
            controller.sendPageMessage('Test');
            controller.loadApproversInMap(1);
            controller.getKey();
            controller.authForExp1= AFE;
            
            
            //Testing AFEExtension
            PageReference pageRef1 = new PageReference('/apex/AFEViewPage');
            Test.setCurrentPage(pageRef1);
             ApexPages.currentPage().getParameters().put('id', AFE.Id);
            AFEExtension  controller3 = new AFEExtension(new ApexPages.StandardController(new Authorization_for_Expenditure__c()));
            
            Authorization_for_Expenditure__c af=controller3.myObject;
            controller3.ViewAppr();
            controller3.getPricingList();
            //controller3.getmyObject();
            //controller3.setmyObject();
            controller3.CancelAfe();
            controller3.callUpdate();
            controller3.closePopup();
            controller3.showPopup();
            controller3.closePopupCancel();
            controller3.showPopupCancel();
            controller3.remainder();
            controller3.MarkAfe();
            controller3.SaveRec();
            
            
             //Testing ViewApproverExtension
            PageReference pageRef2 = new PageReference('/apex/changeApprovers');
            Test.setCurrentPage(pageRef2);
            ApexPages.currentPage().getParameters().put('id', AFE.Id);
            viewApproversExtension controller4 = new viewApproversExtension(new ApexPages.StandardController(new Authorization_for_Expenditure__c()));
            viewApproversExtension controller5 = new viewApproversExtension();
            
            controller4.saveRecord();
            controller4.saveAFEapprovers();
            controller4.populateApproverMapforEdit();
            controller4.getLevels();
            controller4.setChangeField();
            controller4.previousCounterSet();
            controller4.nextCounterSet();
            controller4.sendPageMessage('TEST');
            controller4.checkIsBlank();
            controller4.clearApproversFields();
            controller4.loadApproversInMap(1);
            controller4.getKey();
            //pageRef2 = controller4.removeLevel();
            controller4.saveRecord();

            List<Authorization_for_Expenditure__c> a = new List<Authorization_for_Expenditure__c>();
            a.add(AFE);            
            a.add(AFE1);
            a.add(AFE2);  
           // AfeApprovalHelper.ProcessInst(a);       
           }
             
           }
           
                  
            
         /* static testMethod void myUnitTest(){
            init();
            System.runAs(Approver1){
            TestSubmit.doRejection('Appr1', AFE1.Id);
            }
            }*/