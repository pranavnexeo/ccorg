public class CallReportSendEmailWithActionCntrlr {
    public Opportunity_Call_Report__c oppCall{get;set;}
    public CallReportSendEmailWithActionCntrlr(ApexPages.StandardController stdcontroller){
        oppCall = (Opportunity_Call_Report__c) stdController.getRecord();
    }
    
    public PageReference redirect(){
        Call_Report_Settings__c crs = Call_Report_Settings__c.getInstance();
        string tempId = crs.With_Action_Template_Id__c;
        string redirectUrl = crs.Redirect_URL__c;
        return new PageReference(redirectUrl+oppCall.id+'&tid='+tempId);
    }

}