public class CdfDetailviewMsgController {
    public Contract contractObj{get;set;}
    public boolean leadmessage{get;set;}
    public boolean renewContract{get;set;}
    public CdfDetailviewMsgController(ApexPages.StandardController stdController) {
        contractObj = (Contract)stdController.getRecord();
        contractObj = [Select Id, StartDate,EndDate, Status, SAP_Material__r.Material_General_Data__c, Default_Shipping_Plant__c,Business_Contract_Required__c,Business_Contract__c
                        from Contract where Id =: contractObj.Id Limit 1];
        leadmessage = checkLeadTime();
        renewContract = contractRenew();
    }
    
    public boolean checkLeadTime(){
        Date today = System.Today();
        Integer numberOfDays = today.daysBetween(contractObj.StartDate);
        Integer LeadTime;
        String LeadTimeStr ;
        List<Material_Plant2__c> mpList = [Select Id,Planned_Delivery_Time__c from Material_Plant2__c where Material_General_Data__c =: contractObj.SAP_Material__r.Material_General_Data__c
                            and SAP_Plant__c =: contractObj.Default_Shipping_Plant__c Limit 1 ];
        LeadTimeStr = mpList.isEmpty() ? null : mpList[0].Planned_Delivery_Time__c;
        LeadTime = LeadTimeStr != null ? Integer.ValueOf(LeadTimeStr) : null;
        system.debug('-----------1----------'+LeadTime);
        system.debug('-----------2----------'+numberOfDays );
        if(LeadTime != null && contractObj.Status != 'Activated' && contractObj.Status != 'Expired' && contractObj.Status != 'Cancelled' && contractObj.Status != 'Rejected - Never Activated'){
            if(LeadTime > numberOfDays )
                return true;
        }    
        return false;
    }
     public boolean contractRenew(){
        if(contractObj.Business_Contract_Required__c){
             if(contractObj.Business_Contract__c!= null){
                 Business_Contract__c b = [select Id, Expiration_Date__c from Business_Contract__c where Id =: contractObj.Business_Contract__c  Limit 1];
                 if(b.Expiration_Date__c <= contractObj.EndDate){
                     return true;
                 }
             }
         }
         return false;
     }

}