public class BillingInfoNewExtension {
    private final ApexPages.StandardController BillingController;
    ID PcID;
    Boolean insertFlag = false;
    public Billto_Cost_Center_Code__c payReq{get;set;}
    
    public BillingInfoNewExtension(ApexPages.StandardController controller) {
        BillingController = controller;
        payReq =(Billto_Cost_Center_Code__c)controller.getRecord();
      
    }
    
     public void getRecDetails(){
     String PriceReqName=Apexpages.currentPage().getParameters().get('PriceReqDtl'); 
     List<Billto_Cost_Center_Code__c> PCcheck= [SELECT ID, NAME,New_Bill_Code__c,Active_Billto_Code__c,Bill_Code_Description__c,Bill_To__c,
     Report_Grouping_Code_Description_new__c,Company_Code__c,SAP_Billing_Cost_Center_Code_Description__c,Business_Area__c,Actual_Cost_Center_Code__c,Actual_Cost_Center_Code_Description__c FROM Billto_Cost_Center_Code__c where Billto_Cost_Center_Code__c.Name= :PriceReqName Limit 1];
     for(Billto_Cost_Center_Code__c pc : PCcheck){
        PcID = pc.id;
        String actualcode = pc.Actual_Cost_Center_Code__c;
        payReq.Active_Billto_Code__c = pc.Active_Billto_Code__c;
        payReq.New_Bill_Code__c = pc.New_Bill_Code__c;
        payReq.Bill_Code_Description__c = pc.Bill_Code_Description__c;
        payReq.Report_Grouping_Code_Description_new__c = pc.Report_Grouping_Code_Description_new__c;  
        payReq.Company_Code__c = pc.Company_Code__c;  
        payReq.Business_Area__c = pc.Business_Area__c;
        payReq.Actual_Cost_Center_Code__c = pc.Actual_Cost_Center_Code__c;
        if(pc.Active_Billto_Code__c=='Y')
        {
           if(actualcode.startsWith('00'))
           {
                payReq.Actual_Cost_Center_Code_Description__c=pc.SAP_Billing_Cost_Center_Code_Description__c;
                                        
             }else{
                 payReq.Actual_Cost_Center_Code_Description__c=pc.Actual_Cost_Center_Code_Description__c;                               
                }
               }  
             }
     } 
}