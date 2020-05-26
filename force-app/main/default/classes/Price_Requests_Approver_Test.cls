@istest(seeAlldata=false)
public class Price_Requests_Approver_Test{
    public static testMethod void testPriceReqApp() {
    
       Price_Request_Approver__c app=new Price_Request_Approver__c(Approval_Level__c='Exception 1',PLM__c='abcd', SAP_Sales_Group__c='group',SAP_Sales_Group_Code__c='code',Material_Group_4_Desc__c='test',material_group_4__c='test',plm_name__c='test');
       insert app;
       Price_Requests_Approver controller = new Price_Requests_Approver(new ApexPages.StandardController(app));
        
       controller.save();
    }
    
}