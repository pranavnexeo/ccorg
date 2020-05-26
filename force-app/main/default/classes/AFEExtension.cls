public class AFEExtension {

    public List<AFE_approvers__c> pricingList = new List<AFE_approvers__c>();
    public boolean displayPopup {get; set;} 
    public boolean displayPopupCancel {get; set;} 
    public boolean AfeCancel {get;set;}
    
    public PageReference ViewAppr(){
    String Urls='/apex/changeApprovers?id='+Afe.ID;
    PageReference pageRef = new PageReference(Urls);
     pageRef.setRedirect(true);
       return pageRef;    
    }
    public List<AFE_approvers__c> getPricingList(){
        
                return pricingList;
        }
    
    public Authorization_for_Expenditure__c myObject {
   get {
      if (myObject == null)
         myObject = new Authorization_for_Expenditure__c();
      return myObject;
   }
   set;
}
    
    
    private final Authorization_for_Expenditure__c AFE;
    private final ApexPages.StandardController AFEController;
    
     
    public AFEExtension(ApexPages.StandardController controller) {
        AFE=(Authorization_for_Expenditure__c)controller.getRecord();
        AFEController = controller;
        pricingList = [SELECT Id, Name, Approver_1__c, Approver_2__c, Approver_3__c, Approver_4__c, Approver_5__c,Key__c, Level__c FROM AFE_approvers__c  where Authorization_for_Expenditure__r.Id=:AFE.Id];
        System.debug('pricingList @@@'+pricingList);
    }
       
   public PageReference CancelAfe(){
   
   List<Authorization_for_Expenditure__c> AFEObj =[select Id,Status__c,DecreaseCounter__c, CloseStatus__c,Comments_for_Cancellation__c from Authorization_for_Expenditure__c where Id = :AFE.Id];
   //AFEObj.Comments_for_Cancellation__c = ;
   AFEController.save();
   
   //AFEObj.Comments_for_Cancellation__c  = AFE.Comments_for_Cancellation__c;
   if(AFEObj.size() >0){
       AFEObj[0].Status__c = 'Cancelled';
       AFEObj[0].CloseStatus__c = 'Cancelled';
       AFEObj[0].DecreaseCounter__c = true;
       System.debug('___@@@@@AFE.Comments_for_Cancellation__c____@@@@'+AFE.Comments_for_Cancellation__c);
   
       Update AFEObj;
    }
   PageReference p = ApexPages.currentPage();
   p.getParameters().put('id',Apexpages.currentPage().getParameters().get('id'));
     
   p.setRedirect(true);
   return p;
     /*AFE.Status__c = 'Cancelled';
     AFE.CloseStatus__c = 'Cancelled';
     Update AFE;*/
   
   }
    public void callUpdate(){
       List<Authorization_for_Expenditure__c> AFEObj =[select Id,Status__c,CloseStatus__c,Comments_for_Cancellation__c from Authorization_for_Expenditure__c where Id = :AFE.Id];
       
       
    
    }
    public void closePopup() {        
        displayPopup = false;    
    }     
    public void showPopup() {        
        displayPopup = true;    
        AfeCancel = true;
    }
    
      public void closePopupCancel() {        
        displayPopupCancel = false;    
    }     
    public void showPopupCancel() {        
        displayPopupCancel = true;    
    }
    
   /* public void AFEView(){
        
        System.debug('AFE Audit--------');
        
        Authorization_for_Expenditure__c AFEObj = [select Id,Status__c from Authorization_for_Expenditure__c where Id = :AFE.Id];
        
        String currentValue =  AFEObj.Status__c;
        
        if(currentValue ==null){
            currentValue ='';
        }
        
       // AFEObj.Audit_History__c= currentValue +' '+ UserInfo.getName()+' : '+System.Now();
       // AFEObj.Last_Audit_Due__c= System.Today();
        
        update AFEObj;
    } */
    
    public void remainder(){
     List<Authorization_for_Expenditure__c> AFEObj1 = [select Id,Status__c,isEmailSend__c from Authorization_for_Expenditure__c where Id = :AFE.Id];
     
     if(AFEObj1.size() >0){
         AFEObj1[0].isEmailSend__c = true;
     
         update AFEObj1;
      }
    }
    
     public PageReference MarkAfe(){
     List<Authorization_for_Expenditure__c> AFEObj2 = [select Id,Status__c,isEmailSend__c,Mark_Afe_As_Complete__c from Authorization_for_Expenditure__c where Id = :AFE.Id];
     if(AFEObj2.size() >0){
         AFEObj2[0].Status__c = 'Completed & Accepted';
         update AFEObj2;
     } 
      PageReference p = ApexPages.currentPage();
      p.getParameters().put('success','true');
      p.getParameters().put('id',Apexpages.currentPage().getParameters().get('id'));
      
       p.setRedirect(true);
       return p;
     
    }
 
    
    public void SaveRec(){
     List<Authorization_for_Expenditure__c> AFEObj2 = [select Id,closeStatus__c,isEmailSend__c,Mark_Afe_As_Complete__c from Authorization_for_Expenditure__c where Id = :AFE.Id];
     if(AFEObj2.size() >0){
         AFEObj2[0].closeStatus__c = 'Completed & Accepted';
         update AFEObj2;
     }
    }

}