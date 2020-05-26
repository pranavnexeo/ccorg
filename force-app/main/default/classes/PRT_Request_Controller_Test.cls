@isTest
public class PRT_Request_Controller_Test {
 public static testMethod void testcontroller() { 
 
 
 
 Opportunity opp = new Opportunity (CreatedById = UserInfo.getuserId(),Name='abcd',StageName = 'Prospecting',CloseDate = System.today());
 insert opp;
 Price_Request_Transaction__c prt = new Price_Request_Transaction__c(CreatedById = UserInfo.getuserId(),Opportunity__c = opp.Id);
 insert prt;
 
 PRT_Request_Controller controller = new PRT_Request_Controller();
 
 controller.priceRequest = prt;
 
 PageReference pageRef = Page.PRT_Create_Opportunity;
 Test.setCurrentPage(pageRef);
 controller.opportunitySelected = String.valueof(opp.Id);
 controller.setOpportunitySelected(opp.Id);
 controller.getOpportunity();
 
 controller.Save_Price_Request_with_New_Opportunity();
 controller.init();
 controller.Cancel_Save();
 //String nextPage = controller.Save_Price_Request_with_New_Opportunity().getUrl();
 //System.assertEquals('/apex/failure?error=noParam', nextPage);
 controller.getAlreadyHaveOpportunityMessage();
 controller.getOpportunityRelatedtoParentAccount_Count();
 controller.getPrice_Request_Link();
 controller.getValidationErrorMessage();
 controller.getOpportunitySelected();
 
 //nextPage = controller.Save_Price_Request_with_New_Opportunity().getUrl();
 
 
 }
 public static testMethod void testcontroller1() { 
 
 
 
 Opportunity opp = new Opportunity (CreatedById = UserInfo.getuserId(),Name='abcd',StageName = 'Prospecting',CloseDate = System.today());
 insert opp;
 Price_Request_Transaction__c prt = new Price_Request_Transaction__c(CreatedById = UserInfo.getuserId(),Opportunity__c = opp.Id);
 insert prt;
 
 PRT_Request_Controller controller = new PRT_Request_Controller();
 
 PageReference pageRef = Page.PRT_Create_Opportunity;
 Test.setCurrentPage(pageRef);
 controller.getpriceRequest();
 controller.setOpportunitySelected('');
 controller.Save_Price_Request_with_New_Opportunity();
 
 
 }

}